package road.ui.tooltip
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class SimpleTipRender extends Sprite
	{
		private var tbxTip:TextField;
		public function SimpleTipRender(tip:String)
		{
			tbxTip = new TextField();
			tbxTip.selectable = false;
			tbxTip.text = tip;
			tbxTip.width = tbxTip.textWidth+4;
			tbxTip.height = tbxTip.textHeight + 4;
			
			this.graphics.beginFill(0xFFFFFF,1);
			this.graphics.drawRect(0,0,tbxTip.width,tbxTip.height);
			this.graphics.endFill();
			
			this.addChild(tbxTip);
		}
		
	}
}