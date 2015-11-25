package road.ui.controls
{
	import fl.controls.BaseButton;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.ui.controls.tabPanelClasses.*;

	public class TabPanel2 extends TabPanel
	{
		protected var _headerMargin_right:uint = 1;
		
		private static const defaultStyle:Object = { contentBg:TabPanel_Content_Bg }
		
		private static const PRE_STYLE:Object = { 	upSkin:TabPanel2_PreButton_upSkin,
													downSkin:TabPanel2_PreButton_downSkin,
													overSkin:TabPanel2_PreButton_overSkin,
												  	disabledSkin:TabPanel2_PreButton_upSkin,
												  	selectedDisabledSkin:TabPanel2_PreButton_upSkin,
												  	selectedUpSkin:TabPanel2_PreButton_upSkin,
												  	selectedDownSkin:TabPanel2_PreButton_downSkin,
												  	selectedOverSkin:TabPanel2_PreButton_overSkin,
												 	focusRectSkin:null, focusRectPadding:null,
												  	repeatDelay:500,repeatInterval:35};
		private static const NEXT_STYLE:Object = { 	upSkin:TabPanel2_NextButton_upSkin,
													downSkin:TabPanel2_NextButton_downSkin,
													overSkin:TabPanel2_NextButton_overSkin,
												  	disabledSkin:TabPanel2_NextButton_upSkin,
												 	selectedDisabledSkin:TabPanel2_NextButton_upSkin,
												  	selectedUpSkin:TabPanel2_NextButton_upSkin,
												  	selectedDownSkin:TabPanel2_NextButton_downSkin,
												  	selectedOverSkin:TabPanel2_NextButton_overSkin,
												 	focusRectSkin:null, focusRectPadding:null,
												  	repeatDelay:500,repeatInterval:35};	
												  	
		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle, UIComponent.getStyleDefinition());
		}
		
		public function TabPanel2()
		{
			super();
		}
		
		public function get headerWdith():uint
		{
			return _headerWidth;
		}
		public function set headerWidth(value:uint):void
		{
			if(_headerWidth == value)return;
			_headerWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get headerMargin_right():uint
		{
			return _headerMargin_right;
		}
		public function set headerMargin_right(value:uint):void
		{
			if(_headerMargin_right == value) return;
			_headerMargin_right = value;
			invalidate(InvalidationType.SIZE);
		}
		
		override protected function createMoveBtn():void
		{
			_preBtn = new BaseButton();
			_preBtn.addEventListener(MouseEvent.MOUSE_DOWN,__preBtnDown);
			_preBtn.addEventListener(MouseEvent.MOUSE_UP,__preBtnUp);
			_preBtn.setSize(10,5);
			copyStylesToChild2(_preBtn,PRE_STYLE);
			_nextBtn = new BaseButton();
			_nextBtn.addEventListener(MouseEvent.MOUSE_DOWN,__nextBtnDown);
			_nextBtn.addEventListener(MouseEvent.MOUSE_UP,__nextBtnUp);
			_nextBtn.setSize(10,5);
			copyStylesToChild2(_nextBtn,NEXT_STYLE);
		}
		
		override public function setContentSize(w:Number,h:Number):void
		{
			setSize(w + contentPaddingWidth * 2 + _headerWidth,h + contentPaddingHeight * 2);
		}
		
		override protected function createHeader(value:Object):TabPanelHeader
		{
			return new TabPanelHeader2(value) as TabPanelHeader;
		}
		
		override protected function __preEnterFrame(evt:Event):void
		{
			if(_headerContainer.y < _headerPadding)
			{
				_headerContainer.y += 5;
			}
			else
			{
				_headerContainer.y = _headerPadding;
				_preBtn.removeEventListener(Event.ENTER_FRAME,__preEnterFrame);
			}
		}
		
		override protected function __nextEnterFrame(evt:Event):void
		{
			if(_headerContainer.y > this.height - _headerContainer.height - _nextBtn.height * 2 - _headerPadding)
			{
				_headerContainer.y -= 5;
			}
			else
			{
				_headerContainer.y = this.height - _headerContainer.height - _nextBtn.height * 2 - _headerPadding;
				_nextBtn.removeEventListener(Event.ENTER_FRAME,__nextEnterFrame);
			}
		}
		
		override protected function drawLayout():void
		{
			contentBg.x = _headerMargin_right + _headerWidth;
			contentBg.width = this.width - contentBg.x;
			contentBg.height = this.height;
			
			contentRect.width = this.width - _headerMargin_right - _headerWidth - 2 * contentPaddingWidth;
			contentRect.height = this.height - 2 * _contentPaddingHeight;
			
			var i:int = 0;
			for(i = 0;i < contents.length;i++)
			{
				var c:DisplayObject = contents[i];
				c.scrollRect = contentRect;
				c.x = headerWdith + headerMargin_right + contentPaddingWidth;
				c.y = contentPaddingHeight;
			}
			var headersheight:Number = 0;
			for(i = 0; i < headers.length; i++)
			{
				var h:TabPanelHeader = headers[i];
				h.y = headersheight;
				h.x = 0;
				h.width = _headerWidth;
				headersheight +=  h.height + _headerPadding;
			}
			headersheight -= _headerPadding;
			_headerContainer.y = headerPadding;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000,1);
			if(headersheight > height - headerPadding * 2)
			{
				_preBtn.move((_headerWidth - _preBtn.width) / 2,height - headerPadding - _nextBtn.height * 2 - 1);
				_nextBtn.move((_headerWidth - _nextBtn.width) / 2,height - headerPadding - _nextBtn.height);
				_mask.graphics.drawRect(_headerContainer.x,_headerContainer.y,_headerWidth,height - headerPadding * 2 - _nextBtn.height * 2 - 2);
			}
			else
			{
				_mask.graphics.drawRect(_headerContainer.x,0,_headerWidth,height);
			}
			_mask.graphics.endFill();
		}
		
		override protected function addMoveBtn():void
		{
			if(_mask.height != height)
			{
				this.addChild(_preBtn);
				this.addChild(_nextBtn);
			}
		}
	}
}