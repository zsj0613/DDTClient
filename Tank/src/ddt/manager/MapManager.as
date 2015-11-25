package ddt.manager
{
	import flash.events.EventDispatcher;
	
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.DungeonInfo;
	import ddt.data.FightLibInfo;
	import ddt.data.MapInfo;
	import ddt.request.GetDungeonInfoAction;
	import ddt.request.GetFightLibInfoAction;
	import ddt.request.GetMapInfoAction;
	import ddt.request.LoadWeekOpenMap;
	import ddt.utils.LeavePage;
	
	public class MapManager extends EventDispatcher
	{
		private static var _list:Array;
		
		private static var _openList:Array;
		
		private static var _radomMapInfo:MapInfo;
		
		private static var _pveList:Array;
		private static var _pvpList:Array;
		private static var _pveLinkList:Array;
		private static var _pveBossList:Array;
		private static var _pveExplrolList:Array;
		private static var _pvpComplectiList:Array;
		private static var _fightLibList:Array;
		
		public static const PVP_TRAIN_MAP:int = 1;
		public static const PVP_COMPECTI_MAP:int = 0;
		public static const PVE_EXPROL_MAP:int = 2;
		public static const PVE_BOSS_MAP:int = 3;//boss
		public static const PVE_LINK_MAP:int = 4;//fb
		public static const FIGHT_LIB:int = 5;
		/**
		 *房间大厅小地图图标map列表用 分别为两个一个pvp 一个PVE
		 */		
		public static const PVE_MAP:int = 5;
		public static const PVP_MAP:int = 6;
		
		public static function getListByType(type:int = 0):Array
		{
			if(type == PVP_TRAIN_MAP)
			{
				return _list;
			}else if(type == PVE_MAP)
			{
				return _pveList;
			}else if(type == PVE_LINK_MAP)
			{
				return _pveLinkList;
			}else if(type == PVE_BOSS_MAP)
			{
				return _pveBossList;
			}else if(type == PVE_EXPROL_MAP)
			{
				return _pveExplrolList;
			}else if(type == PVP_COMPECTI_MAP)
			{
				return _pvpComplectiList;
			}else if(type == PVP_MAP)
			{
				return _pvpList;
			}else if(type == FIGHT_LIB)
			{
				return _fightLibList;
			}
			return null;
		}
		
		public static function setup():void
		{
			new GetMapInfoAction().loadSync(__loadMapComplete,3);
			new GetDungeonInfoAction().loadSync(__loadDungeonComplete,3);
			new LoadWeekOpenMap().loadSync(__loadWeekOpenMap,3);
//			new GetFightLibInfoAction().loadSync(__loadFightLibInfoComplete,3);
//			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN,__userLoginsuccess);
		}
		
		private static function __loadMapComplete(loader:GetMapInfoAction):void
		{
			if(loader.isSuccess)
			{				
				_list = loader.list;
				_pvpList = _list.slice();
				_radomMapInfo = new MapInfo();
				_radomMapInfo.ID = 0;
				_radomMapInfo.isOpen = true;
				_radomMapInfo.canSelect = true;

				_radomMapInfo.Name = LanguageMgr.GetTranslation("ddt.manager.MapManager.random");
				_radomMapInfo.Description = LanguageMgr.GetTranslation("ddt.manager.MapManager.random");
//				_radomMapInfo.Name = "随机地图";
//				_radomMapInfo.Description = "随机地图";
				_list.unshift(_radomMapInfo);
				_pvpComplectiList = [_radomMapInfo];
				buildMap();
			}
			else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.MapManager.loader"),true,callSolveLogin,false,HAlertDialog.OK_LABEL,callSolveLogin);
				//AlertDialog.show("错误","加载地图信息失败!");
			}
		}
		
		private static function __loadDungeonComplete(loader:GetDungeonInfoAction):void
		{
			if(loader.isSuccess)
			{	
				_pveList = loader.list;
				_pveLinkList = [];
				_pveBossList = [];
				_pveExplrolList = [];
				_fightLibList = [];
				for(var i:int = 0;i<_pveList.length;i++)
				{
					var info:DungeonInfo = _pveList[i];
					if(info.Type == PVE_LINK_MAP)
					{
						_pveLinkList.push(info);
					}else if(info.Type == PVE_BOSS_MAP)
					{
						_pveBossList.push(info);
					}else if(info.Type == PVE_EXPROL_MAP)
					{
						_pveExplrolList.push(info);
//						_pvpList.push(info);
					}else if(info.Type == FIGHT_LIB)
					{
						_fightLibList.push(info);
					}
				}
				var dungeonInfo:DungeonInfo = new DungeonInfo();
				dungeonInfo.ID = 10000;
				dungeonInfo.Description = LanguageMgr.GetTranslation("ddt.manager.selectDuplicate");
				dungeonInfo.isOpen = true;
				dungeonInfo.Name = LanguageMgr.GetTranslation("ddt.manager.selectDuplicate");
				dungeonInfo.Type = 4;
				_pveLinkList.unshift(dungeonInfo);
				_pveBossList.unshift(dungeonInfo);
			}else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.MapManager.loader"),true,callSolveLogin,false,HAlertDialog.OK_LABEL,callSolveLogin);
			}
		}
		
		private static function callSolveLogin():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
		}
		
		private static function __loadWeekOpenMap(loader:LoadWeekOpenMap):void
		{
			if(loader.isSuccess)
			{
				_openList = loader.list;
				buildMap();
			}
			else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.MapManager.loader"),true,callSolveLogin,false,HAlertDialog.OK_LABEL,callSolveLogin);
				//AlertDialog.show("错误","加载地图信息失败!");
			}
		}
		
//		private static function __loadFightLibInfoComplete(loader:GetFightLibInfoAction):void
//		{
//			if(loader.isSuccess)
//			{
//				_fightLibList = loader.list;
//			}else
//			{
//				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Error"),LanguageMgr.GetTranslation("ddt.manager.MapManager.loader"),true,callSolveLogin,false,HAlertDialog.OK_LABEL,callSolveLogin);
//				//AlertDialog.show("错误","加载地图信息失败!");
//			}
//		}
		
		public static function buildMap():void
		{	
			if(_openList == null || _list == null || ServerManager.Instance.current == null) return;
			var currentMaps:String;
			for(var i:uint = 0;i<_openList.length;i++)
			{
				if(_openList[i].serverID == ServerManager.Instance.current.ID)
				{
					currentMaps = _openList[i].maps;
				}
			}
			
			if(_openList && _list)
			{
				for each(var info:MapInfo in _list)
				{	
					if(currentMaps){
						info.isOpen = currentMaps.indexOf(String(info.ID)) > -1;
					}
				}
				_list.splice(_list.indexOf(_radomMapInfo),1);
				_list.unshift(_radomMapInfo);
			}
		}
		
		public static function isMapOpen(id:int):Boolean
		{
			return getMapInfo(id).isOpen;
		}
		
		public function getMapIsOpen(mapid:int):Boolean
		{
			return _openList.indexOf(mapid) != -1;
		}
		
		public static function getMapInfo(id:Number):MapInfo
		{
			for each(var info:MapInfo in _list)
			{
				if(info.ID == id)
				{
					return info;
				}
			}
			return null;
		}
		
		
		public static function getDungeonInfo(id:int):DungeonInfo
		{
			for each(var info:DungeonInfo in _pveList)
			{
				if(info.ID == id)
				{
					return info;
				}
			}
			return null;
		}
		
		public static function getFightLibList():Array
		{
			return _fightLibList;
		}
		
		public static function getMapName(id:int):String
		{
			var info:DungeonInfo = getDungeonInfo(id);
			if(info)
			{
				return info.Name;
			}
			var m_info:MapInfo = getMapInfo(id);
			if(m_info)
			{
				return m_info.Name;
			}
			return "";
		}
	}
}