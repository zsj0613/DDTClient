package road.ui.controls
{
	import fl.controls.BaseButton;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.managers.IFocusManagerComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import road.ui.manager.UIManager;
	
	/**
	 *  Frame closing
	 * */
	[Event(name="close",type="flash.events.Event")]
	[Event(name="resize",type="flash.events.Event")]
	[Event(name="startDrag",type="road.ui.FrameEvent")]
	[Event(name="stopDrag",type="road.ui.FrameEvent")]
	[Style(name="activeSkin",type="Class")]
	
	/**
	 * 
	 * @author ROAD-S
	 * 
	 * Frame contains Title,content Panels
	 */	
	public class Frame extends UIComponent implements IFocusManagerComponent
	{
		protected var _minWidth:Number = 140;
		protected var _minHeigth:Number = 80;
		
		/**
		 * between titlepanel,contentpanel and border
		 */		
		protected var _marginWidth:Number = 15;
		protected var _marginHeight:Number = 4;
		/**
		 * between titlePanel and contentPanel
		 */		
		protected var _paddingWidth:Number = 2;
		protected var _paddingHeight:Number = 2;
		
		protected var _titleHeight:Number;
		
		private var _titleTextField:TextField;
		
		private static const defaultStyle:Object = {	activeSkin:Frame_activeBG,
														dragBorder:Frame_dragBorder,
														titleTextFormat:new TextFormat("_sans", 14, 0xffffff, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)
														};

		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle, UIComponent.getStyleDefinition());
		}
		private static const MIN_STYLE:Object = { 	upSkin:Frame_iconifiedIcon_defaultImage,
													downSkin:Frame_iconifiedIcon_pressedImage,
													overSkin:Frame_iconifiedIcon_rolloverImage,
												  	disabledSkin:Frame_iconifiedIcon_disabledImage,
												  	selectedDisabledSkin:Frame_normalIcon_disabledImage,
												  	selectedUpSkin:Frame_normalIcon_defaultImage,
												  	selectedDownSkin:Frame_normalIcon_pressedImage,
												  	selectedOverSkin:Frame_normalIcon_rolloverImage,
												 	focusRectSkin:null, focusRectPadding:null,
												  	repeatDelay:500,repeatInterval:35};
		private static const MAX_STYLE:Object = { 	upSkin:Frame_maximizeIcon_defaultImage,
													downSkin:Frame_maximizeIcon_pressedImage,
													overSkin:Frame_maximizeIcon_rolloverImage,
												  	disabledSkin:Frame_maximizeIcon_disabledImage,
												 	selectedDisabledSkin:Frame_normalIcon_disabledImage,
												  	selectedUpSkin:Frame_normalIcon_defaultImage,
												  	selectedDownSkin:Frame_normalIcon_pressedImage,
												  	selectedOverSkin:Frame_normalIcon_rolloverImage,
												 	focusRectSkin:null, focusRectPadding:null,
												  	repeatDelay:500,repeatInterval:35};		
		private static const CLOSE_STYLE:Object = {	upSkin:Frame_closeIcon_defaultImage,
													downSkin:Frame_closeIcon_pressedImage,
													overSkin:Frame_closeIcon_rolloverImage,
												  	disabledSkin:Frame_closeIcon_disabledImage,
												 	repeatDelay:500,repeatInterval:35};		  	
		
		protected var background:DisplayObject;	
		protected var border:Sprite;											
		protected var btnClose:BaseButton;
		protected var btnMinsize:BaseButton;
		protected var btnMaxsize:BaseButton;
		private var _active:Boolean;
		protected var _titlePanel:UIComponent;
		protected var _contentPanel:UIComponent;
		private var _dragging:Boolean = false;
		private var _titleDrag:Sprite;;
		protected var borderAsset:Sprite;
		protected var _modal:Boolean;
				
		public function get active():Boolean
		{
			return _active;
		}
		public function set active(value:Boolean):void
		{
			if(_active == value)
			{
				return;
			}
			_active = value;
			invalidate(InvalidationType.STATE);
		}
		
		public function set maxsizable(value:Boolean):void
		{
			if(btnMaxsize.visible == value) return;
			btnMaxsize.visible = value;
			this.invalidate(InvalidationType.SIZE);
		}
		public function get maxsizable():Boolean
		{
			return btnMaxsize.visible;
		}
		public function set minsizable(value:Boolean):void
		{
			if(btnMinsize.visible == value) return;
			btnMinsize.visible == value;
			this.invalidate(InvalidationType.SIZE);
		}
		
		public function get marginWidth():Number
		{
			return _marginWidth;
		}
		public function set marginWidth(value:Number):void
		{
			if(_marginWidth == value)return;
			_marginWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get marginHeight():Number
		{
			return _marginHeight;
		}
		public function set marginHeight(value:Number):void
		{
			if(_marginHeight == value)return;
			_marginHeight = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get paddingWidth():Number
		{
			return _paddingWidth;
		}
		public function set paddingWidth(value:Number):void
		{
			if(_paddingWidth == value)return;
			_paddingWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get paddingHeight():Number
		{
			return _paddingHeight;
		}
		public function set paddingHeight(value:Number):void
		{
			if(_paddingHeight == value)return;
			_paddingHeight = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get titleHeight():Number
		{
			return _titleHeight;
		}
		public function set titleHeight(value:Number):void
		{
			if(_titleHeight == value)return;
			_titleHeight = value;
			invalidate(InvalidationType.SIZE);
		}
		public function getName():String
		{
			if(_titleTextField != null)
			{
				return _titleTextField.text;
			}
			return "";
		}
		public function setName(value:String):void
		{
			if(_titleTextField == null)
			{
				_titleTextField = new TextField();
				_titleTextField.width = 200;
				_titleTextField.selectable = false;
				_titleTextField.height = _titleHeight - 2;
			}
			_titleTextField.text = value;
			var t:TextFormat = getStyleValue("titleTextFormat") as TextFormat
			_titleTextField.setTextFormat(t);
			if(value == "")
			{
				if(_titleTextField.parent == _titlePanel)_titlePanel.removeChild(_titleTextField);
			}
			else
			{
				_titlePanel.addChild(_titleTextField);
			}
		}
		
		public function Frame(modal:Boolean = false)
		{
			_modal = modal;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			init();
		}
		
		protected function init():void
		{
			_active = true;
			
			_titleHeight = 32;
			
			_titlePanel = new UIComponent();
			_titlePanel.move(marginWidth,marginHeight);
			this.addChild(_titlePanel);
			
			_contentPanel = new UIComponent();
			_contentPanel.move(marginWidth,marginHeight + _titleHeight + _paddingHeight);
			this.addChild(_contentPanel);
			
			_titleDrag = new Sprite();
			_titleDrag.graphics.beginFill(0,0);
			_titleDrag.graphics.drawRect(0,0,10,30);
			_titleDrag.graphics.endFill();
			_titleDrag.addEventListener(MouseEvent.MOUSE_DOWN,__titleMouseDown);
//			_titleDrag.addEventListener(MouseEvent.MOUSE_DOWN,__titelMouseUp);
			this.addChild(_titleDrag);
			
			btnClose = new BaseButton();
			btnClose.setSize(16,16);
			btnClose.addEventListener(MouseEvent.CLICK,__closeClick);
			btnClose.useHandCursor = true;
			copyStylesToChild2(btnClose,CLOSE_STYLE);
			this.addChild(btnClose);
			
			btnMinsize = new BaseButton();
			btnMinsize.setSize(24,24);
			btnMinsize.visible = false;
			btnMinsize.addEventListener(MouseEvent.CLICK,__minsizeClick);
			copyStylesToChild2(btnMinsize,MIN_STYLE);
			this.addChild(btnMinsize);
			
			btnMaxsize = new BaseButton();
			btnMaxsize.setSize(24,24);
			btnMaxsize.visible = false;
			btnMaxsize.addEventListener(MouseEvent.CLICK,__maxsizeClick);
			copyStylesToChild2(btnMaxsize,MAX_STYLE);
			this.addChild(btnMaxsize);
			
			this.border = new Frame_dragBorder();
			this.addChild(border);
			//this.border.addEventListener(MouseEvent.MOUSE_UP,__titelMouseUp);
			//this.border.addEventListener(MouseEvent.ROLL_OUT,__titelMouseUp);
			border.visible = false;
			
			borderAsset = new Sprite();
			borderAsset.graphics.beginFill(0,0);
			borderAsset.graphics.drawRect(-3000,-3000,6000,6000);
			borderAsset.graphics.endFill();
			borderAsset.addEventListener(MouseEvent.MOUSE_UP,__titelMouseUp);
			borderAsset.addEventListener(MouseEvent.ROLL_OUT,__titelMouseUp);
			
			if(_modal)
			{
				var float:Sprite = new Sprite();
				float.graphics.beginFill(0xffffff,0);
				float.graphics.drawRect(-3000,-3000,6000,6000);
				float.graphics.endFill();
				float.addEventListener(MouseEvent.MOUSE_DOWN,__mouseDown);
				float.addEventListener(MouseEvent.MOUSE_UP,__mouseUp);
				addChildAt(float,0);
			}
		}
		
		private function __mouseDown(event:MouseEvent):void
		{
			this.border.visible = true;
			event.stopImmediatePropagation();
		}
		
		private function __mouseUp(event:MouseEvent):void
		{
			this.border.visible = false;
			event.stopImmediatePropagation();		
		}
		
		private function __titleMouseDown(event:MouseEvent):void
		{
			this.startDrag();
			border.visible = true;
			this.addChild(borderAsset);
			var point:Point = this.parent.globalToLocal(this.localToGlobal(new Point(border.x,border.y)));
			this.border.startDrag(false,new Rectangle(-point.x,-point.y,stage.stageWidth - _width,stage.stageHeight - _height));
			this.dispatchEvent(new FrameEvent(FrameEvent.START_DRAG));
		}
		private function __titelMouseUp(event:MouseEvent):void
		{
			this.stopDrag();
			if(this.border.visible)
			{
				this.border.stopDrag();
				this.removeChild(borderAsset);
				var point:Point = this.parent.globalToLocal(this.localToGlobal(new Point(border.x,border.y)));
				this.border.x = 0;
				this.border.y = 0;
				if(point.x < 0)point.x = 0;
				if(point.y < 0)point.y = 0;
				if(point.x > stage.stageWidth - _width)point.x = stage.stageWidth - _width;
				if(point.y > stage.stageHeight - _height)point.y = stage.stageHeight - _height;
				this.move(point.x,point.y);
				this.border.visible = false;
				this.dispatchEvent(new FrameEvent(FrameEvent.STOP_DRAG));
			}
		}
		
		public function setCloseVisible(b:Boolean):void
		{
			btnClose.visible = b;
		}
		
		private function __closeClick(event:MouseEvent):void
		{
			doClosing();
		}
		
		protected function doClosing():void
		{
			if(parent)
			{
				parent.removeChild(this);
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private var _orientX:Number;
		private var _orientY:Number;
		private function __minsizeClick(event:MouseEvent):void
		{
			if(this.btnMinsize.selected)
			{
				this.btnMinsize.selected = false;
				this.btnMaxsize.selected = false;
				this.setSize(this.startWidth,this.startHeight);
			}
			else
			{
				if(btnMaxsize.selected)
				{
					this.stage.removeEventListener(Event.RESIZE,__stageResize);
					this.move(this._orientX,this._orientY);
				}
				this.btnMinsize.selected = true;
				this.btnMaxsize.selected = false;
				this.setSize(_minWidth,_minHeigth);
			}
		}
		private function __maxsizeClick(event:MouseEvent):void
		{
			if(this.btnMaxsize.selected)
			{
				this.btnMinsize.selected = false;
				this.btnMaxsize.selected = false;
				this.setSize(this.startWidth,this.startHeight);
				this.stage.removeEventListener(Event.RESIZE,__stageResize);
				this.move(this._orientX,this._orientY);
			}
			else
			{
				this.btnMinsize.selected = false;
				this.btnMaxsize.selected = true;
				this.stage.addEventListener(Event.RESIZE,__stageResize);
				this.setSize(stage.stageWidth,stage.stageHeight);
				var point:Point = this.parent.globalToLocal(new Point(0,0));
				this._orientX = this.x;
				this._orientY = this.y;
				this.move(point.x,point.y);
			}
		}
		
		private function __stageResize(event:Event):void
		{
			this.setSize(stage.stageWidth,stage.stageHeight);
		}
		override public function setSize(w:Number, h:Number):void
		{
			w = w < _minWidth ? _minWidth : w;
			h = h < _minHeigth ? _minHeigth : h;
			super.setSize(w,h);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function setContentSize(w:Number,h:Number):void
		{
			this._contentPanel.setSize(w,h);
			this.setSize(w + marginWidth * 2,h + marginHeight * 2 + _titleHeight + _paddingHeight);
		}
		
		public function get TitlePanel():DisplayObjectContainer
		{
			return _titlePanel;
		}
		public function get ContentPanel():DisplayObjectContainer
		{
			return _contentPanel;
		}
			
		protected function copyStylesToChild2(child:UIComponent, style:Object):void
		{
			for(var n:String in style)
			{
				child.setStyle(n,style[n]);	
			}	
		}
		
		override protected function keyDownHandler(arg0:KeyboardEvent):void
		{
			if(arg0.keyCode == Keyboard.ESCAPE)
			{
				arg0.stopImmediatePropagation();
				close();
			}
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLES,InvalidationType.STATE))
			{
				this.drawBackground();
				this.invalidate(InvalidationType.SIZE,false);
			}
			if(isInvalid(InvalidationType.SIZE))
			{
				this.drawLayout();	
			}
			super.draw();
		}
		protected function drawBackground():void
		{
			var bg:DisplayObject = background;
			background = getDisplayObjectInstance(getStyleValue("activeSkin"));
			this.addChildAt(background,0);
			if(bg != null && bg != background)
			{
				this.removeChild(bg);
			}
		}
		protected function drawLayout():void
		{
			this.border.graphics.clear();
			this.border.width = this.width;
			this.border.height = this.height;
			
			this._titleDrag.width = this.width -20;
			
			drawPanels();
			
			var bx:Number = this.width - 24;
			var by:Number = 8;
			
			btnClose.x = bx;
			btnClose.y = by - 2;
			bx -= 28;
			
			if(btnMaxsize.visible)
			{
				btnMaxsize.x = bx;
				btnMaxsize.y = by;
				bx -= 28;
			}
			
			if(btnMinsize.visible)
			{
				btnMinsize.x = bx;
				btnMinsize.y = by;
			}
			//this.titleDrag.width = bx - 8;
		}	
		
		protected function drawPanels():void
		{
			this.background.width = this.width;
			this.background.height = this.height;
			this._contentPanel.move(marginWidth,marginHeight + _titleHeight + paddingHeight);
		}
		
		public function show():void
		{
			UIManager.AddDialog(this);
		}
		
		public function close():void
		{
			this.doClosing();
		}
	}
}