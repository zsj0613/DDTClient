package ddt.register.uicontrol
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	public class HBaseButton extends Sprite
	{
		protected var _bg:DisplayObject;
		protected var _textField:TextField;
		protected var _buttonFormat:IButtonFormat;
		protected var _label:String;
		protected var _container:Sprite;
		protected var _enable:Boolean = true;
		
		public function HBaseButton($bg:DisplayObject,$label:String = "")
		{
			_bg = $bg;
			_label = $label;
			init();
		}
		
		protected function init():void
		{
			_container = new Sprite();
			addChild(_container);
			
			creatButtonFormat();
			_container.addChild(_bg);
			if(_label != "")
			{
				creatTextField();
				_container.addChild(_textField);
			}
			_buttonFormat.setUpFormat(this);
			buttonMode = true;
			center();
			addEvent();
		}
		
		protected function addEvent():void
		{
			addEventListener(MouseEvent.ROLL_OVER,overHandler);
			addEventListener(MouseEvent.ROLL_OUT,outHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			addEventListener(MouseEvent.MOUSE_UP,upHandler);
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function overHandler(evt:MouseEvent):void
		{
			_buttonFormat.setOverFormat(this);
		}
		protected function outHandler(evt:MouseEvent):void
		{
			_buttonFormat.setOutFormat(this);
		}
		
		protected function downHandler(evt:MouseEvent):void
		{
			_buttonFormat.setDownFormat(this);
		}
		protected function upHandler(evt:MouseEvent):void
		{
			_buttonFormat.setUpFormat(this);
		}
		
		protected function clickHandler(evt:MouseEvent):void
		{
			if(!enable)
			{
				evt.stopImmediatePropagation();
			}
		}
	
		protected function creatTextField():TextField
		{
			_textField = new TextField();
			_textField.autoSize = "left";
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			_textField.text = _label;
			_textField.filters = [new GlowFilter(0x996348,1,4,4,10)];
			return _textField
		}
	
		protected function creatButtonFormat():void
		{
			_buttonFormat = new SimpleButtonFormat();
		}
		
		public function center():void
		{
			if(_textField)
			{
				_textField.x = ((_bg.x+_bg.width)-_textField.width)/2;    //当_bg.x！= 0 的时候，公式好像有些问题 _bg.x + (_bg.width - _textField.width)/2;
				_textField.y = ((_bg.y+_bg.height)-_textField.height)/2;  //当_bg.y！= 0 的时候，公式好像有些问题  _bg.y + (_bg.height - _textField.height)/2;
			}
		}
		
		override public function set width($w:Number):void
		{
			_bg.width = $w;
			center();
		}
		
		override public function get width():Number
		{
			return _bg.width;
		}
		
		override public function get height():Number
		{
			return _bg.height;
		}
		
		override public function set height($h:Number):void
		{
			_bg.height = $h;
			center();
		}
		
		public function set enable(b:Boolean):void
		{
			if(b)
			{
				_buttonFormat.setEnable(this);
				buttonMode = true;
				addEvent();
			}
			else
			{
				_buttonFormat.setNotEnable(this);
				buttonMode = false;
				removeEvent();
			}
			_enable = b;
		}
		
		public function get enable ():Boolean
		{
			return _enable;
		}
		
		public function get container():DisplayObjectContainer
		{
			return _container;
		}
		
		public function get bg():DisplayObject
		{
			return _bg;
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function get buttonFormat():IButtonFormat
		{
			return _buttonFormat;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(s:String):void
		{
			if(_textField)
			_textField.text = s;
			center();
		}
		
		public function set useBackgoundPos(b:Boolean):void
		{
			if(b)
			{
				this.x = _bg.x;
				this.y = _bg.y;
				_bg.x = 0;
				_bg.y = 0;
				center();
			}
		}
		
		protected function removeEvent():void
		{
			removeEventListener(MouseEvent.ROLL_OVER,overHandler);
			removeEventListener(MouseEvent.ROLL_OUT,outHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			removeEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		
		public function dispose ():void
		{
			removeEvent();
			removeEventListener(MouseEvent.CLICK,clickHandler);
			if(_bg && _bg.parent) _bg.parent.removeChild(_bg);
			_bg = null;
			_container = null;
			if(_buttonFormat)_buttonFormat.dispose();
			_buttonFormat = null;
			if(this.parent)this.parent.removeChild(this);
		}

	}
}