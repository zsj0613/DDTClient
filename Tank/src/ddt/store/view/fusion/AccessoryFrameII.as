package ddt.store.view.fusion
{
	import flash.display.Shape;
	import flash.events.Event;
	
	import game.crazyTank.view.storeII.AccessoryItemAsset;
	
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import ddt.store.events.StoreIIEvent;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.LanguageMgr;

	public class AccessoryFrameII extends HConfirmFrame
	{
		private var _list      : SimpleGrid;
		private var _bg        : Shape;
		private var _items     : Array;
		private var _area      : AccessoryDragInArea;
		public function AccessoryFrameII()
		{
			super();
			init();
		}
		
		private function init() : void
		{
			blackGound = false;
			alphaGound = false;
			stopKeyEvent = true;
			showCancel = false;
			titleText = LanguageMgr.GetTranslation("store.view.fusion.AccessoryFrame.add");
			setContentSize(224,202);
			_bg  = new Shape();
			_bg.graphics.lineStyle(1,0xffffff);
			_bg.graphics.beginFill(0x766963,1);
			_bg.graphics.drawRect(0,0,224,172);
			_bg.graphics.endFill();
			this.addContent(_bg);
			_list = new SimpleGrid(65,70,3);
			_list.verticalScrollPolicy = "off";
			_list.horizontalScrollPolicy = "off";
			_list.setSize(224,172);
			this.addContent(_list);
			_items = new Array();
			initList();
		}
		private function initList() : void
		{
			clearList();
			for(var i:int=5;i<11;i++)
			{
				var item : AccessoryItemAsset = new AccessoryItemAsset();
				var cell : AccessoryItemCell  = new AccessoryItemCell(i);
				item.addChild(cell);
				cell.x = item.cell_0.x;
				cell.y = item.cell_0.y;
				cell.addEventListener(Event.CHANGE, __itemInfoChange);
				_items.push(cell);
				_list.appendItem(item);
			}
			_area = new AccessoryDragInArea(_items);
			_list.parent.addChildAt(_area,0);
		}
		private function __itemInfoChange(evt: Event) : void
		{
			dispatchEvent(new StoreIIEvent(StoreIIEvent.ITEM_CLICK));
		}
		public function clearList() : void
		{
			_list.clearItems();
			for(var i:int=0;i<_items.length;i++)
			{
				var cell : AccessoryItemCell = _items[i] as AccessoryItemCell;
				cell.removeEventListener(Event.CHANGE, __itemInfoChange);
				cell.dispose();
			}
			_items = new Array();
		}
		
		public function get isBinds() : Boolean
		{
			for(var i:int=0;i<_items.length;i++)
			{
				if(_items[i] && _items[i].info && _items[i].info.IsBinds)return true;
			}
			return false;
		}
		
		public function setItemInfo(index:int,info:ItemTemplateInfo):void
		{
			_items[index-5].info = info;
		}
		
		public function listEmpty() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var cell : AccessoryItemCell = _items[i] as AccessoryItemCell;
			}
		}
		override public function dispose() : void
		{
			clearList();
			if(this.parent)this.parent.removeChild(this);
		}
		
		override public function show():void
		{
//			UIManager.AddDialog(this,true);
			TipManager.AddTippanel(this,true);
		}
		
		/**
		 * 返回附加品的个数
		 */
		public function getCount() : Number
		{
			var count : Number = 0;
			for(var i:int=0;i<_items.length;i++)
			{
				if(_items[i] != null && _items[i].info != null)
				{
					count ++;
				}
			}
			return count;
		}
		
		public function containsItem(item:InventoryItemInfo):Boolean
		{
			for(var i:int=0;i<_items.length;i++)
			{
				if(_items[i] != null && _items[i].itemInfo == item)
				return true;
			}
			return false;
		}
		
		/**
		 * 取得附加品的包类型和包位置
		 */
		public function getAllAccessory() : Array
		{
			var data : Array = new Array();
			for(var i:int=0;i<_items.length;i++)
			{
				if(_items[i] != null && _items[i].info != null)
				{
					var data1 : Array = new Array();
					data1.push(_items[i].info.BagType);
					data1.push(_items[i].place);
					data.push(data1);
				}
			}
			return data;
		}
		
	}
}