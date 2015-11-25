package ddt.events
{
	import flash.events.Event;

	public class YGButtonEvent extends Event
	{
		private var _name : String;
		public function YGButtonEvent(type:String,selectName:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._name = selectName;
		}
		public function get ItemName() : String
		{
			return this._name;
		}
		
	}
}