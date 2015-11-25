package ddt.game.animations
{
	import flash.display.DisplayObject;

	public class BaseAnimate implements IAnimate
	{
		protected var _level:int = 0;
		protected var _finished:Boolean;
		
		public function BaseAnimate()
		{
		}

		public function get level():int
		{
			return _level;
		}
		
		public function prepare(aniset:AnimationSet):void
		{
		}
		
		public function canAct():Boolean
		{
			return !_finished;
		}
		
		public function update(movie:DisplayObject):Boolean
		{
			_finished = true;
			return false;
		}
		
		public function canReplace(anit:IAnimate):Boolean
		{
			return true;
		}
		
		public function cancel():void
		{
		}
		
	}
}