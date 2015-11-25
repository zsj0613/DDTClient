package ddt.view.changeColor
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.events.ChangeColorCellEvent;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.BagEvent;
	import ddt.view.bagII.BagIIListView;
	import ddt.view.cells.BagCell;
	import ddt.view.infoandbag.CellEvent;

	public class ColorChangeBagListView extends BagIIListView
	{
		public function ColorChangeBagListView()
		{
			super(0, null);
			setSize(330,330);
		}
		
		override protected function createCells():void
		{
			_cells = new Dictionary();
			for(var i:int = 0; i < 49; i++)
			{
				var cell:ChangeColorBagCell = new ChangeColorBagCell(i);
				appendItem(cell);
				cell.bagType = _bagType;
				
				cell.addEventListener(MouseEvent.CLICK,__cellClick);
				cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
				_cells[cell.place] = cell;
			}
		}
		
		override public function setData(bag:BagInfo):void
		{
			if(_bagdata != null)
			{
				_bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
			}
			_bagdata = bag;
			var j:int=0;
			for(var i:String in _bagdata.items)
			{
				_cells[j++].info = _bagdata.items[i];
			}
			_bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
		}
		
		private function __updateGoods(evt:BagEvent):void
		{
			var changes:Dictionary = evt.changedSlots;
			for each(var i:InventoryItemInfo in changes)
			{
				var c:InventoryItemInfo = PlayerManager.Instance.Self.Bag.getItemAt(i.Place);
				if(c)
				{
					updateItem(c);
				}else
				{
					removeBagItem(i);
				}
			}
		}
		
		public function updateItem(item:InventoryItemInfo):void
		{
			for(var i:int=0; i<49; i++)
			{
				if(_cells[i].itemInfo && _cells[i].itemInfo.Place == item.Place)
				{
					_cells[i].info = item;
					return;
				}
			}
			for(var j:int=0; j<49; j++)
			{
				if(_cells[j].itemInfo == null)
				{
					_cells[j].info = item;
					return;
				}
			}
		}
		
		public function removeBagItem(item:InventoryItemInfo):void
		{
			for(var i:int=0; i<49; i++)
			{
				if(_cells[i].itemInfo && _cells[i].itemInfo.Place == item.Place)
				{
					_cells[i].info = null;
					return;
				}
			}
		}
		
//		private function __removeGoods(evt:BagEvent):void
//		{
//			var t:InventoryItemInfo = evt.data as InventoryItemInfo;
//			for(var i:int = 0;i<_bagdata.items.length;i++)
//			{
//				if(_bagdata.items[i]==null)
//				{
//					setCellInfo(i,null);
//					break;
//				} 
//			}
//		}
//		
		override protected function __cellClick(evt:MouseEvent):void
		{
			if((evt.currentTarget as BagCell).locked == false && (evt.currentTarget as BagCell).info!=null)
			{
				dispatchEvent(new ChangeColorCellEvent(ChangeColorCellEvent.CLICK,(evt.currentTarget as BagCell),true));
			}
		}
		
		override public function dispose():void
		{
			_controller = null;
			if(_bagdata != null)
			{
				_bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
				_bagdata = null;
			}
			for(var i:String in _cells)
			{
				_cells[i].removeEventListener(MouseEvent.CLICK,__cellClick);
				_cells[i].removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
				_cells[i].dispose();
				_cells[i]=null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}