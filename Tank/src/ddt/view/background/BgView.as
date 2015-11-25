package ddt.view.background
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.BackGround1Asset;

	public class BgView extends BackGround1Asset
	{
		private static var instance:BgView = new BgView();
		
		private  var _bgBtn:BgBtnAsset;
		
		private var _black:Sprite;
		
		public static function get Instance():BgView
		{
			return instance;
		}
		public function BgView()
		{
			_bgBtn = new BgBtnAsset();
			addChild(_bgBtn);
			_black = new Sprite();
			_black.visible = false;
			_black.graphics.beginFill(0x00000,1);
			_black.graphics.drawRect(0,0,width,height);
			_black.graphics.endFill();
			addChild(_black);
		}
		
		public function showGameBack(isGame:Boolean):void
		{
			_black.visible = isGame;
		}
		
		public function showBtnBg(isBtn:Boolean = true):void
		{
			_bgBtn.visible = false; //isBtn;
		}
		
		public function hideBg():void{
			visible = false;
		}
		
		public function showBg():void{
			visible = true;
		}	
	}
}