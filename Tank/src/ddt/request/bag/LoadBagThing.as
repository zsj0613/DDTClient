package ddt.request.bag
{
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.ItemManager;
	import ddt.manager.PlayerManager;

	public class LoadBagThing extends RequestLoader
	{
		private static const PATH:String = "LoadUserItems.ashx";
		
		private var __id:int;
		
		public static var BagThingLoaded:Boolean = false;
		public function LoadBagThing(id:int)
		{
			__id = id;
			var obj:Object = new Object();
			obj["ID"] = id;
			super(PATH, obj);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			BagThingLoaded = true;
			saveInBag(PlayerManager.Instance.Self.Bag,xml.EquipBag..Item);
			saveInBag(PlayerManager.Instance.Self.PropBag,xml.PropBag..Item);
		}
		
		private function saveInBag(_bag:BagInfo,xmllist:XMLList):void
		{
			_bag.beginChanges();
			try
			{
				var icInfo:XML = describeType(new InventoryItemInfo());
				for(var i:int = 0;i < xmllist.length(); i ++)
				{
					var info:InventoryItemInfo = XmlSerialize.decodeType(xmllist[i],InventoryItemInfo,icInfo);
					ItemManager.fill(info);
					_bag.addItem(info);
				}
				_bag.commiteChanges();
			}
			finally
			{
				_bag.commiteChanges();
			}
		}
	}
}