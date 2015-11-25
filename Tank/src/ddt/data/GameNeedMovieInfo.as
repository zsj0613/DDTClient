package ddt.data
{
	import road.loader.*;
	
	import ddt.manager.PathManager;
	
	public class GameNeedMovieInfo
	{
		/**
		 *1 是flash目录
		 * 2 是资源目录 
		 */		
		public var type:int;
		/**
		 *资源路径 
		 */		
		public var path:String;
		/**
		 *类路径 
		 */		
		public var classPath:String;
		public function get filePath():String
		{
			var mainPath:String = "";

			mainPath = PathManager.SITE_MAIN;
			
			return mainPath+path;
		}
		
		public function startLoad():void
		{
			LoaderManager.Instance.creatAndStartLoad(filePath,BaseLoader.MODULE_LOADER);
		}
	}
}