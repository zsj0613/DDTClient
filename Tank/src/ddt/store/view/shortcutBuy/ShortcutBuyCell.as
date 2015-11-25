package ddt.store.view.shortcutBuy
{
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.bagII.StoreCellAsset;
	import game.crazyTank.view.storeII.smallCellShine;
	
	import road.ui.controls.ISelectable;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.LanguageMgr;
	import ddt.view.cells.BaseCell;
	import ddt.view.common.ShineObject;
	import store.view.shortcutBuy.StoreShortcutCellBgAsset;
	
	/**
	 * @author wickila
	 * @time 0401/2010
	 * @description 铁匠铺快捷购买的格子，次格子为可选的
	 * */

	public class ShortcutBuyCell extends BaseCell
	{
		private var _selected:Boolean = false;
		private var _mcBg:MovieClip;
		private var _nameArr:Array = [LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.lingju"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.jiezi"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.shouzhuo"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.baozhu"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.zhuque"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.xuanwu"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.qinglong"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.baihu")];
		private var _shiner:ShineObject;
		public function ShortcutBuyCell(info:ItemTemplateInfo)
		{
			super(new StoreCellAsset(),info);
			init();
		}
		
		private function init():void
		{
			_mcBg = new StoreShortcutCellBgAsset();
			_mcBg.stop();
			_mcBg.x = -6;
			_mcBg.y = -6;
			_mcBg.visible = false;
			addChildAt(_mcBg,0);
			
			_shiner = new ShineObject(new smallCellShine());
			_shiner.mouseChildren=_shiner.mouseEnabled = _shiner.visible = false;
			addChildAt(_shiner,1);
			
			var name:String = "";
			for(var i:int = 0; i < _nameArr.length; i++) {
				if(info.Name.indexOf(_nameArr[i]) > 0) {
					name = _nameArr[i];
					break;
				}
			}
			var t:TextField = getNameLabel(name);
			t.x = _mcBg.x + 16;
			t.y = _mcBg.y + _mcBg.height - 3;
			t.mouseEnabled = false;
			addChild(t);
			
			if(t.text == "") {
				_mcBg.x = -3;
				_mcBg.y = -3;
			}
		}
		
		private function getNameLabel(name:String):TextField {
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			var tf:TextFormat = new TextFormat();
			tf.color = 0x663300;
			tf.font = "微软雅黑";
			tf.size = 16;
			tf.bold = true;
			t.defaultTextFormat = tf;
			t.text = name;
			return t;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected)
			{
				_mcBg.gotoAndStop(2);
			}else
			{
				_mcBg.gotoAndStop(1);
			}
		}
		
		public function startShine():void
		{
			_shiner.visible=true;
			_shiner.shine();
		}
		
		public function stopShine():void
		{
			_shiner.stopShine();
			_shiner.visible=false;
		}
		
		public function showBg():void {
			_mcBg.visible = true;
		}
		
		public function hideBg():void {
			_mcBg.visible = false;
		}
		
		override public function dispose():void
		{
			_shiner.dispose();
			removeChild(_mcBg);
			_mcBg = null;
			super.dispose();
		}
		
	}
}