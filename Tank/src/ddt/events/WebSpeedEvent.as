package ddt.events
{
	import flash.events.Event;
	
	import ddt.data.WeaponInfo;

	public class WebSpeedEvent extends Event
	{
		public var info:WeaponInfo;
		
		public static const STATE_CHANE:String = "stateChange";
		
		public function WebSpeedEvent(type:String, info:WeaponInfo = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.info = info;
		}
		
	}
}