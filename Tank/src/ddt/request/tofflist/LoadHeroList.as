package ddt.request.tofflist
{
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.player.PlayerInfo;
	import ddt.loader.RequestLoader;

	public class LoadHeroList extends RequestLoader
	{
		private var PATH:String = "LoadUsersSort.ashx";
		public var list:Array;
		
		public function LoadHeroList(page:int,order:int = 0)
		{
			var param:Object = new Object();
			param["page"] = page;
			param["order"] = order;
			
			super(PATH, param);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			list = new Array();
			var xmllist:XMLList = xml..Item;
			for(var i:int = 0;i < xmllist.length(); i ++)
			{
				var trueSex:Boolean = xmllist[i].@Sex == "true" ? true : false;//human 09.5.14
				var info:PlayerInfo = XmlSerialize.decodeType(xmllist[i],PlayerInfo);
				info.beginChanges();
				info.Sex = trueSex;
				info.Hide = xmllist[i].@Hide;
				info.Style = xmllist[i].@Style;
				info.Colors = xmllist[i].@Colors;
				info.Skin = xmllist[i].@Skin;
				info.commitChanges();
				list.push(info);
			}
		}
	}
}