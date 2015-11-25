package ddt.view.roulette
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.manager.SoundManager;
	
	public class TurnSoundControl extends EventDispatcher
	{
		private var _timer:Timer;
		private var _isPlaySound:Boolean = false;
		private var _oneArray:Array = ["127","128","129","130","131"];
		private var _threeArray:Array = ["130","131","133","132","135","134","129","128","127","132","135","134","129","128","127"];
		private var _number:int = 0;
		
		public function TurnSoundControl(target:IEventDispatcher=null)
		{
			super(target);
			init();
			initEvent();
		}
		
		private function init():void
		{
			_timer = new Timer(6000);
			_timer.stop();
		}
		
		private function initEvent():void
		{
			_timer.addEventListener(TimerEvent.TIMER , _timerOne);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE , _timerComplete);
		}
		
		private function _timerOne(evt:TimerEvent):void
		{
			SoundManager.instance.stop("124");
			SoundManager.instance.play("124");
		}
		
		private function _timerComplete(evt:TimerEvent):void
		{
		}
		
		public function playSound():void
		{
			if(!_isPlaySound)
			{
				_isPlaySound = true;
				_timer.delay = 6000;
				_timer.reset();
				_timer.start();
				SoundManager.instance.play("124");
			}
		}
		
		public function playOneStep():void
		{
			var id:String = _oneArray[_number];
			SoundManager.instance.play(id);
			_number = (_number>=4)?0:(_number+1);
				
		}
		
		public function playThreeStep(value:int):void
		{
			var id:String = _threeArray[value];
			SoundManager.instance.play(id);
		}
		
		public function stop():void
		{
			_isPlaySound = false;
			_timer.stop();
			SoundManager.instance.stop("124");
		}
		
		public function dispose():void
		{
			if(_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER , _timerOne);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE , _timerComplete);
				_timer = null;
			}
		}
	}
}



























