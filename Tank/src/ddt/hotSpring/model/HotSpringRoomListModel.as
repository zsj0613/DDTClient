package ddt.hotSpring.model
{
	import flash.events.EventDispatcher;
	
	import road.data.DictionaryData;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.hotSpring.player.HotSpringPlayerBase;
	import ddt.hotSpring.events.HotSpringRoomEvent;
	import ddt.hotSpring.events.HotSpringRoomListEvent;
	import ddt.hotSpring.vo.MapVO;
	import ddt.hotSpring.vo.PlayerVO;
	import ddt.manager.HotSpringManager;
	import ddt.manager.PlayerManager;
	
	public class HotSpringRoomListModel extends EventDispatcher
	{
		private static var _instance : HotSpringRoomListModel;
		private var _roomList:DictionaryData=new DictionaryData();//房间列表	
		private var _roomSelf:HotSpringRoomInfo;//当前用户创建的房间
		
		/**
		 *模型单例 
		 */
		public static function get Instance() : HotSpringRoomListModel
		{
			if(_instance == null)
			{
				_instance = new HotSpringRoomListModel();
			}
			return _instance;
		}
		
		/**
		 * 取得房间列表
		 */		
		public function get roomList():DictionaryData
		{
			_roomList.list.sortOn("roomNumber",Array.NUMERIC);
			return _roomList;
		}
		
		/**
		 * 增加或更新房间
		 */		
		public function roomAddOrUpdate(roomVO:HotSpringRoomInfo):void
		{
			if(HotSpringManager.Instance.roomCurrently && HotSpringManager.Instance.roomCurrently.roomID==roomVO.roomID)
			{//如果更新的房间是当前玩家所在的房间信息，则更新
				HotSpringManager.Instance.roomCurrently=roomVO;
			}
			
			if(_roomList[roomVO.roomID]!=null)
			{//已存在
				_roomList.add(roomVO.roomID, roomVO);//add方法中已处理相同key的数据更新
				dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_UPDATE, roomVO));
			}
			else
			{//增加
				_roomList.add(roomVO.roomID, roomVO);//add方法中已处理相同key的数据更新
				dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_ADD, roomVO));
				dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_LIST_UPDATE));
			}
		}
		
		/**
		 * 移除房间
		 */		
		public function roomRemove(roomID:int):void
		{
			_roomList.remove(roomID);
			dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_REMOVE, roomID));
			dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_LIST_UPDATE));
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
		
		public function dispose():void
		{
			_roomSelf=null;
			
			if(_roomList) _roomList.clear();
			_roomList=null;
			
			_instance=null;
		}
	}
}