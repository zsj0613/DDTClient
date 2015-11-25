package ddt.data
{
	import flash.events.Event;

	public class GameEvent extends Event
	{
		public static const WIND_CHANGED:String = "windChanged";
		public static const TURN_CHANGED:String = "turnChanged";
		public static const READY_CHANGED:String = "readyChanged";
		
		public var data:*;
		public function GameEvent(type:String,value:*)
		{
			data = value;
			super(type);
		}
		
		
		
	}
}