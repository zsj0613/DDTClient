package road.ui.controls.tabPanelClasses
{
	import fl.core.UIComponent;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TabPanelHeader2 extends TabPanelHeader
	{
		private static const defaultStyle:Object = {
													upSkin:TabPanel2_headerButton_upSkin,
													downSkin:TabPanel2_headerButton_downSkin,
													overSkin:TabPanel2_headerButton_overSkin,
												  	disabledSkin:TabPanel2_headerButton_disabledSkin,
												  	textFormat:new TextFormat("_sans", 12, 0x003366, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
												 	selectedDisabledSkin:TabPanel2_headerButton_selectedDisabledSkin,
												  	selectedUpSkin:TabPanel2_headerButton_selectedUpSkin,
												  	selectedDownSkin:TabPanel2_headerButton_selectedDownSkin,
												  	selectedOverSkin:TabPanel2_headerButton_selectedOverSkin,
												 	selectedTextFormat:new TextFormat("_sans", 12, 0x003366, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
												 	focusRectSkin:null, focusRectPadding:null,
												 	repeatDelay:500,repeatInterval:35}
		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle, UIComponent.getStyleDefinition());
		}
		
		public function TabPanelHeader2(value:Object)
		{
			super(value);
		}
	}
}