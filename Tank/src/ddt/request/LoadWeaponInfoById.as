package ddt.request
{
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.WeaponInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.ItemManager;

	public class LoadWeaponInfoById extends RequestLoader
	{
		private var path:String = "UserGoodsInfo.ashx";
		private var _callback:Function;
		private var _playerid:int;
		
		public function LoadWeaponInfoById(id:int,callback:Function = null,playerid:int = -1)
		{
			_callback = callback;
			_playerid = playerid;
			var param:Object = new Object();
			param["id"] = id;
			super(path, param);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			var info:InventoryItemInfo = XmlSerialize.decodeType(XML(xml.Item),InventoryItemInfo)
			ItemManager.fill(info);
			var source:WeaponInfo = new WeaponInfo(info);
			if(_callback != null)
			{
				if(_playerid != -1)
				{
					_callback(_playerid,source);
				}
				else
				{
					_callback(source);
				}
			}
		}
	}
}