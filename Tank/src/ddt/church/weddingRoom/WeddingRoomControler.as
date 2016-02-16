package ddt.church.weddingRoom
{
	import ddt.church.weddingRoom.frame.CreateRoomFrame;
	import ddt.church.weddingRoom.frame.UnmarryFrame;
	
	import flash.events.Event;
	
	import road.comm.PackageIn;
	import road.loader.ModuleLoader;
	import road.manager.SoundManager;
	
	import ddt.data.ChurchRoomInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.ExternalInterfaceManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.SocketManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.common.BellowStripViewII;

	public class WeddingRoomControler extends BaseStateView
	{
		private var _model:WeddingRoomModel;
		private var _view:WeddingRoomView;
		
		private var _fireLoader:ModuleLoader;
		
		private var _mapSrcLoaded:Boolean = false;
		private var _mapServerReady:Boolean = false;
		public static const UNMARRY:String = "unmarry";
		public function WeddingRoomControler()
		{
			super();
		}
		override public function prepare():void
		{
			super.prepare();
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			super.enter(prev,data);
			init();
			addEvent();
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
			SoundManager.Instance.playMusic("062");
		}
		
		private function init():void
		{
			_model = new WeddingRoomModel();
			_view = new WeddingRoomView(this,_model);
			addChild(_view);
		}
		
		private function addEvent():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE,__addRoom);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,__removeRoom);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,__updateRoom);
		}
		
		private function removeEvent():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE,__addRoom);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,__removeRoom);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,__updateRoom);
		}
		
		private function __addRoom(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var result:Boolean = pkg.readBoolean();
			if(!result)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.addRoom"));
				//MessageTipManager.getInstance().show("创建房间失败");
				return;	
			}
			
			var room:ChurchRoomInfo = new ChurchRoomInfo(); 
			room.id = pkg.readInt();
			room.isStarted = pkg.readBoolean();
			room.roomName = pkg.readUTF();
			room.isLocked = pkg.readBoolean();
			room.mapID = pkg.readInt();
			room.valideTimes = pkg.readInt();
			room.currentNum = pkg.readInt();
			room.createID = pkg.readInt();
			room.createName = pkg.readUTF();
			room.groomID = pkg.readInt();
			room.groomName = pkg.readUTF();
			room.brideID = pkg.readInt();
			room.brideName = pkg.readUTF();
			room.creactTime  = pkg.readDate();
			var statu:int = pkg.readByte();
			if(statu == 1)
			{
				room.status = ChurchRoomInfo.WEDDING_NONE
			}else
			{
				room.status = ChurchRoomInfo.WEDDING_ING;
			}
			//发送给香港易游的数据
			if(PathManager.solveExternalInterfaceEnabel())
			{
				var self:SelfInfo = PlayerManager.Instance.Self;
				ExternalInterfaceManager.sendToAgent(8,self.ID,self.NickName,ServerManager.Instance.zoneName,-1,"",self.SpouseName);
			}
			room.discription = pkg.readUTF();
			_model.addRoom(room);
			
//			trace("教堂房间信息："+room.roomName+"创建时间"+room.creactTime+"有效期"+room.valideTimes);
		}
		
		private function __removeRoom(event:CrazyTankSocketEvent):void
		{
			var id:int = event.pkg.readInt();
			_model.removeRoom(id);
		}
		
		private function __updateRoom(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			/* 房间是否为null */
			var result:Boolean = pkg.readBoolean();
			if(result)
			{
				var room:ChurchRoomInfo = new ChurchRoomInfo(); 
				room.id = pkg.readInt();
				room.isStarted = pkg.readBoolean();
				room.roomName = pkg.readUTF();
				room.isLocked = pkg.readBoolean();
				room.mapID = pkg.readInt();
				room.valideTimes = pkg.readInt();
				room.currentNum = pkg.readInt();
				room.createID = pkg.readInt();
				room.createName = pkg.readUTF();
				room.groomID = pkg.readInt();
				room.groomName = pkg.readUTF();
				room.brideID = pkg.readInt();
				room.brideName = pkg.readUTF();
				room.creactTime  = pkg.readDate();
				var statu:int = pkg.readByte();
				if(statu == 1)
				{
					room.status = ChurchRoomInfo.WEDDING_NONE
				}else
				{
					room.status = ChurchRoomInfo.WEDDING_ING;
				}
				room.discription = pkg.readUTF();
				_model.updateRoom(room);
			}
		}

		/**
		 * 显示创建婚礼房间 
		 * 
		 */	
		public function showCreateFrame():void
		{
			
			if(!PlayerManager.Instance.Self.IsMarried)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.showCreateFrame"));
				//MessageTipManager.getInstance().show("您还未结婚，不可举行婚礼");
				return;
			}else if(ChurchRoomManager.instance.selfRoom)
			{
				SocketManager.Instance.out.sendEnterRoom(0,"");
				return;
			}
			
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			var createRoomFrame:CreateRoomFrame = new CreateRoomFrame(this);
			createRoomFrame.show();
			
		}
		
		/**
		 * 显示离婚确认窗口 
		 * 
		 */		
		public function showUnmarryFrame():void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			new UnmarryFrame(this).show();
		}

		public function createRoom(room:ChurchRoomInfo):void
		{
			if(ChurchRoomManager.instance.selfRoom)
			{
				SocketManager.Instance.out.sendEnterRoom(0,"");
			}
			
			SocketManager.Instance.out.sendCreateRoom(room);		
		}
		
		public function unmarry(isPlayMovie:Boolean = false):void
		{
			if(ChurchRoomManager.instance._selfRoom)
			{
				if(ChurchRoomManager.instance._selfRoom.status == ChurchRoomInfo.WEDDING_ING)
				{
					SocketManager.Instance.out.sendUnmarry(true);
					SocketManager.Instance.out.sendUnmarry(isPlayMovie);
					if(_model && ChurchRoomManager.instance._selfRoom)
					{
						_model.removeRoom(ChurchRoomManager.instance._selfRoom.id);
					}
					dispatchEvent(new Event(UNMARRY));
					return;
				}
			}
			SocketManager.Instance.out.sendUnmarry(isPlayMovie);
			if(_model && ChurchRoomManager.instance._selfRoom)
			{
				_model.removeRoom(ChurchRoomManager.instance._selfRoom.id);
			}
			dispatchEvent(new Event(UNMARRY));
		}
		
		/**
		 * 切换视图状态 
		 * @param state
		 * 
		 */		
		public function changeViewState(state:String):void
		{
			_view.changeState(state);
		}
		
		override public function leaving(next:BaseStateView):void
		{
			super.leaving(next);
			
			SocketManager.Instance.out.sendExitMarryRoom();
			
			BellowStripViewII.Instance.backFunction = null;
			BellowStripViewII.Instance.hide();
			
			dispose();
		}
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		override public function getType():String
		{
			return StateType.CHURCH_ROOMLIST;
		}
		
		override public function dispose():void
		{
			removeEvent();
			
			if(_model)_model.dispose();
			_model = null;
			if(_view)_view.dispose();
			_view = null;
		}
	}
}