package ddt.auctionHouse.view
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.noBuffTipAsset;
	
	import road.utils.ComponentHelper;
	
	public class StripTip extends noBuffTipAsset
	{
		private var _description:String;
		private var _descriptionTxt:TextField;
		private var _gapeOffSet:int = 10;
		private var _oneLineHeight:int = 28;
		public function StripTip(_txt:String)
		{
			super();
			descriptionTxt.visible = false;
			_descriptionTxt = new TextField();
			_descriptionTxt.wordWrap = true;
			_descriptionTxt.autoSize = TextFieldAutoSize.LEFT;
			_descriptionTxt.text = _txt;
			var textformat:TextFormat = descriptionTxt.getTextFormat();
			textformat.size = 12;
			_descriptionTxt.setTextFormat(textformat);
			_descriptionTxt.filters = descriptionTxt.filters;
			tipBg.width  = _descriptionTxt.textWidth+(2*_gapeOffSet);
			tipBg.height = _oneLineHeight;
			addChild(_descriptionTxt);
			_descriptionTxt.x = _gapeOffSet;
			_descriptionTxt.y = (tipBg.height - _descriptionTxt.height)*.5;
			ComponentHelper.replaceChild(this,tipBg,new GoodsTipBgAsset());
		}
	}
}