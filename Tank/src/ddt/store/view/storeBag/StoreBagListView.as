package ddt.store.view.storeBag
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.store.events.StoreBagEvent;
	import ddt.store.events.UpdateItemEvent;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.view.bagII.BagIIEquipListView;
	import ddt.view.cells.BagCell;
	import ddt.view.infoandbag.CellEvent;

	public class StoreBagListView extends SimpleGrid
	{
		protected var _cells:Dictionary;
		protected var _bagdata:DictionaryData;
		protected var _controller:StoreBagController;
		protected var _bagType:int;
		private static var cellNum:int = 70;
		private var timer:Timer = new Timer(BagIIEquipListView.DoubleClickSpeed,1);
		private var currentTarget:StoreBagCell;
		
		public function StoreBagListView(bagType:int,controller:StoreBagController)
		{
			_controller = controller;
			_bagType = bagType;
			super(45, 45, 7);
			cellPaddingHeight = cellPaddingWidth = 1;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.ON;
			marginHeight = marginWidth = 0;
			setSize(345,138);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			createCells();
		}
		
		protected function createCells():void
		{
			_cells = new Dictionary();
			for(var i:int = 0; i < 70; i++)
			{
				var cell:StoreBagCell = new StoreBagCell(i);
				appendItem(cell);
				cell.bagType = _bagType;
				
				cell.addEventListener(MouseEvent.MOUSE_DOWN,__downHandler);
				cell.addEventListener(MouseEvent.CLICK,__cellClick);
				cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timer);
				_cells[cell.place] = cell;
			}
		}
		
		private function __downHandler(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			if((evt.currentTarget as BagCell).info!=null){
			    if(timer.running)
		    	{
			    	if((evt.currentTarget as BagCell).info != null)
				    {
				    	timer.stop();
				    	dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,evt.currentTarget,true));
				    	SoundManager.Instance.play("008");
				    	currentTarget = null;
				    }
			    }
		    	else
		    	{
			    	timer.reset();
				    timer.start();
			    	if((evt.currentTarget as BagCell).info != null)
				    	currentTarget = evt.currentTarget as StoreBagCell;
			    }
			}
		}
		
		private function __timer(e:TimerEvent):void
		{
			if(currentTarget)
			{
				dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,currentTarget));
				currentTarget = null;
			}
		}
		
		protected function __cellChanged(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function __cellClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
//			if((evt.currentTarget as BagCell).info != null)
//				dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,evt.currentTarget));
		}
		
		public function getCellByPlace(place:int):BagCell{
			return _cells[place];
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
		
		public function setData(list:DictionaryData):void
		{
			if(_bagdata != null)
			{
				for(var j:String in _bagdata)
			    {
			    	_cells[j].info = null;
		    	}
				_bagdata.removeEventListener(DictionaryEvent.ADD,__addGoods);
//				_bagdata.removeEventListener(DictionaryEvent.UPDATE,__addGoods);
				_bagdata.removeEventListener(StoreBagEvent.REMOVE,__removeGoods);
				_bagdata.removeEventListener(UpdateItemEvent.UPDATEITEMEVENT,__updateGoods);
			}
			_bagdata = list;
			if(list)
			{				
			    for(var i:String in list)
		    	{
			    	if(_cells[i] != null)
				    	_cells[i].info = list[i];
		    	}
			}
			
			_bagdata.addEventListener(DictionaryEvent.ADD,__addGoods);
//			_bagdata.addEventListener(DictionaryEvent.UPDATE,__addGoods);
			_bagdata.addEventListener(StoreBagEvent.REMOVE,__removeGoods);
			_bagdata.addEventListener(UpdateItemEvent.UPDATEITEMEVENT,__updateGoods);
			updateScrollBar();
		}
		
		private function updateScrollBar(updatePosition:Boolean = true):void
		{
			if(_controller.currentPanel != 5)
			{
				this.enabled = _bagdata.length>7*3?true:false;
			}else
			{
				this.enabled = _bagdata.length>7*7?true:false;
			}
			if(updatePosition) this.verticalScrollPosition = 0;
		}
		
		private function __addGoods(evt:DictionaryEvent):void
		{
			var t:InventoryItemInfo = evt.data as InventoryItemInfo;
			for(var i:int=0;i<70;i++)
			{
				if(_bagdata[i] == t)
				{
					setCellInfo(i,t);
					break;
				}
			}
			updateScrollBar();
		}
		
		private function checkShouldAutoLink(item:InventoryItemInfo):Boolean
		{
			if(_controller.model.NeedAutoLink <= 0) return false;
			if(item.TemplateID ==  EquipType.LUCKY
			|| item.TemplateID == EquipType.SYMBLE
			|| item.TemplateID == EquipType.STRENGTH_STONE4
			|| item.StrengthenLevel >= 10) return true;
			return false;
		}
		
		private function __removeGoods(evt:StoreBagEvent):void
		{
			_cells[evt.pos].info = null;
			updateScrollBar(false);
		}
		
		private function __updateGoods(evt:UpdateItemEvent):void
		{
//			_cells[evt.pos].info = null;
			_cells[evt.pos].info = evt.item as InventoryItemInfo;
			updateScrollBar(false);
		}
		
		public function getCellByPos(pos:int):BagCell
		{
			return _cells[pos];
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
			_controller = null;
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timer);
			if(_bagdata != null)
			{
				_bagdata.removeEventListener(DictionaryEvent.ADD,__addGoods);
//				_bagdata.removeEventListener(DictionaryEvent.UPDATE,__addGoods);
				_bagdata.removeEventListener(StoreBagEvent.REMOVE,__removeGoods);
				_bagdata.removeEventListener(UpdateItemEvent.UPDATEITEMEVENT,__updateGoods);
				_bagdata = null;
			}
			for each(var i:BagCell in _cells)
			{
				i.removeEventListener(MouseEvent.MOUSE_DOWN,__downHandler);
				i.addEventListener(MouseEvent.CLICK,__cellClick);
				i.removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
				i.dispose();
			}
		}
	}
}