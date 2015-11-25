package road.ui.controls.tabPanelClasses
{
	import fl.controls.BaseButton;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TabPanelHeader extends BaseButton
	{
		private static var defaultStyle:Object = {
													upSkin:TabPanel_HeaderButton_upSkin,
													downSkin:TabPanel_HeaderButton_downSkin,
													overSkin:TabPanel_HeaderButton_overSkin,
												  	disabledSkin:TabPanel_HeaderButton_disabledSkin,
												  	textFormat:new TextFormat("_sans", 12, 0x003366, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
												 	selectedDisabledSkin:TabPanel_HeaderButton_selectedDisabledSkin,
												  	selectedUpSkin:TabPanel_HeaderButton_selectedUpSkin,
												  	selectedDownSkin:TabPanel_HeaderButton_selectedDownSkin,
												  	selectedOverSkin:TabPanel_HeaderButton_selectedOverSkin,
												 	selectedTextFormat:new TextFormat("_sans", 12, 0x003366, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
												 	focusRectSkin:null, focusRectPadding:null,
												 	repeatDelay:500,repeatInterval:35}
		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle, UIComponent.getStyleDefinition());
		}
	
	   protected var _lable:TextField;
	   protected var _icon:DisplayObject;
	   protected var _value:Object;
	   
	   public function get lable():String
	   {
	   		return _lable.text;
	   }
	   public function set lable(value:String):void
	   {
	   		if(_lable.text == value) return;
	   		_lable.text = value;
	   		this.width = _lable.textWidth + 16;
	   		invalidate(InvalidationType.SIZE);
	   }
	   
	   public function get icon():DisplayObject
	   {
	   		return _icon;
	   }
	   public function set icon(value:DisplayObject):void
	   {
	   		if(_icon != null)
	   		{
	   			if(_icon.parent != null)
	   			{
	   				_icon.parent.removeChild(_icon);
	   			}
	   			_icon = null;
	   		}
	   		_icon = value;
	   		this.width = _icon.width + 16;
	   }
	   
	   public function TabPanelHeader(value:Object)
	   {
	   		_value = value;
	   		init();
	   }
	   
	   protected function init():void
	   {
	   		if(_value is String)
	   		{
	   			addLabel();
	   		}
	   		else if(_value is DisplayObject)
	   		{
	   			addIcon();
	   		}
	   }
	   
	   protected function addLabel():void
	   {
	   		_lable = new TextField();
	   		_lable.type = TextFieldType.DYNAMIC;
	   		_lable.selectable = false;
	   		lable = _value as String;
	   		this.addChild(_lable);
	   }
	   
	   protected function addIcon():void
	   {
	   		icon = _value as DisplayObject;
	   		this.addChild(_icon);
	   }
	   
	   override protected function drawBackground():void
	   {
	   		super.drawBackground();
	   		if(_value is String)
	   		{
				updateLabelTxt();
	   		}
	   }
	   
	   protected function updateLabelTxt():void
	   {
	   		var tf:TextFormat = getStyleValue( selected ? "selectedTextFormat":"textFormat") as TextFormat;
			if (tf != null) 
			{
				_lable.setTextFormat(tf);
			} 
	   }
	   
	   override protected function drawLayout():void
	   {
	   		super.drawLayout();
			if(_value is String)
			{
				updateLabelPos();
			}
			else
			{
				updateIconPos();
			}
	   }
	   
	   protected function updateLabelPos():void
	   {
			_lable.width = _lable.textWidth;
			_lable.height = _lable.textHeight;
			_lable.x = Math.round((width - _lable.textWidth) /2);
			_lable.y = Math.round((height- _lable.textHeight)/2);
	   }
	   
	   protected function updateIconPos():void
	   {
	   		_icon.x = Math.round((width - _icon.width) / 2);
	   		_icon.y = Math.round((height - _icon.height) / 2);
	   }
		
	}
}