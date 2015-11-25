package ddt.view.bagII
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.SocketManager;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.CellFactory;
	import ddt.view.infoandbag.CellEvent;

	public class BagIIListView extends SimpleGrid
	{
		public var _cells:Dictionary;
		protected var _bagdata:BagInfo;
		protected var _controller:IBagIIController;
		protected var _bagType:int;
		
		public function BagIIListView(bagType:int,controller:IBagIIController,towNum:int=7)
		{
			_controller = controller;
			_bagType = bagType;
			super(46, 46, towNum);
			cellPaddingHeight = cellPaddingWidth = 0;
			verticalScrollPolicy = horizontalScrollPolicy = ScrollPolicy.OFF;
			marginHeight = marginWidth = 0;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			createCells();
		}
		
		protected function createCells():void
		{
			_cells = new Dictionary();
			for(var i:int = 0; i < 49; i++)
			{
				var cell:BagCell = CellFactory.instance.createBagCell(i) as BagCell;
				appendItem(cell);
				cell.bagType = _bagType;
				cell.bagLocked = true;
				cell.addEventListener(MouseEvent.MOUSE_DOWN,__cellClick);
				cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
				_cells[cell.place] = cell;
			}
		}
		
		protected function __cellChanged(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function __cellClick(evt:MouseEvent):void
		{
			if((evt.currentTarget as BagCell).info != null)
				dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,evt.currentTarget,false,false,evt.ctrlKey));
		}
		
		public function setCellInfo(index:int,info:InventoryItemInfo):void
		{
			if(info == null)
			{
				_cells[String(index)].info = null;
				return;
			}
			if(info.Count == 0)
			{
				_cells[String(index)].info = null;
			}
			else
			{
				_cells[String(index)].info = info;
			}
		}
		
		public function setData(bag:BagInfo):void
		{
			if(_bagdata != null)
			{
				_bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
			}
			_bagdata = bag;
			for(var i:String in _bagdata.items)
			{
				if(_cells[i] != null)
					_cells[i].info = _bagdata.items[i];
			}
			_bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
		}
		
		private function __updateGoods(evt:BagEvent):void
		{
			var changes:Dictionary = evt.changedSlots;
			for each(var i:InventoryItemInfo in changes)
			{
				var c:InventoryItemInfo = _bagdata.getItemAt(i.Place);
				if(c)
				{
					setCellInfo(c.Place,c);
				}else
				{
					setCellInfo(i.Place,null);
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function dispose():void
		{
			_controller = null;
			if(_bagdata != null)
			{
				_bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
				_bagdata = null;
			}
			
			for each(var i:BagCell in _cells)
			{
				i.addEventListener(MouseEvent.CLICK,__cellClick);
				i.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
				i.dispose();
				i = null;
			}
			_cells = null;
			if(parent)parent.removeChild(this);
		}
	}
}