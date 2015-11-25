package ddt.manager
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import ddt.view.ClientDownloading;
	
	public class DownlandClientManager
	{
		public function DownlandClientManager()
		{
		}
		
		private static var _instance:DownlandClientManager
		public static function get Instance():DownlandClientManager
		{
			if(_instance == null)
			{
				_instance = new DownlandClientManager
			}
			return _instance;
		}
		
		private var _downlandBtnView:ClientDownloading;
		private var _downLandBtnContainer:DisplayObjectContainer;
		public function show(container:DisplayObjectContainer):void
		{
			_downLandBtnContainer = container;
			if(_downlandBtnView == null)
			{
				_downlandBtnView = new ClientDownloading();
			}
			if(container)
			{
				container.addChild(_downlandBtnView);
			}
		}
		
		public function hide():void
		{
			if(_downLandBtnContainer && _downlandBtnView.parent == _downLandBtnContainer)
			{
				_downLandBtnContainer.removeChild(_downlandBtnView);
			}
			_downLandBtnContainer = null;
		}
		
		private var _downlandBtnPos:Point;
		public function setDownlandBtnPos(pos:Point):void
		{
			_downlandBtnPos = pos;
			if(_downlandBtnPos)
			{
				_downlandBtnView.x = pos.x;
				_downlandBtnView.y = pos.y;
			}
		}

	}
}