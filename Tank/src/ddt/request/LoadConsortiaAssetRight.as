package ddt.request
{
	import flash.net.URLVariables;
	
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.ConsortiaAssetLevelOffer;
	import ddt.loader.RequestLoader;


	public class LoadConsortiaAssetRight extends RequestLoader
	{
		private static const PATH:String = "ConsortiaEquipControlList.ashx";
		public var list:  Array;
		public var page:int;
		public var count:int;
		public var totalCount:int;
		public function LoadConsortiaAssetRight(id : int,type:int=-1,level:int=-1)
		{
			var para:URLVariables = new URLVariables();
			para["consortiaID"] = id;
			para["level"] = level;
			para["type"] = type;
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
				list.push(XmlSerialize.decodeType(xmllist[i],ConsortiaAssetLevelOffer));
			}
		}
	}
}