package ddt.view.bagII
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.CellFactory;
	import ddt.view.infoandbag.CellEvent;
	
	public class BagIIEquipListView extends BagIIListView
	{
		public static const DoubleClickSpeed:uint = 350;
		private var timer:Timer = new Timer(DoubleClickSpeed,1);
		private var ctrlKey:Boolean=false;
		
		private var currentTarget:BagCell;
		public var _startIndex : int;
		public var _stopIndex : int;
		public function BagIIEquipListView(bagType:int, controller:IBagIIController,startIndex:int=31,stopIndex:int=80)
		{
			_startIndex = startIndex;
			_stopIndex  = stopIndex;
			super(bagType,controller);
		}
		
		override protected function createCells():void
		{
			_cells = new Dictionary();
			for(var i:int = _startIndex; i < _stopIndex; i++)
			{
				var cell:BagCell = CellFactory.instance.createBagCell(i) as BagCell;
				appendItem(cell);
				cell.bagLocked = true;
				cell.addEventListener(MouseEvent.MOUSE_DOWN,__downHandler);
				
				cell.bagType = _bagType;
				cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
				_cells[cell.place] = cell;
			}
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timer);
		}
		
		private function __downHandler(evt:MouseEvent):void
		{
			ctrlKey=evt.ctrlKey;
			if(timer.running)
			{
				if((evt.currentTarget as BagCell).info != null)
				{
					timer.stop();
					dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,evt.currentTarget));
					currentTarget = null;
				}
			}
			else
			{
				timer.reset();
				timer.start();
				if((evt.currentTarget as BagCell).info != null)
					currentTarget = evt.currentTarget as BagCell;
			}
		}
		
		private function __timer(e:TimerEvent):void
		{
			if(currentTarget)
			{
				dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,currentTarget,false,false,ctrlKey));
				currentTarget = null;
			}
		}
		
		override protected function __cellClick(evt:MouseEvent):void {}
		
		
		
		override public function setCellInfo(index:int,info:InventoryItemInfo):void
		{
			if(index >= _startIndex && index < _stopIndex)
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
		}
		
		override public function dispose():void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timer);
			timer = null;
			for each(var cell:BagCell in _cells)
			{
				cell.removeEventListener(MouseEvent.MOUSE_DOWN,__downHandler);
				cell.removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
			}
			super.dispose();
		}
		
	}
}