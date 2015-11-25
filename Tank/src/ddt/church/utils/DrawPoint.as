package ddt.church.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class DrawPoint extends Sprite
	{
		public function DrawPoint(container:DisplayObjectContainer,color:int = 0xff0000,x:Number = 0,y:Number =0)
		{
			super();
			
			this.graphics.beginFill(color);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
			
			this.x = x;
			this.y = y;
			container.addChild(this);
		}
		
	}
}