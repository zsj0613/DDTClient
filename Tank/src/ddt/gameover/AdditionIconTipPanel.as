package ddt.gameover
{
	import fl.core.UIComponent;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	
	import ddt.view.bagII.GoodsTipItem;

	public class AdditionIconTipPanel extends UIComponent
	{
		private var _bg:GoodsTipBgAsset = new GoodsTipBgAsset();
		private var _tipText:String;
		private var _item:GoodsTipItem;
		public function AdditionIconTipPanel(tipText:String)
		{
			super();
			_tipText = tipText;
			
			init();
		}
		
		override protected function configUI():void
		{
			_bg = new GoodsTipBgAsset();
			
			addChild(_bg);
		}
		
		private function init():void
		{
			_item = new GoodsTipItem("",_tipText);
			
			_item.x = 4;
			_item.y = 5;
			
			addChild(_item);
			
			_bg.width = _tipText.length * 14.5;
			_bg.height = _item.height + 10;
		}
	}
}