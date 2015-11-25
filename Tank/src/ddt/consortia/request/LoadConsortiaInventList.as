package ddt.consortia.request
{
	import flash.net.URLVariables;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.consortia.data.ConsortiaInventData;
	import ddt.loader.RequestLoader;

	public class LoadConsortiaInventList extends RequestLoader
	{
		
		private static const PATH:String = "ConsortiaInviteUsersList.ashx";
		public var list:Array;
		public var page:int;
		public var count:int;
		public var totalCount:int;
		public function LoadConsortiaInventList(userID:int = -1)
		{
			this.page = page;
			this.count = count;
			var para:URLVariables = new URLVariables();
			para["page"] = 1;
			para["size"] = 10000;
			para["order"] = -1;
			para["userID"] = userID;
			para["inviteID"] = -1;
			
			super(PATH, para);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			list = [];
			totalCount = int(xml.@total);
			var xmllist:XMLList = XML(xml)..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				list.push(XmlSerialize.decodeType(xmllist[i],ConsortiaInventData));
			}
		}
		
	}
}