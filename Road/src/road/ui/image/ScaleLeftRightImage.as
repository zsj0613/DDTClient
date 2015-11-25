package road.ui.image
{
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.utils.ObjectUtils;
	import flash.display.Bitmap;
	/**
	 * 
	 * @author Herman
	 * 左右拉伸的图片 由三张图片组合而成
	 */	
	public class ScaleLeftRightImage extends Image
	{

		public function ScaleLeftRightImage(){}

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
			graphics.drawRect(_bitmaps[0].width, 0, _width-_bitmaps[0].width - _bitmaps[2].width, _height);
			graphics.endFill();
			
			if(_bitmaps[2].x<=0)
			{
				_bitmaps[2].x=_width-_bitmaps[2].width;
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