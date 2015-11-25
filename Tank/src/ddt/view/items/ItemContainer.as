package ddt.view.items
{
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.goods.PropInfo;
	
	[Event(name="itemClick",type="ddt.view.items.ItemEvent")]
	[Event(name="itemOver",type="ddt.view.items.ItemEvent")]
	[Event(name="itemOut",type="ddt.view.items.ItemEvent")]
	[Event(name="itemMove",type="ddt.view.items.ItemEvent")]
	public class ItemContainer extends SimpleGrid
	{	
		private var list:Array;
		
		private var _ordinal:Boolean;
		
		private var _clickAble:Boolean;
	
		public function ItemContainer(count:Number,column:Number =1,bgvisible:Boolean = true,ordinal:Boolean = false,clickable:Boolean = false)
		{
			super(40,40,column);
			list = new Array();
			for(var i:int = 0; i < count;i ++)
			{
				var item:ItemCellView = new ItemCellView(i);
				item.addEventListener(ItemEvent.ITEM_CLICK,__itemClick);
				item.addEventListener(ItemEvent.ITEM_OVER,__itemOver);
				item.addEventListener(ItemEvent.ITEM_OUT,__itemOut);
				item.addEventListener(ItemEvent.ITEM_MOVE,__itemMove);
				super.appendItem(item);
				list.push(item);
			}
			_clickAble = clickable;
			_ordinal = ordinal;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
		}
		
		
		public function setState(clickable:Boolean,isGray:Boolean):void
		{
			_clickAble = clickable;
			setItemState(clickable,isGray);
		}
		
		public function get clickAble():Boolean
		{
			return _clickAble;
		}
		
		override public function appendItem(item:DisplayObject):void
		{
			for each(var cell:ItemCellView in list)
			{
				if(cell.item == null)
				{
					cell.setItem(item,false);
					return;
				}
			}
		}
		
		public function get blankItems():Array
		{
			var ar:Array = [];
			var index:int = 0;
			for each(var cell:ItemCellView in list)
			{
				if(cell.item == null)
				{
					ar.push(index);
				}
				index++;
			}
			return ar;
		}
		
		private function __itemClick(event:ItemEvent):void
		{
			this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,event.item,event.index));
		}
		
		private function __itemOver(event:ItemEvent):void
		{
			this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_OVER,event.item,event.index));
		}

		private function __itemOut(event:ItemEvent):void
		{
			this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_OUT,event.item,event.index));
		}
		private function __itemMove(event:ItemEvent):void
		{
			this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_MOVE,event.item,event.index));
		}
		
		override public function appendItemAt(item:DisplayObject,index:int):void
		{
			var cell:ItemCellView
			if(_ordinal)
			{
				cell = list[list.length -1] as ItemCellView;
				for(var i:int = index; i < list.length -1; i ++)
				{
					list[i+1] = list[i];
				}
				list[index] = cell;
				cell.setItem(item,false);
				super.appendItemAt(cell,index);
			}
			else
			{
				cell = list[index];
				cell.setItem(item,false);
			}
		}
		
		override public function removeItem(item:DisplayObject):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var cell:ItemCellView = list[i];
				if(cell.item == item)
				{
					removeChildAt(i);
				}
			}
		}
		
		override public function removeItemAt(index:int):void
		{
			var cell:ItemCellView = list[index];
			cell.setItem(null,false);
			if(_ordinal)
			{
				list.splice(index,1);
				super.removeItem(cell);
				list.push(cell);
				super.appendItem(cell);
			}
		}
		
		public function clear():void
		{
			for each(var cell:ItemCellView in list)
			{
				cell.setItem(null,false);
			}
		}
		
		
		public function setItemClickAt(index:int,isClick:Boolean,isGray:Boolean):void
		{
			list[index].setClick(isClick,isGray,false);
		}
		
		public function mouseClickAt(index:int):void
		{
			list[index].mouseClick();
		}
		
		public function setNoClickAt(index:int):void
		{
			list[index].setNoEnergyAsset();
		}
	
		private function setItemState(isClick:Boolean,isGray:Boolean):void
		{
			for each(var cell:ItemCellView in list)
			{
				var isExist:Boolean = false;;
				if(PropItemView(cell.item) != null)
				{
					isExist = PropItemView(cell.item).isExist;
				}
				cell.setClick(isClick,isGray,isExist);
			}
		}
		
		public function setClickByEnergy(energy:int):void
		{
			for each(var cell:ItemCellView in list)
			{
				if(cell.item)
				{
					var info:PropInfo = PropItemView(cell.item).info;
					if(info)
					{
						if(energy < info.needEnergy)
						{
							cell.setClick(true,true,PropItemView(cell.item).isExist);
						}
					}
				}
			}
		}
		
		public function dispose():void
		{
			super.clearItems();
			while(list.length > 0)
			{
				var item:ItemCellView = list.shift() as ItemCellView;
				item.dispose();
			}
			list = null;
			if(parent) parent.removeChild(this);
		}		

	}
}