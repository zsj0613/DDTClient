package {
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	import road.loader.BaseLoader;
	import road.loader.LoaderEvent;
	import road.loader.LoaderManager;
	import road.loader.LoaderSavingManager;
	import road.loader.ModuleLoader;
	import road.utils.ClassUtils;
	

	[SWF(width = "1000",height = "600",frameRate = "25")]
	public class Loading extends Sprite
	{
		private var _bigLoadingAsset:LoadingAsset;
		private var _config:XML;//config.xml
		private var _loadTimer:Timer;
		private var _configLoaderTryTimer:Timer;
		private var _user:String = "";
		private var _pass:String = "";
		private var _version:String = "00001";
		private var _configLoader:BaseLoader;
		
		private var InitFunction:String = "Init";
		private var RegisterInitFunction:String = "ddt.register.EnterRegister";
		private var _configURL:String = "config.xml";
		private var _swfPath:String = "swf/";
		private var _ashxPath:String = "ashx/";
		
		private var _coreLoader:ModuleLoader;
		
		
		public function Loading()
		{		
			if(stage)
			{
				__addToStage(null);
			}else
			{
				addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			}
		}
		
		private function __addToStage(event:Event):void
		{	
			this.init();
		}
		

		private function init():void
		{
			_loadTimer = new Timer(3000);
			_user = stage.loaderInfo.parameters["user"];
			_pass = stage.loaderInfo.parameters["key"];
			
			var context :LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			LoaderManager.Instance.setup(context, String(Math.random()));
			ClassUtils.uiSourceDomain = context.applicationDomain;
			loadConfig();
		}
		
		
		
		private function loadConfig():void
		{		
			this._configLoader = LoaderManager.Instance.creatAndStartLoad(this._configURL, BaseLoader.TEXT_LOADER);
			this._configLoader.addEventListener(Event.COMPLETE, this.__onConfigLoadComplete);
		}
		
		private function __onConfigLoadComplete(event:LoaderEvent):void
		{
			this._configLoader.removeEventListener(Event.COMPLETE, this.__onConfigLoadComplete);
			
			var a:XML = new XML(event.loader.content);
			
			if(a && a != "")
			{	
				var temp:XMLList = a..update;
				/**
				 *  <version from="versionid" to="vid">
				 * 		<file value="*" />
				 * 		<file value="image/*.png" />
				 *  </version>
				 * 
				 */
				for each (var note:XML in temp)
				{
					LoaderSavingManager.parseUpdate(note);
				}
				
				temp = a..config;
				
				if(temp.length() > 0)
				{
					_config = temp[0];
					_version = _config.VERSION.@value;
					_swfPath = _config.SWF_PATH.@value;
					_ashxPath = _config.ASHX_PATH.@value;
					loadSelectList();
				}
				
			}else
			{
				throw new ErrorEvent("CONFIG_LOAD_ERROR",true,false,"Load config file fail! please try again later!");
			}   
		}
		
		
		
		private function loadSelectList():void
		{
			 var urlVar:URLVariables = new URLVariables();
			 urlVar["username"] = _user;
			 this._configLoader = LoaderManager.Instance.creatAndStartLoad(_ashxPath+"LoginSelectList.ashx", BaseLoader.TEXT_LOADER,urlVar);
             this._configLoader.addEventListener(Event.COMPLETE, this.__selectListComplete);
		}

		
		private function __selectListComplete(event:LoaderEvent):void
		{
	
            this._configLoader.removeEventListener(Event.COMPLETE, this.__selectListComplete);
			var xmllist:XMLList = XML(event.loader.content)..Item;
			if(xmllist.length() < 1)
			{
				_bigLoadingAsset = new LoadingAsset();
				_bigLoadingAsset.gotoAndStop(1);
				addChild(_bigLoadingAsset);
				beginLoadRegister();
			}else
			{
				_bigLoadingAsset = new LoadingAsset();
				_bigLoadingAsset.gotoAndStop(1);
				addChild(_bigLoadingAsset);
				beginLoadCore();
			} 
		}
		
		
		
		
		private function beginLoadCore():void
		{	
			var CorePath:String = _swfPath+"library"+_version+".swf";
			this._coreLoader = LoaderManager.Instance.createLoader(CorePath, BaseLoader.MODULE_LOADER);
			this._coreLoader.addEventListener(LoaderEvent.COMPLETE, __loadCoreComplete);
			this._coreLoader.addEventListener(LoaderEvent.PROGRESS,__LoadingProgress);
			LoaderManager.Instance.startLoad(this._coreLoader);
		}
		
		private function __LoadingProgress(event:LoaderEvent):void
		{
			_bigLoadingAsset.mcProgress.progress = (int)(event.loader.progress * 69)+21;
		}
		
		private function __loadCoreComplete(event:Event):void
		{
			_bigLoadingAsset.mcProgress.progress = 90;
			_coreLoader.removeEventListener(LoaderEvent.COMPLETE, this.__loadCoreComplete);
			_coreLoader.removeEventListener(LoaderEvent.PROGRESS,__LoadingProgress);
			
			var ator:Function = ClassUtils.getDefinition(InitFunction) as Function;
				ator(this,_config,_user,_pass);
				
			addChild(_bigLoadingAsset);
			_bigLoadingAsset.addFrameScript(_bigLoadingAsset.totalFrames -1,__playComplete);
			addEventListener(Event.ENTER_FRAME,checkStateHandler);
			_loadTimer.addEventListener(TimerEvent.TIMER,onLoadTimer);
			_loadTimer.start();
		}
		
		private function checkStateHandler(e:Event):void
		{
			var game:Object = ClassUtils.getDefinition("DDT") as Object;
			if(game.CheckState())
			{
				removeEventListener(Event.ENTER_FRAME,checkStateHandler);
				_loadTimer.stop();
				_loadTimer.removeEventListener(TimerEvent.TIMER,onLoadTimer);
				_bigLoadingAsset.gotoAndPlay(102);
			} 
		}
		
		private function onLoadTimer(e:TimerEvent):void
		{
			_bigLoadingAsset.mcProgress.next();
		}
		
		private function __playComplete():void
		{
			this.removeChild(_bigLoadingAsset);
			_bigLoadingAsset = null;
		}
		
//		Load Register
		private function beginLoadRegister():void
		{
			var CorePath:String = _swfPath+"library"+_version+".swf";
			this._coreLoader = LoaderManager.Instance.createLoader(CorePath, BaseLoader.MODULE_LOADER);
			this._coreLoader.addEventListener(LoaderEvent.COMPLETE,__loadRegisterComplete);
			this._coreLoader.addEventListener(LoaderEvent.PROGRESS,__loadRegisterProgress);
			LoaderManager.Instance.startLoad(this._coreLoader);
		}
		
		private function __loadRegisterProgress(event:LoaderEvent):void
		{
			_bigLoadingAsset.mcProgress.progress = (int)(event.loader.progress * 100);
		}
		
		private var _loadRegisterComplete:Boolean;
		private function __loadRegisterComplete(event:Event):void
		{
			_loadRegisterComplete = true;
			tryEnterRegister();
		}
		private var _hasEnterRegister:Boolean;
		private function tryEnterRegister():void
		{
			_coreLoader.removeEventListener(LoaderEvent.COMPLETE,__loadRegisterComplete);
			_coreLoader.removeEventListener(LoaderEvent.PROGRESS,__loadRegisterProgress);
			if( _loadRegisterComplete && !_hasEnterRegister)
			{
				this.removeChild(_bigLoadingAsset);
				_bigLoadingAsset = null;
				_hasEnterRegister = true;
				var ator:Function = ClassUtils.getDefinition(RegisterInitFunction) as Function;
				ator(this,_config,_user,_pass);
			}
		}
	}
}