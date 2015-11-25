package ddt.game
{
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.toolStripTipAsset;
	
	import road.utils.ComponentHelper;
	
	import ddt.utils.ComponentHelperII;
	import ddt.utils.Helpers;

	public class ToolStripTip extends toolStripTipAsset
	{
		public var bg:GoodsTipBgAsset=new GoodsTipBgAsset();
		public function ToolStripTip()
		{
			super();
			content_txt.wordWrap = true;
			tipBg.visible=false;
			ComponentHelper.replaceChild(this,tipBg,bg);
		}
		
		public function set title(value:String):void
		{
			titleTxt.text = value;
		}
		
		public function set content(value:String):void
		{
			content_txt.text = value;
			updateView();
		}
		
		private function updateView():void
		{
			bg.height = content_txt.height + 30;
		}
		
	}
}