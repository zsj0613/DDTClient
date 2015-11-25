package ddt.view.im
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.im.PhotoFrame;
	
	//import ddt.manager.PathManager;
	//import ddt.request.LoadPlayerWebsiteInfo;

	public class IMFriendPhotoCell extends Sprite
	{
		private var _load : Loader;
		private var _url  : URLRequest;
		private var _context:LoaderContext;
		private var _websiteInfo : Dictionary;
		private var _photoFrame  : PhotoFrame;
		private var _mask        : Shape;
		public function IMFriendPhotoCell()
		{
			super();
			_load = new Loader();
			_load.contentLoaderInfo.addEventListener(Event.COMPLETE,        __loadCompleteHandler);
			_load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __loadIoErrorHandler);
			_context = new LoaderContext(true);
			_photoFrame = new PhotoFrame();
			_mask = new Shape();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0,0,54,55);
			_mask.graphics.endFill();
			
		}
		//private var _loadPlayerInfo : LoadPlayerWebsiteInfo;
		public function set playerLoginName($loginName : String) : void
		{
			var para : Object = new Object();
			para["LoginName"] = $loginName;
		//	if(PathManager.solveWebPlayerInfoPath($loginName) != "")
//			new LoadPlayerWebsiteInfo(PathManager.solveWebPlayerInfoPath("")).loadSync(__returnWebSiteInfoHandler);//测试
			//_loadPlayerInfo = new LoadPlayerWebsiteInfo(PathManager.solveWebPlayerInfoPath($loginName));
			//_loadPlayerInfo.loadSync(__returnWebSiteInfoHandler);
		}
	//	private function __returnWebSiteInfoHandler(action : LoadPlayerWebsiteInfo) : void
		//{
		//	_websiteInfo = action.info;
		//	if(_websiteInfo["tinyHeadUrl"] != null && _websiteInfo["tinyHeadUrl"] != "")
		//	loadImage(_websiteInfo["tinyHeadUrl"]);
		//} 
		
		
		//private function loadImage($url : String) : void
		//{
		//	_url  = new URLRequest($url);
		////	_load.load(_url,_context);
		//}
		private function __loadCompleteHandler(evt : Event) : void
		{
//			_load.contentLoaderInfo.removeEventListener(Event.COMPLETE,        __loadCompleteHandler);
//			_load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __loadIoErrorHandler);
			this.addChildAt(_load,0);
			_load.x = 4;
			_load.y = 5;
			_load.mask = _mask;
			addChild(_photoFrame);
			addChild(_mask);
		}
		public function clearSprite() : void
		{
		//	if(_loadPlayerInfo)_loadPlayerInfo.close();
			if(_load)_load.unload();
			while(this.numChildren)
			{
				this.removeChildAt(0);
			}
			this.graphics.clear();
		}
		private function __loadIoErrorHandler(evt : IOErrorEvent) : void
		{
//			_load.contentLoaderInfo.removeEventListener(Event.COMPLETE,        __loadCompleteHandler);
//			_load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __loadIoErrorHandler);
		}
		public function dispose() : void
		{
			if(_mask && _mask.parent)
			{
				_mask.graphics.clear();
				_mask.parent.removeChild(_mask);
			}
			_mask = null;
			
			if(_load)
			{
				_load.contentLoaderInfo.removeEventListener(Event.COMPLETE,        __loadCompleteHandler);
				_load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __loadIoErrorHandler);
			}
			clearSprite();
			
			if(_photoFrame && _photoFrame.parent)
			{
				_photoFrame.parent.removeChild(_photoFrame);
			}
			_photoFrame = null;
			
			_url  = null;
			_load = null;
			_context = null;
			_websiteInfo = null;
	//		_loadPlayerInfo = null;
			
			if(this.parent)
				this.parent.removeChild(this);
		}
		
	}
}