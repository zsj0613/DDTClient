package ddt.register.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class FadingBlock extends Sprite
	{		
		private var _life:Number;
		private var _exected:Boolean;
		private var _newStart:Boolean;
		private var _showed:Boolean;
		
		public function FadingBlock()
		{
			_life = 0;
			_newStart = true;
			graphics.beginFill(0);
			graphics.drawRect(0,0,1008,608);
			graphics.endFill();
		}
		
		public function update():void
		{
			if(_newStart)
			{
				this.alpha = 0;
				_life = 0;
				_exected = false;
				_showed = false;
				addEventListener(Event.ENTER_FRAME,__enterFrame);
			}
			else
			{
				_life = 1;
				alpha = _life;
				_exected = false;
			}
			_newStart = false;
		}
		
		public function show():void
		{
			_newStart = true;
			update();
		}
		
		private function __enterFrame(event:Event):void
		{
			if(_life < 1)
			{
				_life += 0.16;
				this.alpha = _life;
			}
			else if(_life < 2)
			{
				var tick:int = getTimer();
				tick = getTimer() -tick;
				var time:Number = (tick / 40) * 0.2;
				_life += time < 0.2 ? 0.2 : time;
				if(_life > 2)
				{
					_life = 2.01;
				}
			}
			else if(_life > 2)
			{
				_life += 0.16;
				alpha = 3 - _life;
				if(alpha < 0.2)
				{
					if(parent)parent.removeChild(this);
					removeEventListener(Event.ENTER_FRAME,__enterFrame);
					_newStart = true;
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
	}
}