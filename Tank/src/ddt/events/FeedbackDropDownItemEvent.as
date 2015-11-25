package ddt.events
{
	import flash.events.Event;
	public class FeedbackDropDownItemEvent extends Event
	{
		public static const SELECTED:String = "selected";
		
		public var data:Object; 
		public function FeedbackDropDownItemEvent(type:String, data:Object)
		{
			this.data=data;
			super(type);
		}
	}
}