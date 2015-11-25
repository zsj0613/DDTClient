package road.ui.controls.hframe
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import road.ui.accect.ExcalmatoryMarkBitmapAccect;
	import road.ui.accect.InputBackgound;
	import road.utils.StringHelper;
	
	public class HTipFrame extends HConfirmFrame
	{
		private var _icon   : ExcalmatoryMarkBitmapAccect;
		private var _tipIma : DisplayObject;
		private var _tipTxt : TextField;
		private var _tipTxt2: TextField;
		private var _format1: TextFormat;
		private var _format2: TextFormat;
		private var _inputFormat:TextFormat;
		private var _inputTextField:TextField;
		private var _inputContainer:Sprite;
		private var _inputBackgound:InputBackgound;
		public function HTipFrame()
		{
			super();
			init();
		}
		private function init() : void
		{
			_tipTxt = new TextField();
			_tipTxt.selectable = false;
			_tipTxt.mouseEnabled = false;
			_tipTxt.autoSize = TextFieldAutoSize.LEFT;
			_tipTxt.text = "";
			addContent(_tipTxt,false);
			
			_inputContainer = new Sprite();
			_inputTextField = new TextField();
			_inputTextField.type = TextFieldType.INPUT;
			_inputTextField.multiline = false;
			_inputTextField.wordWrap = false;
			_inputFormat = new TextFormat("宋体",18,0xFFFFFF,true);
			_inputTextField.defaultTextFormat = _inputFormat;
			_inputBackgound = new InputBackgound();
			_inputContainer.addChild(_inputBackgound);
			_inputContainer.addChild(_inputTextField);
			addContent(_inputContainer,false);

			_tipTxt2 = new TextField();
			_tipTxt2.text = "";
			_tipTxt2.selectable = false;
			_tipTxt2.mouseEnabled = false;
			_tipTxt2.autoSize = TextFieldAutoSize.LEFT;
			addContent(_tipTxt2,false);
						
			_icon = new ExcalmatoryMarkBitmapAccect();
			this.addContent(_icon,false);
			
			_format1   = new TextFormat("宋体",14,0x2C1525);
			_format2   = new TextFormat("宋体",12,0x693C0C);
			fireEvent = false;
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			super.__onKeyDownd(e);
			e.stopImmediatePropagation();
		}
	
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
			_inputTextField.text = "";
			stage.focus = _inputTextField;
			
		}
		override public function dispose():void
		{
			if(stage)stage.focus = null;
			super.dispose();
			_inputTextField.removeEventListener(TextEvent.TEXT_INPUT,  __inputHandler);
		}
		
		public function clearInputText() : void
		{
			_inputTextField.text = "";
			if(stage)stage.focus = _inputTextField;
		}
		
		/*最大字符*/
		private var _maxChar : int;
		public function set maxChar(i : int) : void
		{
			_inputTextField.addEventListener(TextEvent.TEXT_INPUT,  __inputHandler);
			_maxChar = i;
		}
		private function __inputHandler(evt : TextEvent) : void
		{
			StringHelper.checkTextFieldLength(_inputTextField,_maxChar); // bret 09.5.24
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		
		public function tipTxt(msg : String,msg2 : String="") : void
		{
			_tipTxt.text = msg;
			_tipTxt2.text = msg2;
			_tipTxt.setTextFormat(this._format1);
			_tipTxt2.setTextFormat(this._format2);
		}
		public function set inputTxtWidth(w : int) : void
		{
			_inputBackgound.width = w; //bret 09.6.3
			_inputTextField.width = w - 4;
		}
		public function get inputTxt() : String
		{
			return _inputTextField.text.toString();
		}
		
		public function set inputTxt(s:String):void
		{
			_inputTextField.text = s;
		}
		
		public function set iconVisible(b : Boolean) : void
		{
			if(!b && _icon.parent)_icon.parent.removeChild(_icon);
			if(b)this.addContent(_icon,false);
		}
		
		public function set tipIma($mc : DisplayObject) : void
		{
			if($mc == null)
			{
				if(_tipIma && _tipIma.parent)this.removeChild(_tipIma);
				return;
			}
			_tipIma = $mc;
			this.addContent(_tipIma,false);
		}
		public function set space(i : int) : void
		{
			this._space = i;
		}
		
		private var _y     : int = 5;
		private var _space : int = 0;
		private function get contentWidth() : int
		{
			return (this.frameWidth - 32);
		}
		public function layou() : void
		{
			if(_icon.parent)
			{
				if(_tipIma)
				{
					_icon.x = (this.contentWidth - (_icon.width + _tipIma.width + _space))/2;
					_tipIma.x = _icon.x + _icon.width+ _space;
					_icon.y = _tipIma.y = _y;
					var _h : int = (_tipIma.height > _icon.height ? _tipIma.height : _icon.height);
					_icon.y +=  (_h-_icon.height)/2;
					_tipIma.y += (_h - _tipIma.height)/2;
					_y += _h;
					
				}
				else
				{
					_y += _icon.height;
				}
				
			}
			else
			{
				if(_tipIma)
				{
					_tipIma.x = this.contentWidth/2 - _tipIma.width/2;
					_tipIma.y = _y;
					_y += _tipIma.height;
				}
			}
			_tipTxt.x = this.contentWidth/2 - _tipTxt.width/2;
			_tipTxt.y = _y + _space;
			_inputContainer.x = this.contentWidth/2 - _inputContainer.width/2;
			_inputContainer.y = _tipTxt.y + 20 + _space;
		
			if(!_icon.parent && !_tipIma)
			{
				_tipTxt.x = (this.contentWidth - (_tipTxt.width + _space + _inputContainer.width))/2;
			    _tipTxt.y = _y + 3;
				_inputContainer.y =  _y ;
				_inputContainer.x = (this.contentWidth + _tipTxt.width + _space + _inputContainer.width)/2 - _inputContainer.width;
			}
			
			_tipTxt2.y = _tipTxt.y + 25;
			_tipTxt2.x = (this.contentWidth - _tipTxt2.width)/2;
		}
		// bret 09.6.3 ************************************
		public function get getInputText():TextField
		{
			return _inputTextField;
		}
		
		public function setFocus():void
		{
			if(stage) stage.focus = _inputTextField;
		}
		
		//bret 09.6.8 
		public function set tipTxtY(num:Number):void
		{
			_tipTxt.y = num + 3;
			_inputContainer.y = num;
		}
		
		//bret 09.6.18
		public function get tipTxt2():TextField
		{
			return _tipTxt2;
		}
	}
}