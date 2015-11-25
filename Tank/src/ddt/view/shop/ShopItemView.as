package ddt.view.shop
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import game.crazyTank.view.bagII.PropGlowBgAccect;
	
	import webGame.crazyTank.view.shopII.CellTipAsset;

	public class ShopItemView extends Sprite
	{
		private var _isGlow    : Boolean = false;
		private var glow_mc    : PropGlowBgAccect;
		private var lightingFilter:ColorMatrixFilter;
		private var tip        : CellTipAsset;
		private var _count     : String;
		private var _money     : int;
		private var item       : ShopCell;
		private var _types     : int;
		public function ShopItemView($types:int=0,$count : String = "",$money:int=0, $item:ShopCell=null, isCount:Boolean=false)
		{
			_types = $types;
			_count = $count;
			_money = $money;
			item = $item;
			tip = new CellTipAsset();
			addChild(tip);
			tip.addChild(item);
			item.x = 14 ;
			item.y = 14 ;
			tip.addChild(tip.countTxt);
			glow_mc = new PropGlowBgAccect();
			addChild(glow_mc);
			this.glow_mc.visible = false;
			this.buttonMode = true;
//			addEventListener(MouseEvent.ROLL_OVER,__over);
//			addEventListener(MouseEvent.ROLL_OUT,__out);
			setUpLintingFilter();
			initText();
		}
		public function gotoAndStopHandler(frame : int) : void
		{
			tip.CellStateAsset.gotoAndStop(frame);
		}
		public function get types() : int
		{
			return _types;
		}
		
		private function initText() : void
		{
			tip.CellStateAsset.gotoAndStop(1);
			tip.countTxt.mouseEnabled = tip.moneyTxt.mouseEnabled = false;
			tip.countTxt.selectable   = tip.moneyTxt.selectable   = false;
			tip.countTxt.text = _count;
			tip.moneyTxt.text = String(_money) + "点券";
		}
		
//		private function __over(e:MouseEvent):void
//		{
//			this.filters = [lightingFilter];
//			e.stopImmediatePropagation();
//			e.stopPropagation();
//		}
//	
//		private function __out(e:MouseEvent):void
//		{
//			this.filters = null;
//			e.stopImmediatePropagation();
//			e.stopPropagation();
//		}
		
		public function get count() : String
		{
			return _count;
		}
		public function get money() : int
		{
			return this._money;
		}
		public function dispose() : void
		{
//			this.removeEventListener(MouseEvent.ROLL_OVER,__over);
//			removeEventListener(MouseEvent.ROLL_OUT,__out);
			if(item)
			{
				item.dispose();
				if(item.parent)item.parent.removeChild(item);
			}
			item = null;
			this.filters = null;
			lightingFilter = null;
			if(tip && tip.parent)tip.parent.removeChild(tip);
			tip = null;
			if(glow_mc && glow_mc.parent)glow_mc.parent.removeChild(glow_mc);
			glow_mc = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
		
		private function setUpLintingFilter():void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			lightingFilter = new ColorMatrixFilter(matrix);   //这里好像是 new BitmapFilter(matrix);
		}
		
	
		public function set glow (b:Boolean):void
		{
			_isGlow = b;
			this.glow_mc.visible = _isGlow;
		}
		
		public function get glow():Boolean
		{
			return _isGlow;
		}
		
	}
}