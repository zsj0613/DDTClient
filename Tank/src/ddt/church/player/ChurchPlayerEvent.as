package ddt.church.player
{
	import flash.events.Event;

	public class ChurchPlayerEvent extends Event
	{
		public static const FIRE_COMPLETE:String = "fireComplete";
		public function ChurchPlayerEvent(type:String)
		{
			super(type);
		}
		
	}
}