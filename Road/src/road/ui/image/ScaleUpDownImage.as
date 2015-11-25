package road.ui.image
{
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.utils.ObjectUtils;
	import flash.display.Bitmap;
	/**
	 * 
	 * @author Herman
	 * 上下拉伸的图片 由三张图片组合而成
	 */	
	public class ScaleUpDownImage extends Image
	{
		
		public function ScaleUpDownImage(){}

		private var _bitmaps:Vector.<Bitmap>;
		private var _imageLinks:Array;
		
		override public function dispose():void
		{
			removeImages();
			graphics.clear();
			_bitmaps = null;
			super.dispose();
		}
		
		override protected function addChildren():void
		{
			if(_bitmaps == null)return;
			addChild(_bitmaps[0]);
			addChild(_bitmaps[2]);
		}
		
		override protected function resetDisplay():void
		{
			_imageLinks = ComponentFactory.parasArgs(_resourceLink);
			removeImages();
			creatImages();
		}
		
		override protected function updateSize():void
		{
			if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height])
			{
				drawImage();
			}
		}
		
		private function creatImages():void
		{
			_bitmaps = new Vector.<Bitmap>;
			for(var i:int = 0;i<_imageLinks.length;i++)
			{
				var bitmap:Bitmap = ComponentFactory.Instance.creat(_imageLinks[i]);
				_bitmaps.push(bitmap);
			}
		}
		
		private function drawImage():void
		{
			graphics.clear();
			graphics.beginBitmapFill(_bitmaps[1].bitmapData);
			graphics.drawRect(0, _bitmaps[0].height, _width, _height-_bitmaps[0].height - _bitmaps[2].height);
			graphics.endFill();
			
			if(_bitmaps[2].y<=0)
			{
				_bitmaps[2].y=_height-_bitmaps[2].height;
			}
		}
		
		private function removeImages():void
		{
			if(_bitmaps == null) return;
			for(var i:int = 0;i<_bitmaps.length;i++)
			{
				ObjectUtils.disposeObject(_bitmaps[i]);
			}
		}
	}
}