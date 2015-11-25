package ddt.events
{
	import flash.events.Event;

	public class LoadHandleEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		public function LoadHandleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}