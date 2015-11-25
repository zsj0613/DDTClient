package ddt.menu
{
	import flash.events.Event;

	public class MenuEvent extends Event
	{
		public static const CLICK:String = "menuClick";
		
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}