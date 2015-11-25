package road.ui.controls
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SimpleLabel extends UIComponent
	{
		private static const MARGIN_WIDTH:int = 3;
		private static const MARGIN_HEIGHT:int = 2;
		
		private var _txt:String;
		private var _field:TextField;
		private var _format:TextFormat;
		
		public function SimpleLabel(txt:String = "label",format:TextFormat = null)
		{
			_txt = txt;
			_format = format;
			super();
		}
		
		public function get text():String
		{
			return _txt;
		}
		
		public function set text(value:String):void
		{
			if(_txt == value)return;
			_txt = value;
			invalidate(InvalidationType.DATA);
		}
		
		public function get textFormat():TextFormat
		{
			if(_format)return _format;
			return _field.defaultTextFormat;
		}
		
		public function set textFormat(value:TextFormat):void
		{
			if(_format == value)return;
			if(_field.defaultTextFormat == value)return;
			_format = value;
			invalidate(InvalidationType.DATA);
		}
		
		public function get textField():TextField
		{
			return _field;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_field = new TextField();
			_field.wordWrap = false;
			_field.autoSize = TextFieldAutoSize.LEFT;
			addChild(_field);
			_field.selectable = false;
			invalidate(InvalidationType.DATA);
			drawNow();
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.DATA))
			{
				drawLayout();
			}
			super.draw();
		}
		
		protected function drawLayout():void
		{
			if(_format)
			{
				_field.defaultTextFormat = _format;
			}
			_field.text = _txt;
			setSize(MARGIN_WIDTH * 2 + _field.textWidth, MARGIN_HEIGHT * 2 + _field.textHeight);
			_field.x = MARGIN_WIDTH;
			_field.y = MARGIN_HEIGHT;
		}
	}
}