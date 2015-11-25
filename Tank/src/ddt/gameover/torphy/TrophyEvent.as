package ddt.gameover.torphy
{
	import flash.events.Event;

	public class TrophyEvent extends Event
	{
		
		public function TrophyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}