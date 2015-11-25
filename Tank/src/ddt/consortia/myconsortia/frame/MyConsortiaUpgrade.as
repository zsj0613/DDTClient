package ddt.consortia.myconsortia.frame
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.consortia.accect.consortiaUpGradeAsset;
	import ddt.data.ConsortiaLevelInfo;
	import ddt.data.EquipType;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.ConsortiaLevelUpManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.QuickBuyFrame;
	
	public class MyConsortiaUpgrade extends HConfirmFrame
	{
		private var fastPurchaseGoldBox:FastPurchaseGoldBox;
		private var _quick:QuickBuyFrame;
		private static const CONSORTIAGRADE      : String = "consortiagradeState";//公会
		private static const CONSORTIASHOPGRADE  : String = "consortiashopgradeState";//商城
		private static const CONSORTIASTOREGRADE : String = "consortiastoregradeState";//保管箱
		private static const CONSORTIASMITHGRADE : String = "consortiasmithgradeState";//铁匠铺
		private var _currentState : String = "";
		
		private var _upgrade    : consortiaUpGradeAsset;
//		private var _model      : ConsortiaModel;
		private var _currentBtn : MovieClip;
		
		public function MyConsortiaUpgrade()
		{
			super();
//			_model = $model;
			initUI();
		}
		private function initUI():void
		{
			titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.titleText");//"公会升级";
			okLabel = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.okLabel");//"升 级";
			cancelLabel = LanguageMgr.GetTranslation("cancel");//"取 消";
			this.moveEnable = false;
			buttonGape = 200;
			setSize(608,300);
			fireEvent = false;
			
			_upgrade = new consortiaUpGradeAsset();
			
			_upgrade.consortiaSmithGrade.gotoAndStop(1);
			_upgrade.consortiaShopGrade.gotoAndStop(1);
			_upgrade.consortiaBankGrade.gotoAndStop(1);
			_upgrade.consortiaSmithGrade.buttonMode = true;
			_upgrade.consortiaShopGrade.buttonMode  = true;
			_upgrade.consortiaBankGrade.buttonMode  = true;
			_upgrade.consortiaGrade.buttonMode      = true;
			
			addContent(_upgrade,false);
			_upgrade.levelTxt.mouseEnabled = false;
			_upgrade.levelTxt2.mouseEnabled = false;
			_upgrade.levelTxt3.mouseEnabled = false;
			_upgrade.levelTxt4.mouseEnabled = false;
			
			_upgrade.appealTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
			
		}
		public function addEvent() : void
		{
			okFunction = onUpGrade;
			cancelFunction = __cancel;
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__upLevelHandler);
			_upgrade.consortiaGrade.addEventListener(MouseEvent.CLICK,                       __switchUpGradeType);
			_upgrade.consortiaSmithGrade.addEventListener(MouseEvent.CLICK,                  __switchUpGradeType);
			_upgrade.consortiaShopGrade.addEventListener(MouseEvent.CLICK,                   __switchUpGradeType);
			_upgrade.consortiaBankGrade.addEventListener(MouseEvent.CLICK,                   __switchUpGradeType);
		}
		
		public function removeEvent() : void
		{
			okFunction = null;
			cancelFunction = null;
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__upLevelHandler);
			_upgrade.consortiaGrade.removeEventListener(MouseEvent.CLICK,                       __switchUpGradeType);
			_upgrade.consortiaSmithGrade.removeEventListener(MouseEvent.CLICK,                  __switchUpGradeType);
			_upgrade.consortiaShopGrade.removeEventListener(MouseEvent.CLICK,                   __switchUpGradeType);
			_upgrade.consortiaBankGrade.removeEventListener(MouseEvent.CLICK,                   __switchUpGradeType);
			
		}
		
		private function __switchUpGradeType(evt : MouseEvent) : void
		{
			if(_currentBtn == evt.currentTarget)return;
			_currentBtn = evt.currentTarget as MovieClip;
			SoundManager.instance.play("008");
			switch(_currentBtn.name)
			{
				case "consortiaGrade":
				viewState = CONSORTIAGRADE;
				break;
				case "consortiaSmithGrade":
				viewState = CONSORTIASMITHGRADE;
				break;
				case "consortiaShopGrade":
				viewState = CONSORTIASHOPGRADE;
				break;
				case "consortiaBankGrade":
				viewState = CONSORTIASTOREGRADE;
				break;
			}
		}
		private function upBtnState() : void
		{
			_upgrade.consortiaGrade.gotoAndStop(1);
			_upgrade.consortiaSmithGrade.gotoAndStop(1);
			_upgrade.consortiaShopGrade.gotoAndStop(1);
			_upgrade.consortiaBankGrade.gotoAndStop(1);
			_currentBtn.gotoAndStop(2);
			
		}
		
		private function set viewState(state : String) : void
		{
			_currentState = state;
			upBtnState();
			upView();
		}
		private function __upLevelHandler(evt : PlayerPropertyEvent) : void
		{
			if(evt.changedProperties["ConsortiaLevel"] || evt.changedProperties["ShopLevel"] || evt.changedProperties["SmithLevel"] || evt.changedProperties["StoreLevel"])
			upView();
		}
		private function __upRichesHandler(evt : Event) : void
		{
			upView();
		}
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
			if(okFunction == null)addEvent();
			_currentBtn = _upgrade.consortiaGrade as MovieClip;
			viewState = CONSORTIAGRADE;
		}
		private function __cancel():void
		{
			removeEvent();
			if(this.parent)this.parent.removeChild(this);
		}
		private function onUpGrade():void
		{
			if(!checkConsortiaRiches())
			{
				//财富不足
				__openRichesTip();
				return ;	
			}
			if(checkGoldOrLevel())
			{
				switch(_currentState)
				{
					case CONSORTIAGRADE:
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.info"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.sure"),true,sendUpGradeData);
					break;
					case CONSORTIASHOPGRADE:
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.info"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE"),true,sendUpGradeData);
					//HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.info"),"是否确定升级公会商城等级?",true,sendUpGradeData,cancelback);
					break;
					case CONSORTIASTOREGRADE:
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.info"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASTOREGRADE"),true,sendUpGradeData);
					//HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.info"),"是否确定升级公会保管箱等级?",true,sendUpGradeData,cancelback);
					break;
					case CONSORTIASMITHGRADE:
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.info"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASMITHGRADE"),true,sendUpGradeData);
					//HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.info"),"是否确定升级公会铁匠铺等级?",true,sendUpGradeData,cancelback);
					break;
				}
			}
		}
		
		private function checkConsortiaRiches() : Boolean
		{
			var level        : int;
			var consortiaLevel : int = consortiaLevel();
			switch(_currentState)
			{
				case CONSORTIAGRADE:
					if(consortiaLevel < 10)
					{
						if(consortiaRiches < getConsortiaLevelData(consortiaLevel+1).Riches)return false;
					}
				break;
				case CONSORTIASHOPGRADE:
				    level = PlayerManager.Instance.Self.ShopLevel;
				    if(level < 5 || ((level+1)*2) < consortiaLevel)
				    {
				    	if(consortiaRiches < getConsortiaLevelData(level+1).ShopRiches)return false;
				    }
				break;
				case CONSORTIASTOREGRADE:
				    level = PlayerManager.Instance.Self.StoreLevel;
				    if(level < 10 || level < consortiaLevel)
				    {
				    	if(consortiaRiches < getConsortiaLevelData(level+1).StoreRiches)return false;
				    }
				break;
				case CONSORTIASMITHGRADE:
				    level = PlayerManager.Instance.Self.SmithLevel;
				    if(level < 10 || level < consortiaLevel)
				    {
				    	if(consortiaRiches < getConsortiaLevelData(level+1).SmithRiches)return false;
				    }
				break;
			}
			return true;
		}
		/*检查金币*/
		private function checkGoldOrLevel() : Boolean
		{
			var level : int = consortiaLevel();
			var consortiaLevel : int = consortiaLevel();
			switch(_currentState)
			{
				case CONSORTIAGRADE:
					if(consortiaLevel >= 10)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaLevel"));
						//MessageTipManager.getInstance().show("公会已升到最高等级");
						return false;
					}
				break;
				case CONSORTIASHOPGRADE:
				    level = PlayerManager.Instance.Self.ShopLevel;
				    if(level >= 5)
				    {
				    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel"));
				    	//MessageTipManager.getInstance().show("公会商城已升到最高等级");
						return false;
				    }
				    else if(((level+1)*2) > consortiaLevel && consortiaLevel != 10)
				    {
				    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
				    	//MessageTipManager.getInstance().show("请升级公会");
				    	return false;
				    }
				break;
				case CONSORTIASTOREGRADE:
				    level = PlayerManager.Instance.Self.StoreLevel;
				    if(level >= 10)
				    {
				    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.smith"));
				    	//MessageTipManager.getInstance().show("公会保管箱已升到最高等级");
						return false;
				    }
				    else if(level >= consortiaLevel && consortiaLevel != 10)
				    {
				    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
				    	//MessageTipManager.getInstance().show("请升级公会");
				    	return false;
				    }
				break;
				case CONSORTIASMITHGRADE:
				    level = PlayerManager.Instance.Self.SmithLevel;
				    if(level >= 10)
				    {
				    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.store"));
				    	//MessageTipManager.getInstance().show("公会铁匠铺已升到最高等级");
						return false;
				    }
				    else if(level >= consortiaLevel && consortiaLevel != 10)
				    {
				    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
				    	//MessageTipManager.getInstance().show("请升级公会");
				    	return false;
				    }
				break;
			}
			if(_currentState == CONSORTIAGRADE && PlayerManager.Instance.Self.Gold < getConsortiaLevelData(level+1).NeedGold)
			{
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
					return false;
				}
				
				var tip : String = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.gold");
				this.close();
				fastPurchaseGoldBox=new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX);
				fastPurchaseGoldBox.autoDispose=true;
				fastPurchaseGoldBox.okFunction=okFastPurchaseGold;
				fastPurchaseGoldBox.cancelFunction=cancelFastPurchaseGold;
				fastPurchaseGoldBox.closeCallBack=cancelFastPurchaseGold;
				fastPurchaseGoldBox.show();
				
//				var msg : ChatData = new ChatData();
//				msg.channel = ChatInputView.SYS_TIP;
//				msg.msg     = tip;
//				ChatManager.Instance.chat(msg);
				return false;
			}
			return true;
		
		}
		
		private function okFastPurchaseGold():void
		{
			if(fastPurchaseGoldBox)
			{
				fastPurchaseGoldBox.close();
			}
			
			_quick = new QuickBuyFrame(LanguageMgr.GetTranslation("ddt.view.store.matte.goldQuickBuy"),"");
			_quick.cancelFunction=_quick.closeCallBack=cancelQuickBuy;
			_quick.itemID = EquipType.GOLD_BOX;
			_quick.x = 350;
			_quick.y = 200;
			_quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,__shortCutBuyHandler);
			_quick.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			_quick.show();
		}
		
		private function cancelQuickBuy():void
		{
			if(_quick)
			{
				_quick.close();
			}
		}
		
		private function cancelFastPurchaseGold():void
		{
			if(fastPurchaseGoldBox)
			{
				fastPurchaseGoldBox.close();
			}
		}
		
		private function removeFromStageHandler(event:Event):void{
			BagStore.Instance.reduceTipPanelNumber();
		}
		
		private function __shortCutBuyHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			this.show();
		}
		
		private function sendUpGradeData() : void
		{
			switch(_currentState)
			{
				case CONSORTIAGRADE:
				SocketManager.Instance.out.sendConsortiaLevelUp(0,0);
				break;
				case CONSORTIASHOPGRADE:
				SocketManager.Instance.out.sendConsortiaShopLevelUp();
				break;
				case CONSORTIASTOREGRADE:
				SocketManager.Instance.out.sendConsortiaBankLevelUp();
				break;
				case CONSORTIASMITHGRADE:
				SocketManager.Instance.out.sendConsortiaSmithUp();
				break;
			}
		}
        /**
        * 公会升级后刷新页面 
        */
		private function upView() : void
		{
			var level        : int;
			this.okBtnEnable = true;
			switch(_currentState)
			{
				case CONSORTIAGRADE:
				    level = consortiaLevel();
				    if(level==0)return;
				    var upLevel      : ConsortiaLevelInfo = getConsortiaLevelData(level+1);
				    var currentLevel : ConsortiaLevelInfo = getConsortiaLevelData(level);
				    if(level >= 10)
					{
						this.okBtnEnable = false;
					 	_upgrade.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.explainTxt",currentLevel.Count);
					 	_upgrade.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 	_upgrade.consumeTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 }
					 else
					 {
					 	_upgrade.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.upgrade",currentLevel.Count);
		                if(upLevel)_upgrade.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.nextLevel",(level+1),upLevel.Count);
		                if(upLevel)
		                {
		                	_upgrade.consumeTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.consumeTxt",String(upLevel.Riches),checkRiches(getConsortiaLevelData(level+1).Riches),upLevel.NeedGold)
		                	+checkGoldTxt(upLevel.NeedGold);
		                }
		                
					 }
					 _upgrade.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 _upgrade.titleTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.titleTxt");//"公会升级";
				break;
				case CONSORTIASHOPGRADE:
				    level = PlayerManager.Instance.Self.ShopLevel;
				    if(level >= 5)
					{
						this.okBtnEnable = false;
					 	_upgrade.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel");
					 	//_upgrade.explainTxt.text = "公会商城已经是最高等级";
					 	_upgrade.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 	_upgrade.consumeTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 	_upgrade.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 }
					 else
					 {
					 	_upgrade.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE.explainTxt");
					 	//_upgrade.explainTxt.text = "升级后可购买更高级的商品";
		                _upgrade.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.consortiashop.ConsortiaShopView.titleText")+(level+1)+LanguageMgr.GetTranslation("grade");
		                //_upgrade.nextLevel.text  = "公会商城"+(level+1)+"级";
		                _upgrade.appealTxt.text  = LanguageMgr.GetTranslation("consortia.upgrade")+((level+1)*2)+LanguageMgr.GetTranslation("grade");
		                //_upgrade.appealTxt.text  = "公会等级"+((level+1)*2)+"级";
		                if(getConsortiaLevelData(level+1))
		                _upgrade.consumeTxt.htmlText = getConsortiaLevelData(level+1).ShopRiches +LanguageMgr.GetTranslation("consortia.Money")+checkRiches(getConsortiaLevelData(level+1).ShopRiches);
		                //_upgrade.consumeTxt.htmlText = getConsortiaLevelData(level+1).ShopRiches +"财富"+checkRiches(getConsortiaLevelData(level+1).ShopRiches);
					 }
					 _upgrade.titleTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopUpgrade");
					 //_upgrade.titleTxt.text  = "公会商城升级";
				break;
				case CONSORTIASTOREGRADE:
				     level = PlayerManager.Instance.Self.StoreLevel;
				    if(level >= 10)
					{
						this.okBtnEnable = false;
					 	_upgrade.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.smith");
					 	//_upgrade.explainTxt.text = "公会保管箱已经是最高等级";
					 	_upgrade.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 	_upgrade.consumeTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 	_upgrade.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 }
					 else
					 {
					 	_upgrade.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.contentUpgrade",(level*10));
					 	//_upgrade.explainTxt.text = "升级后可提升保管箱容量，目前可储存数量为"+(level*10)+"格";
		                _upgrade.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.contentSmith",(level+1),((level+1)*10));
		                //_upgrade.nextLevel.text  = "保管箱"+(level+1)+"级，可储存数量"+((level+1)*10)+"格";
		                _upgrade.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.appealTxt",(level+1));
		                //_upgrade.appealTxt.text  = "公会等级"+(level+1)+"级";
		                if(getConsortiaLevelData(level+1))
		                _upgrade.consumeTxt.htmlText = getConsortiaLevelData(level+1).StoreRiches +LanguageMgr.GetTranslation("consortia.Money")+checkRiches(getConsortiaLevelData(level+1).StoreRiches);
		                //_upgrade.consumeTxt.htmlText = getConsortiaLevelData(level+1).StoreRiches +"财富"+checkRiches(getConsortiaLevelData(level+1).StoreRiches);
					 }
					 _upgrade.titleTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaSmithUpgrade");
					 //_upgrade.titleTxt.text  = "公会保管箱升级";
				break;
				case CONSORTIASMITHGRADE:
				    level = PlayerManager.Instance.Self.SmithLevel;
				    if(level >= 10)
					{
						this.okBtnEnable = false;
					 	_upgrade.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.store");
					 	//_upgrade.explainTxt.text = "公会铁匠铺已经是最高等级";
					 	_upgrade.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 	_upgrade.consumeTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 	_upgrade.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					 }
					 else
					 {
					 	_upgrade.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.success")+successRatio(level);
					 	//_upgrade.explainTxt.text = "升级后可提升强化合成成功率，目前提升成功率"+successRatio(level);
		                _upgrade.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.storeSuccess",(level+1),successRatio(level+1));
		                //_upgrade.nextLevel.text  = "公会铁匠铺"+(level+1)+"级，提升成功率"+successRatio(level+1);
		                _upgrade.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.appealTxt",(level+1));
		                //_upgrade.appealTxt.text  = "公会等级"+(level+1)+"级";
		                if(getConsortiaLevelData(level+1))
		                _upgrade.consumeTxt.htmlText = getConsortiaLevelData(level+1).SmithRiches +LanguageMgr.GetTranslation("consortia.Money")+checkRiches(getConsortiaLevelData(level+1).SmithRiches);
		                //_upgrade.consumeTxt.htmlText = getConsortiaLevelData(level+1).SmithRiches +"财富"+checkRiches(getConsortiaLevelData(level+1).SmithRiches);
					 }
					 _upgrade.titleTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.storeUpgrade");
					 //_upgrade.titleTxt.text  = "公会铁匠铺升级";
				break;
			}
			
			 _upgrade.levelTxt.text    = String(consortiaLevel());
			 _upgrade.levelTxt2.text   = String(PlayerManager.Instance.Self.SmithLevel);
			 _upgrade.levelTxt3.text   = String(PlayerManager.Instance.Self.ShopLevel);
			 _upgrade.levelTxt4.text   = String(PlayerManager.Instance.Self.StoreLevel);
		}
		
		private function checkRiches($riches : int) : String
		{
			if(consortiaRiches >= $riches)
			{
				return "";
			}
			else
			{
				return LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
				//return "<FONT SIZE='12' FACE='Arial' KERNING='2' COLOR='#ff0000'>(条件不足)</FONT>";
			}
			
		}
		private function checkGoldTxt($gold : int) : String
		{
			if(PlayerManager.Instance.Self.Gold >= $gold)
			{
				return "";
			}
			return LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
			//return "<FONT SIZE='12' FACE='Arial' KERNING='2' COLOR='#ff0000'>(条件不足)</FONT>";
		}
		
		private function successRatio($level : int) : String
		{
			var rate : String = ($level*10)+"%";
			return String(rate);
		}
		
		private function getConsortiaLevelData($level : int) : ConsortiaLevelInfo
		{
			$level <= 0 ? 1 : false;
			var info : ConsortiaLevelInfo = ConsortiaLevelUpManager.Instance.getLevelData($level) as ConsortiaLevelInfo;
			return info;
		}

		private function consortiaLevel() : int
		{
			return PlayerManager.Instance.Self.ConsortiaLevel;
		}

		private function get consortiaRiches() : int
		{
			return PlayerManager.Instance.Self.ConsortiaRiches;
		}
		
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(_upgrade && _upgrade.parent)_upgrade.parent.removeChild(_upgrade);
			_upgrade = null;
			_currentBtn = null;
			if(this.parent)this.parent.removeChild(this);
			if(fastPurchaseGoldBox)
			{
				fastPurchaseGoldBox.dispose();
				fastPurchaseGoldBox=null;
			}
			if(_quick)
			{
				_quick.dispose();
				_quick=null;
			}
		}
		
		private function __openRichesTip() : void
		{
			SoundManager.instance.play("047");
			var tipFrame : ConosritaRichesTipsFrame = new ConosritaRichesTipsFrame();
			tipFrame.show();
		}
	}
}