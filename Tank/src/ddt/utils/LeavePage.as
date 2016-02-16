package ddt.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import road.manager.SoundManager;
	
	import ddt.data.PathInfo;
	import ddt.manager.PathManager;
	import ddt.view.common.BellowStripViewII;
	
	public class LeavePage
	{
		public static var IsDesktopApp:Boolean = false;
		public static function LeavePageTo(path:String,window:String = null):void
		{
			if(ExternalInterface.available)
			{
				if(LeavePage.IsDesktopApp)
				{
					if(window == "_self")
					{
						ExternalInterface.call("WindowReturn");
						return;
					}
				}else if(PathManager.solveAllowPopupFavorite())
				{
//				ExternalInterface.call("setFavorite",PathManager.solveLogin(),LanguageMgr.GetTranslation("ddt.task.TaskPannelPosView.loginPath"),"1");
					ExternalInterface.call("setFavorite",PathManager.solveLogin(),BellowStripViewII.siteName,"1");
				}
			}
			if(PathInfo.ISTOPDERIICT && (window == "_self") && ExternalInterface.available)
			{
				var redirictURL:String = "function redict () {top.location.href=\""+path+"\"}";
				ExternalInterface.call(redirictURL);
			}else
			{
				navigateToURL(new URLRequest(path),window);
			}
		}
		
		public static function leaveToFill():void
		{
			SoundManager.Instance.play("008");
			if(ExternalInterface.available && PathManager.solveFillJSCommandEnable() && !LeavePage.IsDesktopApp)
			{
				ExternalInterface.call(PathManager.solveFillJSCommandValue());
			}else
			{
				navigateToURL(new URLRequest(PathManager.solveFillPage()),"_blank");
			}
		}
		
		// 0表示网页登陆,1表示客户端登陆
		public static function GetClientType():int
		{
			if(IsDesktopApp)
				return 1;
			return 0;
		}
	}
}