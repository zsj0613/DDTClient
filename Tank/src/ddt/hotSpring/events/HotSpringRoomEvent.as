package ddt.hotSpring.events
{
	import flash.events.Event;
	
	public class HotSpringRoomEvent extends Event
	{		
		/**
		 *房间内玩家增加
		 */		
		public static const ROOM_PLAYER_ADD:String = "roomPlayerAdd";
		
		/**
		 *房间内玩家更新
		 */		
		public static const ROOM_PLAYER_UPDATE:String = "roomPlayerUpdate";
		
		/**
		 *玩家退出/移除出房间
		 */
		public static const ROOM_PLAYER_REMOVE:String = "roomPlayerRemove";
		
		/**
		 *玩家相关数据更新(相关属性)
		 */
		public static const ROOM_PLAYER_UPDATE_ATTRIBUTE:String = "roomPlayerUpdateAttribute";
		
		/**
		 * 事件传输数据 
		 */		
		public var data:Object;
		
		public function HotSpringRoomEvent(type:String, data:Object=null)
		{
			super(type);
			this.data=data;
		}
	}
}