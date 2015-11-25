package ddt.view.roulette
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.sampler.startSampling;
	import flash.utils.Timer;
	
	import road.manager.SoundManager;
	
	public class TurnControl extends EventDispatcher
	{
		private var _goodsList:Array;
		private var _turnType:int = 1;
		private var _timer:Timer;
		private var _isStopTurn:Boolean = false;
		private var _nowDelayTime:int = 1000;
		
		private var _sparkleNumber:int = 0;
		
		private var _delay:Array = [500,30,500];
		
		private var _moveTime:Array = [2000,3000,2000];
		private var _selectedGoodsNumber:int = 0;
		private var _turnTypeTimeSum:int = 0;
		private var _stepTime:int = 0;
		
		private var _startModerationNumber:int = 0;
		private var _moderationNumber:int = 0;
		
		private var _sound:TurnSoundControl;
		
		public static const TURNCOMPLETE:String = "turn_complete";
		
		public function TurnControl(target:IEventDispatcher=null)
		{
			super(target);
			init();
			initEvent();
		}
		
		private function init():void
		{
			_timer = new Timer(100,1);
			_timer.stop();
			_sound = new TurnSoundControl();
		}
		
		private function initEvent():void
		{
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE , _timeComplete);
		}
		
		private function _startTimer(time:int):void
		{
			if(!_isStopTurn)
			{
				_timer.delay = time;
				_timer.reset();
				_timer.start();
			}
		}
		
		private function _nextNode():void
		{
			if(!_isStopTurn)
			{
				sparkleNumber += 1;
				_goodsList[sparkleNumber].setSparkle();
				_clearPrevSelct(sparkleNumber , prevSelected);
				
				if(nowDelayTime > 30 && turnType == 1)
				{
					_sound.stop();
					_sound.playOneStep();
				}
				else if(turnType == 3 && _moderationNumber <= 14)
				{
					_sound.stop();
					_sound.playThreeStep(_moderationNumber);
				}
				else
					_sound.playSound();
			}
		}
		
		private function _clearPrevSelct(now:int , prev:int):void
		{
			 var between:int = ((now - prev) < 0)?(now - prev + _goodsList.length):(now - prev);
			 if(between == 1)
			 {
				 _goodsList[prev].selected = false;
			 }
			 else
			 {
				 var one:int = ((now - 1) < 0)?(now - 1 + _goodsList.length):(now - 1);
				 _goodsList[one].setGreep();
				 _goodsList[prev].selected = false;
			 }
		}
		
		private function _timeComplete(e:TimerEvent):void
		{
			_updateTurnType(nowDelayTime);
			nowDelayTime += _stepTime;
			_nextNode();
			_startTimer(nowDelayTime);
			
		}
		
		private function _updateTurnType(value:int):void
		{
			switch(turnType)
			{
				case 1:
					if(value <= _delay[1])
						turnType = 2;
					break;
				case 2:
					if(_turnTypeTimeSum >= _moveTime[1] && _sparkleNumber == _startModerationNumber)
						turnType = 3;
					break;
				case 3:
					_moderationNumber--;
					if(_moderationNumber <= 0)
						stopTurn();
					break;
			}
		}
		
		public function startTurn():void
		{
			_isStopTurn = false;
			sparkleNumber--;
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE , _timeComplete);
		}
		
		public function stopTurn():void
		{
			_isStopTurn = true;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE , _timeComplete);
			_turnComplete();
		}
		
		private function _turnComplete():void
		{
			dispatchEvent(new Event(TurnControl.TURNCOMPLETE));
		}
		
		public function turnPlate(list:Array , _select:int):void
		{
			turnType = 1;
			_goodsList = list;
			selectedGoodsNumber = _select;
			startTurn();
			_startTimer(nowDelayTime);
		}
		
		public function set sparkleNumber(value:int):void
		{
			_sparkleNumber = value;
			if(_sparkleNumber >= _goodsList.length)
				_sparkleNumber = 0;
		}
		
		public function get sparkleNumber():int
		{
			return _sparkleNumber;
		}
		
		private function get prevSelected():int
		{
			var prev:int = 0;
			switch(_turnType)
			{
				case 1:
					prev = (sparkleNumber == 0)?(_goodsList.length - 1):(_sparkleNumber -1);
					break;
				case 2:
					prev = (sparkleNumber - 3 < 0)?(sparkleNumber - 3 + _goodsList.length):(sparkleNumber - 3);
					break;
				case 3:
					if(_moderationNumber > 9)
					{
						prev = (sparkleNumber - 3 < 0)?(sparkleNumber - 3 + _goodsList.length):(sparkleNumber - 3);
					}
					else
					{
						var step:int = (_moderationNumber >= 7)?(_moderationNumber - 6):1;
						prev = (sparkleNumber - step < 0)?(sparkleNumber - step  + _goodsList.length):(_sparkleNumber - step);
						if(_moderationNumber >= 8)
							_goodsList[(prev+1 >= _goodsList.length)?0:prev+1].selected = false;
					}
					break;
			}
			return prev;
		}
		
		public function set nowDelayTime(value:int):void
		{
			_turnTypeTimeSum += _nowDelayTime;
			_nowDelayTime = value;
		}
		
		public function get nowDelayTime():int
		{
			return _nowDelayTime;
		}
		
		public function set turnType(value:int):void
		{
			_turnType = value;
			_turnTypeTimeSum = 0;
			switch(_turnType)
			{
				case 1:
					_nowDelayTime = _delay[0];
					_stepTime = -60;
					break;
				case 2:
					_nowDelayTime = _delay[1];
					_stepTime = 0;
					break;
				case 3:
					_nowDelayTime = _delay[1];
					_stepTime = 30;
					break;
			}
		}
		
		public function get turnType():int
		{
			return _turnType;
		}
		
		public function set goodsList(list:Array):void
		{
			_goodsList = list;
		}
		
		public function set selectedGoodsNumber(value:int):void
		{
			_selectedGoodsNumber = value;
			_moderationNumber = (_delay[2] - _delay[1])/30;
			var m:int = _selectedGoodsNumber - _moderationNumber;
			while(m < 0)
			{
				m += _goodsList.length;
			}
			_startModerationNumber = m;
			
		}
		
		public function dispose():void
		{
			if(_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE , _timeComplete);
				_timer = null;
			}
			
			if(_sound)
			{
				_sound.dispose();
				_sound = null;
			}
		}
	}
}