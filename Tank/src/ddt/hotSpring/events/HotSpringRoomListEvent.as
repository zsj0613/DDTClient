package ddt.hotSpring.events
{
	import flash.events.Event;
	
	public class HotSpringRoomListEvent extends Event
	{
		/**
		 *玩家创建房间成功 
		 */		
		public static const ROOM_CREATE:String = "roomCreate";
		
		/**
		 *房间列表更新 
		 */		
		public static const ROOM_LIST_UPDATE:String = "roomListUpdate";
		
		/**
		 *移除(关闭)房间 
		 */		
		public static const ROOM_REMOVE:String = "roomRemove";
		
		/**
		 *增加房间
		 */		
		public static const ROOM_ADD:String = "roomAdd";
		
		/**
		 *更新房间
		 */		
		public static const ROOM_UPDATE:String = "roomUpdate";
		
		/**
		 *视图中房间列表加载/更新完成
		 */		
		public static const ROOM_LIST_UPDATE_VIEW:String = "roomListUpdateView";
		
		/**
		 * 事件传输数据 
		 */		
		public var data:Object;
		
		public function HotSpringRoomListEvent(type:String, data:Object=null)
		{
			super(type);
			this.data=data;
		}
	}
}