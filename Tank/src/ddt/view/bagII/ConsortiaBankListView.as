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
	
	/**公会保管箱10*10格子列表
	 * 且带有背景
	 * 与背包7*7不同
	 * **/
	public class ConsortiaBankListView extends BagIIListView
	{
		private var timer:Timer = new Timer(BagIIEquipListView.DoubleClickSpeed,1);
		private var _bankLevel : int;
		
		private var currentTarget:BagCell;
		
		public function ConsortiaBankListView(bagType:int, controller:IBagIIController,level : int=0)
		{
			_bankLevel = level;
			super(bagType, controller,10);
		}
		public function upLevel(level : int) : void
		{
			if(level == _bankLevel)return;
			for(var i:int = _bankLevel; i < level; i++)
			{
				for(var j:int=0;j<10;j++)
				{
					var index : int = i*10 + j;
					var cell: BagCell = _cells[index] as BagCell;
					cell.grayFilters = false;
					cell.mouseEnabled = true;
				}
			}
			_bankLevel = level;
		}
		
		private function __downHandler(evt:MouseEvent):void
		{
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
				dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,currentTarget,false,false));
				currentTarget = null;
			}
		}		
		
		private function __resultHandler(evt : MouseEvent) : void
		{
			
		}
		override protected function createCells():void
		{
			_cells = new Dictionary();
			for(var i:int = 0; i < 10; i++)
			{
				for(var j:int=0;j<10;j++)
				{
					var index : int = i*10 + j;
					var cell: BagCell = CellFactory.instance.createBagCell(index) as BagCell;
					appendItem(cell);
					cell.bagType = _bagType;
					cell.bagLocked = true;
//					cell.addEventListener(MouseEvent.CLICK,__cellClick);
					cell.addEventListener(MouseEvent.MOUSE_DOWN,__downHandler);
					cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
					_cells[cell.place] = cell;
					if(_bankLevel <= i)
					{
						cell.grayFilters = true;
						cell.mouseEnabled = false;
					}
				}
			}
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timer);
		}
		
		/**检查是公会保管箱格子,等级
		 * 0有空余的格子
		 * 1等级为0
		 * 2没有空格子,且等级为10
		 * 3没有空格子,等级不到10
		 * **/
		public function checkConsortiaStoreCell() : int
		{
			if(_bankLevel == 0)return 1;
			for(var i:int = 0; i < _bankLevel; i++)
			{
				for(var j:int=0;j< 10;j++)
				{
					var index : int = i*10 + j;
					var cell : BagCell = _cells[index] as BagCell;
					if(!cell.info)return 0;
				}
			}
			if(_bankLevel == 10)return 2;
			return 3;
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