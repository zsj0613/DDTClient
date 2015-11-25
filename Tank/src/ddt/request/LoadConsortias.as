package ddt.request
{
	import flash.net.URLVariables;
	
	import ddt.data.ConsortiaInfo;
	import ddt.loader.CompressTextLoader;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	
	import road.serialize.xml.XmlSerialize;
	import road.utils.MD5;

	public class LoadConsortias extends CompressTextLoader
	{
		private static const PATH:String = "ConsortiaList.ashx";
		
		public var list:Array;
		public var page:int;
		public var count:int;
		public var totalCount:int;
		private var _openApply : int = 2;
		public function LoadConsortias(page:int,count:int,order:int = -1,name:String = "",level:int = -1,consortiaid:int = -1,openApply:int=-1)
		{
			this.page = page;
			this.count = count;
			var keymd5:String = MD5.hash(PlayerManager.Instance.Account.Password);
			var para:URLVariables = new URLVariables();
			para["page"] = page;
			para["size"] = count;
			para["name"] = name;
			para["level"] = level;
			para["ConsortiaID"] = consortiaid;
			para["order"] = order;
			para["openApply"] = openApply;/**-1表示全部，1开启的，0关闭的**/
			para["key"] = keymd5;
			para["rnd"] = Math.random();
			_openApply =  openApply;
			super(PathManager.solveRequestPath(PATH),para);
		}
		
		override protected function onTextReturn(xml:String):void
		{
			list = new Array();
			var xmlData:XML = new XML(xml);
			totalCount = int(xmlData.@total);
			var xmllist:XMLList = xmlData..Item;
			for(var i:int = 0; i < xmllist.length(); i++)
			{
				list.push(XmlSerialize.decodeType(xmllist[i],ConsortiaInfo));
			}
			super.onTextReturn(xml);
		}
	}
}