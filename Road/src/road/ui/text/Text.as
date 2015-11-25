package road.ui.text
{
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.utils.ObjectUtils;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	public class Text extends Component
	{
		public static const DYNAMIC:int = 0;
		public static const INPUT:int = 1;
		public static const P_htmlText:String = "htmlText";
		public static const P_text:String = "text";
		public static const P_textFormat:String = "textFormat";
		public static const P_type:String = "type";
		public static const STATIC:int = 2;

		public function Text()
		{
		}

		protected var _field:TextField;
		protected var _htmlText:String;
		protected var _text:String;
		protected var _textFormat:TextFormat;
		private var _textFormatStyle:String;
		private var _type:int = 0;
		
		override public function dispose():void
		{
			ObjectUtils.disposeObject(_field);
			_field = null;
			_textFormat = null;
			super.dispose();
		}
		/**
		 * 
		 * @param value htmlText
		 * 
		 */		
		public function set htmlText (value:String):void
		{
			if(_htmlText == value)return;
			_htmlText = value;
			onPropertiesChanged(P_htmlText);
		}
		/**
		 * 
		 * @param frameIndex 跳帧
		 * 
		 */		
		public function setFrame(frameIndex:int):void
		{
			
		}
		/**
		 * 
		 * @return 文本
		 * 
		 */		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			if(_text == value) return;
			_text = value;
			onPropertiesChanged(P_text);
		}
		/**
		 * 
		 * @return  系统文本框
		 * 
		 */		
		public function get textField():TextField
		{
			return _field;
		}
		/**
		 * 
		 * @param format 文本格式
		 * 
		 */		
		public function set textFormat(format:TextFormat):void
		{
			if(_textFormat == format) return;
			_textFormat = format;
			onPropertiesChanged(P_textFormat);
		}
		/**
		 * 
		 * @param stylename 文本格式的样式
		 * 通过ComponentFactory.Instance.model.getSet 获取
		 * 
		 */		
		public function set textFormatStyle(stylename:String):void
		{
			if(_textFormatStyle == stylename) return;
			_textFormatStyle = stylename;
			textFormat = ComponentFactory.Instance.model.getSet(_textFormatStyle);
		}
		/**
		 * 
		 * @param $type 文本的类型
		 * DYNAMIC 为动态文本
		 * INPUT 为输入文本
		 */		
		public function set type($type:int):void
		{
			if(_type == $type)return;
			_type = $type;
			onPropertiesChanged(P_type);
		}
		
		protected function __onTextChange(event:Event):void
		{
			_text = _field.text;
			updateText();
		}
		
		override protected function init():void
		{
			_field = new TextField();
			_field.autoSize = TextFieldAutoSize.LEFT;
			mouseChildren = false;
			mouseEnabled = false;
			super.init();
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			if(_changedPropeties[P_type])
			{
				if(_type == INPUT)
				{
					mouseChildren = true;
					mouseEnabled = true;
					_field.addEventListener(Event.CHANGE,__onTextChange);
					_field.type = TextFieldType.INPUT;
				}else if(_type == DYNAMIC || _type == STATIC)
				{
					mouseChildren = false;
					mouseEnabled = false;
					_field.removeEventListener(Event.CHANGE,__onTextChange);
					_field.type = TextFieldType.DYNAMIC;
				}
			}
			if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height] || _changedPropeties[P_type])
			{
				if(_type == INPUT || _type == STATIC)
				{
					_field.width = _width;
					_field.height = _height;
				}
			}
			if(_changedPropeties[P_text])
			{
				updateText();
			}
			
			if(_changedPropeties[P_htmlText])
			{
				updateHtmlText();
			}
		}
		
		protected function updateHtmlText():void
		{
			_field.htmlText = _htmlText;
			updateSize();
		}
		
		protected function updateSize():void
		{
			if(_type == DYNAMIC)
			{
				_width = _field.textWidth;
				_height = _field.textHeight;
			}
		}
		
		protected function updateText():void
		{
			_field.text = _text;
			_field.defaultTextFormat = _textFormat;
			_field.setTextFormat(_textFormat);
			updateSize();
		}
	}
}