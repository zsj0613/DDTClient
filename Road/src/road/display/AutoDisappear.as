package road.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class AutoDisappear extends Sprite
	{
		private var _life:Number;
		private var _age:Number;
		private var _last:Number;
		[Event(name="complete",type="flash.events.Event")]
		public function AutoDisappear(movie:DisplayObject,life:Number)
		{
			super();
			_life = life * 1000;
			_age = 0;
			addChild(movie);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			
		}
		
		private function __addToStage(event:Event):void
		{
			_last = getTimer();
			addEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		private function __enterFrame(event:Event):void
		{
			if(parent)
			{
				_age += getTimer() - _last;
				_last = getTimer();
				if(_age > _life)
				{
					parent.removeChild(this);
					removeEventListener(Event.ENTER_FRAME,__enterFrame);
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
	}
}