package ddt.game
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.CountDownAsset;
	
	import road.manager.SoundManager;
	
	import ddt.manager.GameManager;

	[Event(name="complete",type="flash.events.Event")]
	public class CountDownView extends Sprite
	{
		private var _countDown:CountDownAsset;
		
		private var _timer:Timer;
		
		private var _totalTime:int;
		
		private var _isPlayerSound:Boolean;
		
		/**
		 * 已经走过的时间 
		 */		
		private var _alreadyTime:int;
		public function get alreadyTime():int
		{
			return _alreadyTime;
		}
		
		public function CountDownView(totalTime:int,isPlayerSound:Boolean = true)
		{
			_isPlayerSound = isPlayerSound;
			_totalTime = totalTime;
			initView();
		}
		
		private function initView():void
		{			
			_timer = new Timer(1000,_totalTime);//Config.COUNT_DOWN);
			_countDown = new CountDownAsset();
			addChild(_countDown);
		}
		
		public function reset():void
		{
			_countDown.gotoAndStop(_totalTime);
		}

		/**
		 * 启动计时器 
		 * 
		 */		
		public function startCountDown():void
		{
			stopCountDown();
			_countDown.gotoAndStop(_totalTime);
			_countDown.visible = true;
			_timer.addEventListener(TimerEvent.TIMER,__timer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer.start();
			_alreadyTime = _totalTime;
		}
		
		public function pause():void
		{
			_timer.reset();
		}
		
		public function stopCountDown():void
		{
			_timer.removeEventListener(TimerEvent.TIMER,__timer);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			if(_timer.running)
			{
				SoundManager.instance.stop("067");
			}
			_timer.reset();
		}
		

		
		private function __timer(event:TimerEvent):void
		{
			_countDown.gotoAndStop(_totalTime -_timer.currentCount);
			_alreadyTime = _totalTime -_timer.currentCount;
			
			GameManager.Instance.Current.selfGamePlayer.shootTime = _timer.currentCount;
			if(_countDown.currentFrame <= 4)
			{
				if(_isPlayerSound)
				{
					SoundManager.instance.stop("067");
					SoundManager.instance.play("067");
				}
			}
			else
			{
				if(_isPlayerSound)
				{
					SoundManager.instance.play("014");
				}
			}
		}
		
		private function __timerComplete(event:TimerEvent):void
		{
			_alreadyTime = 0;
			stopCountDown();
			_countDown.visible = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function dispose():void
		{
			stopCountDown();
			_alreadyTime = _totalTime;
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,__timer);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			}
			_timer = null;
			if(parent)
				parent.removeChild(this);
		}
		
	}
}