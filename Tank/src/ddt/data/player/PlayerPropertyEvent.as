package ddt.data.player
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class PlayerPropertyEvent extends Event
	{
		public static const PROPERTY_CHANGE:String = "propertychange";
		
		private var _changedProperties:Dictionary;
		
		public function get changedProperties():Dictionary
		{
			return _changedProperties;
		}
		
		public function PlayerPropertyEvent(type:String,changedProperties:Dictionary)
		{
			_changedProperties = changedProperties;
			super(type);
		}
		
	}
}