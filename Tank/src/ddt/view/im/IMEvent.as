package ddt.view.im
{
	import flash.events.Event;

	public class IMEvent extends Event
	{
		public static const ADDNEW_FRIEND:String = "addnewfriend";
		
		public var data:Object;
		
		public function IMEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
		
	}
}