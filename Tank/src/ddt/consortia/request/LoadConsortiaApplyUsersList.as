package ddt.consortia.request
{
	import flash.net.URLVariables;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.consortia.data.ConsortiaApplyInfo;
	import ddt.loader.RequestLoader;

	public class LoadConsortiaApplyUsersList extends RequestLoader
	{
		private static const PATH:String = "ConsortiaApplyUsersList.ashx";
		
		public var list:Array;
		public var totalCount:int;
		
		public function LoadConsortiaApplyUsersList(page:int,size:int,order:int = -1,consortiaID:int = -1,applyID:int = -1,userID:int = -1,userLevel:int = -1)
		{
			var paras:URLVariables = new URLVariables();
			paras["page"] = page;
			paras["size"] = size;
			paras["order"] = order;
			paras["consortiaID"] = consortiaID;
			paras["applyID"] = applyID;
			paras["userID"] = userID;
			paras["userLevel"] = userLevel;
			super(PATH,paras);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			list = new Array();
			totalCount = int(xml.@total);
			var xmllist:XMLList = XML(xml)..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				list.push(XmlSerialize.decodeType(xmllist[i],ConsortiaApplyInfo));
			}
		}
	}
}