package road.ui.controls
{
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	
	/**
	 * 
	 * @author ROAD-S
	 * 
	 * Frame contains Title,content,buttom panels
	 */	
	public class Frame2 extends Frame
	{
		protected var _buttomPanel:UIComponent;
		protected var buttomBG:DisplayObject;
		protected var _buttomPadding:Number;
		
		private static const defaultStyle:Object = {	activeSkin:Frame2_activeBG,
														buttomSkin:Frame2_buttomBG
														};
														
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
		
		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle,Frame.getStyleDefinition());
		}
		
		public function get buttomHeight():Number
		{
			return _buttomPanel.height;
		}
		
		public function Frame2(modal:Boolean = false)
		{
			super(modal);
		}
		
		override protected function init():void
		{
			super.init();
			_minHeigth = 120;
			_buttomPadding = 6;
			_buttomPanel = new UIComponent();
			_buttomPanel.move(_marginWidth,_marginHeight + _titlePanel.height + _paddingHeight * 2 + _contentPanel.height);
			_buttomPanel.setSize(this.width - marginWidth * 2,30);
			_contentPanel.setSize(_minWidth - marginWidth * 2,_minHeigth - marginHeight * 2 - paddingHeight * 2 - _titleHeight - _buttomPanel.height);
			this.addChild(_buttomPanel);
			setSize(this.width,this.height);
		}
		
		public function get ButtomPanel():UIComponent
		{
			return _buttomPanel;
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			w = w < _minWidth ? _minWidth : w;
			h = h < _minHeigth ? _minHeigth : h;
			if(_buttomPanel != null)
			{
				this._contentPanel.setSize(w - marginWidth * 2,h - marginHeight * 2 - paddingHeight * 2 - _titleHeight - _buttomPanel.height);
			}
			super.setSize(w,h);
		}
		
		override public function setContentSize(w:Number, h:Number):void
		{
			this._contentPanel.setSize(w,h);
			this.setSize(w + marginWidth * 2,h + marginHeight * 2 + _titleHeight + _paddingHeight * 2 + _buttomPanel.height);
		}
		
		public function setButtomSize(w:Number,h:Number):void
		{
			this._buttomPanel.setSize(w,h - _buttomPadding);
			this.setSize(w + marginWidth * 2,h + marginHeight * 2 + _titleHeight + _paddingHeight * 2 + _buttomPanel.height);
		}
		
		override protected function drawBackground():void
		{
			if(background == null)
			{
				background = getDisplayObjectInstance(getStyleValue("activeSkin"));
				this.addChildAt(background,0);
			}
			if(buttomBG == null)
			{
				buttomBG = getDisplayObjectInstance(getStyleValue("buttomSkin"));
				this.addChildAt(buttomBG,1);
			}
		}
		
		override protected function drawPanels():void
		{
			this.background.width = this.width;
			this.background.height = marginHeight + _titleHeight + paddingHeight * 2 + _contentPanel.height;
			this.buttomBG.width = this.width;
			this.buttomBG.height = _buttomPanel.height + marginHeight;
			this.buttomBG.y = this.background.height;
			this._contentPanel.move(marginWidth,marginHeight + _titleHeight + paddingHeight);
			this._buttomPanel.move(marginWidth,marginHeight + _titleHeight + paddingHeight * 2 + _contentPanel.height + _buttomPadding);
		}
	}
}