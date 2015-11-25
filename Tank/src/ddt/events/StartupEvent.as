package ddt.events
{
	import flash.events.Event;
	
	public class StartupEvent extends Event
	{
		public static const CORE_LOAD_COMPLETE:String = "coreUILoadComplete";
		public function StartupEvent(type:String)
		{
			super(type);
		}
	}
}