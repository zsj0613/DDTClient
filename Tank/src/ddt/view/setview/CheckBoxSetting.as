package ddt.view.setview
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import game.crazyTank.view.setting.CheckUIAccect;
	
	import road.ui.controls.HButton.HCheckBox;
	
	public class CheckBoxSetting extends HCheckBox
	{
		public function CheckBoxSetting(label:String="checkBox", displayText:DisplayObject=null)
		{
			var asset:CheckUIAccect=new CheckUIAccect();
			super(label, displayText, asset);
		}
	}
}