package ddt.game.animations
{
	import flash.display.DisplayObject;
	
	import ddt.data.Direction;

	public class DirectionMovingAnimation extends BaseAnimate
	{
		private var _dir:String;

		public function DirectionMovingAnimation(dir:String)
		{
			_dir = dir;
			_level = AnimationLevel.MIDDLE;
		}

		override public function cancel():void
		{
			_finished = true;
		}
		
		override public function update(movie:DisplayObject):Boolean
		{
			switch(_dir)
			{
				case Direction.RIGHT:
					movie.x -= 18;
					break;
				case Direction.LEFT:
					movie.x += 18;
					break;
				case Direction.UP:
					movie.y += 18;
					break;
				case Direction.DOWN:
					movie.y -= 18;
					break;
				default:
					return false;
					break;
			}
			return true;
		}
	}
}