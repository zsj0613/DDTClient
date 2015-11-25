package ddt.request
{
	import road.serialize.xml.XmlSerialize;
	import road.utils.ClassFactory;
	
	import ddt.data.PathInfo;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.ItemManager;
	import ddt.view.common.SimpleLoading;
	

	public class LoadAuctionListAction extends RequestLoader
	{
		public static const PATH:String = "AuctionPageList.ashx";
		
		public var list:Array;
		
		public var total:int;
		
		public function LoadAuctionListAction(page:int,name:String,type:int,pay:int,userID:int,buyId:int,sortIndex:uint = 0,sortBy:String = "true",Auctions:String="")
		{
			var data:Object = new Object();
			data.page = page;
			data.name = name;
			data.type = type;
			data.pay = pay;
			data.userID = userID;
			data.buyID = buyId;
			data.order = sortIndex;
			data.sort = sortBy;
			data.Auctions = Auctions;
			super(PATH + "?",data,false);
			SimpleLoading.instance.show();
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			
			list = new Array();
			var xmllist:XMLList = xml.Item;
			total = xml.@total;
			for(var i:int = 0; i < xmllist.length(); i ++)
			{
				var info:AuctionGoodsInfo = XmlSerialize.decodeType(xmllist[i],AuctionGoodsInfo);
				var xmllistII:XMLList = xmllist[i].Item;
				if(xmllistII.length() > 0)
				{
					var bagInfo:InventoryItemInfo = XmlSerialize.decodeType(xmllistII[0],InventoryItemInfo);
					var templateInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(bagInfo.TemplateID);
					ClassFactory.copyProperties(templateInfo,bagInfo);
					info.BagItemInfo = bagInfo;
					list.unshift(info);
				}
			}
			SimpleLoading.instance.hide();
		}
		
	}
}