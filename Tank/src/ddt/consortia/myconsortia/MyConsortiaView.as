package ddt.consortia.myconsortia
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HOverIconButton;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_18;
	import tank.assets.ScaleBMP_19;
	import ddt.consortia.ConsortiaControl;
	import ddt.consortia.ConsortiaModel;
	import ddt.consortia.IConsortiaViewPage;
	import tank.consortia.accect.ConsortiaHelp;
	import tank.consortia.accect.ConsortiaPropTipAsset;
	import tank.consortia.accect.MyConsortiaViewAccect;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.data.ConsortiaLevelInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.ConsortiaLevelUpManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.view.HelpFrame;
	import ddt.view.common.RoomIIPropTip;
	import ddt.view.consortia.ConsortiaAssetManagerFrame;

	public class MyConsortiaView extends MyConsortiaViewAccect implements IConsortiaViewPage
	{
		private var _model                 : ConsortiaModel;
		private var _contro                : ConsortiaControl;
		private var _memberList            : MyConsortiaMemberList;
		private var _myConsortiaInfo       : MyConsortiaInfoPane;
		private var _myConsortiaManagerBar : MyConsortiaManagerBar;
		private var _myConsortiaEventList  : MyConsortiaEventList;
		private var _helpBtn               : HBaseButton;
		private var _assetRightBtn         : HOverIconButton;
		
		private static const CONSORTIASHOPGRADE  : String = "ShopLevelIcon";//商城
		private static const CONSORTIASTOREGRADE : String = "SmithLevelIcon";//保管箱
		private static const CONSORTIASMITHGRADE : String = "StoreLevelIcon";//铁匠铺
		public function MyConsortiaView($model:ConsortiaModel,$contro:ConsortiaControl)
		{
			_model = $model;
			_contro = $contro;
			init();
			initEvent();
		}
		
		private function init():void
		{
//			tips["ShopLevelIcon"]  = LanguageMgr.GetTranslation("ddt.consortia.consortiashop.ConsortiaShopView.titleText");
//		    tips["SmithLevelIcon"] = " "+LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaView.consortiaStore");
//		    tips["StoreLevelIcon"] = " "+LanguageMgr.GetTranslation("ddt.consortia.consortiabank.ConsortiaBankView.titleText");
			_memberList = new MyConsortiaMemberList();
			_memberList.x = memberListPos.x;
			_memberList.y = memberListPos.y;
			addChild(_memberList);
			this.removeChild(memberListPos);

            _myConsortiaInfo = new MyConsortiaInfoPane();
			addChild(_myConsortiaInfo);
			this.removeChild(myConsortiaInfoPos);
           // ComponentHelper.replaceChild(this,this.myConsortiaInfoPos,_myConsortiaInfo);
        

			_myConsortiaManagerBar = new MyConsortiaManagerBar(this._model,this._contro)
			addChild(_myConsortiaManagerBar);
			_myConsortiaManagerBar.x = ButtonContainerPos.x;
			_myConsortiaManagerBar.y = ButtonContainerPos.y;
			removeChild(ButtonContainerPos);
			
			
			_myConsortiaEventList = new MyConsortiaEventList(_model);
			_myConsortiaEventList.x = rightDisplayBoardPos.x;
			_myConsortiaEventList.y = rightDisplayBoardPos.y;
			addChild(_myConsortiaEventList);
			rightDisplayBoardPos.visible = false;
			_myConsortiaEventList.visible = false;
			displayBoardBtnAccect.buttonMode = true;
			displayBoardBtnAccect.gotoAndStop(2);
			consortiaEventBtnAsset.buttonMode = true;
			
			
			
			_helpBtn = new HBaseButton(this.helpBtnAsset);
			_helpBtn.useBackgoundPos = true;
			addChild(_helpBtn);
			
			addChild(ShopLevelIcon);
			addChild(StoreLevelIcon);
			addChild(SmithLevelIcon);
			
		}
		
		private function initEvent():void
		{
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__dutyLevelChange);
			_model.addEventListener(ConsortiaDataEvent.MY_CONSORTIA_DATA_CHANGE,__myConsortiaDataChange);
			_model.addEventListener(ConsortiaDataEvent.UP_MY_CONSORTIA_DATA_CHANGE,__upMyConsortiaDataChange);
			_model.addEventListener(ConsortiaDataEvent.CONSORTIA_MEMBER_LIST_CHANGE,__memberListChannge);
			PlayerManager.Instance.addEventListener(PlayerManager.CONSORTIA_PLACARD_UPDATE, __upMyConsortiaPlacard);
			this.consortiaEventBtnAsset.addEventListener(MouseEvent.CLICK,    __consortiaEventListHandler);
			displayBoardBtnAccect.addEventListener(MouseEvent.CLICK,          __displayerBoardHandler);
			addEventListener(KeyboardEvent.KEY_DOWN,                          __keyDownHandler);
			_helpBtn.addEventListener(MouseEvent.CLICK,                       __openHelp);
			ShopLevelIcon.addEventListener(MouseEvent.MOUSE_OVER,             keepPayOverListener);
			ShopLevelIcon.addEventListener(MouseEvent.MOUSE_OUT,              keepPayOutListener);
			StoreLevelIcon.addEventListener(MouseEvent.MOUSE_OVER,            keepPayOverListener);
			StoreLevelIcon.addEventListener(MouseEvent.MOUSE_OUT,             keepPayOutListener);
			SmithLevelIcon.addEventListener(MouseEvent.MOUSE_OVER,            keepPayOverListener);
			SmithLevelIcon.addEventListener(MouseEvent.MOUSE_OUT,             keepPayOutListener);
			
//			ConsortiaAssetManagerFrame.dispatcher.addEventListener(Event.CHANGE, __AssetManagerStateChage);
            
		}
		
		private function removeEvent():void
		{
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__dutyLevelChange);
			_model.removeEventListener(ConsortiaDataEvent.MY_CONSORTIA_DATA_CHANGE,__myConsortiaDataChange);
			_model.removeEventListener(ConsortiaDataEvent.UP_MY_CONSORTIA_DATA_CHANGE,__upMyConsortiaDataChange);
			_model.removeEventListener(ConsortiaDataEvent.CONSORTIA_MEMBER_LIST_CHANGE,__memberListChannge);
			PlayerManager.Instance.removeEventListener(PlayerManager.CONSORTIA_PLACARD_UPDATE, __upMyConsortiaPlacard);
			this.consortiaEventBtnAsset.removeEventListener(MouseEvent.CLICK,    __consortiaEventListHandler);
			displayBoardBtnAccect.removeEventListener(MouseEvent.CLICK,          __displayerBoardHandler);
			removeEventListener(KeyboardEvent.KEY_DOWN,                          __keyDownHandler);
			_helpBtn.removeEventListener(MouseEvent.CLICK,                       __openHelp);
			ShopLevelIcon.removeEventListener(MouseEvent.MOUSE_OVER,             keepPayOverListener);
			ShopLevelIcon.removeEventListener(MouseEvent.MOUSE_OUT,              keepPayOutListener);
			StoreLevelIcon.removeEventListener(MouseEvent.MOUSE_OVER,            keepPayOverListener);
			StoreLevelIcon.removeEventListener(MouseEvent.MOUSE_OUT,             keepPayOutListener);
			SmithLevelIcon.removeEventListener(MouseEvent.MOUSE_OVER,            keepPayOverListener);
			SmithLevelIcon.removeEventListener(MouseEvent.MOUSE_OUT,             keepPayOutListener);
			
			 
//			ConsortiaAssetManagerFrame.dispatcher.removeEventListener(Event.CHANGE, __AssetManagerStateChage);
		}
		private function __consortiaEventListHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			_myConsortiaEventList.visible = true;
			consortiaEventBtnAsset.gotoAndStop(2);
			displayBoardBtnAccect.gotoAndStop(1);
			_myConsortiaInfo.clearPlacard = true;
			this._contro.loadMyConsortiaEventList(1,10,-1,_model.myConsortiaData.ConsortiaID);
		}
//		private function __AssetManagerStateChage(evt : Event) : void
//		{
//			assetManagerEffect.visible = !ConsortiaAssetManagerFrame.getConsortiaAssetState();
//		}
		private function __keyDownHandler(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == Keyboard.ENTER)evt.stopPropagation();
		}
		
		/*更新公告*/
		private function __upMyConsortiaPlacard(evt : Event) : void
		{
			_model.myConsortiaData.Placard = PlayerManager.Instance.SelfConsortia.Placard;
			_myConsortiaInfo.upMyConsortiaPlacard(_model.myConsortiaData.Placard);
		}
		private function __displayerBoardHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			this._myConsortiaEventList.visible = false;
			consortiaEventBtnAsset.gotoAndStop(1);
			displayBoardBtnAccect.gotoAndStop(2);
			_myConsortiaInfo.clearPlacard = false;
		}
		
		private function __dutyLevelChange(evt : PlayerPropertyEvent) : void
		{
			if(evt.changedProperties["DutyLevel"])
			{
				if(PlayerManager.Instance.Self.DutyLevel == 1)
				{
					_contro.loadConsortiaEquipContrl();
					_model.addEventListener(ConsortiaDataEvent.CONSORTIA_ASSET_LEVEL_OFFER,  __upViewHandler);
				}else
				{
					ConsortiaAssetManagerFrame.setConsortiaAssetState(true);
				}
			}
		}
		
		private function __myConsortiaDataChange(e:ConsortiaDataEvent):void
		{
			if(_model.myConsortiaData)
			{
				_myConsortiaInfo.info = _model.myConsortiaData;
//				PlayerManager.Instance.Self.ConsortiaRiches = _model.myConsortiaData.LastDayRiches;
				PlayerManager.Instance.Self.ConsortiaHonor  = _model.myConsortiaData.Honor;
			}
			/**会长有没有设置资产管理**/
			
			if(PlayerManager.Instance.Self.DutyLevel == 1)
			{
				_contro.loadConsortiaEquipContrl();
				_model.addEventListener(ConsortiaDataEvent.CONSORTIA_ASSET_LEVEL_OFFER,  __upViewHandler);
			}else
			{
				ConsortiaAssetManagerFrame.setConsortiaAssetState(true);
			}
		}
		/**会长有没有设置资产管理**/
		private function __upViewHandler(evt : ConsortiaDataEvent) : void
		{
			_model.removeEventListener(ConsortiaDataEvent.CONSORTIA_ASSET_LEVEL_OFFER,  __upViewHandler);
			if(_model.consortiaAssetLevelOffer.length > 0 && PlayerManager.Instance.Self.DutyLevel != 1)
			{
//				_assetRightBtn.isInitState = false;
//				assetManagerEffect.visible = false;
				ConsortiaAssetManagerFrame.setConsortiaAssetState(true);
			}
			else
			{
//				_assetRightBtn.isInitState = true;
//				assetManagerEffect.visible = true;
				ConsortiaAssetManagerFrame.setConsortiaAssetState(false);
			}
		}
		private function __upMyConsortiaDataChange(evt : ConsortiaDataEvent) : void
		{
			if(_model.myConsortiaData)_myConsortiaInfo.info = _model.myConsortiaData;
			if(evt.data is ConsortiaPlayerInfo)
			{
				var info : ConsortiaPlayerInfo = evt.data as ConsortiaPlayerInfo;
				this._memberList.upItem(info);
			}
			
			
		}
		
		private function __memberListChannge(e:ConsortiaDataEvent):void
		{
			if(e.data is ConsortiaPlayerInfo)
			{
				_memberList.upItem(e.data as ConsortiaPlayerInfo);
			}
			else
			{
				_memberList.memberList = _model.consortiaMemberList;
			}
			
			this._myConsortiaInfo.count = _model.consortiaMemberList.length;
		}
		
		
		public function dispose ():void
		{
			removeEvent();
			_memberList.dispose();
			if(_memberList && _memberList.parent)_memberList.parent.removeChild(_memberList);
			_memberList = null;
			_myConsortiaInfo.dispose();
			if(_myConsortiaInfo && _myConsortiaInfo.parent)_myConsortiaInfo.parent.removeChild(_myConsortiaInfo);
			_myConsortiaInfo = null;
			_myConsortiaManagerBar.dispose();
			if(_myConsortiaManagerBar && _myConsortiaManagerBar.parent)_myConsortiaManagerBar.parent.removeChild(_myConsortiaManagerBar);
			_myConsortiaManagerBar = null;
			_myConsortiaEventList.dispose();
			if(_myConsortiaEventList && _myConsortiaEventList.parent)_myConsortiaEventList.parent.removeChild(_myConsortiaEventList);
			_myConsortiaEventList = null;
			if(_helpBtn)
			{
				if(_helpBtn.parent)_helpBtn.parent.removeChild(_helpBtn);
				_helpBtn.dispose();
			}
			_helpBtn = null;
			keepPayTip = null;
		}
		
		public function leaveView ():void
		{
			visible = false;
			removeEvent();
		}
		
		public function enterView ():void
		{
			visible = true;
			initEvent();
			_contro.loadSelfConsortiaMemberList(1);
			_contro.sendGetMyConsortiaData();
			_contro.sendLoadDutyInfo(PlayerManager.Instance.Self.ConsortiaID);
			if(_model.consortiaMemberList)
			{
				_memberList.memberList = _model.consortiaMemberList;
			}
			//removeEvent();
		}
		/**************************
		 * 打开帮助窗口
		 * "**********************/
		 private var _helpPage : HelpFrame;
		 private function initHelpPage() : void
		 {
		 	var helpBd : BitmapData = new ConsortiaHelp(0,0);
			var helpIma : Bitmap = new Bitmap(helpBd);
		 	_helpPage = new HelpFrame(helpIma);
			_helpPage.titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaView.titleText");;
			//_helpPage.titleText = "公会说明";
	        helpBd = null;
		 }
		 private function __openHelp(evt : MouseEvent) : void
		 {
			SoundManager.Instance.play("047");
			if(!_helpPage)initHelpPage();
			_helpPage.show();
		 }
		 
		 
//		 private var keepPayTip:RoomIIPropTip;
//		 private var tips : Dictionary = new Dictionary(true);
//		 private var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
//		 private function keepPayOverListener(event:MouseEvent):void
//		 {
//			itemTemplateInfo.Description = tips[event.target.name];
//			itemTemplateInfo.Property4   = "";
//			itemTemplateInfo.Name        = "";
//			if(!keepPayTip)keepPayTip = new RoomIIPropTip(false,false,false);
//			keepPayTip.changeStyle(itemTemplateInfo,event.target.width - 3,false);
//		
//			var keepPay_pos:Point = this.localToGlobal(new Point(event.target.x,event.target.y));
//			keepPayTip.x = keepPay_pos.x;
//			keepPayTip.y = keepPay_pos.y + event.target.height;
//			TipManager.AddTippanel(keepPayTip);
//			
//		}
		 
		private var keepPayTip:ConsortiaPropTipAsset;
		private function keepPayOverListener(event:MouseEvent):void
		{
			if(!keepPayTip)keepPayTip = new ConsortiaPropTipAsset();
			gradeInfoPanel(event.target.name);
			
			var keepPay_pos:Point = this.localToGlobal(new Point(event.target.x,event.target.y));
			keepPayTip.x = keepPay_pos.x - keepPayTip.width/2 + event.target.width/2 - 5;
			keepPayTip.y = keepPay_pos.y + event.target.height;
			TipManager.AddTippanel(keepPayTip);
		}
		 
		private function keepPayOutListener(event:MouseEvent):void{
			if(keepPayTip && keepPayTip.parent)TipManager.RemoveTippanel(keepPayTip);
		}
		
		
		private function gradeInfoPanel(name:String):void {
			var level        : int;
			switch(name)
			{
				case CONSORTIASHOPGRADE:
					level = PlayerManager.Instance.Self.ShopLevel;
					if(level >= 5)
					{
						keepPayTip.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel");
						keepPayTip.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
						keepPayTip.consumeTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
						keepPayTip.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					}
					else
					{
						keepPayTip.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE.explainTxt");
						keepPayTip.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.consortiashop.ConsortiaShopView.titleText")+(level+1)+LanguageMgr.GetTranslation("grade");
						keepPayTip.appealTxt.text  = LanguageMgr.GetTranslation("consortia.upgrade")+((level+1)*2)+LanguageMgr.GetTranslation("grade");
						if(getConsortiaLevelData(level+1))
							keepPayTip.consumeTxt.htmlText = getConsortiaLevelData(level+1).ShopRiches +LanguageMgr.GetTranslation("consortia.Money")+checkRiches(getConsortiaLevelData(level+1).ShopRiches);
					}
					break;
				case CONSORTIASMITHGRADE:
					level = PlayerManager.Instance.Self.StoreLevel;
					if(level >= 10)
					{
						keepPayTip.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.smith");
						keepPayTip.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
						keepPayTip.consumeTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
						keepPayTip.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					}
					else
					{
						keepPayTip.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.contentUpgrade",(level*10));
						keepPayTip.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.contentSmith",(level+1),((level+1)*10));
						keepPayTip.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.appealTxt",(level+1));
						if(getConsortiaLevelData(level+1))
							keepPayTip.consumeTxt.htmlText = getConsortiaLevelData(level+1).StoreRiches +LanguageMgr.GetTranslation("consortia.Money")+checkRiches(getConsortiaLevelData(level+1).StoreRiches);
					}
					break;
				case CONSORTIASTOREGRADE:
					level = PlayerManager.Instance.Self.SmithLevel;
					if(level >= 10)
					{
						keepPayTip.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.store");
						keepPayTip.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
						keepPayTip.consumeTxt.htmlText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
						keepPayTip.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
					}
					else
					{
						keepPayTip.explainTxt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.success")+successRatio(level);
						keepPayTip.nextLevel.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.storeSuccess",(level+1),successRatio(level+1));
						keepPayTip.appealTxt.text  = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaUpgrade.appealTxt",(level+1));
						if(getConsortiaLevelData(level+1))
							keepPayTip.consumeTxt.htmlText = getConsortiaLevelData(level+1).SmithRiches +LanguageMgr.GetTranslation("consortia.Money")+checkRiches(getConsortiaLevelData(level+1).SmithRiches);
					}
					break;
			}
			if(keepPayTip.explainTxt.textHeight < 20) {
				keepPayTip.nextLevel.y = keepPayTip.nextLevelWord.y = 26;
				keepPayTip.appealTxt.y = keepPayTip.appealTxtWord.y = 44;
				keepPayTip.consumeTxt.y = keepPayTip.consumeTxtWord.y = 62;
				keepPayTip.bg.height = 90;
			}
			else {
				keepPayTip.nextLevel.y = keepPayTip.nextLevelWord.y = 40;
				keepPayTip.appealTxt.y = keepPayTip.appealTxtWord.y = 58;
				keepPayTip.consumeTxt.y = keepPayTip.consumeTxtWord.y = 76;
				keepPayTip.bg.height = 105;
			}
		}
		
		
		private function getConsortiaLevelData($level : int) : ConsortiaLevelInfo
		{
			$level <= 0 ? 1 : false;
			var info : ConsortiaLevelInfo = ConsortiaLevelUpManager.Instance.getLevelData($level) as ConsortiaLevelInfo;
			return info;
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
		private function get consortiaRiches() : int
		{
			return PlayerManager.Instance.Self.ConsortiaRiches;
		}
		
		private function successRatio($level : int) : String
		{
			var rate : String = ($level*10)+"%";
			return String(rate);
		}
	}
}