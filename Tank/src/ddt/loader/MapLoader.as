package ddt.loader
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import road.loader.DisplayLoader;
	
	import ddt.data.MapInfo;
	import ddt.manager.PathManager;

	public class MapLoader extends EventDispatcher
	{
		private var _info:MapInfo;
		
		public function get info():MapInfo
		{
			return _info;
		}
		
		private var _back:Bitmap;
		public function get backBmp():Bitmap
		{
			return _back;
		}
		
		private var _fore:Bitmap;
		public function get foreBmp():Bitmap
		{
			return _fore;
		}
		
		private var _dead:Bitmap;
		public function get deadBmp():Bitmap
		{
			return _dead;
		}
		
		private var _loaderBack:DisplayLoader;
		
		private var _loaderFore:DisplayLoader;
		
		private var _loaderDead:DisplayLoader;
		
		private var _count:int;
		
		private var _total:int;
		
		private var _loadCompleted:Boolean;
		
		public function get completed():Boolean
		{
			return _loadCompleted;
		}
		
		public function MapLoader(info:MapInfo)
		{
			_info = info;
		}
		
		public function load():void
		{
			_count = 0;
			_total = 0;
			_loadCompleted = false;
			if(_info.DeadPic != "")
			{
				_total ++;
				_loaderDead = new DisplayLoader(0,PathManager.solveMapPath(_info.ID,_info.DeadPic,"png"));
				_loaderDead.loadSync(__deadComplete,3);
			}
			
			if(_info.ForePic != "")
			{
				_total ++;
				_loaderFore = new DisplayLoader(0,PathManager.solveMapPath(_info.ID,_info.ForePic,"png"));
				_loaderFore.loadSync(__foreComplete,3);
			}
			
			_total ++;
			_loaderBack = new DisplayLoader(0,PathManager.solveMapPath(_info.ID,_info.BackPic,"jpg"));
			_loaderBack.loadSync(__backComplete,3);
		}
		
		private function __backComplete(loader:DisplayLoader):void
		{
			if(loader.isSuccess)
			{
				_back = loader.content as Bitmap;
				count();
			}
		}
		
		private function __foreComplete(loader:DisplayLoader):void
		{
			if(loader.isSuccess)
			{
				_fore = loader.content as Bitmap;
				count();
			}
		}
		
		private function __deadComplete(loader:DisplayLoader):void
		{
			if(loader.isSuccess)
			{
				_dead = loader.content as Bitmap;
				count();
			}
		}
		
		private function count():void
		{
			_count ++;
			if(_count == _total)
			{
				_loadCompleted = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}