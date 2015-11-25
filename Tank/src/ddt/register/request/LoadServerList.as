package ddt.register.request
{
	import flash.net.URLVariables;
	import ddt.loader.RequestLoader;
	
	import ddt.register.uicontrol.HAlertDialog;

	public class LoadServerList extends RequestLoader
	{
		private var path:String = "ServerList.ashx";
		public var listXml:XML;
		public var agentId:int;
		public var zoneName:String;
		
		public function LoadServerList(params:URLVariables=null, tryTime:int = 1)
		{
			_tryTime = tryTime;
			super(path, params);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			try
			{
				agentId = xml.@agentId;
				zoneName = xml.@AreaName;
				var xmllist:XMLList = xml..Item;
				if(xmllist.length() > 0)
				{
					listXml = xml;
				}
				else
				{
//					HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.request.LoadServerListAction.server"));
					HAlertDialog.show("提示","服务器维护中，请稍后再试!");
				}
			}
			catch(err:Error)
			{
//				trace("Load serverlist:",err.getStackTrace());
			}
		}
	}
}