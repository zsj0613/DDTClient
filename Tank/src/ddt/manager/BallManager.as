package ddt.manager
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import road.utils.ClassUtils;
	import road.ui.controls.hframe.HAlertDialog;
	
	import ddt.data.BallInfo;
	import ddt.request.LoadBallList;
	import ddt.utils.LeavePage;
	
	public class BallManager
	{
		private static var _list:Dictionary;
		
		public static function setup():void
		{
			new LoadBallList().loadSync(__loadBallInfo,3);
		}
		
		public static function get ready():Boolean
		{
			return _list != null;
		}
		
		public static function findBall(id:int):BallInfo
		{
			return _list[id];
		}
		
		private static function __loadBallInfo(loader:LoadBallList):void
		{
			if(loader.isSuccess)
			{
				_list = loader.list;
			}
			else
			{
				
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.manager.BallManager.bom"),true,callSolveLogin,false,HAlertDialog.OK_LABEL,callSolveLogin);
				//AlertDialog.show("错误","炸弹元数据加载失败");
			}
		}
		
		private static function callSolveLogin():void
		{
			LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
		}
		
		
		public static function solveBallAssetName(bombid:int):String
		{
			return "tank.resource.bombs.Bomb"+bombid;
		}
		
		public static function solveBallWeaponMovieName(bombid:int):String
		{
			return "tank.resource.bombs.BombMovie"+bombid;
		}
		
		public static function createBallWeaponMovie(bombid:int):MovieClip
		{
			return ClassUtils.CreatInstance(solveBallWeaponMovieName(bombid)) as MovieClip;
		}
		
		public static function createBallAsset(bombid:int):Sprite
		{
			return ClassUtils.CreatInstance(solveBallAssetName(bombid)) as Sprite;
		}

	}
}