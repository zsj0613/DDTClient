package ddt.data
{
	import flash.display.DisplayObject;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	
	public class DeputyWeaponInfo
	{
		private var _info:InventoryItemInfo;
		public var energy:Number = 110;
		public var ballId:int;
		public var coolDown:int = 2;
		public var weaponType:int = 0;
		public var name:String = LanguageMgr.GetTranslation("ddt.auctionHouse.view.offhand");
		public function DeputyWeaponInfo(inventoryInfo:InventoryItemInfo)
		{
			_info = inventoryInfo;
			if(_info)
			{
				energy = Number(_info.Property4);
				ballId = int(_info.Property1);
				coolDown = int(_info.Property6);
				weaponType = int(_info.Property3);
				name = _info.Name;
			}
		}
		
		public function dispose():void
		{
			_info = null;
		}
		
		/**
		 * 取得使用副武器时用于显示的大小图标
		 * type = 0 返回大图标
		 * type = 1 返回小图标
		 * @return 
		 * 
		 */		
		public function getDeputyWeaponIcon(type:int = 0):DisplayObject
		{
			return PlayerManager.Instance.getDeputyWeaponIcon(_info,type);
		}
		
		public function get info():InventoryItemInfo
		{
			return _info;
		}

	}
}