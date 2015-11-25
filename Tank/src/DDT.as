package 
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.Font;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import ddt.data.AccountInfo;
	import ddt.data.ColorEnum;
	import ddt.data.Config;
	import ddt.data.CrytoHelper;
	import ddt.data.PathInfo;
	import ddt.events.StartupEvent;
	import ddt.loader.StartupResourceLoader;
	import ddt.manager.BallManager;
	import ddt.manager.ChatManager;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.ConsortiaLevelUpManager;
	import ddt.manager.EffortManager;
	import ddt.manager.EnthrallManager;
	import ddt.manager.FeedbackManager;
	import ddt.manager.FightLibManager;
	import ddt.manager.FilterWordManager;
	import ddt.manager.HotSpringManager;
	import ddt.manager.ItemManager;
	import ddt.manager.JSHelper;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MapManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.QueueManager;
	import ddt.manager.RoomManager;
	import ddt.manager.RouletteManager;
	import ddt.manager.SharedManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StageFocusManager;
	import ddt.manager.StateManager;
	import ddt.manager.StatisticManager;
	import ddt.manager.TaskManager;
	import ddt.manager.TimeManager;
	import ddt.manager.WorldBossManager;
	import ddt.request.LoadLanguageAction;
	import ddt.request.StatisticExitLoginTool;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;
	import ddt.view.background.BgView;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.BuggleView;
	import ddt.view.common.WaitingView;
	import ddt.view.dailyconduct.TestingTipFrame;
	import ddt.view.im.IMController;
	import ddt.view.movement.MovementLeftView;
	import ddt.view.userGuide.UserGuideControler;
	
	import org.aswing.KeyboardManager;
	
	import road.loader.BaseLoader;
	import road.loader.LoaderManager;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HBlackFrame;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.ClassUtils;
	import road.utils.StringHelper;
	
	public class DDT extends Sprite
	{
		private var _user:String;
		private var _pass:String;
		private var _allowMulti:Boolean;
		private var _musicList:Array;
		private var _lang:String;
		private var _path:PathInfo;
		private var _setupCall:Function;
		private var _extraModuleLoader:BaseLoader;
		private var _config:XML;
		public function DDT():void
		{
			this.scrollRect = new Rectangle(0,0,1000,600);
		}
		
		public function start(config:XML,user:String,pass:String,setupCall:Function = null):void
		{
			Version.Build = config.VERSION.@value;
			_config = config;
			_setupCall = setupCall;
			_user = user;
			_pass = pass;
			parseConfig(config);
			BgView.Instance.showBtnBg(true);
			if(_setupCall != null)
				//注册隐藏背景
				BgView.Instance.hideBg();			
			addChild(BgView.Instance);
		}
		private function setup():void
		{
			_startTime = getTimer();
			if(StringHelper.isNullOrEmpty(_user))
			{
				LeavePage.LeavePageTo(PathManager.solveLogin(),"_self");
			}
			else
			{
				var m1:String = "zRSdzFcnZjOCxDMkWUbuRgiOZIQlk7frZMhElQ0a7VqZI9VgU3+lwo0ghZLU3Gg63kOY2UyJ5vFpQdwJUQydsF337ZAUJz4rwGRt/MNL70wm71nGfmdPv4ING+DyJ3ZxFawwE1zSMjMOqQtY4IV8his/HlgXuUfIHVDK87nMNLc=";
				var m2:String = "AQAB";
				var acc:AccountInfo = new AccountInfo();
				acc.Account = _user;
				acc.Password = _pass;
				acc.Key = CrytoHelper.generateRsaKey(m1,m2);				
				PlayerManager.Instance.setup(acc);	
				
				for(var i:int = 1;i<=9;i++)
				{
					Font.registerFont(ClassUtils.getDefinition("ddt.view.common.Font"+i.toString()));
				}
				var a:Class = ClassUtils.getDefinition("ddt.Config");
				a["ParseAll"](_config.child("setting")[0]);
				
				QueueManager.setup(stage);
				StateManager.setup(this,new BaseStateCreator());
				BellowStripViewII.Instance.setup(this);
				UIManager.setup(this,Config.GAME_WIDTH,Config.GAME_HEIGHT);
				EffortManager.Instance.setup();
				
				HAlertDialog.OK_LABEL = LanguageMgr.GetTranslation("ok");
				HConfirmDialog.OK_LABEL = LanguageMgr.GetTranslation("ok");
				HConfirmDialog.CANCEL_LABEL = LanguageMgr.GetTranslation("cancel");
				HConfirmFrame.OK_LABEL = LanguageMgr.GetTranslation("ok");
				HConfirmFrame.CANCEL_LABEL = LanguageMgr.GetTranslation("cancel");
				HBlackFrame.OK_LABEL = LanguageMgr.GetTranslation("ok");
				HBlackFrame.CANCEL_LABEL = LanguageMgr.GetTranslation("cancel")
				
				TipManager.setup(this,stage,Config.GAME_WIDTH,Config.GAME_HEIGHT);
				
				var guideLayer:Sprite = new Sprite();
				addChild(guideLayer);
				UserGuideControler.Instance.setup(guideLayer);
				
				
				MapManager.setup();
				ChatManager.Instance.setup();
				BuggleView.instance.setup();
				KeyboardManager.getInstance().init(stage);
				ColorEnum.initColor();
				SharedManager.Instance.setup();
				BallManager.setup();
				ItemManager.Instance.setup();
				ShopManager.Instance.setUp();
				IMController.Instance.setup();
				TaskManager.setup();
				TimeManager.Instance.setup();
				RoomManager.Instance.setup();
				ChurchRoomManager.instance.setup();
				SoundManager.instance.setup(_musicList,PathManager.SITE_MAIN);
				ConsortiaLevelUpManager.Instance.setup();
				EnthrallManager.getInstance().setup();
				MovementLeftView.Instance.setup();
				StageFocusManager.getInstance().steup(stage);
				FightLibManager.Instance.setup();
				HotSpringManager.instance.setup();
				RouletteManager.instance.setup();
				FeedbackManager.instance.setup();
				//WorldBossManager.instance.setup();
				

				
				stage.focus = stage;
				stage.stageFocusRect = false;
				setCallExternal();
				if(_setupCall != null)
				{
					_setupCall();
				}else
				{
					if(!_allowMulti)
					{
						closeAndListen();
					}
					else
					{
						
						StateManager.setState(StateType.LOGIN);
					}
				}
			}
		}
		

		
		private static var test:LocalConnection = new LocalConnection();
		private function closeAndListen():Boolean
		{
			try
			{
				WaitingView.instance.show(WaitingView.LOGIN,LanguageMgr.GetTranslation("crazyTank.CLOSE_OTHER_CLIENT"),false);
				test.client = this;
				test.connect("7road");
				test.addEventListener(StatusEvent.STATUS,__status);
				WaitingView.instance.hide();
				StateManager.setState(StateType.LOGIN);
			}
			catch(err:Error)
			{
				test.send("7road","closeLocal");
				setTimeout(closeAndListen,1000);
				return false;
			}
			return true;
		}
		
		private function __status(event:StatusEvent):void 
		{
			test.removeEventListener(StatusEvent.STATUS,__status);
			closeAndListen();
		}
		
		
		public function closeLocal():void
		{
			test.close();
			try
			{
				SocketManager.Instance.socket.close();
			}
			catch(e:Error){}
			var block:Sprite = new Sprite();
			block.graphics.beginFill(0,1);
			block.graphics.drawRect(0,0,1500,1000);
			block.graphics.endFill();
			TipManager.AddTippanel(block,true);
			HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("crazyTank.ONLY_ONE_CLIENT"));
		}
		
		public function parseConfig(config:XML):void
		{
			TestingTipFrame.str = config.NOTICE.@value;
			_path = new PathInfo();
			_path.SITEII = "";
			StatisticManager.siteName = "";
			_path.SITE = config.RES_PATH.@value;
			_path.REQUEST_PATH = config.ASHX_PATH.@value;
			_path.XML_PATH =config.XML_PATH.@value;
			_path.SWF_PATH = config.SWF_PATH.@value;

			 

			_path.FILL_PATH = "login.do?method=pay&username="+_user;
			
			_path.LOGIN_PATH = "login.aspx";
			
			_path.OFFICIAL_SITE = "";
			_path.GAME_FORUM = "";

			
			
			_path.TRAINER_PATH = "";
			_path.COUNT_PATH = "";
			_path.PARTER_ID = "";

			StatisticManager.Instance().isStatistic = false;
			

			
			
			_path.PHP_IMAGE_LINK = false;
			
			
			_path.CLIENT_DOWNLOAD      = "";
			
			_allowMulti = Boolean(config.ALLOW_MULTI.@value);
			var MUSIC_LIST:String ="1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040";
			
			_musicList =  MUSIC_LIST.split(",");
			Security.loadPolicyFile(config.POLICY_FILE.@value);
			Security.allowDomain("*");
			_path.COMMUNITY_EXIST = false;
			_path.ALLOW_POPUP_FAVORITE = false;
			_path.FILL_JS_COMMAND_ENABLE = false;
			_path.EXTERNAL_INTERFACE_ENABLE = false;			
			_path.FEEDBACK_ENABLE = false;

			
			
			PathManager.setup(_path);
			FilterWordManager.loadWord();
			ChatManager.SHIELD_NOTICE=false;
			loadLanguagePkg();
		}
		
		private function converBoolean(value:String):Boolean
		{
			if(value == "true")
			{
				return true
			}
			return false;
		}
		private function creatRightMenu():ContextMenu
		{
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			var item:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("crazyTank.share"));
			//var item:ContextMenuItem = new ContextMenuItem("分享给MSN/QQ好友");
			item.separatorBefore = true;
			myContextMenu.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onQQMSNClick);
			var item1:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("crazyTank.collection"));
			//var item1:ContextMenuItem = new ContextMenuItem("收藏地址");
			item1.separatorBefore = true;
			myContextMenu.customItems.push(item1);
			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,addFavClick);
			var item2:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("crazyTank.supply"));
			//var item2:ContextMenuItem = new ContextMenuItem("点券充值");
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,goPayClick);
			myContextMenu.customItems.push(item2);
			return myContextMenu;
		}
		private function onQQMSNClick(e:ContextMenuEvent):void
		{
			System.setClipboard(LanguageMgr.GetTranslation("crazyTank.clickboard")+"\n"+PathManager.solveLogin());
			HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("crazyTank.copyOK"));
		}
		
		private function addFavClick(e:ContextMenuEvent):void
		{
			//			JSHelper.addFavoriteAsync(PathManager.solveLogin(),LanguageMgr.GetTranslation("ddt.task.TaskPannelPosView.loginPath"));BellowStripViewII.siteName
			JSHelper.addFavoriteAsync(PathManager.solveLogin(),BellowStripViewII.siteName);
		}
		
		private function goPayClick(e:ContextMenuEvent):void
		{
			LeavePage.leaveToFill();
		}
		
		private function loadLanguagePkg():void
		{
			new LoadLanguageAction().loadSync(__loadLanguageCallback,3);
		}
		
		
		
		private function __loadLanguageCallback(loader:LoadLanguageAction):void
		{
			if(loader.isSuccess)
			{
				LanguageMgr.setup(loader.languages);
				StartupResourceLoader.Instance.addEventListener(StartupEvent.CORE_LOAD_COMPLETE,__onCoreSetupLoadComplete);
				StartupResourceLoader.Instance.start();
				contextMenu = creatRightMenu();
			}
			else
			{
				HAlertDialog.show("错误","加载语言包失败",true);
			}
		}
		private function __onCoreSetupLoadComplete(event:StartupEvent):void
		{
			StartupResourceLoader.Instance.removeEventListener(StartupEvent.CORE_LOAD_COMPLETE,__onCoreSetupLoadComplete);
			setup();
		}
		
		public static function CheckState():Boolean
		{
			if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.SERVER_LIST)
			{
				return true;
			}
			return false;
		}
		
		private function setCallExternal():void
		{
			if(ExternalInterface.available)
			{
				callExternal();
			}else
			{
				addEventListener(Event.ENTER_FRAME,externalCheck);
			}
		}
		
		private function externalCheck(e:Event):void
		{
			if(ExternalInterface.available)
			{
				removeEventListener(Event.ENTER_FRAME,externalCheck);
				callExternal();
			}
		}
		
		private function callExternal():void
		{
			ExternalInterface.addCallback("SetIsDesktop",setIsDesktop);
			ExternalInterface.call("IsDesktop");
			ExternalInterface.addCallback("ClosingDDTClient",closeClientCallback);
		}
		
		private var _startTime:int;
		private var _endTime:int;
		private function closeClientCallback():void
		{
			try
			{
				if(LeavePage.IsDesktopApp == false)
					return;
				
				_endTime = getTimer();
				
				var elasped:int = Math.round((_endTime - _startTime) / 1000);
				
				new StatisticExitLoginTool(elasped.toString()).loadSync();
				
				_startTime = getTimer();
			}
			catch(e:Error)
			{ }
		}
		
		private function setIsDesktop():void
		{
			LeavePage.IsDesktopApp = true;
		}
		
	}
}
