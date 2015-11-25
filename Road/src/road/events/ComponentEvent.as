package road.events
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	public class ComponentEvent extends Event
	{
		public static const PROPERTIES_CHANGED:String = "propertiesChanged";

		public function ComponentEvent(type:String,changedPropertie:Dictionary = null)
		{
			_changedProperties = changedPropertie;
			super(type);
		}

		private var _changedProperties:Dictionary;
		
		public function get changedProperties():Dictionary
		{
			return _changedProperties;
		}
	}
}