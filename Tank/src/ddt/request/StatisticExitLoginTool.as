package ddt.request
{
	import flash.net.URLVariables;
	
	import ddt.loader.RequestLoader;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;

	public class StatisticExitLoginTool extends RequestLoader
	{
//		private static const PATH : String = "http://192.168.0.24/AssayerHandler/Client.aspx";
		public function StatisticExitLoginTool(elapsedTime:String,managed:Boolean=true)
		{
			var para:URLVariables = new URLVariables();
			para["t"] = elapsedTime;
			para["username"] = PlayerManager.Instance.Account.Account;
			para["subid"] = ServerManager.Instance.AgentID;
			var path:String = PathManager.solveCountPath() + "Client.aspx";
			super(path, para,false,false);
		}
		
		
		override protected function onRequestReturn(xml:XML):void
		{
//			trace(xml.toXMLString());
//			list = [];
//			totalCount = int(xml.@total);
//			var xmllist:XMLList = XML(xml)..Item;
//			for(var i:int = 0; i < xmllist.length(); i++)
//			{
//				list.push(XmlSerialize.decodeType(xmllist[i],AuditingData));
//			}
		}
		
	}
}