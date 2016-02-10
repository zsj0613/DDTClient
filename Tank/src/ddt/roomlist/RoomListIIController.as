package ddt.roomlist
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ddt.data.SimpleRoomInfo;
	import ddt.data.player.FriendListPlayer;
	import ddt.data.player.PlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StatisticManager;
	import ddt.manager.TaskManager;
	import ddt.menu.RightMenu;
	import ddt.menu.RightMenuPanel;
	import ddt.socket.GameInSocketOut;
	import ddt.socket.GameSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.WaitingView;
	
	import par.manager.ParticleManager;
	import par.manager.ShapeManager;
	
	import road.comm.PackageIn;
	import road.loader.BaseLoader;
	import road.loader.LoaderEvent;
	import road.loader.LoaderManager;
	import road.loader.ModuleLoader;
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.StringHelper;

    /**房间列表**/
	public class RoomListIIController extends BaseStateView implements IRoomListIIController
	{ 
		private static var isShowTutorial  : Boolean = false;//是否显示新手教程 
		protected var _model               : IRoomListIIModel;
		protected var _container           : Sprite;
		private var _view                  : RoomListIIView;
		private var _createview            : RoomListIICreateRoomView;
		private var _findRoom              : RoomListIIFindRoomPanel;
		private var _passinput:RoomListIIPassInput;
		public function RoomListIIController()
		{
		}
		
		protected function init():void
		{
			_model = new RoomListIIModel();
			_container = new Sprite();
			_container.graphics.beginFill(0x000000,0);
			_container.graphics.drawRect(0,0,1000,600);
			_container.graphics.endFill();
			_view = new RoomListIIView(this,_model);
			_container.addChild(_view);
			RightMenu.Instance.chanllengeEnable = true;
			
		}
		
		protected function initEvent():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,__addRoom);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,      __addWaitingPlayer);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,   __removeWaitingPlayer);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROOMLIST_PASS,   __roomListPass);
			_container.addEventListener(MouseEvent.CLICK,                                     __containerClick); 
			RightMenu.Instance.addEventListener(RightMenuPanel.CHALLENGE,                     __onChanllengeClick);
		}
		
		override public function getType():String
		{
			return StateType.ROOM_LIST;
		}
		
		private function __addRoom(evt:CrazyTankSocketEvent):void
		{
			var tempArray:Array = [];
			var pkg:PackageIn = evt.pkg;
			_model.roomTotal = pkg.readInt();
			var len:int = pkg.readInt();
			for(var i:int = 0 ; i<len ; i++)
			{
//				_model.roomTotal = pkg.readInt();
				var id:int = pkg.readInt();
				var info:SimpleRoomInfo = _model.getRoomById(id);
				if(info == null)
					info = new SimpleRoomInfo();
				info.ID = id;
				info.roomType = pkg.readByte();
				info.timeType = pkg.readByte();
				info.totalPlayer = pkg.readByte();
				info.placeCount = pkg.readByte();
				info.IsLocked = pkg.readBoolean();
				info.mapId = pkg.readInt();
				info.isPlaying = pkg.readBoolean();
				
				info.Name = pkg.readUTF();
				info.gameMode = pkg.readByte();
				info.hardLevel = pkg.readByte();
				info.levelLimits = pkg.readInt();
				tempArray.push(info);
			}
			updataRoom(tempArray);
		}
		
		protected function updataRoom(tempArray : Array) : void
		{
			if(tempArray.length == 0)
			{
				_model.updateRoom(tempArray);
				return;
			}
			if((tempArray[0] as SimpleRoomInfo).roomType <=2)_model.updateRoom(tempArray);
		}
		
		private function __addWaitingPlayer(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var player:PlayerInfo = new PlayerInfo();
			player.beginChanges();
			player.ID = pkg.clientId;
			
			player.Grade = pkg.readInt();
			player.Sex = pkg.readBoolean();
			player.NickName = pkg.readUTF();
			player.ConsortiaName = pkg.readUTF();
			player.Offer = pkg.readInt();
			player.WinCount = pkg.readInt();
			player.TotalCount = pkg.readInt();
			player.EscapeCount = pkg.readInt();
			player.ConsortiaID = pkg.readInt();
			
			player.Repute = pkg.readInt();
			
			player.IsMarried = pkg.readBoolean();
			
			if(player.IsMarried)
			{
				player.SpouseID = pkg.readInt();
				player.SpouseName = pkg.readUTF();
			}
			player.LoginName = pkg.readUTF();
			player.FightPower = pkg.readInt();
			player.commitChanges();
			_model.addWaitingPlayer(player);
		}
		
		private function __removeWaitingPlayer(evt:CrazyTankSocketEvent):void
		{
			_model.removeWaitingPlayer(evt.pkg.clientId);
		}
		
		public function setRoomShowMode(mode:int):void
		{
			_model.roomShowMode = mode;
		}
		
		private function __roomListPass(evt:CrazyTankSocketEvent):void
		{
			var id:int = evt.pkg.readInt();
			if(_passinput)
			{
				_passinput.dispose();
			}
			_passinput = null;
			if(!_passinput)
			{
				_passinput = new RoomListIIPassInput();
				UIManager.setChildCenter(_passinput);
			}
			_passinput.ID = id;
			_passinput.show();
			_passinput.okBtnEnable = false;
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			SoundManager.instance.playMusic("062");
			super.enter(prev,data);
			StatisticManager.loginRoomListNum ++;
			SocketManager.Instance.out.sendCurrentState(1);
			
			init();
			initEvent();
			SocketManager.Instance.out.sendSceneLogin(lookupEnumerate.ROOM_LIST);
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
			BellowStripViewII.Instance.tutorialBtnsStatus(true);
			BellowStripViewII.Instance.tutorialStatus(false);
			RoomManager.Instance.current = null;
			BellowStripViewII.Instance.newQuest(false);
			if(StatisticManager.Instance().IsNovice)TaskManager.requestCanAcceptTask();
			if(!ShapeManager.ready)
			{
				var ml:ModuleLoader =  LoaderManager.Instance.createLoader("shape.swf",BaseLoader.MODULE_LOADER);
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
			
			if(PlayerManager.Instance.hasTempStyle)
			{
				PlayerManager.Instance.readAllTempStyleEvent();
			}
			
		}
		
		
		private function __modelCompleted(event:Event):void
		{
			(event.currentTarget as ModuleLoader).removeEventListener(LoaderEvent.COMPLETE,__modelCompleted);
			ShapeManager.setup();
		}
		
		override public function leaving(next:BaseStateView):void
		{
			dispose();
			GameInSocketOut.sendExitScene();
			BellowStripViewII.Instance.hide();
			RightMenu.Instance.chanllengeEnable = false;
			super.leaving(next);
		}

		override public function getView():DisplayObject
		{
			return _container;
		}
		
		public function sendGoIntoRoom(info:SimpleRoomInfo):void
		{
			_view.sendGointoRoom(info);
		}
		
		public function showFindRoom():void
		{
			if(_findRoom)_findRoom.dispose();
			_findRoom = null;
			_findRoom = new RoomListIIFindRoomPanel(this,_model);
			_findRoom.show();
		}
		
		protected function __containerClick(evt:MouseEvent):void
		{
			_view.setMenuDisvisiable();
		}
		
		protected function __onChanllengeClick(e:Event):void
		{
			//if(RightMenu.Instance.info.Grade<4)
			//{
				//MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.cantBeChallenged"));
			//	return;
			//}
			if(RightMenu.Instance.info.State == 0 && (e.target.info is FriendListPlayer))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.friendOffline"));
				return;
			}
			var  i:int=(Math.random()*100+4)%4;
			GameInSocketOut.sendCreateRoom(RoomListIICreateRoomView.PREWORD[i],1,2,"");
			RoomManager.Instance.tempInventPlayerID = RightMenu.Instance.info.ID;
			RightMenu.Instance.removeEventListener(RightMenuPanel.CHALLENGE,__onChanllengeClick);       
		}
		
		public static function disorder(arr:Array):Array
		{
			for(var i:int = 0 ; i<arr.length ; i++)
			{
				var random:int = (Math.random()*10000)%arr.length;
				var temInfo:SimpleRoomInfo = arr[i];
				arr[i] = arr[random];
				arr[random] = temInfo;
			}
			var newArray:Array = [];
			for(var j:int = 0 ; j <arr.length ;j++)
			{
				if(!(arr[j] as SimpleRoomInfo).isPlaying)
				{
					newArray.push(arr[j]);
				}else
				{
					newArray.unshift(arr[j]);
				}
			}
			return newArray;
		}
		
		override public function dispose():void
		{
			WaitingView.instance.hide();
			if(_createview)_createview.dispose();
			if(_findRoom)_findRoom.dispose();
			if(_view)_view.dispose();
			if(_model)_model.dispose();
			_createview = null;
			_view = null;
			_model = null;
			_findRoom = null;
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,__addRoom);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,__addWaitingPlayer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,__removeWaitingPlayer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ROOMLIST_PASS,   __roomListPass);
			RightMenu.Instance.removeEventListener(RightMenuPanel.CHALLENGE,__onChanllengeClick); 
			_container.removeEventListener(MouseEvent.CLICK,__containerClick);
		}
		
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		public function showCreateView():void
		{
			if(_createview != null)_createview.dispose();
			_createview = null;
            _createview = new RoomListIICreateRoomView(this);
			UIManager.setChildCenter(_createview);
			TipManager.AddTippanel(_createview);
		}
	}
}