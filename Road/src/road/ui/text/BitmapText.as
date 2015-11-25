package road.ui.text
{
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.ui.Disposeable;
	import road.utils.ClassUtils;
	import road.utils.DisplayUtils;
	import road.utils.ObjectUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * 
	 * @author Herman
	 * 文字遮罩 下面是一张图片组合成的文本
	 */	
	public class BitmapText extends Text
	{
		
		public static const P_backgound:String = "backgound";

		public function BitmapText()
		{
			super();
		}

		protected var _backStyle:String;
		protected var _backgound:DisplayObject;
		protected var _bitmapDisplay:Sprite;
		protected var _brush:BitmapData;

		/**
		 * 
		 * 背景样式
		 */		
		public function get backStyle ():String
		{
			return _backStyle;
		}
		
		public function set backStyle (value:String):void
		{
			if(value == _backStyle) return;
			_backStyle = value;
			backgound = ComponentFactory.Instance.creat(_backStyle);
		}
		/**
		 * 
		 * @param source 背景
		 * 
		 */		
		public function set backgound(source:DisplayObject):void
		{
			if(_backgound == source) return;
			ObjectUtils.disposeObject(_backgound);
			_backgound = source;
			_backgound.cacheAsBitmap = true;
			onPropertiesChanged(P_backgound);
		}
		
		override public function dispose():void
		{
			ObjectUtils.disposeObject(_backgound);
			_backgound = null;
			ObjectUtils.disposeObject(_bitmapDisplay);
			_bitmapDisplay = null;
			super.dispose();
		}
		
		override protected function addChildren():void
		{
			if(_bitmapDisplay)addChild(_bitmapDisplay);
			if(_backgound)addChild(_backgound);
		}
		override protected function init():void
		{
			super.init();
			_bitmapDisplay = new Sprite();
			_field.cacheAsBitmap = true;
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			if(_changedPropeties[Text.P_textFormat])
			{
				updateText();
			}
		}
		
		override protected function updateText():void
		{
			super.updateText();
			_backgound.width = _width;
			_backgound.height = _height;
			_backgound.mask = DisplayUtils.drawTextShape(_field);
		}
	}
}