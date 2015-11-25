package ddt.hotSpring.events
{
	import flash.events.Event;
	
	public class HotSpringRoomPlayerEvent extends Event
	{
		/**
		 *立即改变玩家位置 
		 */		
		public static const PLAYER_POS_CHANGE:String = "playerPosChange";
		
		/**
		 *立即改变玩家移动速度 
		 */		
		public static const PLAYER_MOVE_SPEED_CHANGE:String = "playerMoveSpeedChange";
		
		public var playerid:int;
		public function HotSpringRoomPlayerEvent(type:String,playerid:int)
		{
			this.playerid = playerid;
			super(type);
		}
	}
}