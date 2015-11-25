package road.ui.controls
{
	import flash.events.Event;

	public class FrameEvent extends Event
	{
		public static const START_DRAG:String ="startDrag";
		public static const STOP_DRAG:String = "stopDrag";
		
		public function FrameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}