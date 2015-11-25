package ddt.view.dailyconduct
{
	import flash.events.Event;

	public class DailyConductEvent extends Event
	{
		public static const LINK : String = "on_link";
		public var data : Object;
		public function DailyConductEvent(type:String,$data : Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = $data;
			super(type, bubbles, cancelable);
		}
		
	}
}