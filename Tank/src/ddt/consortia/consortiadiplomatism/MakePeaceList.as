
package ddt.consortia.consortiadiplomatism
{
	import flash.display.Sprite;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.manager.SocketManager;

	public class MakePeaceList extends Sprite
	{
		private var _list : SimpleGrid;
		private var _items : Array;
		public function MakePeaceList()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			_list = new SimpleGrid(409,30,1);
			_list.verticalScrollPolicy = "on";
			_list.setSize(440,92);
			addChild(_list);
			
			_items = new Array();
			
			
		}
		private function addEvent() : void
		{
			
		}
		
		public function set info($list : Array) : void
		{
			clearList();
			for(var i:int=0;i<$list.length;i++)
			{
				var item : MakePeaceItem = new MakePeaceItem(__okClick,__cancelClick);
				item.info =$list[i];
				_list.appendItem(item);
				_items.push(item);
				if(i%2 == 0)item.gotoAndStop(2);
			}
		}
		
		private function __okClick(id:int):void
		{
			SocketManager.Instance.out.sendConsortiaAllyApplyUpdate(id);
		}
		
		private function __cancelClick(id:int):void
		{
			SocketManager.Instance.out.sendConsortiaRemoveApplyAlly(id);
		}
		private function clearList() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : MakePeaceItem = _items[i] as MakePeaceItem;
				_list.removeItem(item);
				item.dispose();
			}
			_items = new Array();
			
		}
		public function removeItem(id : int) : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : MakePeaceItem = _items[i] as MakePeaceItem;
				if(item.info["ID"] == id)
				{
					_list.removeItem(item);
					item.dispose();
					_items.splice(i,1);
					break;
				}
			}
			sortItems();
		}
		private function sortItems() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : MakePeaceItem = _items[i] as MakePeaceItem;
				if(i%2 == 0)item.gotoAndStop(2);
				else item.gotoAndStop(1);
			}
		}
		public function dispose() : void
		{
			clearList();
			_items = null;
			if(_list && _list.parent)_list.parent.removeChild(_list);
			_list = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
	}
}