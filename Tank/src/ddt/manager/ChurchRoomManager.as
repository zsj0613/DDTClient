package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	import ddt.data.ChurchRoomInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.events.ChurchRoomEvent;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.states.StateType;
	import ddt.view.common.WaitingView;
	
	import road.comm.PackageIn;
	import road.loader.BaseLoader;
	import road.loader.LoaderEvent;
	import road.loader.LoaderManager;
	import road.loader.ModuleLoader;
	import road.utils.ClassUtils;

	public class ChurchRoomManager extends EventDispatcher
	{
		private static const WEDDING_SCENE:Boolean = false;
		private static const MOON_SCENE:Boolean = true;
		
		private var _currentScene:Boolean = WEDDING_SCENE;
		
		public function get currentScene():Boolean
		{
			return _currentScene;
		}
		
		public function set currentScene(value:Boolean):void
		{
			if(_currentScene == value)return;
			_currentScene = value;
			
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.SCENE_CHANGE,_currentScene));
		}
		
		
		/* 自己的典礼房间 */
		public var _selfRoom:ChurchRoomInfo;
		
		public function get selfRoom():ChurchRoomInfo
		{
			return _selfRoom;
		}
		
		public function set selfRoom(value:ChurchRoomInfo):void
		{
			_selfRoom = value;
		}
		
		/*  当前房间 */
		private var _currentRoom:ChurchRoomInfo;
		public function set currentRoom(value:ChurchRoomInfo):void
		{
			if(_currentRoom == value)return;
			_currentRoom = value;
			
			onChurchRoomInfoChange();
		}
		
		public function get currentRoom():ChurchRoomInfo
		{
			return _currentRoom;
		}

/////////////////////////////////////////////////////////////////////////////////////////	
		private var _mapLoader01:ModuleLoader;
		private var _mapLoader02:ModuleLoader;
		
		private function onChurchRoomInfoChange():void
		{
			if(_currentRoom != null)
			{
				loadMap();
			}
		}
		
		public function loadMap():void
		{
			WaitingView.instance.show(WaitingView.LOAD,LanguageMgr.GetTranslation("ddt.manager.ChurchRoomManager.loadingMap"));
			if(!ClassUtils.hasDefinition("ddt.church.Map01")||!ClassUtils.hasDefinition("ddt.church.Map02"))
			{
				_mapLoader01 =  LoaderManager.Instance.createLoader(PathManager.solveChurchSceneSourcePath("Map01"),BaseLoader.MODULE_LOADER);
				_mapLoader02 =  LoaderManager.Instance.createLoader(PathManager.solveChurchSceneSourcePath("Map02"),BaseLoader.MODULE_LOADER);
				LoaderManager.Instance.startLoad(_mapLoader01);
				LoaderManager.Instance.startLoad(_mapLoader02);
//				if(ChurchRoomManager.instance.currentScene)
//				{
//					_mapLoader =  ModelManager.addModelFile("Salute.swf",false);
//				}
				_mapLoader01.addEventListener(ProgressEvent.PROGRESS,onLoadMapProgress);
				_mapLoader02.addEventListener(ProgressEvent.PROGRESS,onLoadMapProgress);
				_mapLoader01.addEventListener(LoaderEvent.COMPLETE,onMapSrcLoaded);
				_mapLoader02.addEventListener(LoaderEvent.COMPLETE,onMapSrcLoaded);
			}else
			{
				onMapSrcLoaded(null);
			}
		}
		
		private function onLoadMapProgress(e:ProgressEvent):void
		{
			WaitingView.instance.percent = Math.round(( _mapLoader01.progress +_mapLoader02.progress)/2);
		}
		
		private function onMapSrcLoaded(event:Event):void
		{
			if(_mapLoader01.isSuccess && _mapLoader02.isSuccess)
			{
				tryLoginScene();
			}
		}
		
		public function tryLoginScene():void
		{
			StateManager.setState(StateType.CHURCH_SCENE);
		}
//////////////////////////////////////////////////////////////////////////////////////
		
		private var _isHideName:Boolean;
		
		public function get isHideName():Boolean
		{
			return _isHideName;
		}
		
		public function set isHideName(value:Boolean):void
		{
			_isHideName = value;
			
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.ROOM_HIDE_NAME));
		}
		
		private var _isHidePao:Boolean;
		
		public function get isHidePao():Boolean
		{
			return _isHidePao;
		}
		
		public function set isHidePao(value:Boolean):void
		{
			_isHidePao = value;
			
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.ROOM_HIDE_PAO));
		}
		
		private var _isFireEnable:Boolean;
		public function set fireEnable(value:Boolean):void
		{
			_isFireEnable = value;
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.ROOM_FIRE_ENABLE_CHANGE));
		}
		
		public function get fireEnable ():Boolean
		{
			return _isFireEnable;
		}
		
		private var _isHideFire:Boolean;
		public function get isHideFire():Boolean
		{
			return _isHideFire;
		}
		
		public function set isHideFire(value:Boolean):void
		{
			_isHideFire = value;
			
			dispatchEvent(new ChurchRoomEvent(ChurchRoomEvent.ROOM_HIDE_FIRE));
		}
		
		private static var  _instance:ChurchRoomManager;
		public static function get instance():ChurchRoomManager
		{
			if(!_instance)
			{
				_instance = new ChurchRoomManager();
			}
			return _instance;
		}
		public function ChurchRoomManager()
		{
			
		}
		
		public function setup():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_LOGIN,__roomLogin);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_STATE,__updateSelfRoom);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,__removePlayer);
		}
		/**
		 * 进入房间反馈 
		 * @param event
		 * 
		 */		
		private function __roomLogin(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;

			var result:Boolean = pkg.readBoolean();
			if(!result)
			{
				return;
			}
			
			var room:ChurchRoomInfo = new ChurchRoomInfo(); 
			room.id = pkg.readInt();
			room.roomName = pkg.readUTF();
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
			room.isStarted = pkg.readBoolean();
			var statu:int = pkg.readByte();
			if(statu == 1)
			{
				room.status = ChurchRoomInfo.WEDDING_NONE
			}else
			{
				room.status = ChurchRoomInfo.WEDDING_ING;
			}
			room.discription = pkg.readUTF();
			room.canInvite = pkg.readBoolean();
			
			var sceneIndex:int = pkg.readInt();
			
			ChurchRoomManager.instance.currentScene = sceneIndex==1?false:true;
			room.isUsedSalute = pkg.readBoolean();
			
			currentRoom = room;
			/* 同步自己的房间信息 */
			if(isAdmin(PlayerManager.Instance.Self))
			{
				selfRoom = room;
			}
		}
		
		private function __updateSelfRoom(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var userID:int = pkg.readInt();
			var state:Boolean = pkg.readBoolean();
			if(!state)
			{
				selfRoom = null;
				return;
			}
			
			if(selfRoom == null)
			{
				selfRoom = new ChurchRoomInfo(); 
			}
			selfRoom.id = pkg.readInt();
			selfRoom.roomName = pkg.readUTF();
			selfRoom.mapID = pkg.readInt();
			selfRoom.valideTimes = pkg.readInt();
			selfRoom.createID = pkg.readInt();
			selfRoom.groomID = pkg.readInt();
			selfRoom.brideID = pkg.readInt();
			selfRoom.creactTime  = pkg.readDate();
			selfRoom.isUsedSalute = pkg.readBoolean();
		}
		
		public function __removePlayer(event:CrazyTankSocketEvent):void
		{
			var id:int = event.pkg.clientId;
			if(id == PlayerManager.Instance.Self.ID)
			{
				StateManager.setState(StateType.CHURCH_ROOMLIST);
			}
		}
		
		/**
		 * 是否新郎或新娘 
		 * @return 
		 * 
		 */		
		public function isAdmin(info:PlayerInfo):Boolean
		{
			if(_currentRoom)
			{
				return (info.ID == _currentRoom.groomID || info.ID == _currentRoom.brideID);
			}
			return false;
		}
	}
}