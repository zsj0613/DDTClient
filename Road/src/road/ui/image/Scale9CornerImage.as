package road.ui.image
{
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.utils.ObjectUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	/**
	 * 
	 * @author Herman
	 * 9张小图片组合而成的可拉伸的图片（类似9宫格）
	 * 但是每张图片都是通过bitmapData画出来的
	 * 
	 */	
	public class Scale9CornerImage extends Image
	{
		public function Scale9CornerImage()
		{
			super();
		}

		private var _imageLinks:Array;
		private var _images:Vector.<Bitmap>;
		
		override public function dispose():void
		{
			graphics.clear();
			removeImages();
			_images = null;
			_imageLinks = null;
			super.dispose();
		}
		override protected function addChildren():void
		{
			if(_images && _images.length >0)
			{
				addChild(_images[0]);
				addChild(_images[2]);
				addChild(_images[6]);
				addChild(_images[8]);
			}
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
			_images = new Vector.<Bitmap>();
			for(var i:int = 0;i<_imageLinks.length;i++)
			{
				_images.push(ComponentFactory.Instance.creat(_imageLinks[i]));
			}
		}
		
		private function drawImage():void
		{
			graphics.clear();
			var startMatrix:Matrix = new Matrix();
			
			startMatrix.translate(_images[0].width,0);
			graphics.beginBitmapFill(_images[1].bitmapData,startMatrix);
			graphics.drawRect(_images[0].width, 0, _width-_images[0].width - _images[2].width, _images[1].height);
			
			startMatrix.translate(0, _images[0].height);
			graphics.beginBitmapFill(_images[3].bitmapData,startMatrix);
			graphics.drawRect(0, _images[0].height, _images[3].width, _height -_images[0].height - _images[6].height );
			
			startMatrix.translate(_width-_images[5].width, _images[2].height);
			graphics.beginBitmapFill(_images[5].bitmapData,startMatrix);
			graphics.drawRect(_width-_images[5].width, _images[2].height, _images[5].width , _height - _images[2].height - _images[8].height);
			
			startMatrix.translate(_images[6].width, _height - _images[7].height);
			graphics.beginBitmapFill(_images[7].bitmapData,startMatrix);
			graphics.drawRect(_images[6].width, _height - _images[7].height, _width - _images[6].width - _images[8].width, _images[7].height);
			
			startMatrix.translate(_images[0].width, _images[0].height);
			graphics.beginBitmapFill(_images[4].bitmapData,startMatrix);
			graphics.drawRect(_images[0].width, _images[0].height, _width - _images[0].width - _images[2].width, _height - _images[0].height - _images[6].height);
			
			graphics.endFill();
			
			_images[0].x = 0;
			_images[0].y = 0;
			
			_images[2].x = _width - _images[2].width;
			_images[2].y = 0;
			
			_images[6].x = 0;
			_images[6].y = _height - _images[6].height;
			
			_images[8].x = _width - _images[8].width;
			_images[8].y = _height - _images[8].height;
		}
		private function removeImages():void
		{
			if(_images == null) return;
			for(var i:int = 0;i<_images.length;i++)
			{
				ObjectUtils.disposeObject(_images[i]);
			}
		}
	}
}