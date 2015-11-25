package ddt.hotSpring.model
{
	import flash.events.EventDispatcher;
	
	import road.data.DictionaryData;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.hotSpring.player.HotSpringPlayer;
	import ddt.hotSpring.events.HotSpringRoomEvent;
	import ddt.hotSpring.events.HotSpringRoomListEvent;
	import ddt.hotSpring.vo.MapVO;
	import ddt.hotSpring.vo.PlayerVO;
	import ddt.manager.HotSpringManager;
	import ddt.manager.PlayerManager;
	
	public class HotSpringRoomModel extends EventDispatcher
	{
		private static var _instance : HotSpringRoomModel;
		private var _roomSelf:HotSpringRoomInfo;//当前用户创建的房间
		private var _mapVO:MapVO=new MapVO();
		private var _selfVO:PlayerVO=new PlayerVO();//当前玩家信息
		private var _roomPlayerList:DictionaryData=new DictionaryData();//房间内玩家列表
		
		//金币房等级所对应每小时的经验值
		public static const expUpArray:Array=[0,200,240,288,346,415,498,597,717,860,946,1041,1145,1259,1385,
			1523,1676,1843,2028,2231,2342,2459,2582,2711,2847,2989,3139,3295,3460,3633,3815,3929,4047,4169,
			4294,4423,4555,4692,4833,4978,5127]
		
		/**
		 *模型单例 
		 */
		public static function get Instance() : HotSpringRoomModel
		{
			if(_instance == null)
			{
				_instance = new HotSpringRoomModel();
			}
			return _instance;
		}
		
		/**
		 * 取得当前用户自已创建的房间
		 */		
		public function get roomSelf():HotSpringRoomInfo
		{
			return _roomSelf;
		}
		
		/**
		 * 设置当前用户自已创建的房间(只在创建成功时才会设置此值)
		 */
		public function set roomSelf(value:HotSpringRoomInfo):void
		{
			_roomSelf=value;
			dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_CREATE, _roomSelf));
		}
		
		/**
		 * 取得房间内玩家列表
		 */		
		public function get roomPlayerList():DictionaryData
		{
			return _roomPlayerList;
		}
		
		/**
		 * 设置房间内玩家列表
		 */		
		public function set roomPlayerList(value:DictionaryData):void
		{
			_roomPlayerList=value;
		}
		
		/**
		 * 增加/更新房间内玩家
		 */		
		public function roomPlayerAddOrUpdate(playerVO:PlayerVO):void
		{
			if(playerVO.playerInfo.ID==PlayerManager.Instance.Self.ID)
			{//如果是当前玩家
				_selfVO=playerVO;//给当前玩家信息赙值
			}
			
			if(_roomPlayerList[playerVO.playerInfo.ID])
			{//存在
				_roomPlayerList.add(playerVO.playerInfo.ID, playerVO);
				dispatchEvent(new HotSpringRoomEvent(HotSpringRoomEvent.ROOM_PLAYER_UPDATE, playerVO));
			}
			else
			{
				_roomPlayerList.add(playerVO.playerInfo.ID, playerVO);
				dispatchEvent(new HotSpringRoomEvent(HotSpringRoomEvent.ROOM_PLAYER_ADD, playerVO));
			}
		}
		
		/**
		 * 清除玩家
		 */		
		public function roomPlayerRemove(playerID:int):void
		{
			if(_roomPlayerList) _roomPlayerList.remove(playerID);
			dispatchEvent(new HotSpringRoomEvent(HotSpringRoomEvent.ROOM_PLAYER_REMOVE, playerID));
		}
		
		/**
		 * 设置地图信息 
		 */		
		public function set mapVO(value:MapVO):void
		{
			_mapVO=value;
		}
		
		/**
		 *取得地图信息 
		 */		
		public function get mapVO():MapVO
		{
			return _mapVO;
		}
		
		/**
		 * 当前玩家信息
		 */		
		public function get selfVO():PlayerVO
		{
			return _selfVO;
		}
		
		/**
		 * 当前玩家信息
		 */		
		public function set selfVO(value:PlayerVO):void
		{
			_selfVO = value;
		}
		
		/**
		 * 根据房间类型及当前玩家等级取得玩家在房间内每分钟得到的经验值
		 */		
		public function getExpUpValue(roomType:int, playerLevel:int):int
		{
			var hourValue:int;
			switch(roomType)
			{
				case 1://系统金币房
					hourValue=int(expUpArray[playerLevel]);
					break;
			}
			return int(hourValue/60);//每分钟所得到的经验值
		}
		
		public function dispose():void
		{
			_roomSelf=null;
			_mapVO=null;
			_selfVO=null;
			
			if(_roomPlayerList)
			{
				while(_roomPlayerList.list.length>0)
				{
					_roomPlayerList.list.shift();
				}
				_roomPlayerList.clear();
			}
			_roomPlayerList=null;
			_instance=null;
		}
	}
}