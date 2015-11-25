package ddt.view.buffControl.buffButton
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.noBuffTipAsset;
	
	import road.utils.ComponentHelper;

	public class NoBuffTip extends noBuffTipAsset
	{
		private var _description:String;
		private var _descriptionTxt:TextField;
		private var bg:DisplayObject
		public function NoBuffTip()
		{
			super();
			descriptionTxt.visible = false;
			_descriptionTxt = new TextField();
			_descriptionTxt.wordWrap = true;
			_descriptionTxt.autoSize = TextFieldAutoSize.LEFT;
			_descriptionTxt.width = tipBg.width - 20;
			bg=new GoodsTipBgAsset()
			ComponentHelper.replaceChild(this,tipBg,bg);
		}
		
		public function set description(value:String):void
		{
			_descriptionTxt.text = value;
			_descriptionTxt.setTextFormat(descriptionTxt.getTextFormat());
			_descriptionTxt.filters = descriptionTxt.filters;
			adaptTxt();
		}
		
		private function adaptTxt():void
		{
			bg.height = _descriptionTxt.textHeight + 20;
			_descriptionTxt.x = 10;
			_descriptionTxt.y = 10;
			addChild(_descriptionTxt);
		}
		
	}
}