package ddt.request.tofflist
{
	import road.serialize.xml.XmlSerialize;
	
	import ddt.data.player.PlayerInfo;
	import ddt.loader.RequestLoader;

	public class LoadHeroInfo extends RequestLoader
	{
		private var path:String = "LoadUserEquip.ashx";
		public var info:PlayerInfo;
		
		public function LoadHeroInfo(id:int)
		{
			var param:Object = new Object();
			param["ID"] = id;
			super(path,param);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
			info = XmlSerialize.decodeType(XML(xml.Item),PlayerInfo);
		}
	}
}