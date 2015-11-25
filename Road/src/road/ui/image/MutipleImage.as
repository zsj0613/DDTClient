package road.ui.image
{
	import road.geom.InnerRectangle;
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.utils.ClassUtils;
	import road.utils.ObjectUtils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * 
	 * @author Herman
	 * 复合图片，通过imageRectString 设置每张图片重叠的内部矩形
	 */	
	public class MutipleImage extends Image
	{
		public static const P_imageRect:String = "imagesRect";

		public function MutipleImage(){}

		private var _imageLinks:Array;
		private var _imageRectString:String
		private var _images:Vector.<DisplayObject>;
		private var _imagesRect:Vector.<InnerRectangle>;

		override public function dispose():void
		{
			if(_images)
			{
				for(var i:int = 0;i<_images.length;i++)
				{
					ObjectUtils.disposeObject(_images[i]);
				}
			}
			_images = null;
			_imagesRect = null;
			super.dispose();
		}
		/**
		 * 
		 * @param value 所有图片的内部矩形
		 * 
		 */		
		public function set imageRectString(value:String):void
		{
			if(_imageRectString == value)return;
			_imagesRect = new Vector.<InnerRectangle>();
			_imageRectString = value;
			var rectsData:Array = ComponentFactory.parasArgs(_imageRectString);
			for(var i:int = 0;i<rectsData.length;i++)
			{
				if(String(rectsData[i]) == "")
				{		
					_imagesRect.push(null)
				}else
				{
					_imagesRect.push(ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,String(rectsData[i]).split("|")));
				}
			}
			onPropertiesChanged(P_imageRect);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			if(_images == null)return;
			for(var i:int = 0;i<_images.length;i++)
			{
				Sprite(_display).addChild(_images[i]);
			}
		}
		
		override protected function init():void
		{
			_display = new Sprite();
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
			if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height] || _changedPropeties[P_imageRect])
			{
				for(var i:int = 0;i<_images.length;i++)
				{
					if(_imagesRect && _imagesRect[i])
					{
						var innerRect:Rectangle = _imagesRect[i].getInnerRect(_width,_height);
						_images[i].x = innerRect.x;
						_images[i].y = innerRect.y;
						_images[i].height = innerRect.height;
						_images[i].width = innerRect.width;
					}else
					{
						_images[i].width = _width;
						_images[i].height = _height;
					}
				}
			}
		}
		
		private function creatImages():void
		{
			_images = new Vector.<DisplayObject>;
			for(var i:int = 0;i<_imageLinks.length;i++)
			{
				var image:DisplayObject;
				var imageArgs:Array = String(_imageLinks[i]).split("|");
				image = ComponentFactory.Instance.creat(imageArgs[0]);
				_images.push(image);
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