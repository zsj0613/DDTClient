package ddt.gameover.torphy
{
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.SocketManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.infoandbag.CellEvent;
	
	import webgame.crazytank.game.view.TrophyAsset;

	public class TrophyView extends TrophyAsset
	{
		private var _list:SimpleGrid;
		
		private var _items:Array;
		
		private var _infos:Array;
		
		public function get infos():Array
		{
			return _infos;
		}
		
		public function set infos(value:Array):void
		{
			_infos = value;
			update();	
		}
		
		public function TrophyView()
		{
			initView();		
		}
		
		private function initView():void
		{
			_items = [];
			_list = new SimpleGrid(45,45,5);
			_list.column = 5;
			_list.x = 20;
			_list.y = 35;
			_list.setSize(229,310);
			_list.verticalScrollPolicy = "off";
			_list.horizontalScrollPolicy = "off";
			_list.cellPaddingWidth = -1;
			_list.cellPaddingHeight = -1;
			addChild(_list);
			
			for(var i:uint = 0; i <= 34; i ++)
			{
				var item:TrophyCell = new TrophyCell(null,i);
				_items.push(item);
				item.addEventListener(CellEvent.ITEM_CLICK,__itemClick);
				_list.appendItem(item);
			}
			select_btn.addEventListener(MouseEvent.CLICK,__selected);
		}
	
		public function dispose():void
		{
			if(select_btn)
			{
				select_btn.removeEventListener(MouseEvent.CLICK,__selected);
				if(select_btn.parent)
					select_btn.parent.removeChild(select_btn);
			}
			select_btn = null;
			
			for each(var cell:TrophyCell in _items)
			{
				cell.removeEventListener(CellEvent.ITEM_CLICK,__itemClick);
				cell.info = null;
				cell.dispose();
				cell = null;
			}
			_items = null;
			
			if(_list)
			{
				_list.clearItems();
				
				if(_list.parent)
					_list.parent.removeChild(_list);
			}
			_list = null;
			
			_infos = null;
			
			if(parent)
				parent.removeChild(this);
		}
		
		public function update():void
		{
			for each(var cell:TrophyCell in _items)
			{
				cell.info = null;
			}
			for (var i:uint = 0; i < _infos.length; i ++)
			{
				var info:InventoryItemInfo = _infos[i];
				var item:TrophyCell = _items[i];
				if(item == null){
					continue;
				}
				if(info != null)
				{
					if(item.info == null)
					{
						item.info = info;
					}
				}
				else
				{
					item.info = null;	
				}
			}
		}
		
		public function __selected(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			SocketManager.Instance.out.sendGetTropToBag(-1);
		}
		
		public function __itemClick(event:CellEvent):void
		{
			SoundManager.Instance.play("008");
			var item:TrophyCell = event.data as TrophyCell;
			SocketManager.Instance.out.sendGetTropToBag((item.info as InventoryItemInfo).Place);
		} 
	}
}