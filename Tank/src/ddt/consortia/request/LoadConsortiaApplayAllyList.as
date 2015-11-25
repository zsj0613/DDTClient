package ddt.consortia.request
{
	import flash.net.URLVariables;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.consortia.data.ConsortiaDiplomatismInfo;
	import ddt.loader.RequestLoader;

	public class LoadConsortiaApplayAllyList extends RequestLoader
	{
		private static const PATH:String = "ConsortiaApplyAllyList.ashx";
		
		public var list:Array;
		public var totalCount:int;
		
		public function LoadConsortiaApplayAllyList(state:int,page:int,size:int,order:int = -1,consortiaID:int = -1,applyID:int = -1)
		{
			var paras:URLVariables = new URLVariables();
			paras["page"] = page;
			paras["size"] = size;
			paras["order"] = order;
			paras["consortiaID"] = consortiaID;
			paras["applyID"] = applyID;
			paras["state"] = state;
			super(PATH, paras);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{	
//			trace(xml.toXMLString());
			list = new Array();
			totalCount = int(xml.@total);
			var xmllist:XMLList = XML(xml)..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				list.push(XmlSerialize.decodeType(xmllist[i],ConsortiaDiplomatismInfo));
			}
		}
	}
}