package ddt.game.actions
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ddt.actions.BaseAction;
	import ddt.data.game.Living;
	import ddt.game.animations.PhysicalObjFocusAnimation;
	import ddt.game.objects.GameLiving;

	public class LivingJumpAction extends BaseAction
	{
		private var _living:GameLiving;
		protected var _target:Point;
		private var _speed:int;
		private var _firstExcuted:Boolean = true;
		private var _jumpType : int ;
		public function LivingJumpAction(living:GameLiving,target:Point,speed:int,jumpType : int =0)
		{
			_living = living;
			_target = target;
			_speed = speed;
			_jumpType = jumpType;
			super();
		}
		
		override public function connect(action:BaseAction):Boolean
		{
			var ac:LivingJumpAction = action as LivingJumpAction;
			if(ac && ac._target.y > _target.y)
			{
				//过滤掉掉落点比现在点高的FallingAction
				return true;
			}
			return false;
		}
		
		override public function prepare():void
		{
			if(_isPrepare) return;
			_isPrepare = true;
			if(_living.isLiving)
			{
					_living.startMoving();
					if(_jumpType == 1)
					{
						_living.actionMovie.source.gotoAndPlay("walk");
						_living.actionMovie.source.addEventListener(Event.ENTER_FRAME,__checkMoveMovie);
//						_living.addEventListener(Event.ENTER_FRAME,__trace);
					}
			}
			else
			{
				finish();
			}
			
			
		}
		
//		private function __trace(evt:Event):void
//		{
//			trace("===================current frame:" + _moveMovie.currentFrame + "/" + _moveMovie.totalFrames + "   pos:" + _living.pos);
//		}
		
		private var _moveMovie:MovieClip;
		private function __checkMoveMovie(event:Event):void
		{
			if(_living.actionMovie.source.getChildAt(0))
			{
				_living.actionMovie.source.removeEventListener(Event.ENTER_FRAME,__checkMoveMovie);
				_moveMovie = _living.actionMovie.source.getChildAt(0) as MovieClip;
				_moveMovie.gotoAndStop(4);
				_moveMovie.addFrameScript(4,stopMovie);
				_moveMovie.addFrameScript(_moveMovie.totalFrames-1,doActionStand);
			}
		}
		
		private function stopMovie():void
		{
			_moveMovie.stop();
		}
		
		private function contuineMovie():void
		{
			_moveMovie.addFrameScript(4,null);
			if(_moveMovie.currentFrame<_moveMovie.totalFrames)_moveMovie.gotoAndStop(_moveMovie.currentFrame+1);
			_moveMovie.nextFrame();//play();
		}
		
		private function doActionStand():void
		{
			_moveMovie.addFrameScript(_moveMovie.totalFrames-1,null);
			_living.actionMovie.doAction("stand");
		}
		
		
		
		override public function execute():void
		{
			if(_jumpType == 0)
			{
				jumpBass();
			}
			else if(_jumpType == 1)
			{
				jumpAmortize();
			}
			else
			{
				jumpContinuous();
			}
			
		}
		private var _state     : int = 0;
		private var _times     : int = 0;
		private var _g         : Number = 0.04;
		private var _tempSpeed : Number = 0;
		private function jumpAmortize() : void
		{
		    if(_state > 4)
			{
				_times ++;
				_tempSpeed =  _times *_times * _g*50;
				setPoint(-_tempSpeed);
				if(_living.info.pos.y - _target.y >= 0)
				{
					_living.info.pos = _target;
					_times = -1;
					contuineMovie();
					_state++;
					if(_state > 12)
					{
						_state = 0;
						executeAtOnce();
					}
				}else
				{
					_moveMovie.gotoAndStop(6);
				}
			}
			else if(_living.info.pos.y - _target.y < -(_speed*2))
			{
				_state += 1;
				_times = 0;
				_moveMovie.gotoAndStop(5);
			}
			else
			{
				_tempSpeed = _speed*1.5 - _times * _g;
				if(_tempSpeed < _speed/2)_tempSpeed = _speed/2;
				setPoint(_tempSpeed);
			}
		}
		
		//爬梯子
		private function jumpContinuous() : void
		{
			_speed = 20;
			if(_state == 25)
			{
				_times --;
				setPoint(-_speed/2);
				if(_times <= 3)
				{
					_state = 0; 
					_times = 0;
					if(_living.info.pos.y <= _target.y)executeAtOnce();
				}
			}
			else if(_state == 24)
			{
				_times ++;
				setPoint(_speed+1);
				if(_times >= 5)
				{
					_state = 25;
				}
			}
			else 
			{
				_state ++;
			}
			
		}
		
		private function setPoint($speed : Number) : void
		{
			_living.info.pos = new Point(_target.x,_living.info.pos.y - $speed);
			_living.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(_living,25,-150));
		}
		
		private function jumpBass() : void
		{
			if(_living.info.pos.y - _target.y <= _speed)
			{
				executeAtOnce();
			}
			else
			{
				setPoint(_speed);
			}
		}
		override public function executeAtOnce():void
		{
			super.executeAtOnce();
			_living.info.pos = _target;
			if(_living.actionMovie)
			{
				if(_living.actionMovie.currentAction == Living.STAND_ACTION)
				{
					_living.info.doDefaultAction();
				}
			}
			finish();
			
		}
		
		private function finish():void
		{
			_living.stopMoving();
			_isFinished = true;
		}
		
		
	}
}