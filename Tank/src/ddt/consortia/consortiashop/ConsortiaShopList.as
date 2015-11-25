package ddt.consortia.consortiashop
{
	import flash.display.Sprite;
	
	import road.ui.controls.SimpleGrid;

	public class ConsortiaShopList extends Sprite
	{
		private var _list       : SimpleGrid;
		private var _shopId     : int;
		public function ConsortiaShopList()
		{
			super();
			init();
			addEvent() ;
		}
		private function init() : void
		{
			_list = new SimpleGrid(533,68,1);
			addChild(_list);
			_list.verticalScrollPolicy = "on";
			_list.horizontalScrollPolicy = "off";
			_list.setSize(560,427);
		}
		private function addEvent() : void
		{
			
		}
		private function removeEvent() : void
		{
			
		}
		public function dispose() : void
		{
			removeEvent();
			clearList();
			if(_list && _list.parent)_list.parent.removeChild(_list);
			_list = null;
			if(this.parent)this.parent.removeChild(this);
		}
		public function list($list : Array,shopId:int,enable : Boolean=false) : void
		{
			_shopId = shopId+10;
			clearList();
			for(var i : int=0;i<$list.length;i++)
			{
				var item : ConsortiaShopItem = new ConsortiaShopItem(enable);
				_list.appendItem(item);
				item.info = $list[i];
				item.shopId = _shopId;
			}
			if($list.length <6)
			{
				var len : int = 6 - $list.length;
				for(var j:int=0;j<len;j++)
				{
					var item2 : ConsortiaShopItem = new ConsortiaShopItem(enable);
					_list.appendItem(item2);
					item2.btnVisible = false;
				}
			}
		}
		private function clearList() : void
		{
			for(var i:int=0;i<_list.items.length;i++)
			{
				var item : ConsortiaShopItem = _list.getItemAt(i) as ConsortiaShopItem;
				item.dispose();
			}
			_list.clearItems();
		}
		
	}
}