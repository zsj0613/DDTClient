package ddt.request
{
	import flash.net.URLVariables;
	
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.loader.RequestLoader;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;

	public class LoginSelectList extends RequestLoader
	{
		public var list:Array;
		public var totalCount:int;
		private static const PATH:String = "LoginSelectList.ashx";
		public function LoginSelectList(username:String)
		{
			var para:URLVariables = new URLVariables();
			para["username"] = username;
			super(PATH, para);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			var result:String = xml.@value;
			if(result == "true")
			{
				isSuccess = true;
				list = new Array();
				totalCount = int(xml.@total);
				var xmllist:XMLList = XML(xml)..Item;
				for(var i:int = 0; i < xmllist.length(); i++)
				{
					list.push({NickName:xmllist[i].@NickName,Rename:String(xmllist[i].@Rename) == "true" ,ConsortiaName:String(xmllist[i].@ConsortiaName),ConsortiaRename:String(xmllist[i].@ConsortiaRename) == "true" ,NameChanged:false,ConsortiaNameChanged:false,Grade:xmllist[i].@Grade,Repute:xmllist[i].@Repute,WinCount:xmllist[i].@WinCount,TotalCount:xmllist[i].@TotalCount,EscapeCount:xmllist[i].@EscapeCount});
				}
			}
			else
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),xml.@message,true,errorOkCallBack,true,null,errorOkCallBack);
				isSuccess = false;
			}
		}
		
		private function errorOkCallBack():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
		}
		
	}
}