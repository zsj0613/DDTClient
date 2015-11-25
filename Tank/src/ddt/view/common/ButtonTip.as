package ddt.view.common
{
	import fl.core.UIComponent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.common.ButtonTipAsset;

	public class ButtonTip extends UIComponent
	{
		private var _bg:ButtonTipAsset;
		private var _text:TextField;
		private var _title:String;
		
		private static const t:TextFormat = new TextFormat("Arial",14,0xffffff,true);
		
		public function ButtonTip(title:String)
		{
			_title = title;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			
			_text = new TextField();
			_text.height = 20;
			_text.selectable = false;
			
			_text.x = 14;
			_text.y = 5;
			addChild(_text);
			
			_bg = new ButtonTipAsset();
			addChildAt(_bg,0);
			
			setTitle(_title);
		}
		
		public function setTitle(value:String):void
		{
			_text.text = value;
			_text.setTextFormat(t);
			
			_bg.width = _text.textWidth + 28;
			_bg.height = _text.textHeight + 12;
		}
	}
}