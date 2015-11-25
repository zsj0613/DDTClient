package road.loader
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class LoaderSavingManager extends EventDispatcher
	{
		public function LoaderSavingManager()
		{
			
		}
		
		private static const LOCAL_FILE:String = "lsj/files";
		private static var _cacheFile:Boolean = false;
		private static var _version:int;
		private static var _files:Object;
		private static var _saveTimer:Timer;
		private static var _so:SharedObject;
		private static var _changed:Boolean;
		private static var _cache:Dictionary;
		private static var _save:Array;
		
		public static function get Version():int
		{
			return _version;
		}
		
		public static function set cacheAble(value:Boolean):void
		{
			_cacheFile = value;
		}
		
		public static function get cacheAble():Boolean
		{
			return _cacheFile;
		}
		
		public static function setup():void
		{
			_cacheFile = false;
			_cache = new Dictionary();
			_save = new Array();
			loadFilesInLocal();
		}
		
		public static function applyUpdate(fromv:int,tov:int,updatelist:Array):void
		{
			if(tov <= fromv) return;
			if(_version < tov)
			{
				if(_version < fromv)
				{
					//当前版本太旧，清除所有缓存
					_so.data["data"] = _files = new Dictionary();
				}
				else
				{
					var updated:Array = new Array();
					for each(var s:String in updatelist)
					{
						var t:String = getPath(s);
						t = t.replace("*","\\w*");
						updated.push(new RegExp("^"+t));
					}
					
					var temp:Array = new Array();
					for(var f:String in _files)
					{
						if(hasUpdate(f,updated))
						{
							temp.push(f);
						}
					}
					
					for each(var n:String in temp)
					{
						trace("clear cache:",n);
						delete _files[n];
					}
				}
				_version = tov;
				_files["version"] = tov;
				_changed = true;
			}
		}
		
		public static function clearFiles(filter:String):void
		{
			if(_files)
			{
				var updated:Array = new Array();
				var t:String = getPath(filter);
				t = t.replace("*","\\w*");
				updated.push(new RegExp("^"+t));
				
				var temp:Array = new Array();
				for(var f:String in _files)
				{
					if(hasUpdate(f,updated))
					{
						temp.push(f);
					}
				}
				
				for each(var n:String in temp)
				{
					trace("clear cache:",n);
					delete _files[n];
				}
				
				try
				{
					if(_cacheFile)
					{
						_so.flush(20 * 1024 * 1024);
					}
				}
				catch(e:Error){}
			}
		}
		
		private static function loadFilesInLocal():void
		{
			try
			{
				_so = SharedObject.getLocal(LOCAL_FILE);
				_so.addEventListener(NetStatusEvent.NET_STATUS,__netStatus);
				_files = _so.data["data"];
				if(_files == null)
				{
					_files = new Object();
					_so.data["data"] = _files;
					_files["version"] = _version = -1;
					_cacheFile = false;
				}
				else
				{
					_version = _files["version"];
					_cacheFile = true;
				}
			}
			catch(e:Error){}
		}
		
		/**
		 * 替换掉http://..../ 
		 */		
		private static const _reg1:RegExp = /http:\/\/[\w|.|:]+\//i;
		/**
		 * 替换: . / 
		 */		
		private static const _reg2:RegExp = /[:|.|\/]/g;
		private static function getPath(path:String):String
		{
			//只取问号前面部分
			var index:int = path.indexOf("?");
			if(index != -1)
			{
				path = path.substring(0,index)
			}
			path = path.replace(_reg1,"");
			return path.replace(_reg2,"-");
		}
		
		
		public static function saveFilesToLocal():void
		{
			try
			{
				if(_files && _changed && _cacheFile)
				{
					var state:String = _so.flush(20 * 1024 * 1024);
					if(state != SharedObjectFlushStatus.PENDING)
					{
						var tick:int = getTimer();
						if(_save.length > 0)
						{
							var obj:Object = _save[0];
							var so:SharedObject = SharedObject.getLocal(obj.p);
							so.data["data"] = obj.d;
							so.flush();
							_files[obj.p] = true;
							_so.flush();
							_save.shift();
							trace("save local data spend:",getTimer() - tick,"  left:",_save.length);
						}
						if(_save.length == 0)
							_changed = false;
					}
				}	
			}
			catch(e:Error){}
		}
		private static function hasUpdate(path:String,updateList:Array):Boolean
		{
			for each(var s:RegExp in updateList)
			{
				if(path.match(s))
				{
					return true;
				}
			}
			return false;
		}
		
		public static function loadCachedFile(path:String,cacheInMem:Boolean):ByteArray
		{
			if(_files)
			{
				var p:String = getPath(path);
				var tick:int = getTimer();
				var f:ByteArray = _cache[p];
				if(f == null && _files[p])
				{
					var so:SharedObject = SharedObject.getLocal(p);
					f = so.data["data"] as ByteArray;
					if(f && cacheInMem)
					{
						_cache[p] = f;
					}
				}
				if(f)
				{
					trace("get{local:",getTimer() - tick,"ms}",path);
					return f;
				}
			}
			trace("get{network}",path);
			return null;
		}
		
		public static function cacheFile(path:String,data:ByteArray,cacheInMem:Boolean):void
		{
			if(_files)
			{
				var p:String = getPath(path);
				_save.push({p:p,d:data});
				if(cacheInMem)
				{
					_cache[p] = data;
				}
				_changed = true;
			}
		}
		
		private static var _retryCount:int = 0;
		private static function __netStatus(event:NetStatusEvent):void
		{
			trace(event.info.code);
			switch (event.info.code) 
			{
				case "SharedObject.Flush.Failed":
					//第一次用户同意时，会保存失败，重试2次还失败，放弃
					if(_retryCount < 1)
					{
						_so.flush(20 * 1024 * 1024);
						_retryCount ++;
					}
					else
					{
						cacheAble = false;
					}
					break;
				default:
					_retryCount = 0;
					//saveFilesToLocal();
					break;
			}
		}
		
		/**
		 * 更新模块配置,支持*的通配符
		 * @param config
		 *  <version from="versionid" to="vid">
		 * 		<file value="*" />
		 * 		<file value="image/*.png" />
		 *  </version>
		 * 
		 */		
		public static function parseUpdate(config:XML):void
		{
			try
			{
				var vs:XMLList = config..version;
				for each(var unode:XML in vs)
				{
					var fromv:int = int(unode.@from);
					var tov:int = int(unode.@to);
					var fs:XMLList = unode..file;
					var updatelist:Array = new Array();
					for each(var fn:XML in fs)
					{
						updatelist.push(String(fn.@value))
					}
					applyUpdate(fromv,tov,updatelist);
				}
			}
			catch(e:Error)
			{
				//更新失败，清除所有的缓存
				_version = -1;
				_so.data["data"] = _files = new Dictionary();
				_changed = true;
			}
			saveFilesToLocal();
		}
		
		public static function  get hasFileToSave():Boolean
		{
			return _cacheFile && _changed;
		}
	}
}