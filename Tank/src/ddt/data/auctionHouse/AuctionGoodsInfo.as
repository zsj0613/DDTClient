package ddt.data.auctionHouse
{
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.TimeManager;
	
	public class AuctionGoodsInfo
	{
		public function AuctionGoodsInfo()
		{
		}
		
		
		public var AuctionID:int;
		
		public var AuctioneerID:int;
		
		public var AuctioneerName:String;
		
		public var ItemID:int;
		
		public var BagItemInfo:InventoryItemInfo
		
		public var PayType:int;
		
		public var Price:int;
		
		/**
		 * 增值 
		 */		
		public var Rise:int;
		
		/**
		 * 一口价 
		 */		
		public var Mouthful:int;
		
		/**
		 * 开始日期 
		 */		
		public var BeginDate:Date;
		
		/**
		 * 有效时间 
		 */		
		public var ValidDate:int;
		public function getTimeDescription():String
		{
			var result:String = "";
			var offDate:Date = new Date();
			offDate.setTime(BeginDate.getTime());
			offDate.hours = ValidDate+offDate.hours;
			

			var diff:int = Math.abs(TimeManager.Instance.TotalHoursToNow(offDate));
			if(diff <= 1.5)
			{
				
				result = LanguageMgr.GetTranslation("ddt.data.auctionHouse.AuctionGoodsInfo.short");
				//result = "短";
			}
			else if(diff <= 3)
			{
				
				result = LanguageMgr.GetTranslation("ddt.data.auctionHouse.AuctionGoodsInfo.middle");
				//result = "中";
			}
			else if(diff <= 13)
			{
				
				result = LanguageMgr.GetTranslation("ddt.data.auctionHouse.AuctionGoodsInfo.long");
				//result = "长";
			}
			else
			{
				
				result = LanguageMgr.GetTranslation("ddt.data.auctionHouse.AuctionGoodsInfo.very");
				//result = "非常长";
			}
			
			offDate = null;
			return result;
		}
		public function getSithTimeDescription():String
		{
			var result:String = "";
			var offDate:Date = new Date();
			offDate.setTime(BeginDate.getTime());
			offDate.hours = ValidDate+offDate.hours;
			
			/**
			该物品已有人竞拍
			 * 
			 * 30分钟以内
			 * 30分钟到2小时
			 * 2小时到12小时
			 * 大于12小时
			**/
			var diff:int = Math.abs(TimeManager.Instance.TotalHoursToNow(offDate));
			if(diff <= 1.5)
			{
				
				result = LanguageMgr.GetTranslation("ddt.data.auctionHouse.AuctionGoodsInfo.tshort");
				//result = "为30分钟以内";
			}
			else if(diff <= 3)
			{
				
				result = LanguageMgr.GetTranslation("ddt.data.auctionHouse.AuctionGoodsInfo.tmiddle");
				//result = "为30分钟到2小时";
			}
			else if(diff <= 13)
			{
				
				result = LanguageMgr.GetTranslation("ddt.data.auctionHouse.AuctionGoodsInfo.tlong");
				//result = "为2小时到12小时";
			}
			else
			{
				
				result = LanguageMgr.GetTranslation("ddt.data.auctionHouse.AuctionGoodsInfo.tvery");
				//result = "为大于12小时";
			}
			
			offDate = null;
			return result;
		}
		
		public var BuyerID:int;
		public var BuyerName:String;
		
	}
}