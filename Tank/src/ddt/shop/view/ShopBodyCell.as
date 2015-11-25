package ddt.shop.view
{
	import flash.display.Sprite;
	
	import ddt.shop.ShopEvent;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.manager.PlayerManager;
	import ddt.view.cells.BaseCell;

	public class ShopBodyCell extends BaseCell
	{
		private var _shopItemInfo:ShopIICarItemInfo;
		public function ShopBodyCell(bg:Sprite)
		{
			super(bg);
		}
		
		public function set shopItemInfo(value:ShopIICarItemInfo):void
		{
			if(value == null)
			{
				super.info = null;
			}else
			{
				super.info = value.TemplateInfo;
			}
			_shopItemInfo = value;
			locked = false;
			if(value is ShopIICarItemInfo)
			{
				setColor(ShopIICarItemInfo(value).Color);
			}
			dispatchEvent(new ShopEvent(ShopEvent.ITEMINFO_CHANGE,null,null));
		}
		
		public function get shopItemInfo():ShopIICarItemInfo
		{
			return _shopItemInfo;
		}

		public function setSkinColor(color:String):void
		{
			if( shopItemInfo && EquipType.hasSkin(shopItemInfo.CategoryID))
			{
				var t:Array = shopItemInfo.Color.split("|");
				var cs:String = "";
				if(t.length > 2)
				{
					cs = t[0] + "|" + color + "|" + t[2];
				}
				else
				{
					cs = t[0] + "|" + color + "|" + t[1];
				}
				shopItemInfo.Color = cs;
				setColor(cs);
			}
		}
		
		override public function dispose():void
		{
			if(locked)
			{
				if(_info!=null && _info is InventoryItemInfo) PlayerManager.Instance.Self.Bag.unlockItem(_info as InventoryItemInfo);
				locked = false;
			}
			_shopItemInfo = null;
			super.dispose();
		}
	}
}