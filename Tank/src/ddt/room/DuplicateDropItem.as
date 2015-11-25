package ddt.room
{
	import game.crazyTank.view.roomII.DuplicateDropItemAsset;
	
	import road.utils.ComponentHelper;
	
	import ddt.data.goods.InventoryItemInfo;

	public class DuplicateDropItem extends DuplicateDropItemAsset
	{
		private var _cell : DuplicateDropCell;
		private var _info : InventoryItemInfo;
		public function DuplicateDropItem($info : InventoryItemInfo)
		{
			_info = $info;
			init();
		}
		private function init() : void
		{
			_cell = new DuplicateDropCell();
			_cell.info = _info;
			ComponentHelper.replaceChild(this,this.cellMc,_cell);
			this.titleTxt.text = _info.Name;
			titleTxt.mouseEnabled = false;
			titleTxt.selectable   = false;
		}
		
		public function dispose() : void
		{
			if(_cell)_cell.dispose();
			_cell = null;
			_info = null;
		}
		
	}
}