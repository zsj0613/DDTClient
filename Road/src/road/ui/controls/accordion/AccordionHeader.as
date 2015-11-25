package road.ui.controls.accordion
{
	import fl.controls.BaseButton;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class AccordionHeader extends BaseButton
	{
		private static const defaultStyle:Object = {
													upSkin:Accordion_HeaderButton_upSkin,
													downSkin:Accordion_HeaderButton_downSkin,
													overSkin:Accordion_HeaderButton_overSkin,
												  	disabledSkin:Accordion_HeaderButton_disabledSkin,
												  	selectedDisabledSkin:Accordion_HeaderButton_selectedDisabledSkin,
												  	selectedUpSkin:Accordion_HeaderButton_selectedUpSkin,
												  	selectedDownSkin:Accordion_HeaderButton_selectedDownSkin,
												  	selectedOverSkin:Accordion_HeaderButton_selectedOverSkin,
												  	textFormat:new TextFormat("_sans", 12, 0x003366, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
												 	focusRectSkin:null, focusRectPadding:null,
												 	repeatDelay:500,repeatInterval:35
													}
		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle, UIComponent.getStyleDefinition());
		}
		
		private var _label:TextField = new TextField();
		public function get label():String
		{
		   	return _label.text;
		}
		public function set label(value:String):void
		{
		   	if(_label.text == value) return;
		   	_label.text = value;
		   	invalidate(InvalidationType.SIZE);
		}
		
		override protected function configUI():void
		{
	   		super.configUI();
	   		_label = new TextField();
	   		_label.type = TextFieldType.DYNAMIC;
	   		_label.selectable = false;
	   		this.addChild(_label);
		}
		
		override protected function drawBackground():void
		{
	   		super.drawBackground();
	   		
			var tf:TextFormat = getStyleValue("textFormat") as TextFormat;
			if (tf != null) 
			{
				_label.setTextFormat(tf);
			} 
		}
		override protected function drawLayout():void
		{
	   		super.drawLayout();
			
			_label.width = _label.textWidth + 4 ;
			_label.height = _label.textHeight + 4 ;
			_label.x = Math.round((width - _label.textWidth) /2);
			_label.y = Math.round((height- _label.textHeight)/2);
		}
	}
}