package road.ui.controls
{
	import fl.controls.BaseButton;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import road.ui.controls.tabPanelClasses.TabPanelHeader;

	public class TabPanel extends UIComponent
	{
		protected var _contentPaddingWidth:uint = 4;
		protected var _contentPaddingHeight:uint = 4;
		
		protected var _headerPadding:uint = 2;
		protected var _headerWidth:uint = 64;
		protected var _headerHeight:uint = 24;
		
		protected var _minWidth:uint = 140;
		protected var _minHeight:uint = 100;
		
		protected var headers:Array;
		protected var contents:Array;
		protected var contentBg:DisplayObject;
		protected var contentRect:Rectangle;
		private var _selectedIndex:int;
		protected var _preBtn:BaseButton;
		protected var _nextBtn:BaseButton;
		protected var _headerContainer:Sprite;
		protected var _mask:Sprite;
		
		private static const defaultStyle:Object = { contentBg:TabPanel_Content_Bg }
		
		private static const PRE_STYLE:Object = { 	upSkin:TabPanel_PreButton_upSkin,
													downSkin:TabPanel_PreButton_downSkin,
													overSkin:TabPanel_PreButton_overSkin,
												  	disabledSkin:TabPanel_PreButton_upSkin,
												  	selectedDisabledSkin:TabPanel_PreButton_upSkin,
												  	selectedUpSkin:TabPanel_PreButton_upSkin,
												  	selectedDownSkin:TabPanel_PreButton_downSkin,
												  	selectedOverSkin:TabPanel_PreButton_overSkin,
												 	focusRectSkin:null, focusRectPadding:null,
												  	repeatDelay:500,repeatInterval:35};
		private static const NEXT_STYLE:Object = { 	upSkin:TabPanel_NextButton_upSkin,
													downSkin:TabPanel_NextButton_downSkin,
													overSkin:TabPanel_NextButton_overSkin,
												  	disabledSkin:TabPanel_NextButton_upSkin,
												 	selectedDisabledSkin:TabPanel_NextButton_upSkin,
												  	selectedUpSkin:TabPanel_NextButton_upSkin,
												  	selectedDownSkin:TabPanel_NextButton_downSkin,
												  	selectedOverSkin:TabPanel_NextButton_overSkin,
												 	focusRectSkin:null, focusRectPadding:null,
												  	repeatDelay:500,repeatInterval:35};	
		
		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle, UIComponent.getStyleDefinition());
		}
		
		public function get contentPaddingWidth():uint
		{
			return _contentPaddingWidth
		}
		public function set contentPaddingWidth(value:uint):void
		{
			if(_contentPaddingWidth == value)return;
			_contentPaddingWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get contentPaddingHeight():uint
		{
			return _contentPaddingHeight;
		}
		public function set contentPaddingHeight(value:uint):void
		{
			if(_contentPaddingHeight == value)return;
			_contentPaddingHeight = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get headerPadding():uint
		{
			return _headerPadding;
		}
		public function set headerPadding(value:uint):void
		{
			if(_headerPadding == value)return;
			_headerPadding = value;
			invalidate(InvalidationType.SIZE);
		}
		public function get headerHeight():uint
		{
			return _headerHeight;
		}
		public function set headerHeight(value:uint):void
		{
			if(_headerHeight == value)return;
			_headerHeight = value;
			invalidate(InvalidationType.SIZE);
		}
			
		public function TabPanel()
		{
			super();
			
			headers = [];
			contents = [];
			this.contentRect = new Rectangle(0,0,140,100);
			
			_selectedIndex = -1;
			
			createMoveBtn();
			_headerContainer = new Sprite();
			_mask = new Sprite();
		}
		
		protected function createMoveBtn():void
		{
			_preBtn = new BaseButton();
			_preBtn.addEventListener(MouseEvent.MOUSE_DOWN,__preBtnDown);
			_preBtn.addEventListener(MouseEvent.MOUSE_UP,__preBtnUp);
			_preBtn.setSize(11,18);
			copyStylesToChild2(_preBtn,PRE_STYLE);
			_nextBtn = new BaseButton();
			_nextBtn.addEventListener(MouseEvent.MOUSE_DOWN,__nextBtnDown);
			_nextBtn.addEventListener(MouseEvent.MOUSE_UP,__nextBtnUp);
			_nextBtn.setSize(11,18);
			copyStylesToChild2(_nextBtn,NEXT_STYLE);
			
		}
		
		public function append(content:Sprite,value:Object):void
		{
			var header:TabPanelHeader = createHeader(value);
			header.setSize(header.width,headerHeight);
			header.addEventListener(MouseEvent.CLICK,__headerClick);
			
			headers.push(header);
			contents.push(content);
			invalidate(InvalidationType.DATA);
		}
		
		protected function createHeader(value:Object):TabPanelHeader
		{
			return new TabPanelHeader(value);
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			width = width < _minWidth ? _minWidth : width;
			height = height < _minHeight ? _minHeight : height;
			super.setSize(width,height);
		}
		
		public function setContentSize(w:Number,h:Number):void
		{
			setSize(w + contentPaddingWidth * 2,h + contentPaddingHeight * 2 + _headerHeight);
		}
		
		protected function __preBtnDown(evt:MouseEvent):void
		{
			_preBtn.addEventListener(Event.ENTER_FRAME,__preEnterFrame);
		}
		
		protected function __preBtnUp(evt:MouseEvent):void
		{
			_preBtn.removeEventListener(Event.ENTER_FRAME,__preEnterFrame);
		}
		
		protected function __preEnterFrame(evt:Event):void
		{
			if(_headerContainer.x < _headerPadding)
			{
				_headerContainer.x += 5;
			}
			else
			{
				_headerContainer.x = _headerPadding;
				_preBtn.removeEventListener(Event.ENTER_FRAME,__preEnterFrame);
			}
		}
		
		protected function __nextBtnDown(evt:MouseEvent):void
		{
			_nextBtn.addEventListener(Event.ENTER_FRAME,__nextEnterFrame);
		}
		
		protected function __nextBtnUp(evt:MouseEvent):void
		{
			_nextBtn.removeEventListener(Event.ENTER_FRAME,__nextEnterFrame);
		}
		
		protected function __nextEnterFrame(evt:Event):void
		{
			if(_headerContainer.x > this.width - _headerContainer.width - _nextBtn.width * 2 - _headerPadding)
			{
				_headerContainer.x -= 5;
			}
			else
			{
				_headerContainer.x = this.width - _headerContainer.width - _nextBtn.width * 2 - _headerPadding;
				_nextBtn.removeEventListener(Event.ENTER_FRAME,__nextEnterFrame);
			}
		}
		
		public function removeAt(index:Number):void
		{
			if(headers.length <1) return;
			
			if(index < 0 || index >= headers.length) 
				throw new Error("index out of range");
			var header:Sprite = headers[index];
			var content:Sprite = contents[index];
			headers.splice(index,1);
			contents.splice(index,1);
			invalidate(InvalidationType.DATA);
		}
		
		protected function copyStylesToChild2(child:UIComponent, map:Object):void
		{
			for( var n:String in map)
			{
				child.setStyle(n,map[n]);
			}
		}
		
		protected function __headerClick(event:MouseEvent):void
		{
			this.selectedIndex = getHeaderIndex(event.currentTarget);
		}
		
		
		public function set selectedIndex(value:int):void
		{
			if(value == _selectedIndex) return;
			if(value < 0 || value >= contents.length) return;
			
			_selectedIndex = value;
			invalidate(InvalidationType.SELECTED);
			dispatchEvent(new Event(Event.SELECT));
			
		}
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		private function getHeaderIndex(item:Object):int
		{
			for(var i:int = 0;i<headers.length;i++)
			{
				if(headers[i] == item)
				{
					return i;
				}
			}
			return -1;
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLES))
			{
				drawStyles();
				invalidate(InvalidationType.SIZE,false);
			}	
			if(isInvalid(InvalidationType.SIZE))
			{
				drawLayout();
			}
			if(isInvalid(InvalidationType.DATA))
			{
				drawChildren();
				invalidate(InvalidationType.SIZE,false);
				invalidate(InvalidationType.SELECTED,false);
			}
			if(isInvalid(InvalidationType.SELECTED))
			{
				updateSelectedChildren();
			}
			
			super.draw();
		}
		protected function drawStyles():void
		{
			var bg:DisplayObject = contentBg;
			contentBg = getDisplayObjectInstance(getStyleValue("contentBg"));
			this.addChildAt(contentBg,0);
			if(bg != contentBg && bg != null) this.removeChild(bg);
		}
		protected function drawLayout():void
		{
			contentBg.y = _headerHeight;
			contentBg.width = this.width;
			contentBg.height = this.height - contentBg.y;
			
			contentRect.width = this.width - 2 * contentPaddingWidth;
			contentRect.height = this.height - 2 * contentPaddingHeight - _headerHeight;
			
			var i:int = 0;
			for(i = 0;i < contents.length;i++)
			{
				var c:DisplayObject = contents[i];
				c.scrollRect = contentRect;
				c.x = contentPaddingWidth;
				c.y = contentPaddingHeight + _headerHeight;
			}
			var headerswidth:Number = 0;
			for(i = 0; i < headers.length; i++)
			{
				var h:TabPanelHeader = headers[i];
				h.y = 0;
				h.x = headerswidth;
				h.height = _headerHeight;
				headerswidth +=  h.width + _headerPadding;
			}
			headerswidth -= _headerPadding;
			_headerContainer.x = headerPadding;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000,1);
			if(headerswidth > width - headerPadding * 2)
			{
				_preBtn.move(width - headerPadding - _nextBtn.width * 2 - 1,(_headerHeight - _preBtn.height) / 2);
				_nextBtn.move(width - headerPadding - _nextBtn.width,(_headerHeight - _nextBtn.height) / 2);
				_mask.graphics.drawRect(_headerContainer.x,_headerContainer.y,width - headerPadding * 2 - _nextBtn.width * 2 - 2,_headerHeight);
			}
			else
			{
				_mask.graphics.drawRect(0,_headerContainer.y,width,_headerHeight);
			}
			_mask.graphics.endFill();
		}
		protected function drawChildren():void
		{
			var i:int = 0;
			var len:Number = numChildren;
			for(i = 0;i < len;i ++)
			{
				this.removeChildAt(0);
			}
			this.addChild(contentBg);
			for(i = 0;i < headers.length;i ++)
			{
				this.addChild(contents[i]);
				this._headerContainer.addChild(headers[i]);
			}
			this.addChild(_headerContainer);
			this.addChild(_mask);
			_headerContainer.mask = _mask;
			addMoveBtn();
		}
		
		protected function addMoveBtn():void
		{
			if(_mask.width != width)
			{
				this.addChild(_preBtn);
				this.addChild(_nextBtn);
			}
		}
		protected function updateSelectedChildren():void
		{
			if(contents.length > 0)
			{
				_selectedIndex = _selectedIndex < 0 ? 0 :_selectedIndex;
				_selectedIndex = _selectedIndex > contents.length -1 ? contents.length -1 : _selectedIndex; 
				
				var selectedContent:Sprite = contents[_selectedIndex];
				var selectedHeader:TabPanelHeader = headers[_selectedIndex];
				
				selectedHeader.selected = true;
				selectedHeader.drawNow();
				selectedContent.visible = true;
						
				this._headerContainer.setChildIndex(selectedHeader,this._headerContainer.numChildren - 1);
				this.setChildIndex(selectedContent,this.numChildren - 2);
				this.setChildIndex(contentBg,this.numChildren -3);
				
				for(var j:int = 0;j<headers.length;j++)
				{
					if(headers[j] != selectedHeader)
					{
						TabPanelHeader(headers[j]).selected = false;
						TabPanelHeader(headers[j]).drawNow();
					}
					
				}
				
				for(var i:int = 0;i< contents.length;i++)
				{
					if(contents[i] != selectedContent)
					{
						DisplayObject(contents[i]).visible = false;
					}
				}
			}
			
		}
	}
}