package road.ui.image
{
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.utils.ObjectUtils;
	
	import flash.display.Sprite;
	/**
	 * 
	 * @author Herman
	 * 9宫格拉伸的图片，但是支持跳帧，每一帧的图片都不一样
	 * 
	 */	
	public class ScaleFrameImage extends Image
	{
		public function ScaleFrameImage(){}

		private var _imageLinks:Array;
		private var _images:Vector.<Image>;
		
		override public function dispose():void
		{
			removeImages();
			_images = null;
			_imageLinks = null;
			super.dispose();
		}
		
		override public function setFrame(frameIndex:int):void
		{
			for(var i:int = 0;i<_images.length;i++)
			{
				if((frameIndex - 1) == i)
				{
					_images[i].visible = true;
					if(_width != Math.round(_images[i].width))
					{
						_width = Math.round(_images[i].width);
						_changedPropeties[Component.P_width] = true;
					}
				}else
				{
					_images[i].visible = false;
				}
			}
		}
		
		override protected function init():void
		{
			super.init();
		}
		
		override protected function resetDisplay():void
		{
			_imageLinks = ComponentFactory.parasArgs(_resourceLink);
			removeImages();
			creatImages();
		}
		
		override protected function updateSize():void
		{
			if(_images == null) return;
			if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height])
			{
				for(var i:int = 0;i<_images.length;i++)
				{
					_images[i].width = _width;
					_images[i].height = _height;
				}
			}
		}
		
		private function creatImages():void
		{
			_images = new Vector.<Image>;
			for(var i:int = 0;i<_imageLinks.length;i++)
			{
				var image:Image = ComponentFactory.Instance.creat(_imageLinks[i]);
				_images.push(image);
				addChild(image);
			}
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