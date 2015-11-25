package ddt.manager
{
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	import ddt.utils.LeavePage;
	import ddt.view.common.BellowStripViewII;
	
	public class JSHelper
	{
		public function JSHelper()
		{
		}
		
		public static function addFavoriteAsync(name:String,path:String):void
		{
			setTimeout(addFavoriteImp,40,name,path);
		}
		
		public static function setFavorite(isFirst:Boolean):void
		{
			if(ExternalInterface.available)
			{
				if(LeavePage.IsDesktopApp) return;
				if(!PathManager.solveAllowPopupFavorite()) return;
				if(isFirst)
				{
//					ExternalInterface.call("setFavorite",PathManager.solveLogin(),LanguageMgr.GetTranslation("ddt.task.TaskPannelPosView.loginPath"),"3");
					ExternalInterface.call("setFavorite",PathManager.solveLogin(),BellowStripViewII.siteName,"3");
				}else
				{
//					ExternalInterface.call("setFavorite",PathManager.solveLogin(),LanguageMgr.GetTranslation("ddt.task.TaskPannelPosView.loginPath"),"2");
					ExternalInterface.call("setFavorite",PathManager.solveLogin(),BellowStripViewII.siteName,"2");
				}
			}
		}
		
		private static function addFavoriteImp(name:String,path:String):void
		{
			if(ExternalInterface.available)
			{
				if(LeavePage.IsDesktopApp) return;
				ExternalInterface.call("addfavorite",name,path);
			}
		}
		
		public static function copyToClipboard(src:String):void
		{
			if(ExternalInterface.available)
			{
				if(LeavePage.IsDesktopApp) return;
				ExternalInterface.call("copyToClipboard",src);
			}
		}

	}
}
