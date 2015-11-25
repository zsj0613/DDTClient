package ddt.register
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import ddt.data.ServerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.BossBoxManager;
	import ddt.manager.ItemManager;
	import ddt.manager.JSHelper;
	import ddt.manager.MapManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.TimeManager;
	import ddt.register.manager.RegisterAlertManager;
	import ddt.register.request.LoadCheckName;
	import ddt.register.request.LoadServerList;
	import ddt.register.request.RegisterCharacter;
	import ddt.register.uicontrol.HAlertDialog;
	import ddt.register.view.MainFigureView;
	import ddt.register.view.RegisterSoundManager;
	import ddt.request.LoadServerListAction;
	import ddt.request.LoginAction;
	import ddt.states.StateType;
	import ddt.view.background.BgView;
	import ddt.manager.PathManager;
	
	import road.serialize.xml.XmlSerialize;

	
	public class RegisterState extends Sprite
	{
		private var _root:Sprite;
		private var _config:XML;
		private var _username:String;
		private var _password:String;
		private var _mainFigureView:MainFigureView;
		private var _bigLoading:MovieClip;
		private var _chooeseSex:Boolean;
		private var _chooeseNickname:String = "";
		private var _loadingLayer:Sprite;
		private var _alertLayer:Sprite;
		public static var Login_Path:String = "default.aspx";

		//public static var Resource_Path:String = "res/";

//登录失败返回		
		private var _loginRequest:URLRequest;
		
		
		public function RegisterState(root:Sprite,config:XML,username:String,password:String)
		{		
			_root = root;
			_config = config;
			_username = username;
			_password = password;			
			_loginRequest = new URLRequest("login.do?method=logout");
			init();			
		}
		
		private function init():void
		{
			initView();
			trySetupCore();
		}
		

		
		private function initView():void
		{
			//debugSetup(_root);
			addEventListener(Event.ADDED_TO_STAGE,__onAddToStage);
			addEventListener(MouseEvent.CLICK,__clickFocus);
			RegisterSoundManager.instance.setConfig(true,true,100,100);
			RegisterSoundManager.instance.setup(["fin"],PathManager.SITE_MAIN);
			_mainFigureView = new MainFigureView(_username,_password);
			_mainFigureView.addEventListener(MainFigureView.ANIMATION_OUT_COMPLETE, __animationOutComplete);
			_mainFigureView.addEventListener(MainFigureView.ANIMATION_IN_COMPLETE, __animationInComplete);
			_mainFigureView.addEventListener(MainFigureView.TRY_ENTER_GAME, __tryEnterGameHandler);
			addChild(_mainFigureView);
			
			_loadingLayer = new Sprite();
			
			var BigLoadingClass:Class = getDefinitionByName("LoadingAsset") as Class;
			_bigLoading = new  BigLoadingClass();
			_bigLoading.addEventListener(Event.ENTER_FRAME,__bigLoadingFrameHandler);
			
			_alertLayer = new Sprite();
			RegisterAlertManager.Instance.setup(_alertLayer);
			//debugText("initViewComplete");
		}
		
		
		private function __onAddToStage(event:Event):void
		{
			_root.addChild(_loadingLayer);
			_root.addChild(_alertLayer);
			__clickFocus(null);
		}
		
		private function __clickFocus(event:Event):void
		{
			if(_mainFigureView)_mainFigureView.setFoucs();
		}
		
		// 离场动画完毕
		private var _hasShowLoading:Boolean;
		private function __animationOutComplete(e:Event):void
		{
			_loadingLayer.addChild(_bigLoading);
			_root.addChild(_loadingLayer);
			_root.addChild(_alertLayer);
			_hasShowLoading = true;
		//	tryGoIntoGame();
		}
		// 出场动画完毕
		private var _animationIntroComplete:Boolean;
		private function __animationInComplete(event:Event):void
		{
			_animationIntroComplete = true;
			trySetupCore();
			__clickFocus(null);
		}
		
//===============================================文件加载完毕进行一系列操作===========================================

		
		private var testCurrentLoaded:int;
		private function __onLoadProgress(event:ProgressEvent):void
		{
			if(testCurrentLoaded != event.bytesLoaded)
			{
				testCurrentLoaded = event.bytesLoaded;
			}
			setLoadingPercent(event.bytesLoaded+20);
		}
		
		private var _hasSetup:Boolean;
		private var _serverListXml:XML;
		private var _agentID:int;
		private var _zoneName:String;
		private function trySetupCore():void
		{
			if(!_hasSetup && _animationIntroComplete)
			{
				_hasSetup = true;
				Init(_root,_config,_username,_password,coreSetupCallback);
				_root.addChild(_loadingLayer);
				_root.addChild(_alertLayer);
				__clickFocus(null);
			}
		}
		
		private function coreSetupCallback():void
		{
			BgView.Instance.hideBg();
			creatLogin();
			__clickFocus(null);
		}
		
		
		
		
		private var _hasLoadedTemplate:Boolean;
		private function creatLogin():void
		{
			loadLogin(__creatLoginComplete,"");
		}
		
		private function loadLogin(completeCall:Function,nickName:String):void
		{
			new LoginAction(PlayerManager.Instance.Account,nickName).loadSync(completeCall,3);
		}
		
		private function __creatLoginComplete(loader:Object):void
		{
			if(loader.isSuccess)
			{
				JSHelper.setFavorite(true);
				if(ItemManager.Instance.goodsTemplates == null)
				{
					
					ItemManager.Instance.addEventListener("templateReady",__waitForItemTemplate);
				}
				else
				{
					__waitForItemTemplate(null);
				}
			}else
			{
				HAlertDialog.show("警告：",loader.message,true,refreshPageToLogin,true,null,refreshPageToLogin);
				_mainFigureView.TipText = loader.message;
			}
		}
		
		private function __waitForItemTemplate(event:Event):void
		{
			if(ShopManager.Instance.initialized == false)
			{
				//trace("LoadItem")
				ShopManager.Instance.addEventListener("shopManagerReady",__waitForShopGoods);
			}else
			{
				__waitForShopGoods(null);
			}
		}
		
		private function __waitForShopGoods(evt:Event):void
		{
			//trace("LoadShop")
			_hasLoadedTemplate = true;
			new LoadServerListAction().loadSync(loadServerListComplete,6);			
		}
		private function loadServerListComplete(loader:LoadServerListAction):void
		{
			tryEnter();
		}
		
		
//==============================================注册登录相关的一系列操作=================================================
		private function __tryEnterGameHandler(event:Event):void
		{
			setLoadingPercent(90);
			_chooeseSex = _mainFigureView.BoySelected;
			_chooeseNickname = _mainFigureView.Nickname;
			new LoadCheckName(_chooeseNickname).loadSync(__registerCharacter);
		}
		
		private var _isTryEnter:Boolean;
		private function __registerCharacter(loader:LoadCheckName):void
		{
			if(_mainFigureView)_mainFigureView.setCheckTxt(loader);
			if(loader.isSuccess)
			{
				_isTryEnter = true;
				tryEnter();
				if(_mainFigureView)
					_mainFigureView.doHideAnimation();
			//	new StatisticRequest(SolveCountPath,_agentID).loadSync();
			}
		}
		
		private var _loginComplete:Boolean;
		private function loginAndRegister():void
		{
			//trace("loginAndRegister")
			var registerChar:RegisterCharacter = new RegisterCharacter(_username,_password,_chooeseSex,_chooeseNickname);
			registerChar.loadSync(__registerComplete);
		}
		
		private function __registerComplete(loader:RegisterCharacter):void
		{
			if(loader.isSuccess)
			{
				PlayerManager.Instance.Self.loadPlayerItem();
				loadLogin(__loginCompleteHandler,_chooeseNickname);
			}else
			{
				HAlertDialog.show("警告：",loader.message,true,refreshPageToLogin,true,null,refreshPageToLogin);
			}
		}
		
		private function __loginCompleteHandler(loader:Object):void
		{
		//	debugText(loader.isSuccess);
		//	debugText(loader.message);
		//	debugText(_playerMangerInstance.Instance.Self.TutorialProgress);
			
			if(loader.isSuccess)
			{
				_loginComplete = true;
				tryEnter();
			}else
			{
				HAlertDialog.show("警告：",loader.message,true,refreshPageToLogin,true,null,refreshPageToLogin);
				_mainFigureView.TipText = "登陆失败!";
			}
		}
		
//===============================================进入流程控制===============================================
		
		private var _loadingStepTimer:Timer;
		private function tryEnter():void
		{
			//trace("tryEnter")
			if(!_loginComplete && _isTryEnter && _hasLoadedTemplate)
			{
				loginAndRegister();
			}
			
			
			if(_isTryEnter && _hasLoadedTemplate && _loginComplete)
			{				
				setLoadingPercent(99);
				_bigLoading.gotoAndPlay(2);
				BgView.Instance.showBg();
				StateManager.setState(StateType.SERVER_LIST);
				dispose();
			}
		}
//================================================登陆========================================
		
		
		private function __onLoadingStepTimer(event:TimerEvent):void
		{
			if(_bigLoading["mcProgress"].progress == _bigLoading["mcProgress"].Max_Progress)
			{
				_loadingStepTimer.removeEventListener(TimerEvent.TIMER,__onLoadingStepTimer);
				_loadingStepTimer.stop();
				_loadingStepTimer = null;
			}else
			{
				_bigLoading["mcProgress"].next();
			}
		}
		
		public static var LoadingResultMsg:String = "";
		
		private function setLoadingPercent(percent:int):void
		{
			_bigLoading["mcProgress"].progress = percent;
		}
		
		private function removeEvent():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,__onAddToStage);

			
			if(_mainFigureView)
			{
				_mainFigureView.removeEventListener(MainFigureView.ANIMATION_OUT_COMPLETE, __animationOutComplete);
				_mainFigureView.removeEventListener(MainFigureView.ANIMATION_IN_COMPLETE, __animationInComplete);
				_mainFigureView.removeEventListener(MainFigureView.TRY_ENTER_GAME, __tryEnterGameHandler);
			}
			
			SocketManager.Instance.removeEventListener("templateReady",__waitForItemTemplate);
			SocketManager.Instance.removeEventListener("shopManagerReady",__waitForShopGoods);
			
			if(_loadingStepTimer)
				_loadingStepTimer.removeEventListener(TimerEvent.TIMER,__onLoadingStepTimer);
		}
		
		private function __bigLoadingFrameHandler(event:Event):void
		{
			if(_bigLoading == null)
				return;
			if(_bigLoading.currentFrame == _bigLoading.totalFrames)
			{
				_bigLoading.removeEventListener(Event.ENTER_FRAME,__bigLoadingFrameHandler);
				__loadingPlayComplete();
			}
		}
		
		private function __loadingPlayComplete():void
		{
			if(_bigLoading)
				_loadingLayer.removeChild(_bigLoading);
			_bigLoading = null;
			if(_loadingLayer && _loadingLayer.parent)
				_loadingLayer.parent.removeChild(_loadingLayer);
			_loadingLayer = null;
		}
		
		private function refreshPageToLogin():void
		{
			navigateToURL(_loginRequest,"_self");
		}
		

		

		

		
		private function closeSounds():void
		{
			RegisterSoundManager.instance.stopAllSound();
			RegisterSoundManager.instance.stopMusic();
		}

		public function dispose():void
		{
			closeSounds();
			removeEvent();

			
			if(_mainFigureView)
				_mainFigureView.dispose();
			_mainFigureView = null;
			
			if(_loadingStepTimer)
			{
				_loadingStepTimer.stop();
				_loadingStepTimer.removeEventListener(TimerEvent.TIMER,__onLoadingStepTimer);
			}
			_loadingStepTimer = null;
			_config = null;
			_root = null;
			
			if(_alertLayer && _alertLayer.parent)
				_alertLayer.parent.removeChild(_alertLayer);
		}
	}
}