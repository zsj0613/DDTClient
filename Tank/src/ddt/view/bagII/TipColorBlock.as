package ddt.view.bagII
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.GoodsTipItemColorAsset;

	public class TipColorBlock extends GoodsTipItemColorAsset
	{
		private var _color:uint;
		
		public function TipColorBlock(color:uint)
		{
			_color = color;
			super();
			init();
		}
		
		private function init():void
		{
			color_mc.graphics.beginFill(_color,1);
			color_mc.graphics.drawRect(0,0,14,14);
			color_mc.graphics.endFill();
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			color_mc.graphics.clear();
			if(parent)
				parent.removeChild(this);
		}
	}
}