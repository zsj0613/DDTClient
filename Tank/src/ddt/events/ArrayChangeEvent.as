package ddt.events
{
	import flash.events.Event;

	public class ArrayChangeEvent extends Event
	{
		public var Elements:Array;
		public function ArrayChangeEvent(type:String, elements:Array, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			Elements = elements;
		}
		
	}
}