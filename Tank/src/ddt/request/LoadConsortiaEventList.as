package ddt.request
{
	import flash.net.URLVariables;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.ConsortiaEventInfo;
	import ddt.loader.RequestLoader;

	public class LoadConsortiaEventList extends RequestLoader
	{
		private static const PATH:String = "ConsortiaEventList.ashx";
		
		public var list:Array;
		
		public function LoadConsortiaEventList(page:int,size:int,order:int = -1,consortiaID:int = -1)
		{
			var paras:URLVariables = new URLVariables();
			paras["page"] = page;
			paras["size"] = 50;//size;
			paras["order"] = order;
			paras["consortiaID"] = consortiaID;
			super(PATH, paras);
		}
	
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			list = new Array();
			var xmllist:XMLList = XML(xml)..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				var info:ConsortiaEventInfo = new ConsortiaEventInfo();
				info.ID = xmllist[i].@ID;
				info.ConsortiaID = xmllist[i].@ConsortiaID;
				info.Date = xmllist[i].@Date;
				info.Type = xmllist[i].@Type;
				info.Remark = xmllist[i].@Remark;
				list.push(info);
//				list.push(XmlSerialize.decodeType(xmllist[i],ConsortiaEventInfo));
			}
		}
	}
}