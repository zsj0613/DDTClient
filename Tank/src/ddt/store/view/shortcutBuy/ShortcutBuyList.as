package ddt.store.view.shortcutBuy
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ItemManager;

	public class ShortcutBuyList extends Sprite
	{
		private var _list:SimpleGrid;
		private var _cells:Array;
		private var _cow:int;
		
		public function ShortcutBuyList(itemIDs:Array)
		{
			_cow = Math.ceil(itemIDs.length / 4);
			init();
			createCells(itemIDs);
		}
		
		private function init():void
		{
			_cells = [];
			_list = new SimpleGrid(90,95,4);
			_list.marginHeight = 10;
			_list.marginWidth = 10;
			_list.setSize(360,95*_cow);
			_list.horizontalScrollPolicy = _list.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_list);
		}
		
		override public function get height():Number
		{
			return _list.height;
		}
		
		private function createCells(itemIDs:Array):void
		{
			for(var i:int=0; i<itemIDs.length; i++)
			{
				var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(itemIDs[i]);
				var cell:ShortcutBuyCell = new ShortcutBuyCell(info);
				cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				cell.buttonMode = true;
				cell.showBg();
				_list.appendItem(cell);
				_cells.push(cell);
			}
		}
		
		public function shine():void {
			for each(var cell:ShortcutBuyCell in _cells) {
				cell.hideBg();
				cell.startShine();
			}
		}
		
		public function noShine():void {
			for each(var cell:ShortcutBuyCell in _cells) {
				cell.stopShine();
				cell.showBg();
			}
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			for each(var cell:ShortcutBuyCell in _cells)
			{
				cell.selected = false;
				noShine();
			}
			ShortcutBuyCell(evt.currentTarget).selected = true;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get selectedItemID():int
		{
			for each(var cell:ShortcutBuyCell in _cells)
			{
				if(cell.selected)
				{
					return cell.info.TemplateID;
				}
			}
			return -1;
		}
		
		public function set selectedItemID(value:int):void
		{
			for each(var cell:ShortcutBuyCell in _cells)
			{
				if(cell.info.TemplateID == value)
				{
					cell.selected = true;
					return;
				}
			}
		}
		
		public function dispose():void
		{
			for each(var cell:ShortcutBuyCell in _cells)
			{
				cell.removeEventListener(MouseEvent.CLICK,cellClickHandler);
				cell.dispose();
			}
			_list.clearItems();
			removeChild(_list);
			_list = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
	}
}