package ddt.view.bossbox
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class TimeCountDown extends EventDispatcher
	{
		private var _time:Timer;
		private var _count:int;
		private var _stepSecond:int;
		
		public static const COUNTDOWN_COMPLETE:String = "TIME_countdown_complete"; 
		public static const COUNTDOWN_ONE:String = "countdown_one";
		
		public function TimeCountDown(stepSecond:int)
		{
			_stepSecond = stepSecond;
			_time = new Timer(_stepSecond);
			_time.stop();
		}
		
		public function setTimeOnMinute(minute:int):void
		{
			_count = minute * 60*1000/_stepSecond;
			
			_time.repeatCount = _count;
			_time.reset();
			_time.start();
			_time.addEventListener(TimerEvent.TIMER , _timer);
			_time.addEventListener(TimerEvent.TIMER_COMPLETE, _timerComplete);
		}
		
		private function _timer(e:TimerEvent):void
		{
			dispatchEvent(new Event(TimeCountDown.COUNTDOWN_ONE));
		}
		
		private function _timerComplete(e:TimerEvent):void
		{
			trace("_timerComplete........");
			dispatchEvent(new Event(TimeCountDown.COUNTDOWN_COMPLETE));
		}
	}
}



