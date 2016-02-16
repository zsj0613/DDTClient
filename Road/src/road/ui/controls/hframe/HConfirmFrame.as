package road.ui.controls.hframe
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	
	public class HConfirmFrame extends HFrame
	{
		public static var OK_LABEL:String = "确 定";
		public static var CANCEL_LABEL:String = "取 消";
		
		private var _okBtn:HLabelButton;
		private var _cancelBtn:HLabelButton;
		private var _buttonGape:Number = 50;
		private var _buttonContainer:Sprite;
		
		private var _showCancel:Boolean;
		
		private var _okFunction:Function;
		private var _cancelFunction:Function;
		private var _autoClearn:Boolean = true;
		protected var _contentTextField:TextField;
		public var stopKeyEvent:Boolean = false;
		protected var tFormat:TextFormat; 
		public function HConfirmFrame()
		{
			super();
			_buttonContainer = new Sprite();
			_okBtn = new HLabelButton();
			_okBtn.label = OK_LABEL;
			//_okBtn.label = "确     定";
			_cancelBtn = new HLabelButton();
			_cancelBtn.label = CANCEL_LABEL;
			//_cancelBtn.label = "取     消";
			_buttonContainer.addChild(_okBtn);
			_buttonContainer.addChild(_cancelBtn);
			addChild(_buttonContainer);
			
			_contentTextField = new TextField();
			tFormat= new TextFormat("宋体",16,0x013465,false);
			tFormat.leading = 5;
			_contentTextField.defaultTextFormat = tFormat;
			_contentTextField.mouseEnabled = false;
			_contentTextField.filters = [new GlowFilter(0xffffff,1,4,4,10)];
			_contentTextField.autoSize = "left";
			_contentTextField.text = "";
			addChild(_contentTextField);
			initEvent();
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,__ok);
			_cancelBtn.addEventListener(MouseEvent.CLICK,__cancel);
		}
		public function removeKeyDown() : void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		
		override protected function __removeToStage(e:Event):void
		{
			super.__removeToStage(e);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
			
		}
		override protected function __closeClick(e:MouseEvent):void
		{
			close();
			SoundManager.Instance.play("008");
		}
		
		protected function __onKeyDownd(e:KeyboardEvent):void
		{
			if(stopKeyEvent)
			{
				e.stopImmediatePropagation();
			}
			if(e.keyCode == Keyboard.ENTER)
			{
				if(_okBtn.enable)
				{
					SoundManager.Instance.play("008");
					if(_okFunction != null)
						_okFunction();
				}
			}else if(e.keyCode == Keyboard.ESCAPE)
			{
				if(_cancelBtn.enable)
				{
					SoundManager.Instance.play("008");
					if(_cancelFunction != null)
					{
						_cancelFunction();
					}else
					{
						hide();
					}
				}
			}
		}
		
		public function get fireEvent ():Boolean
		{
			return _fireEvent;
		}
		
		public function set okBtnEnable(b : Boolean) : void
		{
			if(_okBtn)_okBtn.enable = b;
		}
		//* bret 09.6.5******************************
		public function get okBtnEnable():Boolean
		{
			return _okBtn.enable;
		}
		//******************************************
		public function set cancelBtnEnable(b : Boolean) : void
		{
			this._cancelBtn.enable = b;
		}
		
		public function set okLabel ($label:String):void
		{
			_okBtn.label = $label;
		}
		public function get okLabel():String
		{
			return _okBtn.label;
		}
		
		public function set cancelLabel ($label:String):void
		{
			_cancelBtn.label = $label;
		}
		public function get cancelLabel():String
		{
			return _cancelBtn.label;
		}
		
		public function set autoClearn (b:Boolean):void
		{
			_autoClearn = b;
		}
		
		public function get autoClearn():Boolean
		{
			return _autoClearn
		}
		
		
		public function get okBtn():HLabelButton
		{
			return _okBtn;
		}
		
		
		public function get cancelBtn():HLabelButton
		{
			return _cancelBtn;
		}
		
		
		public function set showCancel(b:Boolean):void
		{
			_showCancel = b;
			if(_showCancel)
			{
				_buttonContainer.addChild(_cancelBtn);
			}
			else
			{
				if(_cancelBtn.parent)
				{
					_cancelBtn.parent.removeChild(_cancelBtn);
				}
			}
//			center();
			buttonGape = _buttonGape;
		}
		
		override public function center():void
		{
			super.center();
			_contentTextField.x = (_width - _contentTextField.width)/2;
			_contentTextField.y = 30+ (_height - _contentTextField.height - 80)/2;
			_buttonContainer.y = _height - 42;
			_buttonContainer.x = (_width -_buttonContainer.width)/2;
		}
		
		public function set buttonGape ($gape:Number):void
		{
			_buttonGape = $gape;
			_cancelBtn.x = _buttonGape+_okBtn.width;
			center();
		}
		
		private function __ok(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			if(_okFunction != null)
			{
				_okFunction();
			}else
			{
				if(_autoClearn)
				{
					hide();
				}
			}
		}
		
		private function __cancel(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			if(_cancelFunction != null)
			{
				_cancelFunction();
			}else
			{
				if(_autoClearn)
				{
					hide();
				}
			}
		}
		
		public function set okFunction ($f:Function):void
		{
			_okFunction = $f;
			
		}
		
		public function get okFunction():Function { return _okFunction};
		
		public function set cancelFunction ($f:Function):void
		{
			_cancelFunction = $f;
		}
		public function get cancelFunction():Function { return _cancelFunction};
		
		public function hide ():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		override public function dispose() : void
		{
			super.dispose();
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
			if(_okBtn)
			{
				_okBtn.removeEventListener(MouseEvent.CLICK,__ok);
				if(_okBtn.parent)_okBtn.parent.removeChild(_okBtn);
				_okBtn.dispose();
			}
			_okBtn = null;
			if(_cancelBtn)
			{
				_cancelBtn.removeEventListener(MouseEvent.CLICK,__cancel);
				if(_cancelBtn.parent)_cancelBtn.parent.removeChild(_cancelBtn);
				_cancelBtn.dispose();
			}
			_cancelBtn = null;
			_okFunction = null;
		    _cancelFunction = null;
		}
		
		override public function addActiveEvent():void
		{
			super.addActiveEvent();
			_okBtn.addEventListener(MouseEvent.CLICK,__ok);
			_cancelBtn.addEventListener(MouseEvent.CLICK,__cancel);
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		
		override public function removeActiveEvent():void
		{
			super.removeActiveEvent();
			_okBtn.removeEventListener(MouseEvent.CLICK,__ok);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,__cancel);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		
	}
}