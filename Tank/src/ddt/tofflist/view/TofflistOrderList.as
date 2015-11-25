package ddt.tofflist.view
{
	import flash.display.Sprite;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.player.PlayerInfo;
	import ddt.tofflist.TofflistEvent;
	import ddt.tofflist.TofflistModel;

	public class TofflistOrderList extends Sprite
	{
		private var _list       : SimpleGrid;
		private var _items      : Array;
		private var _currenItem : TofflistOrderItem;
		public function TofflistOrderList()
		{
			super();
			init();
			addEvent();
		}
		
		private function init() : void
		{
			_list = new SimpleGrid(500,33,1);
			_list.setSize(500,380);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "off";
			addChild(_list);
			
			_items = new Array();
		}
		private function addEvent() : void
		{
			
		}
		/**生成列表**/
		public function items($list : Array,page:int=1) : void
		{
			clearList();
			if(!$list)return;
			var length : int = ($list.length > page*8 ? page*8 : $list.length);
			for(var i:int=(page-1)*8;i<length;i++)
			{
				var item : TofflistOrderItem = new TofflistOrderItem();
				item.index = (i+1);
				item.info  = $list[i];
				_list.appendItem(item);
				_items.push(item);
				item.addEventListener( TofflistEvent.TOFFLIST_ITEM_SELECT,  __itemChange);
			}
			/*当前默认的节点*/
			if(_list.getItemAt(0) is TofflistOrderItem)
			{
				var currentItem : TofflistOrderItem = _list.getItemAt(0) as TofflistOrderItem;
				currentItem.isSelect = true;
			}
			else
			{
				TofflistModel.currentText       = "";
			    TofflistModel.currentIndex      = 0;
				TofflistModel.currentPlayerInfo = null;
			}
		}
		/**消除列表**/
		private function clearList() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : TofflistOrderItem = _items[i] as TofflistOrderItem;
				item.removeEventListener( TofflistEvent.TOFFLIST_ITEM_SELECT,  __itemChange);
				_list.removeItem(item);
				item.dispose();
			}
			_list.clearItems();
			_items = new Array();
			_currenItem = null;
			TofflistModel.currentText       = "";
			TofflistModel.currentIndex      = 0;
		    TofflistModel.currentPlayerInfo = null;
		}
		/**节点选择**/
		private function __itemChange(evt : TofflistEvent) : void
		{
			if(_currenItem)_currenItem.isSelect = false;
			_currenItem = evt.data as TofflistOrderItem;
			TofflistModel.currentText       = _currenItem.currentText;
			TofflistModel.currentIndex      = _currenItem.index;
			TofflistModel.currentPlayerInfo = _currenItem.info as PlayerInfo;		
		}
		public function dispose() : void
		{
			clearList();
			_items = null;
			if(_list.parent)this.removeChild(_list);
		}
		
	}
}