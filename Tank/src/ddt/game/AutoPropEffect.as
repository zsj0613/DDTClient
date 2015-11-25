package ddt.game
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	[Event(name="complete",type="flash.events.Event")]
	public class AutoPropEffect extends Sprite
	{
		private var _age:Number;
		private var _last:uint;
		
		public function AutoPropEffect(movie:DisplayObject)
		{
			movie.x = -20;
			addChild(movie);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		private function __addToStage(event:Event):void
		{
			_age = 0;
			_last = getTimer();
			addEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		private function __enterFrame(event:Event):void
		{
			if(parent)
			{
				_age += 0.2;
				_last = getTimer();
				if(_age <= 1)
				{
					this.alpha = _age;
				}
				else if(_age < 4)
				{
					alpha = 1;
				}
				else if(_age < 5)
				{
					if((5 - _age) > 0.2)
					{
						alpha = 5 - _age;
					}
				}
				else if(_age < 6)
				{
					alpha = 1;
				}
				else if(_age>8)
				{
					alpha = 5 - _age;
					if(alpha < 0.2)
					{
						parent.removeChild(this);
						removeEventListener(Event.ENTER_FRAME,__enterFrame);
						this.dispatchEvent(new Event(Event.COMPLETE));
					}
					
				}
			}
		}
	}
}