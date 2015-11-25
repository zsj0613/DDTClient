package ddt.game.animations
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class BaseSetCenterAnimation extends BaseAnimate
	{
		protected var _target:Point;
		protected var _life:int;
		protected var _directed:Boolean;
		//protected var _temp:Point;
		protected var _speed:int;
		protected var _moveSpeed:int = 4;
		public function BaseSetCenterAnimation(cx:Number,cy:Number,life:int = 0,directed:Boolean = false,level:int = AnimationLevel.LOW,speed:int = 0)
		{
			_target = new Point(cx,cy);
			//_temp = _target.clone();
			_finished = false;
			_life = life;
			_level = level;
			_directed = directed;
			_speed = speed;
		}
		
		public override function canAct():Boolean
		{
			return !_finished || _life >=0;
		}
		
		public override function prepare(aniset:AnimationSet):void
		{
			//trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>",_target.x,_target.y);
			_target.x = aniset.stageWidth /2 - _target.x;
			_target.y = aniset.stageHeight /2 - _target.y;
			_target.x = _target.x < aniset.minX ? aniset.minX : (_target.x > 0 ? 0 : _target.x);
			_target.y = _target.y < aniset.minY ? aniset.minY  : ( _target.y > 0 ? 0 : _target.y);
		}
		
		public override function update(movie:DisplayObject):Boolean
		{
			_life --;
			if(!_finished)
			{
				if(!_directed)
				{
					var p:Point = new Point(_target.x - movie.x,_target.y - movie.y);
					if(_speed > 0 && p.length>48){
						movie.x += p.x / _speed;
						movie.y += p.y / _speed;
						return true;
					}else if(p.length > 48){
						movie.x += p.x / _moveSpeed;
						movie.y += p.y / _moveSpeed;
					}
					else if(p.length >= 8)
					{
						p.normalize(8);
						movie.x += p.x;
						movie.y += p.y;
					}
					else
					{
						movie.x += p.x;
						movie.y += p.y;
						_finished = true;
					}
				}
				else
				{
					movie.x = _target.x;
					movie.y = _target.y;
					_finished = true;
				}
				return true;
			}
			return false;
		}
	}
}