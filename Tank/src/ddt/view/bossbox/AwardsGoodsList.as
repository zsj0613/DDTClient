package ddt.view.bossbox
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.bossBoxInfo.BoxGoodsTempInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ItemManager;
	import ddt.view.taskII.TaskAwardCell;
	
	public class AwardsGoodsList extends Sprite
	{
		private var _list:SimpleGrid;
		private var _cells:Array;
		private var _cow:int;
		
		public function AwardsGoodsList(itemIDs:Array)
		{
			super();
			_cow = Math.ceil(itemIDs.length / 2);
			init();
			createCells(itemIDs);
		}
		
		private function init():void
		{
			_cells = [];
			var _width:int = (_cow > 3)?160:166;

			_list = new SimpleGrid(_width,64,2);
			_list.setSize(335,192);
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.verticalScrollPolicy = (_cow > 3)?ScrollPolicy.ON:ScrollPolicy.OFF;
			_list.cellPaddingWidth = 0;
			_list.cellPaddingHeight = 0;
			addChild(_list);
		}
		
		private function createCells(itemIDs:Array):void
		{
			for(var i:int = 0 ; i < itemIDs.length ; i++)
			{
				var boxGoodsInfo:BoxGoodsTempInfo = itemIDs[i] as BoxGoodsTempInfo;
				var info:InventoryItemInfo =  getTemplateInfo(boxGoodsInfo.TemplateId) as InventoryItemInfo;
				info.IsBinds = boxGoodsInfo.IsBind;
				info.LuckCompose = boxGoodsInfo.LuckCompose;
				info.DefendCompose = boxGoodsInfo.DefendCompose;
				info.AttackCompose = boxGoodsInfo.AttackCompose;
				info.AgilityCompose = boxGoodsInfo.AgilityCompose;
				info.StrengthenLevel = boxGoodsInfo.StrengthenLevel;
				info.ValidDate = boxGoodsInfo.ItemValid;
				info.IsJudge = true;
				
				var cell:BoxAwardsCell = new BoxAwardsCell();
				cell.info = info;
				cell.count = boxGoodsInfo.ItemCount;
				_list.appendItem(cell);
				_cells.push(cell);
			}
		}
		
		private function getTemplateInfo(id : int) : InventoryItemInfo
		{
			var itemInfo : InventoryItemInfo = new InventoryItemInfo();
			itemInfo.TemplateID = id;
			ItemManager.fill(itemInfo);
			return itemInfo;
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			for each(var cell:BoxAwardsCell in _cells)
			{
				cell.selected = false;
			}
			BoxAwardsCell(evt.currentTarget).selected = true;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function dispose():void
		{
			for each(var cell:BoxAwardsCell in _cells)
			{
				//cell.removeEventListener(MouseEvent.CLICK,cellClickHandler);
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












