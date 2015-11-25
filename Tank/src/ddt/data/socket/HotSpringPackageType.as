package ddt.data.socket
{
	public class HotSpringPackageType
	{
		/**
		 *玩家行动目标点 
		 */
		public static const TARGET_POINT:int = 0x01;
		
		/**
		 *房间时间更新 
		 */
		public static const HOTSPRING_ROOM_TIME_UPDATE:int = 0x07;
		
		/**
		 *通知玩家续费
		 */
		public static const HOTSPRING_ROOM_RENEWAL_FEE:int = 0x03;
		
		/**
		 *邀请进入温泉房间
		 */
		public static const HOTSPRING_ROOM_INVITE:int = 0x04;
		
		/**
		 *当前玩家编辑房间 
		 */		 
		public static const HOTSPRING_ROOM_EDIT:int = 0x06;	
		
		/**
		 *房间踢人
		 */	 
		public static const HOTSPRING_ROOM_ADMIN_REMOVE_PLAYER:int = 0x09;
		
		/**
		 *系统房间刷新时，针对于玩家的继续提示(扣费)
		 */	
		public static const HOTSPRING_ROOM_PLAYER_CONTINUE:int = 0x0a;
	}
}