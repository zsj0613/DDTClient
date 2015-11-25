package ddt.church.churchScene
{
	import ddt.church.churchScene.frame.ChurchContinuationFrame;
	import ddt.church.churchScene.frame.PresentFrame;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import road.comm.PackageIn;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.data.ChurchRoomInfo;
	import ddt.data.player.ChurchPlayerInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.events.ChurchRoomEvent;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.TimeManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.BellowStripViewII;

	public class SceneControler extends BaseStateView
	{
		private var _sceneModel:SceneModel;
		private var _sceneView:SceneView;

		private var timer:Timer;
		
		public function SceneControler()
		{
			super();
		}
		
		override public function prepare():void
		{
			super.prepare();
		}
		override public function getBackType():String
		{
			return StateType.CHURCH_ROOMLIST;
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			super.enter(prev,data);
			
			TipManager.clearTipLayer();
			UIManager.clear()
			SocketManager.Instance.out.sendCurrentState(0);
			BellowStripViewII.Instance.hide();
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			_sceneModel = new SceneModel();
			_sceneView = new SceneView(this,_sceneModel);
			
			resetTimer();
		}
		
		public function resetTimer():void
		{
			if(ChurchRoomManager.instance.isAdmin(PlayerManager.Instance.Self))
			{
				var beginDate:Date = ChurchRoomManager.instance.currentRoom.creactTime;
				var diff:Number = TimeManager.Instance.TotalDaysToNow(beginDate)*24;
				/* 剩余分钟数 */
				var valid:Number = (ChurchRoomManager.instance.currentRoom.valideTimes - diff)*60;
				
				if(valid>10)
				{
					stopTimer();
					
					timer = new Timer((valid-10)*60*1000,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
					timer.start();
				}
			}
		}
		
		private function __timerComplete(event:TimerEvent):void
		{
			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.timerComplete"));
			//MessageTipManager.getInstance().show("您的房间将在10分钟后关闭，请注意续费。");
			
			var msg:ChatData = new ChatData();
			msg.channel = ChatInputView.SYS_NOTICE;
			msg.msg = LanguageMgr.GetTranslation("church.churchScene.SceneControler.timerComplete.msg");
			//msg.msg = "您的房间将在10分钟后关闭，请注意续费。";
			ChatManager.Instance.chat(msg);
			
			stopTimer();
		}
		
		private function stopTimer():void
		{
			if(timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
				timer = null;
			}
		}
		
		private function addEvent():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,__addPlayer);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,__removePlayer);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MOVE,__movePlayer);
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HYMENEAL,__startWedding);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTINUATION,__continuation);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HYMENEAL_STOP,__stopWedding);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USEFIRECRACKERS,__onUseFire);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GUNSALUTE,__onUseSalute);
			
			ChurchRoomManager.instance.currentRoom.addEventListener(ChurchRoomEvent.WEDDING_STATUS_CHANGE,__updateWeddingStatus);
			ChurchRoomManager.instance.currentRoom.addEventListener(ChurchRoomEvent.ROOM_VALIDETIME_CHANGE,__updateValidTime);
			ChurchRoomManager.instance.addEventListener(ChurchRoomEvent.SCENE_CHANGE,__sceneChange);
		}
		
		private function removeEvent():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,__addPlayer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,__removePlayer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MOVE,__movePlayer);
			
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HYMENEAL,__startWedding);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTINUATION,__continuation);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HYMENEAL_STOP,__stopWedding);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USEFIRECRACKERS,__onUseFire);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GUNSALUTE,__onUseSalute);
			
			ChurchRoomManager.instance.currentRoom.removeEventListener(ChurchRoomEvent.WEDDING_STATUS_CHANGE,__updateWeddingStatus);
			ChurchRoomManager.instance.currentRoom.removeEventListener(ChurchRoomEvent.ROOM_VALIDETIME_CHANGE,__updateValidTime);
			ChurchRoomManager.instance.removeEventListener(ChurchRoomEvent.SCENE_CHANGE,__sceneChange);
		}
		
		private function __continuation(event:CrazyTankSocketEvent):void
		{
			if(ChurchRoomManager.instance.currentRoom)
			{
				ChurchRoomManager.instance.currentRoom.valideTimes = event.pkg.readInt();
			}
		}
		
		private function __updateValidTime(event:ChurchRoomEvent):void
		{
			resetTimer();
		}
		
		override public function leaving(next:BaseStateView):void
		{
			dispose();
			
			ChurchRoomManager.instance.currentRoom = null;
			ChurchRoomManager.instance.currentScene = false;
			ChurchRoomManager.instance.isHideName = false;
			ChurchRoomManager.instance.isHidePao = false;
			ChurchRoomManager.instance.isHideFire = false;
			
			SocketManager.Instance.out.sendExitRoom();
			super.leaving(next);
		}
		
		override public function getType():String
		{
			return StateType.CHURCH_SCENE;
		}
		
		public function __addPlayer(event:CrazyTankSocketEvent):void 
		{
			var pkg:PackageIn = event.pkg;
			
			var playerInfo:PlayerInfo = new PlayerInfo();
			playerInfo.beginChanges();
			playerInfo.Grade = pkg.readInt();
			playerInfo.Hide = pkg.readInt();
			playerInfo.Repute = pkg.readInt();
			playerInfo.ID = pkg.readInt();
			playerInfo.NickName = pkg.readUTF();
			playerInfo.Sex = pkg.readBoolean();
			playerInfo.Style = pkg.readUTF();
			playerInfo.Colors = pkg.readUTF();
			playerInfo.Skin = pkg.readUTF();
			var posx:int = pkg.readInt();
			var posy:int = pkg.readInt();
			playerInfo.FightPower = pkg.readInt();
			playerInfo.WinCount   = pkg.readInt();
			playerInfo.TotalCount = pkg.readInt();
			playerInfo.commitChanges();
			var churchPlayerInfo:ChurchPlayerInfo = new ChurchPlayerInfo(playerInfo);
			churchPlayerInfo.posX = posx;
			churchPlayerInfo.posY = posy;
			
			if(playerInfo.ID == PlayerManager.Instance.Self.ID)return;
			
			_sceneModel.addPlayer(churchPlayerInfo);
		}
		
		public function __removePlayer(event:CrazyTankSocketEvent):void
		{
			var id:int = event.pkg.clientId;
			
			if(id == PlayerManager.Instance.Self.ID)
			{
				StateManager.setState(StateType.CHURCH_ROOMLIST);
			}else
			{
				if(ChurchRoomManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
				{
//					_sceneModel.removePlayer(id);
					return;
				}
				_sceneModel.removePlayer(id);
			}
		}
		
		public function __movePlayer(event:CrazyTankSocketEvent):void
		{
			var id:int = event.pkg.clientId;
			var posX:int = event.pkg.readInt();
			var posY:int = event.pkg.readInt();
			var pathStr:String = event.pkg.readUTF();
			
			if(ChurchRoomManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)return;
			
			if(id == PlayerManager.Instance.Self.ID)return;
			
			var arr:Array = pathStr.split(",");
			var path:Array = [];
			
			for(var i:uint = 0;i<arr.length;i+=2)
			{
				var p:Point = new Point(arr[i],arr[i+1]);
				path.push(p);
			}

			_sceneView.movePlayer(id,path);
		}
		
		private function __updateWeddingStatus(event:ChurchRoomEvent):void
		{	
			if(!ChurchRoomManager.instance.currentScene)
			{
				_sceneView.switchWeddingView();	
			}
		}
		
		public function playWeddingMovie():void
		{
			_sceneView.playerWeddingMovie();
		}	
		
		/**
		 * 开始典礼 
		 */		
		public function startWedding():void
		{
			if(ChurchRoomManager.instance.isAdmin(PlayerManager.Instance.Self)&&ChurchRoomManager.instance.currentRoom.status != ChurchRoomInfo.WEDDING_ING)
			{
				////
				var beginDate:Date = ChurchRoomManager.instance.currentRoom.creactTime;
				var diff:Number = TimeManager.Instance.TotalDaysToNow(beginDate)*24;
				/* 剩余分钟数 */
				var valid:Number = (ChurchRoomManager.instance.currentRoom.valideTimes - diff)*60;
				if(valid<10)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.valid"));
					//MessageTipManager.getInstance().show("礼堂剩余时间不足举行婚礼，请及时续费");
					return;
				}
//				var msg:ChatMsg = new ChatMsg();
//				msg.channel = ChannelListSelectView.SYS_NOTICE;
//				msg.msg = "您的房间还剩余"+valid+"分钟";
//				ChatManagerII.getInstance().chat(msg);
//				return;
				////
				var spouse:ChurchPlayerInfo = _sceneModel.getPlayerFromID(PlayerManager.Instance.Self.SpouseID);
				if(!spouse)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.spouse"));
					//MessageTipManager.getInstance().show("你的情侣不在场，不能开始典礼");
					return;
				}
				
				if(ChurchRoomManager.instance.currentRoom.isStarted)
				{
					if(PlayerManager.Instance.Self.bagLocked)
					{
						new BagLockedGetFrame().show();
						return;
					}
					
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.isStarted"),true,okAgainStartWedding,null,true,LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.more"));
					return;
				}
//				okAgainStartWedding();
				SocketManager.Instance.out.sendStartWedding();
			}
		}
		
		private function okAgainStartWedding():void
		{
			if(PlayerManager.Instance.Self.Money < 500)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				return;
			}
			
			SocketManager.Instance.out.sendStartWedding();
		}
		
		/**
		 * 开始典礼反馈 
		 * @param event
		 */		
		private function __startWedding(event:CrazyTankSocketEvent):void
		{
			var roomID:int = event.pkg.readInt();
			var result:Boolean = event.pkg.readBoolean();
			
			if(result)
			{
				ChurchRoomManager.instance.currentRoom.isStarted = true;
				ChurchRoomManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_ING;
			}
		}
		
		private function __stopWedding(event:CrazyTankSocketEvent):void
		{			
			ChurchRoomManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_NONE;
		}
		
		/**
		 * 礼堂续费 
		 * 
		 */		
		public function continuation():void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			var continuationFrame:ChurchContinuationFrame = new ChurchContinuationFrame(this);
			
			TipManager.AddTippanel(continuationFrame,true);
		}
		
		public function modifyDiscription(roomName:String,modifyPSW:Boolean,psw:String,discription:String):void
		{
			SocketManager.Instance.out.sendModifyChurchDiscription(roomName,modifyPSW,psw,discription);
		}
		
		public function present():void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			if(PlayerManager.Instance.Self.Money < 100)
			{
				var msg:ChatData = new ChatData();
				msg.channel = ChatInputView.SYS_NOTICE;
				msg.msg = LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.Money");
				ChatManager.Instance.chat(msg);
								
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				return;
			}
			
			var presentFrame:PresentFrame = new PresentFrame(this);
			
			TipManager.AddTippanel(presentFrame,true);
		}
		
		public function useFire(id:int,fireID:int):void
		{
			_sceneView.useFire(id,fireID);
		}
		
		private function __onUseFire(e:CrazyTankSocketEvent):void
		{
			var userID:int = e.pkg.readInt();
			var fireID:int = e.pkg.readInt();
			useFire(userID,fireID);
		}
		
		private function __onUseSalute(event:CrazyTankSocketEvent):void
		{
			var userID:int = event.pkg.readInt();
			
			setSaulte(userID);
		}
		
		public function setSaulte(id:int):void
		{
			_sceneView.setSaulte(id);
		}
		
		/**
		 * 场景改变 
		 * @param event
		 */		
		private function __sceneChange(event:ChurchRoomEvent):void
		{
			readyEnterScene();
		}
	
		public function readyEnterScene():void
		{
			/* 关掉所有窗口 */
			TipManager.clearTipLayer();
			TipManager.clearNoclearLayer();
			UIManager.clear();
			
			var switchMovie:SwitchMovie = new SwitchMovie(true,0.06);
			addChild(switchMovie);
			switchMovie.playMovie();
			switchMovie.addEventListener(SwitchMovie.SWITCH_COMPLETE,__readyEnterOk);
		}
		
		private function __readyEnterOk(event:Event):void
		{
			event.currentTarget.removeEventListener(SwitchMovie.SWITCH_COMPLETE,__readyEnterOk);
			enterScene();
		}
		
		public function enterScene():void
		{
			_sceneModel.reset();
			
			var pos:Point;
			if(!ChurchRoomManager.instance.currentScene)
			{
				pos = new Point(514,637);
			}
			_sceneView.setMap(pos);
			
			/* 已经进入场景再发消息 */
			var sceneIndex:int = ChurchRoomManager.instance.currentScene?2:1;
			SocketManager.Instance.out.sendSceneChange(sceneIndex);
		}
		
		override public function dispose():void
		{
			removeEvent();
			stopTimer();
			if(_sceneModel)_sceneModel.dispose();
			_sceneModel = null;
			if(_sceneView)_sceneView.dispose();
			_sceneView = null;
		}
	}
}