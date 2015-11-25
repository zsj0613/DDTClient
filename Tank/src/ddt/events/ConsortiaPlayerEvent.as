package ddt.events
{
	import flash.events.Event;

	public class ConsortiaPlayerEvent extends Event
	{
		public static const PROPERTY_CHANGE:String = "propertychange";
		
		public var data:Object;
		public var property:String;
		
		public function ConsortiaPlayerEvent(type:String,property:String,value:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.property = property;
			this.data = value;
			super(type, bubbles, cancelable);
		}
		
	}
}