package ddt.room
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ddt.data.PathInfo;
	import ddt.data.RoomInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.gameLoad.GameLoadingControler;
	import ddt.invite.IInviteController;
	import ddt.invite.InviteController;
	import ddt.manager.ChatManager;
	import ddt.manager.EffortMovieClipManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.StateManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.church.DialogueAgreePropose;
	
	import par.manager.ParticleManager;
	import par.manager.ShapeManager;
	
	import road.loader.BaseLoader;
	import road.loader.LoaderEvent;
	import road.loader.LoaderManager;
	import road.loader.ModuleLoader;
	import road.manager.SoundManager;;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.StringHelper;

	public class RoomIIController extends BaseStateView 
	{
		private var _container:Sprite;
		private var _room:RoomInfo;
		private var _self:RoomPlayerInfo;
		private var _view:RoomIIView2;
		private var _invite:IInviteController;
		private static var isShowTutorial:Boolean;
		private var _loadingGame : GameLoadingControler;
		
		private var _mapsetPanel : RoomMapSetPanelBase;
		private var _setingAchieve:Boolean;

		public function RoomIIController()
		{
			super();
			GameManager.Instance.setup();
		}
		
		public function get room():RoomInfo
		{
			return _room;
		}
		
		public function get self():RoomPlayerInfo
		{
			return _self;
		}
		
		public function get container():Sprite
		{
			return _container;
		}
		
		public function set setingAchieve(value:Boolean):void
		{
			_setingAchieve = value
		}
		
		public function get setingAchieve():Boolean
		{
			return _setingAchieve;
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			super.enter(prev,data);
			
			GameManager.Instance.reset();
			
			currentState = 0;
			SoundManager.instance.playMusic("065");
			
			_self = PlayerManager.selfRoomPlayerInfo;
			
			_room = RoomManager.Instance.current;
			if(_room == null) return;
			if(_room.frightMatchWithNPC)
			{
				_room.roomType = 0;
				_room.mapId = 0;
				_room.frightMatchWithNPC = false;
			}

			_room.reset();
			_view = new RoomIIView2(this);
			_container = new Sprite();
			_container.addChild(_view);
			
			
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
			BellowStripViewII.Instance.backFunction = __backFunction;
			BellowStripViewII.Instance.closeBag();
			initParicleEnginee();
			if(_room.roomType >2 )
			_setingAchieve = false;
			
			if(PlayerManager.Instance.hasTempStyle)
			{
				PlayerManager.Instance.readAllTempStyleEvent();
			}
			
			if(!DialogueAgreePropose.Instance.isShowed)
			{
				DialogueAgreePropose.Instance.show();
			}
			GameManager.Instance.addEventListener(GameManager.START_LOAD,__startLoading);
			
			if(RoomManager.Instance.haveTempInventPlayer())
			{
				GameInSocketOut.sendInviteGame(RoomManager.Instance.tempInventPlayerID);
				RoomManager.Instance.tempInventPlayerID = -1;
			}
			if(_room.roomType>2)_self.addEventListener(RoomEvent.PLAYER_STATE_CHANGED   ,__hostLeave);
			EffortMovieClipManager.Instance.show();
		}
		/**TODO 这里的逻辑有点乱
		 */		
		private function __hostLeave(evt:RoomEvent):void
		{
			if(StateManager.currentStateType == StateType.ROOM)
			{
				if(_self.isHost && _room.roomState != RoomInfo.STATE_PICKING && currentState != 1)
				{
					_room.mapId = 10000
					GameInSocketOut.sendGameRoomSetUp(_room.mapId,_room.roomType,1,0);
				}
			}
		}
		
		override public function leaving(next:BaseStateView):void
		{
			if(_view)
			{
				_view.dispose();
				_view = null;
			}
			if(_mapsetPanel)
			{
				_mapsetPanel.dispose();
			}
			_mapsetPanel = null;
			if(_invite != null)
			{
				_invite.dispose();
				_invite = null;
			}
			GameManager.Instance.removeEventListener(GameManager.START_LOAD,__startLoading);
			BellowStripViewII.Instance.hide();
			BellowStripViewII.Instance.backFunction = null;
			
			if(_loadingGame) _loadingGame.dispose();
			_loadingGame = null;
			if(RoomManager.isRemovePlayerInRoomAndGame(next.getType()))
			{
				GameInSocketOut.sendGamePlayerExit();
				RoomManager.Instance.removeAndDisposeAllPlayer();
				RoomManager.Instance.current = null;
			}
			super.leaving(next);
		}
		
		private function __backFunction() : void
		{
			StateManager.setState(getBackType(),getBackType());
		}
		override public function check(type:String):Boolean
		{
			if(RoomManager.Instance.current == null || type == StateType.FIGHTING )
			{
//				trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",type);
//				DebugUtils.traceStack();
				return false;
			}
			return true;
		}
		
		override public function getType():String
		{
			return StateType.ROOM;
		}

		override public function getView():DisplayObject
		{
			return _container;
		}
		
		
		override public function getBackType():String
		{
			if(_room){
				return _room.backRoomListType;
			}else{
				return StateType.DUNGEON;
			}
		}
		
		override public function addedToStage():void
		{
			ChatManager.Instance.setFocus();
		}
		
		override public function goBack():Boolean
		{
			if(_room == null) return true;//在翻牌界面停留的时候被挤下来，在trophycontroller的dispose方法里面会跑到这个地方来(不合理，有时间再改)，所以这个时候_room可能为空 by wicki
			for each(var i:RoomPlayerInfo in _room.players)
			{
				if(i.isSelf)
					return false;
			}
			return true;
		}
		
		private function initParicleEnginee():void
		{
			if(!ShapeManager.ready)
			{
				var ml:ModuleLoader =  LoaderManager.Instance.createLoader("res/shape.swf",BaseLoader.MODULE_LOADER);
				LoaderManager.Instance.startLoad(ml);
				if(ml.isSuccess)
				{
					ShapeManager.setup();
				}
				else
				{
					ml.addEventListener(LoaderEvent.COMPLETE,__modelCompleted);
				}
			}
			if(!ParticleManager.ready)
				ParticleManager.loadSyc("partical.xml"+"?"+StringHelper.getRandomNumber());
		}
		
		private function __modelCompleted(event:Event):void
		{
			(event.currentTarget as ModuleLoader).removeEventListener(LoaderEvent.COMPLETE,__modelCompleted);
			ShapeManager.setup();
		}
		
		public function showMapSet():void
		{
			if(_mapsetPanel)
			{
				_mapsetPanel.dispose();
			}
			_mapsetPanel = null;
			if(_room.roomType == 0)
			{
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIMapSet.room"));
				return;
			}
			else if(_room.roomType == 2)
			{
				SoundManager.instance.play("045");
				_mapsetPanel  = new RoomMapSetPanelDanger(this,_room);
			}
			else if(_room.roomType == 1)
			{
				SoundManager.instance.play("045");
				_mapsetPanel = new RoomMapSetPanelPVP(this,_room);
			}
			else
			{
				SoundManager.instance.play("045");
				_mapsetPanel = new RoomMapSetPanelDuplicate(this,_room);
			}
			UIManager.setChildCenter(_mapsetPanel);
			TipManager.AddTippanel(_mapsetPanel);
			_container.stage.focus = _mapsetPanel as Sprite;
		}
		
		public function showInvite():void
		{
			if(_invite == null)
			{
				_invite = new InviteController();
			}
			if(_invite.getView().parent)
			{
				hideInvite();
			}
			else
			{
				_invite.refleshList(0);
				UIManager.AddDialog(_invite.getView());			
			}
		}
		
		public function hideInvite():void
		{
			if(_invite)
			{
				UIManager.RemoveDialog(_invite.getView());
			}
		}
		
		public function showPlayerInfo(info:PlayerInfo):void
		{
			PersonalInfoManager.instance.addPersonalInfo(info.ID,PlayerManager.Instance.Self.ZoneID);
		}
		
		public function captureLeader(flag:Boolean):void
		{
			GameInSocketOut.sendFlagMode(flag);
		}
		
		public function startGame():Boolean
		{
			if(_self.info.WeaponID <= 0)
			{
				SoundManager.instance.play("008");
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.weapon"));
				return false;
			}
			for each(var info:RoomPlayerInfo in RoomManager.Instance.current.players)
			{
				if(!info.isReady)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.all"));
					return false;
				}
			}
			if(_room.roomType == 1)
			{
				if(_room.isTeamBalance() != true)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.moreThanOne"));
					return false;
				}
				GameInSocketOut.sendGameStart();
				_room.roomState = RoomInfo.STATE_LOADING;
				return true;
			}
			else
			{
				GameInSocketOut.sendGameStart();
				//global.traceStr("startGame");
				_room.roomState = RoomInfo.STATE_PICKING;
				return true;	
			}
			return true;
		}
		
		//取消戳和
		public function cancelPickupGame():void
		{
			GameInSocketOut.sendCancelWait();
		}
		
		public function setSelfReadyState(ready:Boolean):Boolean
		{
			if(ready)
			{
				if(!_self.hasWeapon())
				{
					SoundManager.instance.play("008");
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomIIController.weapon"));
					return false;
				}
				if(!_self.isReady)
				{
					GameInSocketOut.sendPlayerState(1);
					_room.roomState = RoomInfo.STATE_READY;
					return true;
				}
			}
			else
			{
				if(_self.isReady)
				{
					if(_room.roomType == 0 && RoomIIView2.wait30Sec)
					{
						GameInSocketOut.sendCancelWait();
					}
					else 
					{
						GameInSocketOut.sendPlayerState(0);
					}
//					
					
					_room.roomState = RoomInfo.STATE_UNREADY;
					return true;
				}
			}
			
			return false;
		}
		
		private function removeView() : void
		{
			if(_view)
			{
				_view.dispose();
				_view = null;
			}
			if(_mapsetPanel && _mapsetPanel.parent)_mapsetPanel.parent.removeChild(_mapsetPanel);
		}
		public var currentState : int = 0;//0房间，1，loading;
		private function __startLoading(e:Event):void
		{
			//global.traceStr("startLoading");
			removeView();
			currentState = 1;
			_loadingGame = new GameLoadingControler();
			_container.addChild(_loadingGame);
			RoomManager.Instance.current.resetReadyStates();
		}
	}
}