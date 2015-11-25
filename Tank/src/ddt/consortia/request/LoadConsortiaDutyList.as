package ddt.consortia.request
{
	import flash.net.URLVariables;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.consortia.data.ConsortiaDutyInfo;
	import ddt.loader.RequestLoader;

	public class LoadConsortiaDutyList extends RequestLoader
	{
		public static const PATH:String = "ConsortiaDutyList.ashx";
		public var list:Array;
		public var totalCount:int;
		public function LoadConsortiaDutyList(consortiaID:int = -1,dutyID:int = -1)
		{
			var paras:URLVariables = new URLVariables();
			paras["page"] = 1;
			paras["size"] = 1000;
			paras["order"] = -1;
			paras["consortiaID"] = consortiaID;
			paras["dutyID"] = dutyID;
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
				list.push(XmlSerialize.decodeType(xmllist[i],ConsortiaDutyInfo));
			}
			
		}
		
	}
}