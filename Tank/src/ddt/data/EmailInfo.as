package ddt.data
{
	import flash.utils.Dictionary;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.LanguageMgr;
	
	public class EmailInfo
	{
		public var ID:int;
		public var UserID:int;
		
		/**
		 * 邮件内容 
		 */		
		 
		public var Content:String = LanguageMgr.GetTranslation("ddt.data.EmailInfo.test");
		//public var Content:String = "中华人民共和国中华人民共和国中华人民共和国中华人民共和国中华人民共和国保人";
		
		/**
		 * 标题 
		 */		
		 
		public var Title:String = LanguageMgr.GetTranslation("ddt.data.EmailInfo.email");
		//public var Title:String = "邮件测试中。。。。。。。。。。。";
		
		/**
		 * 发件人名字 
		 */		
		 
		public var Sender:String = LanguageMgr.GetTranslation("ddt.data.EmailInfo.random");
		//public var Sender:String = "随便测试";
		
		public var SendTime:String;
		
		/**
		 * 附件 
		 */	
		public var Annexs:Dictionary;	
		public var Annex1:InventoryItemInfo;
		public var Annex2:InventoryItemInfo;
		public var Annex3:InventoryItemInfo;
		public var Annex4:InventoryItemInfo;
		public var Annex5:InventoryItemInfo;
		/**
		 * 附件位置记录 
		 */		
		public var Annex1ID:int;
		public var Annex2ID:int;
		public var Annex3ID:int;
		public var Annex4ID:int;
		public var Annex5ID:int;
		
		/**
		 * 金币 
		 */		
		public var Gold:Number = 500;
		
		/**
		 * 券 
		 */		
		public var Money:Number = 600;
		
		/**
		 * 礼券
		 * */
		public var GiftToken:Number = 0;
		
		/**
		 * 有效期 
		 */		
		public var ValidDate:int = 30;
		
		public var Type:int = 0;
		
		/**
		 * 是否读过 
		 */		
		public var IsRead:Boolean = false;
		
		public function getAnnexs():Array
		{
			var result:Array = new Array();
			if(Annex1)result.push(Annex1);
			if(Annex2)result.push(Annex2);
			if(Annex3)result.push(Annex3);
			if(Annex4)result.push(Annex4);
			if(Annex5)result.push(Annex5);
			if(Gold != 0)result.push("gold");
			if(Money != 0)result.push("money");
			if(GiftToken != 0)result.push("gift");
			return result;
		}
		
		public function getAnnexByIndex(index:int):*
		{
			var result:*;
			var annexs:Array = getAnnexs();
			if(index > -1)
			{
				result = annexs[index];
			}
			return result;
		}
		
		public function hasAnnexs():Boolean {
			if(Annex1 || Annex2 || Annex3 || Annex4 || Annex5) {
				return true;
			}
			else {
				return false;
			}
		}
	}
}