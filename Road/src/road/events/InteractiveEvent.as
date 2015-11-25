package road.events
{
	import flash.events.Event;
	
	public class InteractiveEvent extends Event
	{
		public static const STATE_CHANGED:String = "stateChange";
		public function InteractiveEvent(type:String)
		{
			super(type);
		}
	}
}