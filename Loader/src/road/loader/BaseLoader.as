package road.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	[Event(name="complete",type="road.loader.LoaderEvent")]
	[Event(name="loadError",type="road.loader.LoaderEvent")]
	[Event(name="progress",type="road.loader.LoaderEvent")]
	public class BaseLoader extends EventDispatcher
	{
		public static const BITMAP_LOADER:int = 0;
		public static const BYTE_LOADER:int = 3;
		public static const DISPLAY_LOADER:int = 1;
		public static const TEXT_LOADER:int = 2;
		public static const MODULE_LOADER:int = 4;
		public static const COMPRESS_TEXT_LOADER:int = 5;
		public static const TRY_LOAD_TIMES:int = 3;
		
		public function BaseLoader(id:int,url:String,args:URLVariables = null) 
		{
			_url = url;
			_args = args;
			_id = id;
			_loader = new URLLoader();
			addEvent();
		}

		public var loadCompleteMessage:String;
		public var loadErrorMessage:String;
		public var loadProgressMessage:String;
		protected var _args:URLVariables;
		protected var _id:int;
		protected var _isComplete:Boolean;
		protected var _isSuccess:Boolean;
		protected var _loader:URLLoader;
		protected var _progress:Number;
		protected var _request:URLRequest;
		protected var _url:String;
		protected var _isLoading:Boolean;
		private var _currentLoadPath:String;
		protected var _currentTryTime:int = 0;
		protected var _func:Function;
		protected var _starting:Boolean;
		protected var _tryTime:int = 3;
		
		public function get args():URLVariables
		{
			return _args;
		}
		
		public function get content():*
		{
			return _loader.data;
		}
		
		public function getFilePathFromExternal():void
		{
			ExternalInterface.call("ExternalLoadStart",_id,_url);
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get isComplete():Boolean
		{
			return _isComplete;
		}
		
		public function get isSuccess():Boolean
		{
			return _isSuccess;
		}
		public function set isSuccess(value:Boolean):void
		{
			_isSuccess = value;
		}
		
		public function loadFromExternal(path:String):void
		{
			startLoad(path);
		}
		
		public function loadFromLocal(data:ByteArray):void
		{
			
		}
		
		public function loadFromWeb():void
		{
			startLoad(_url);
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function get type():int
		{
			return BYTE_LOADER;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		protected function __onDataLoadComplete(event:Event):void
		{
			removeEvent();
			_loader.close();
			fireComplete();			

		}
		
		protected function onCompleted():void
		{
			if(_func != null)
			{
				_func(this);
			}
		}
		
		protected function fireComplete():void
		{
			_isSuccess = true;
			_isComplete = true;
			_isLoading = false;
			onCompleted();
			dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,this));
		}
		
		protected function __onIOError(event:IOErrorEvent):void
		{
			onLoadError();
		}
		
		protected function __onProgress(event:ProgressEvent):void
		{
			_progress = event.bytesLoaded/event.bytesTotal;
			if(loadProgressMessage)
				loadProgressMessage = loadProgressMessage.replace("{progress}",String(Math.round(_progress*100)));
			dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS,this));
		}
		
		protected function __onStatus(event:HTTPStatusEvent):void
		{
			if(event.status > 399)
			{
				onLoadError();
			}
		}
		
		protected function addEvent():void
		{
			_loader.addEventListener(Event.COMPLETE,__onDataLoadComplete);
			_loader.addEventListener(ProgressEvent.PROGRESS,__onProgress);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,__onStatus);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,__onIOError);
		}
		
		protected function getLoadDataFormat():String
		{
			return URLLoaderDataFormat.BINARY;
		}
		
		protected function onLoadError():void
		{
			if(_currentTryTime < _tryTime)
			{
				startLoad(_currentLoadPath);
				_currentTryTime++;
			}else
			{
				removeEvent();
				_loader.close();
				_isComplete = true;
				_isLoading = false;
				dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,this));
				dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,this));
			}
		}
		
		protected function removeEvent():void
		{
			_loader.removeEventListener(Event.COMPLETE,__onDataLoadComplete);
			_loader.removeEventListener(ProgressEvent.PROGRESS,__onProgress);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,__onStatus);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR,__onIOError);
		}
		
		protected function startLoad(path:String):void
		{
			_starting = true
			_currentLoadPath = path;
			_loader.dataFormat = getLoadDataFormat();
			_request = new URLRequest(path);
			_request.data = _args;
			_isLoading = true;
			_loader.load(_request);
		}
		
		public var analyzer:DataAnalyzer;
		
		public function dispose():void
		{
		}
		public function loadSync(func:Function = null,tryTime:int = 1):void
		{
			_func = func;
			_tryTime  = tryTime;
			if(!_starting)
			{
				startLoad(_url);

			}
		}
	}
	
}