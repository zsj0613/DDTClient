package ddt.game.animations
{
	public class DragMapAnimation extends BaseSetCenterAnimation
	{
		public function DragMapAnimation(cx:Number, cy:Number,directed:Boolean = false, life:int=100)
		{
			super(cx, cy, life,directed,AnimationLevel.HIGHT);
		}
	}
}