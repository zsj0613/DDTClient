package ddt.view.roulette
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import road.manager.SoundManager;
	
	import ddt.data.goods.ItemTemplateInfo;
	import tank.game.movement.RouletteGoodsAsset;
	import ddt.view.cells.BaseCell;
	
	public class RouletteGoodsCell extends BaseCell
	{
		private var _selected:Boolean;
		private var _boolCreep:Boolean = false;
		private var count_txt:TextField;
		private var _count:int;
		
		public function RouletteGoodsCell(bg:Sprite)
		{
			super(bg);
		}
		
		public function setSparkle():void
		{
			selected = true;
			_bg["_select"].gotoAndStop(1);
		}
		
		public function set count(n:int):void
		{
			_count = n;
			count_txt = _bg["count_txt"];
			count_txt.parent.removeChild(count_txt);
			addChild(count_txt);
			if(n<=1){
				count_txt.text = "";
				return;
			}
			count_txt.text = String(n);
			
		}
		
		public function get count():int
		{
			return _count;
		}
		
		public function setGreep():void
		{
			if(!_boolCreep && _selected)
			{
				_bg["_select"].gotoAndPlay(2);
				_boolCreep = true;
			}
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			_bg["_select"].visible = _selected;
			if(_selected == false)
			{
				_boolCreep = false;
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set cellBG(value:Boolean):void
		{
			_bg["_cellbg"].visible = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_bg = null;
		}
	}
}