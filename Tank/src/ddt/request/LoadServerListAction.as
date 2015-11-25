package ddt.request
{
	
	import flash.utils.describeType;
	
	import road.serialize.xml.XmlSerialize;
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.ServerInfo;
	import ddt.loader.RequestLoader;
	import ddt.manager.LanguageMgr;
	import ddt.manager.ServerManager;

	public class LoadServerListAction extends RequestLoader
	{
		private static const PATH:String = "ServerList.ashx";
		
		public var list:Array;
		
		public var agentId:int;
		
		public function LoadServerListAction()
		{
			super(PATH);
			list = new Array();
		}
		
		override protected function onCompleted():void
		{
			try
			{
				var xml:XML = new XML(content);
				
				agentId = xml.@agentId;
				
				var xmllist:XMLList = xml..Item;
				if(xmllist.length() > 0)
				{
					var scInfo:XML = describeType(new ServerInfo());
					for(var i:int = 0; i < xmllist.length(); i ++)
					{
						list.push(XmlSerialize.decodeType(xmllist[i],ServerInfo,scInfo));
					}
					ServerManager.Instance.list = list;
					ServerManager.Instance.AgentID = agentId;
					ServerManager.Instance.zoneName = xml.@AreaName;
					super.onCompleted();
				}
				else
				{
					HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.request.LoadServerListAction.server"));
				}
			}
			catch(err:Error)
			{
				startLoad(_url);
			}
		}
	}
}