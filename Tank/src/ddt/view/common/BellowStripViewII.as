package ddt.view.common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.BelowStripAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HGlowButton;
	import road.ui.manager.UIManager;
	
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.DownlandClientManager;
	import ddt.manager.FeedbackManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MailManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.TaskManager;
	import ddt.manager.UserGuideManager;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;
	import ddt.view.SetPannelView;
	import ddt.view.ChannelList.FastMenu;
	import ddt.view.dailyconduct.DailyConductFrame;
	import ddt.view.emailII.EmailIIEvent;
	import ddt.view.help.LittleHelpFrame;
	import ddt.view.im.IMController;
	import ddt.view.infoandbag.InfoAndBagController;
	import ddt.view.taskII.TaskMainFrame;

	/**
	 * 下方工具条 
	 * @author SYC
	 * 
	 */
	public class BellowStripViewII extends BelowStripAsset
	{
		private static var instance:BellowStripViewII;
		
		private var _unReadEmail:Boolean;
		
		public var goSupplyBtn:HBaseButton;    //bret 09.5.7
		public var goShopBtn:HGlowButton;
		public var goBagBtn:HGlowButton;
		public var goEmailBtn:HGlowButton;
		public var goTaskBtn:HGlowButton;
		public var goFriendListBtn:HGlowButton;
		public var goSetingBtn:HGlowButton;
		public var goChannelBtn:HGlowButton;
		public var goReturnBtn:HGlowButton;
		
		private var _tutorial_btn : HBaseButton;
		private var _collection_btn:HBaseButton; //bret 09.5.13
				
		private var _dailyConduct_btn : HBaseButton;	
		private var _helpBtn:HBaseButton;
		private var allBtns:Array;
		
		private var _callBackFun:Function;
		
		private static var isFirst:Boolean;
		public static var siteName : String = "";//弹弹堂在代理商的名称
		
		private var _bag:InfoAndBagController;
		
		private var _alarms:Array;
		
		private var _BossBtn:HBaseButton;
		
		public function setup(root:Sprite):void
		{
			root.addChild(this);
			this.visible = false;
			_alarms = new Array();
		}
		
		
		public function set unReadEmail(value:Boolean):void
		{
			if(value == _unReadEmail)return;
			_unReadEmail = value;
			if(_enabled)
			{
				updateEmail(); 
			}
		}
	
		private var _unReadTask:Boolean;
		public function set unReadTask(value:Boolean):void
		{
			if(_unReadTask == value) return;
			_unReadTask = value;
			if(_enabled)
			{
				updateTask();
			}
		}
		public function get unReadTask():Boolean
		{
			return _unReadTask;
		}
		
		private var _unReadMovement:Boolean;
		public function set unReadMovement(value:Boolean):void
		{
//			if(_unReadMovement == value) return;
//			_unReadMovement = value;
//			if(_enabled)
//			{
//				updateMovement(); 
//			}
		}
		public function get unReadMovement():Boolean
		{
			return _unReadMovement;
		}
		
		private var _btns:Array;
		private var _grays:Array; 
		
		private var _enabled:Boolean;
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			update();
		}
				
		public static function get Instance():BellowStripViewII
		{
			if(instance == null)
			{
				instance = new BellowStripViewII();
				isFirst = true;
			}
			return instance;
		}
		
		public function BellowStripViewII()
		{
			initView();
			initEvent();
			
		}
		
		public function set backFunction(fn:Function):void
		{
			_callBackFun = fn;
		}
		
		
		public function showHightLightButton(buttonIndex:uint):void
		{
			allBtns[buttonIndex].glow = true;
		}
		
		public function hideHightLightButton(buttonIndex:uint):void
		{
			allBtns[buttonIndex].glow = false;
		}
		
		public function showTaskHightLight():void
		{
			unReadTask = true;
			goTaskBtn.glow = true;
		}
		public function hideTaskHightLight():void{
			unReadTask = false;
			goTaskBtn.glow = false;
		}
		
		public function showmovementHightLight():void
		{
			goChannelBtn.glow = true;
			unReadMovement = true;
		}
		
		
		public function show():void
		{
			tutorialBtnsStatus(this._tutorialBtStatus);
			update();
			visible = true;
			y=0;
		}
		public function showDailyConduct(dailyState  : Boolean):void
		{
			_dailyConduct_btn.visible = _dailyConduct_btn.mouseEnabled = dailyState;
			if(dailyState)
			{
				_dailyConduct_btn.addEventListener(MouseEvent.CLICK, __dailyConductHandler);
			}
			else
			{
				_dailyConduct_btn.removeEventListener(MouseEvent.CLICK, __dailyConductHandler);
			}
		}
		
		/**
		 *投诉反馈按钮显示 
		 */		
		public function showFeedbackNavigation(state:Boolean):void
		{
			FeedbackManager.Instance.showNavigation(this, posFeedbackBtn.x, posFeedbackBtn.y, state);
		}
		
		public function hide():void
		{
			visible = false;
			y=160;//移到屏幕外，减少游戏内的渲染
		}
		
		private function update():void
		{
				
			_BossBtn.visible = false;
			for(var i:uint = 0; i < allBtns.length; i ++)
			{
				updateByIndex(i);
			}	
		}
		
		public function setRoomState():void
		{
			goChannelBtn.enable = false;
		}
		
		public function setShopState():void
		{
			goBagBtn.enable = false;
			if(_bag&&_bag.getView().visible) __player(null);
			//goShopBtn.enable = false;
			//goChannelBtn.enable = false;
		}
		
		public function setStoreEnableFalse():void{
			goBagBtn.enable = false;
		}
		
		public function setStoreEnableTrue():void{
			goBagBtn.enable = true;
		}
		
		public function setAuctionHouseState():void
		{
			goBagBtn.enable = false;
		}
		
		private function updateByIndex(index:uint):void
		{
			
			
			if(!_enabled)
			{
				allBtns[index].enable = false;
			}
			else
			{
				if(index == 3)
				{
					updateTask();
				}
				else if(index == 2)
				{
					
					updateEmail();
				}
//				else if(index == 6)
//				{
////					updateMovement();
//				}
				else
				{
					allBtns[index].enable = true;
				}
			}
		}
		
		private function updateTask():void
		{
			goTaskBtn.glow = _unReadTask;
			goTaskBtn.enable = true;
		}
		
		private function updateMovement():void
		{
			goChannelBtn.glow = _unReadMovement;
			goChannelBtn.enable = true;
		}
		
		private function updateEmail():void
		{
			goEmailBtn.glow = _unReadEmail;
			goEmailBtn.enable = true;
		}
		
	
		private function  initView():void
		{
			_tutorial_btn  = new HBaseButton(tutorial_btn);
			_tutorial_btn.useBackgoundPos = true;
//			addChild(_tutorial_btn);
			_tutorial_btn.enable = false;
			
			_collection_btn = new HBaseButton(collection_btn) //bret 09.5.13
			_collection_btn.useBackgoundPos = true;           //收藏按钮
//			addChild(_collection_btn);                     
			
			_dailyConduct_btn = new HBaseButton(dailyConductBtn);
			_dailyConduct_btn.useBackgoundPos = true;
			addChild(_dailyConduct_btn);
			
			if(posFeedbackBtn.parent) posFeedbackBtn.parent.removeChild(posFeedbackBtn);
			
			_helpBtn = new HBaseButton(hellpMc);
			_helpBtn.useBackgoundPos = true;
//			addChild(_helpBtn);
			
			showDailyConduct(false);
			
			allBtns = [];
			
			//bret 09.5.7 点券充值按钮 ========================
			goSupplyBtn = new HBaseButton(supplyBtn);
			//gosupplyBtn = new HGlowButton(supplyBtn,"","");
			goSupplyBtn.useBackgoundPos = true;
			//goSupplyBtn.enable = false;
			//==============================================
			
			goShopBtn = new HGlowButton(shopBtn,"",LanguageMgr.GetTranslation("ddt.view.common.BellowStripViewII.shop"));
			//goShopBtn = new HGlowButton(shopBtn,"","商城");
			goShopBtn.useBackgoundPos = true;
			
			goBagBtn = new HGlowButton(bagBtn,"",LanguageMgr.GetTranslation("ddt.view.common.BellowStripViewII.bag"));
			//goBagBtn = new HGlowButton(bagBtn,"","背包");
			goBagBtn.useBackgoundPos = true;
			
			goEmailBtn = new HGlowButton(emailBtn,"",LanguageMgr.GetTranslation("ddt.view.common.BellowStripViewII.email"));
			//goEmailBtn = new HGlowButton(emailBtn,"","邮件");
			goEmailBtn.useBackgoundPos = true;
			
			goTaskBtn = new HGlowButton(taskBtn,"",LanguageMgr.GetTranslation("ddt.game.ToolStripView.task"));
			//goTaskBtn = new HGlowButton(taskBtn,"","任务");
			goTaskBtn.useBackgoundPos = true;
			
			goFriendListBtn = new HGlowButton(friendListBtn,"",LanguageMgr.GetTranslation("ddt.game.ToolStripView.friend"));
			//goFriendListBtn = new HGlowButton(friendListBtn,"","好友");
			goFriendListBtn.useBackgoundPos = true;
			
			goSetingBtn = new HGlowButton(setingBtn,"",LanguageMgr.GetTranslation("ddt.game.ToolStripView.set"));
			//goSetingBtn = new HGlowButton(setingBtn,"","设置");
			goSetingBtn.useBackgoundPos = true;
			
			goChannelBtn = new HGlowButton(channelBtn,"",LanguageMgr.GetTranslation("ddt.view.common.BellowStripViewII.channel"));
			//goChannelBtn = new HGlowButton(channelBtn,"","跳转");
			goChannelBtn.useBackgoundPos = true;
		
			goReturnBtn = new HGlowButton(returnBtn,"",LanguageMgr.GetTranslation("ddt.view.common.BellowStripViewII.back"));
			//goReturnBtn = new HGlowButton(returnBtn,"","返回");
			goReturnBtn.useBackgoundPos = true;
			
			
			_BossBtn = new HBaseButton(BossBtn,"世界Boss");
			_BossBtn.useBackgoundPos = true;
		
			
			allBtns.push(goShopBtn);
			allBtns.push(goBagBtn);
			allBtns.push(goEmailBtn);
			allBtns.push(goTaskBtn);
			allBtns.push(goFriendListBtn);
			allBtns.push(goSetingBtn);
			allBtns.push(goChannelBtn);
			allBtns.push(goReturnBtn);
			allBtns.push(goSupplyBtn); //bret 09.5.7 新添加的动能要放在数组后面
		//	allBtns.push(_BossBtn)
			_BossBtn.enable = true;
			addChild(_BossBtn);
			
			for(var i:uint = 0;i<allBtns.length;i++)
			{
//				allBtns[i].y = 548;
//				allBtns[i].x = 600+i*50;
				allBtns[i].enable = false;
				addChild(allBtns[i]);
			}

		}
		
		public function enableAll():void
		{
			enabled = true;
			for(var i:uint = 0;i<allBtns.length;i++)
			{
				allBtns[i].enable = true;
			}
		}
		
		public function disableAll():void
		{
			enabled = false;
			for(var i:uint = 0;i<allBtns.length;i++)
			{
				allBtns[i].enable = false;
			}
		}
		
		private function initEvent():void
		{
			goSupplyBtn.addEventListener(MouseEvent.CLICK,__fillClick);// 点券充值 bret 09.5.7
			
			goReturnBtn.addEventListener(MouseEvent.CLICK,__goBack);
			goBagBtn.addEventListener(MouseEvent.CLICK,__player);
			goEmailBtn.addEventListener(MouseEvent.CLICK,__email);
			goFriendListBtn.addEventListener(MouseEvent.CLICK,__showIM);
			goChannelBtn.addEventListener(MouseEvent.CLICK,__gotoServer);
			goShopBtn.addEventListener(MouseEvent.CLICK,__gotoShop);
			goSetingBtn.addEventListener(MouseEvent.CLICK,__setting);
			goTaskBtn.addEventListener(MouseEvent.CLICK,__task);
			
			_BossBtn.addEventListener(MouseEvent.CLICK,__goWorldBoss);
			_helpBtn.addEventListener(MouseEvent.CLICK,__helpClick);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAIL_RESPONSE,__responseMail);
			MailManager.Instance.Model.addEventListener(EmailIIEvent.INIT_EMAIL,__updateEmail);
		}
		
		private function __goWorldBoss(evt:MouseEvent):void
		{
			SocketManager.Instance.out.sendJoinWorldBoss();
		}
		
		
		
		
		
		
		
		//BellowStrip 快捷键   add by Freeman
//		public function __hotKeyPressed(e:KeyboardEvent):void{
//			if(e.shiftKey){
//				switch(e.keyCode){
//					case 83:	//S -- 商城
//						__gotoShop(null);
//						break;
//					case 66:	//B -- 背包
//							__player(null);
//						break;
//					case 77:	//M -- 邮件
//						__email(null);
//						break;
//					case 81:	//Q -- 任务
//						__task(null);
//						break;
//					case 70:	//F -- 好友
//						__showIM(null);
//						break;
//					case 67:	//C -- 设置
//						__setting(null);
//						break;
//					case 74:	//J -- 跳转
//						//没发现是什么函数
//						break;
//					
//				}
//			} else {
//				return;
//			}
//		}
		//BellowStrip 快捷键   add by Freeman
		
		
//		private var _tutorial : EnterTutorialFrame;
		private function __openTutorial(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
//			if(_tutorial && _tutorial.parent)return;
//			_tutorial = new EnterTutorialFrame();
//			UIManager.setChildCenter(_tutorial);
//			UIManager.AddDialog(_tutorial);
//			_tutorial.addEventListener(Event.CLOSE, __doClosing);
            StateManager.setState(StateType.LODING_TRAINER);
		}
		
		//bret 09.5.13 *********************************************
		private function __collectionWeb(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(LeavePage.IsDesktopApp) return;
			if(ExternalInterface.available)
			ExternalInterface.call("addfavorite",PathManager.solveLogin(),siteName);
//            navigateToURL(new URLRequest("javascript:window.external.addfavorite(\" http://www.flashas.net\");"));
		}
		//**********************************************************
		private var dailyConduct : DailyConductFrame;
		private function __dailyConductHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			switchDailyConduct();
		}
		
		public function showDownBtn():void
		{
			//DownlandClientManager.Instance.show(this);
			//DownlandClientManager.Instance.setDownlandBtnPos(new Point(downBtnPos.x,downBtnPos.y));
		}
		
		public function hideDownBtn():void
		{
			//DownlandClientManager.Instance.hide();
		}
		
		public function switchDailyConduct() : void
		{
			 if(dailyConduct)
		    {
		    	dailyConduct.dispose();
		    	dailyConduct = null;
		    }
		    else
		    {
		    	dailyConduct = new DailyConductFrame();
		    	dailyConduct.show();
		    }
		}
		public function closeDailyConduct() : void{
			 if(dailyConduct){
		    	dailyConduct.dispose();
		    	dailyConduct = null;
		    }
		}
//		private function __doClosing(evt : Event) : void
//		{
//			if(_tutorial && _tutorial.parent)
//			{
//				_tutorial.removeEventListener(Event.CLOSE, __doClosing);
//				_tutorial.dispose();
//				_tutorial = null;
//			}
//			
//		}
	
		/***********************************************
		 *     新手教程按钮状态
		 * ********************************************/
		private var  _tutorialBtStatus : Boolean = false;
		public function tutorialStatus(status:Boolean=false) : void
		{
			_tutorialBtStatus = status;
		}
		public function tutorialBtnsStatus(status:Boolean=false) : void
		{
			_tutorialBtStatus         = status;
			_tutorial_btn.visible     = _tutorial_btn.mouseEnabled   = _tutorialBtStatus;
			_collection_btn.visible   = _collection_btn.mouseEnabled = _tutorialBtStatus;
			if(status)
			{
				_tutorial_btn.addEventListener(MouseEvent.CLICK, __openTutorial);
				_collection_btn.addEventListener(MouseEvent.CLICK,__collectionWeb);
			}
			else
			{
				_tutorial_btn.removeEventListener(MouseEvent.CLICK, __openTutorial);
				_collection_btn.removeEventListener(MouseEvent.CLICK,__collectionWeb);
			}
		}
		
		private function __goBack(event:MouseEvent):void
		{
			SoundManager.Instance.play("015");
			if(_callBackFun != null)
			{
				_callBackFun();
			}else
			{
				StateManager.back();
			}
			
		}
	
		public function __player(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			openBag();
		}
		
		//打开背包不播放音乐
		public function openBag():void{
			if(_bag == null) 
			{
				_bag = new InfoAndBagController(PlayerManager.Instance.Self);
				UIManager.AddDialog(_bag.getView());
				setBagBlackMode();
			}else
			{
				_bag.restBagList();
				if(_bag.getView().visible && !_bag.getView().parent)
				{
					UIManager.AddDialog(_bag.getView());
				}else
				{
					_bag.switchVisible();
				}
				setBagBlackMode();
			}
			goBagBtn.glow = false;
		}
		public function closeBag() : void
		{
			if(_bag)
			{
				if(_bag.getView().visible && _bag.getView().parent)
				{
					_bag.switchVisible();
//					UIManager.AddDialog(_bag.getView());
				}
				setBagBlackMode();
			}
		}
		private function setBagBlackMode():void
		{
			
			if(StateManager.currentStateType == StateType.ROOM || StateManager.currentStateType == StateType.MISSION_RESULT)
			{
				_bag.blackMode = true;
			}else
			{
				_bag.blackMode = false;
			}
		}
	
		private function __email(event:MouseEvent):void
		{
			goEmailBtn.glow = false;
			_unReadEmail = false;
			MailManager.Instance.switchVisible();
			SoundManager.Instance.play("003");
		}

		private function __showIM(evt:MouseEvent):void
		{
			IMController.Instance.switchVisible();
			SoundManager.Instance.play("003");
		}

		private function __gotoServer(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			SoundManager.Instance.play("003");
//			MovementLeftView.Instance.open();
//			clickMovement();
			FastMenu.Instance.switchVisible();
			
		}
		public function clickMovement():void
		{
			goChannelBtn.glow = false;
			unReadMovement = false;
		}

		private function __gotoShop(evt:MouseEvent):void
		{
			StateManager.setState(StateType.SHOP);
			SoundManager.Instance.play("003");
		}
		
		private function __setting(event:MouseEvent):void
		{
			SetPannelView.Instance.switchVisible();
			SoundManager.Instance.play("003");
		}

		private function __task(event:MouseEvent):void
		{
			goTaskBtn.glow = false;
			unReadTask = false;
//			TaskCatalogView.Instance.switchVisible();
			
            TaskMainFrame.Instance.switchVisible();
			SoundManager.Instance.play("003");
		}
		
		private function __responseMail(event:CrazyTankSocketEvent):void
		{
			//type:1加载收件邮，2加载发件邮，3加载全部
			var id:int = event.pkg.readInt();
			var type:int = event.pkg.readInt();
			
			MailManager.Instance.loadMail(type);
			if(type != 2)
			{
				unReadEmail = true;
			}
		}
		
		private function __helpClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			new LittleHelpFrame().show();
		}
		
		private function __updateEmail(event:Event):void
		{
			if(!isFirst) return;
			if(MailManager.Instance.Model.hasUnReadEmail())
			{
				unReadEmail = true;
			}
			else
			{
				unReadEmail = false;
			}
			isFirst = false;
		}
		//bret 09.5.7 点券充值 单击==============================================
		private function __fillClick(evt:MouseEvent):void
		{
			LeavePage.leaveToFill();
		}
		//====================================================================
		public function newQuest(needValidate:Boolean = true):void{
			if(!TaskManager.newQuests || TaskManager.newQuests.length < 1){
				return;
			}
			var S:String = StateManager.currentStateType;
			if(!needValidate || availableForNewQuest()){
				TaskMainFrame.Instance.newQuest(null);
			}
		}
		private function availableForNewQuest():Boolean{
			if(StateManager.currentStateType == StateType.ROOM_LIST || StateManager.currentStateType == StateType.DUNGEON){
				return true;
			}
			return false;
		}
		public function showWorldBoss():void
		{
			_BossBtn.visible = true;
		}
	}
}