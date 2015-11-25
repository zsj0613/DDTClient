package ddt.events
{
	import flash.events.Event;
	
	public class HotSpringEvent extends Event
	{
		/**
		 *进入房间 
		 */		
		public static const ROOM_ENTER:String = "roomEnter";
		
		public var data:Object;
		
		public function HotSpringEvent(type:String, data:Object = null)
		{
			super(type);
			this.data = data;
		}
	}
}