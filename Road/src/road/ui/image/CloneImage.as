package road.ui.image
{
	import road.ui.Component;
	import road.utils.ClassUtils;
	import road.utils.ObjectUtils;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * 
	 * @author Herman
	 * 平铺bitmap的图片
	 */	
	public class CloneImage extends Image
	{
		public function CloneImage(){}

		protected var _brush:BitmapData;
		private var _brushHeight:Number;
		private var _brushWidth:Number;
		
		override public function dispose():void
		{
			graphics.clear();
			ObjectUtils.disposeObject(_brush);
			_brush = null;
			super.dispose();
		}
		
		override protected function resetDisplay():void
		{
			graphics.clear();
			_brushWidth = _width;
			_brushHeight = _height;
			_brush = ClassUtils.CreatInstance(_resourceLink,[_width,_height]);
		}
		
		override protected function updateSize():void
		{
			if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height])
			{
				graphics.clear();
				graphics.beginBitmapFill(_brush);
				graphics.drawRect(0,0,_width,_height);
				graphics.endFill();
			}
		}
	}
}