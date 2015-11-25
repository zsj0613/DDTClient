package ddt.view.personalinfoII
{	
	import flash.text.TextFormat;
	
	import game.crazyTank.view.TextTipPanelAsset;
	/**
	 *	背包里人物属性的tip构造类
	 * @author dordy
	 * 
	 */	
	public class TextTipPanel extends TextTipPanelAsset
	{
		public function TextTipPanel()
		{
			super();
			detail_txt.selectable=false;
			property_txt.selectable=false;
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		/**
		 *	设置属性名称的颜色 
		 * @param color
		 * 
		 */		
		public function set propertyTextColor(color:uint):void
		{
			var format:TextFormat=property_txt.getTextFormat();
			format.color=color;
			property_txt.defaultTextFormat=format;
		}
		/**
		 *	 设置属性名称文本
		 * @param value
		 * 
		 */		
		public function set propertyText(value:String):void
		{
			property_txt.text=value||"";	
		}
		/**
		 *	设置属性详细描述 
		 * @param value
		 * 
		 */		
		public function set detailText(value:String):void
		{
			detail_txt.text=value||"";	
		}
	}
}