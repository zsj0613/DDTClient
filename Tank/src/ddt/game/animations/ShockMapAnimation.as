package ddt.game.animations
{
	import flash.display.DisplayObject;
	
	import phy.object.PhysicalObj;

	public class ShockMapAnimation implements IAnimate
	{
		private var _bomb:PhysicalObj;
		private var _finished:Boolean;
		private var _age:Number;
		private var _life:Number;
		private var _radius:Number;
		private var _x:Number;
		private var _y:Number;
		public function ShockMapAnimation(bomb:PhysicalObj,radius:Number = 7,life:Number = 0)
		{
			_age = 0;
			_life = life;
			_finished = false;
			_bomb = bomb;
			_radius = radius;
		}
		
		public function get level():int
		{
			return AnimationLevel.HIGHT;
		}
		
		public function canAct():Boolean
		{
			return  !_finished || _life >0;
		}
		
		public function canReplace(anit:IAnimate):Boolean
		{
			if(anit is ShockMapAnimation)
			{
				return false;
			}
			return true;
		}
		
		public function prepare(aniset:AnimationSet):void
		{
		}
		
		public function cancel():void
		{
		}
		
		public function update(movie:DisplayObject):Boolean
		{
			_life --;
			if(!_finished)
			{
				if(_age == 0)
				{
					_x = movie.x;
					_y = movie.y;
				}
				_age += 0.25;
				if(_age < 1.5)
				{
					_radius = - _radius;
					movie.x = _x + _radius;
					movie.y = _y + _radius;
				}
				else
				{
					movie.x = _x;
					movie.y = _y;
					_finished = true;
				}
				return true;
			}
			return false;
		}
		
	}
}