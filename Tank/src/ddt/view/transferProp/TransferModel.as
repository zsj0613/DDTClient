package ddt.view.transferProp
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.BagEvent;
	
	/**
	 * @author wicki LA
	 * @time 11/26/2009
	 * @description 道具转移属性所用的数据模型
	 * */

	public class TransferModel extends EventDispatcher
	{
		private var _canTransferList:DictionaryData;
		private var _selfBag:BagInfo;
		private var _trasferBag:BagInfo;
		
		public function TransferModel()
		{
			init();
			initEvents();
		}
		
		private function init():void
		{
			_selfBag = PlayerManager.Instance.Self.Bag;
			var equipList:DictionaryData = _selfBag.items;
			_trasferBag = new BagInfo(BagInfo.EQUIPBAG,0);
			_canTransferList = new DictionaryData;
			for each(var item:InventoryItemInfo in equipList)
			{
				if(item.Refinery>=1&&item.getRemainDate()>0)
				{
					_canTransferList.add(item.Place,item);
				}
			}
			_trasferBag.items = _canTransferList;
		}
		
		private function initEvents():void
		{
			_selfBag.addEventListener(BagEvent.UPDATE,__update);
		}
		
		private function removeEvents():void
		{
			_selfBag.removeEventListener(BagEvent.UPDATE,__update);
		}
		
		private function __update(evt:BagEvent):void
		{
			var changedSlots:Dictionary = evt.changedSlots;
			evt.stopImmediatePropagation();
			for each(var i:InventoryItemInfo in changedSlots)
			{
				var c:InventoryItemInfo = PlayerManager.Instance.Self.Bag.getItemAt(i.Place);
				if(c)
				{
					_trasferBag.addItem(c);
				}else
				{
					_trasferBag.removeItemAt(i.Place);
				}
			}
		}
		
		public function get TransferBag():BagInfo
		{
			return _trasferBag;
		}
		
		public function dispose():void
		{
			removeEvents();
			_canTransferList = null;
			_selfBag = null;
			_trasferBag = null;
		}
		
	}
}