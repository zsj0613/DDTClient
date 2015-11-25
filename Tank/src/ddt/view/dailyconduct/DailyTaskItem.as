package ddt.view.dailyconduct
{
	import com.dailyconduct.view.DailyTaskItemAsset;

	public class DailyTaskItem extends DailyTaskItemAsset
	{
		public function DailyTaskItem()
		{
			super();
			init();
		}
		private function init() : void
		{
			titleTxt.mouseEnabled = titleTxt.selectable = false;
		}
		public function text(title : String,state : Boolean) : void
		{
			
			this.titleTxt.text = title;
			if(state)
			{
				this.stateTxt.htmlText = "<b><FONT SIZE='13' FACE='Arial'  KERNING='2' COLOR='#00FF00' >[完成]</FONT></b>";
			}
			else
			{
				this.stateTxt.htmlText = "<b><FONT SIZE='13' FACE='Arial'  KERNING='2' COLOR='#FF0000' >[未完成]</FONT></b>";
			} 
		}
	}
}