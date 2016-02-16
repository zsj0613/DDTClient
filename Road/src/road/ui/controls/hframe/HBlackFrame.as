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
	
	import road.BitmapUtil.ScaleBitmap;
	import road.manager.SoundManager;
	import road.ui.accect.CloseBtnAccect;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.bitmap.BlackFrameBG;
	import road.ui.controls.hframe.bitmap.BlackFrameBottom;
	import road.ui.controls.hframe.bitmap.BlackFrameHeader;
	import road.ui.manager.TipManager;

	public class HBlackFrame extends Sprite
	{
		public static var OK_LABEL:String = "确 定";
		public static var CANCEL_LABEL:String = "取 消";
		
		
		/**
		 * 背景
		 *   */
		protected var _bg:ScaleBitmap;
		
		/**
		 * 标题背景
		 *   */
		 protected var _header:ScaleBitmap;
		 
		 /**
		 * 
		 * 底部按钮背景
		 *   */
		 protected var _bottom:ScaleBitmap;
		 /**
		 * 背景的容器
		 *   */
		 protected var _bitmapContainer:Sprite;
		 
		 /**
		 * 宽度
		 *   */
		 protected var _width:Number = 300;
		 
		 /**
		 * 高度
		 *   */
		 protected var _height:Number = 300;
		 
		 
		 /**
		 * 
		 * 标题头背景的距离
		 * 
		 *   */
		 protected var _headerGape:Number = 3;
		 /**
		 * 
		 * 下面按钮背景的距离
		 * 
		 *   */
		 protected var _bottomGape:Number = 4;
		 
		 /**
		 * 
		 * 按钮的间距
		 *   */
		 protected var _buttonGape:Number = 80;
		 
		 /**
		 * 
		 * 按钮
		 *   */
		 public var btnOK:HLabelButton;
		 public var btnCancel:HLabelButton;
		 protected var btnClose:HBaseButton;
		 
		 private var _bottomHeight:Number = 36;
		 
		 protected var _bottomContainer:Sprite;
		 
		 protected var _buttonContainer:Sprite;
		 
		 protected var _headerContainer:Sprite;
		 
		 
		 public var okFunction:Function;
		 public var cancelFunction:Function;
		 public var closeFunction:Function;
		 public var enterFunction:Function;
		 public var escFunction :Function;
		 
		 
		 protected var _showClose:Boolean;
		 
		 public var stopClickEvent:Boolean = true;
		 
		 /**
		 * 标题文本框
		 *   */
		 protected var titleField:TextField;
		public function HBlackFrame()
		{
			initViews();
			addEvent();
		}
		
		protected function initViews():void
		{
			titleField = new TextField();
			titleField.autoSize = "left";
			titleField.mouseEnabled = false;
			titleField.selectable = false;
			titleField.filters = [new GlowFilter(0x000000,1,3,3,10)];
			titleField.defaultTextFormat = new TextFormat(null,16,0xffffff,true);
			
			titleField.x = 5;
			titleField.y = 2;
			
			_bitmapContainer = new Sprite();
			_bottomContainer = new Sprite();
			_headerContainer = new Sprite();
			
			addChild(_bitmapContainer);
			
			
			_bg = new BlackFrameBG();
			_header = new BlackFrameHeader();
			_bottom = new BlackFrameBottom();
			_bitmapContainer.addChild(_bg);
			_bitmapContainer.addChild(_headerContainer);
			_headerContainer.addChild(_header);
			_bottomContainer.addChild(_bottom);
			_bitmapContainer.addChild(_bottomContainer);
			addChild(titleField);
			createButtons();
			
		}
		
		public function setSize($width:Number,$height:Number):void
		{
			_width = $width;
			_height = $height;
		
			_bg.width = _width;
			_bg.height = _height;
			_header.width = _width - _headerGape*2;
			_bottom.width = _width - _bottomGape*2;
			_bottom.height = _bottomHeight;
			setPos();
		}
		
		public function setPos():void
		{
			_headerContainer.x = _headerGape;
			_headerContainer.y = 3;
			_bottom.x = _bottomGape;
			setButtonPos();
			_bottomContainer.y = _height-_bottomContainer.height-4;
			
		}
		
		protected function createButtons():void
		{
			_buttonContainer = new Sprite();
			btnClose = new HBaseButton(new CloseBtnAccect());
			addChild(btnClose);
			btnCancel = new HLabelButton();
			btnCancel.label = CANCEL_LABEL;
			
			btnOK = new HLabelButton();
			btnOK.label = OK_LABEL;
			
			_bottomContainer.addChild(_buttonContainer);
			_buttonContainer.addChild(btnOK);
			_buttonContainer.addChild(btnCancel);
		}
		
		protected function setButtonPos():void
		{
			btnOK.y = btnCancel.y = (_bottom.height-btnOK.height)/2;
			btnCancel.x = _buttonGape+btnOK.width;
			
			_buttonContainer.x = (_bottomContainer.width - _buttonContainer.width)/2;
			
			btnClose.x = _width-btnClose.width;
			btnClose.y = 2;
		}
		
		public function addEvent():void
		{
			btnOK.addEventListener(MouseEvent.CLICK,onBtnClick);
			btnCancel.addEventListener(MouseEvent.CLICK,onBtnClick);
			btnClose.addEventListener(MouseEvent.CLICK,onBtnClick);
			_headerContainer.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_headerContainer.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoveToStage);
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			this.startDrag();
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		public function set buttonGape(n:Number):void
		{
			_buttonGape = n;
			setPos();
		}
		
		public function set showBottom (b:Boolean):void
		{
			_buttonContainer.visible = b;
		}
		
		public function set showCancel (b:Boolean):void
		{
			if(b)
			{
				_buttonContainer.addChild(btnCancel);
			}else
			{
				if(btnCancel.parent)
					_buttonContainer.removeChild(btnCancel);
			}
			setPos();
		}
		
		public function set showClose(b:Boolean):void
		{
			_showClose = b;
			btnClose.visible = b;
		}
		
		public function get showClose():Boolean
		{
			return _showClose;
		}
		
		public function set moveEnable (b:Boolean):void
		{
			if(b)
			{
				_headerContainer.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				_headerContainer.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}else
			{
				_headerContainer.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				_headerContainer.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}
		}
		
		public function close ():void
		{
			if(parent) parent.removeChild(this);
		}
		public function show (center:Boolean = true):void
		{
			TipManager.AddTippanel(this,center);
		}
		
		public function dispose ():void
		{
			removeEvent();
			_header.bitmapData.dispose();
			_bottom.bitmapData.dispose();
			_bg.bitmapData.dispose();
			_header.dispose();
			_bottom.dispose();
			_bg.dispose();
			_header = null;
			_bottom = null;
			_bg = null;
			okFunction = null;
			cancelFunction = null;
			closeFunction = null;
			enterFunction = null;
			escFunction = null;
			btnOK.dispose();
			btnOK = null;
			btnCancel.dispose();
			btnCancel = null;
			btnClose.dispose();
			btnClose = null;
		}
		
		public function removeEvent():void
		{
			_headerContainer.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_headerContainer.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			btnOK.removeEventListener(MouseEvent.CLICK,onBtnClick);
			btnCancel.removeEventListener(MouseEvent.CLICK,onBtnClick);
			btnClose.removeEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		protected function onAddToStage(e:Event):void
		{
			stage.focus = this;
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		protected function onRemoveToStage(e:Event):void
		{
			stage.focus = null;
			removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			SoundManager.Instance.play("008");
			e.stopImmediatePropagation();
			if(e.keyCode == Keyboard.ENTER)
			{
				if(enterFunction != null)enterFunction();
			}else if (e.keyCode == Keyboard.ESCAPE)
			{
				if(cancelFunction != null)cancelFunction();
			}
		}
		protected function onBtnClick(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(stopClickEvent)
			{
				e.stopImmediatePropagation();
			}
			switch(e.currentTarget)
			{
				case btnOK:
				if(okFunction != null)okFunction();
				break;
				case btnCancel:
				if(cancelFunction != null)cancelFunction();
				break;
				case btnClose:
				if(closeFunction != null)closeFunction();
				else close();
				break;
			}
		}
		
		public function set titleText(s:String):void
		{
			titleField.text = s;
		}
		
		public function set bottomHeight (w:Number):void
		{
			_bottomHeight = w;
			setSize(_width,_height);
			
		}
		
	}
}