package ddt.events
{
	import flash.events.Event;
	/**
	 * 
	 * @author WickiLA
	 * @time 0601/2010
	 * @description 作战实验室相关事件
	 */	
	public class FightLibCommandEvent extends Event
	{
		public static const WAIT:String = "wait";
		public static const FINISH:String = "finish";
		public function FightLibCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}