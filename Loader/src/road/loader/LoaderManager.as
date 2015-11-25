package road.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	public class LoaderManager extends EventDispatcher
	{
		
		public static const ALLOW_MUTI_LOAD_COUNT:int = 5;
		public static const LOAD_FROM_LOCAL:int = 2;
		public static const LOAD_FROM_WEB:int = 1;
		public static const LOAD_NOT_SET:int = 0;
		private static var _instance:LoaderManager;

		public static function get Instance():LoaderManager
		{
			if(_instance == null)
			{
				_instance = new LoaderManager();
			}
			return _instance;
		}

		public function LoaderManager()
		{
			_loaderSaveByID = new Dictionary();
			_loaderSaveByPath = new Dictionary();
			_loadingLoaderList = new Vector.<BaseLoader>();
			_waitingLoaderList = new Vector.<BaseLoader>();
			initLoadMode();
		}

		private var _loadMode:int = LOAD_NOT_SET;
		private var _loaderIdCounter:int = 0;
		private var _loaderSaveByID:Dictionary;
		private var _loaderSaveByPath:Dictionary;
		private var _loadingLoaderList:Vector.<BaseLoader>;
		private var _waitingLoaderList:Vector.<BaseLoader>;
		
		public function creatLoaderByType(filePath:String,type:int,args:URLVariables):BaseLoader
		{
			var loader:BaseLoader;
			switch(type)
			{
				case BaseLoader.BITMAP_LOADER:
					loader = new BitmapLoader(getNextLoaderID(),filePath);
					break;
				case BaseLoader.TEXT_LOADER:
					loader = new TextLoader(getNextLoaderID(),filePath,args);
					break;
				case BaseLoader.DISPLAY_LOADER:
					loader = new DisplayLoader(getNextLoaderID(),filePath);
					break;
				case BaseLoader.BYTE_LOADER:
					loader = new BaseLoader(getNextLoaderID(),filePath);
					break;
				case BaseLoader.COMPRESS_TEXT_LOADER:
					loader = new CompressTextLoader(getNextLoaderID(),filePath,args);
					break;
				case BaseLoader.MODULE_LOADER:
					loader = new ModuleLoader(getNextLoaderID(),filePath);
					break;
			}
			return loader;
		}
		
		public function getFileDataFromLocal(loader:BaseLoader):ByteArray
		{
			return LoaderSavingManager.loadCachedFile(loader.url,false);
		}
		
		public function getLoadMode():int
		{
			return _loadMode;
		}
		
		public function createLoader(filePath:String,type:int,args:URLVariables = null):*
		{
			var loader:BaseLoader;
			if(args == null)
				args = new URLVariables();
			if(type == BaseLoader.BYTE_LOADER || type == BaseLoader.DISPLAY_LOADER
				|| type == BaseLoader.BITMAP_LOADER || type == BaseLoader.MODULE_LOADER)
			{
				args["lv"] = LoaderSavingManager.Version;
			}else if(type == BaseLoader.COMPRESS_TEXT_LOADER || type == BaseLoader.TEXT_LOADER)
			{
				args["rnd"] = Math.random();
			}
			
			loader = getLoaderByURL(filePath,args);
			if(loader == null)
				loader = creatLoaderByType(filePath,type,args);
			_loaderSaveByID[loader.id] = loader;
			_loaderSaveByPath[loader.url] = loader;
			return loader;
		}
		
		public function creatAndStartLoad(filePath:String,type:int,args:URLVariables = null):BaseLoader
		{
			var loader:BaseLoader = createLoader(filePath,type,args);
			startLoad(loader);
			return loader;
		}
		
		public function getLoaderByID(id:int):BaseLoader
		{
			return _loaderSaveByID[id];
		}
		
		public function getLoaderByURL(url:String,args:URLVariables):BaseLoader
		{
			var loader:BaseLoader = _loaderSaveByPath[url];
			return loader
		}
		
		public function getNextLoaderID():int
		{
			return _loaderIdCounter++;
		}
		
		public function saveFileToLocal(loader:BaseLoader):void
		{
			
		}
		
		public function startLoad(loader:BaseLoader):void
		{
			if(loader.isComplete)
			{
				loader.dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,loader));
				return;
			}
			var ba:ByteArray = getFileDataFromLocal(loader);
			if(ba)
			{
				loader.loadFromLocal(ba);
				return;
			}
			if(_loadingLoaderList.length == ALLOW_MUTI_LOAD_COUNT || getLoadMode() == LOAD_NOT_SET)
			{
				_waitingLoaderList.push(loader);
			}else
			{
				_loadingLoaderList.push(loader);
				if(getLoadMode() == LOAD_FROM_WEB || loader.type == BaseLoader.TEXT_LOADER)
				{
					loader.loadFromWeb();
				}else if(getLoadMode() == LOAD_FROM_LOCAL)
				{
					loader.getFilePathFromExternal();
				}
				loader.addEventListener(LoaderEvent.COMPLETE,__onLoadFinish);
			}
		}
		
		private function __onLoadFinish(event:LoaderEvent):void
		{
			event.loader.removeEventListener(LoaderEvent.COMPLETE,__onLoadFinish);
			_loadingLoaderList.splice(_loadingLoaderList.indexOf(event.loader),1);
			tryLoadWaiting();
		}
		
		private function initLoadMode():void
		{
			if(!ExternalInterface.available)
			{
				setFlashLoadWeb();
				return;
			}
			ExternalInterface.addCallback("SetFlashLoadExternal",setFlashLoadExternal);
			setTimeout(setFlashLoadWeb,200);
		}
		
		private function onExternalLoadStop(id:int,path:String):void
		{
			var loader:BaseLoader = getLoaderByID(id);
			loader.loadFromExternal(path);
		}
		
		private function setFlashLoadExternal():void
		{
			_loadMode = LOAD_FROM_LOCAL;
			ExternalInterface.addCallback("ExternalLoadStop",onExternalLoadStop);
			tryLoadWaiting()
		}
		
		private function setFlashLoadWeb():void
		{
			_loadMode = LOAD_FROM_WEB;
			tryLoadWaiting();
		}
		
		private function tryLoadWaiting():void
		{
			if(_waitingLoaderList.length > 0)startLoad(_waitingLoaderList.shift());
		}
		
		public function setup(context:LoaderContext,textLoaderKey:String):void
		{
			DisplayLoader.Context = context;
			TextLoader.TextLoaderKey = textLoaderKey;
			LoaderSavingManager.setup();
		}
	}
}