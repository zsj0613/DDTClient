package ddt.store.states
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.storeII.TutorialStepAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import ddt.store.IStoreViewBG;
	import ddt.store.StoreController;
	import ddt.store.StoreMainView;
	import ddt.store.Tips;
	import ddt.store.data.StoreModel;
	import ddt.store.events.ChoosePanelEvnet;
	import ddt.store.events.StoreDargEvent;
	import ddt.store.events.StoreIIEvent;
	import ddt.store.view.Compose.StoreIIComposeBG;
	import ddt.store.view.embed.StoreEmbedBG;
	import ddt.store.view.fusion.StoreIIFusionBG;
	import ddt.store.view.lianhua.StoreLianhuaBG;
	import ddt.store.view.storeBag.StoreBagCell;
	import ddt.store.view.storeBag.StoreBagController;
	import ddt.store.view.strength.StoreIIStrengthBG;
	import ddt.store.view.transfer.StoreIITransferBG;
	
	import ddt.data.EquipType;
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.manager.TaskManager;
	import ddt.view.bagII.bagStore.BagStoreFrame;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;
	import ddt.view.infoandbag.CellEvent;
	
	/**
	 * @author Wicki LA
	 * @time 12/10/2009
	 * @description 铁匠铺视图的基类，衍生出普通铁匠铺、公会铁匠铺、跟背包铁匠铺
	 * */

	public class BaseStoreView extends Sprite
	{
		protected var _controller:StoreController;
		protected var _model:StoreModel;
		protected var _container:Sprite;
		
		public var _storeview:StoreMainView;
		protected var _tip:Tips;
		protected var _storeBag:StoreBagController;
		protected var _guideEmbed:TutorialStepAsset;   //蒙板
		
		public function BaseStoreView(controller:StoreController)
		{
			super();
			_controller = controller;
			_model = _controller.Model;
			init();
			initEvents();
		}
		
		protected function init():void
		{
			_container = new Sprite();
			addChild(_container);
			
			_storeview = new StoreMainView();
			_container.addChild(_storeview);
			
			_storeBag = new StoreBagController(_model);
			_storeBag.getView().x = 385;
			_storeBag.getView().y = 12;
			_container.addChild(_storeBag.getView() as Sprite);	
			
			_tip = new Tips();
			_container.addChild(_tip);
			_tip.x = 100;
			_tip.y = 150;
			_tip.mouseChildren = _tip.mouseEnabled = false;
		}
		
		protected function initEvents():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_COMPOSE,__showTipsIII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_STRENGTH,__showTip);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_FUSION,__showTipII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_TRANSFER,__showTipsIII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_REFINERY,__showTipsIII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EMBED,__showTipsIII);
			
			_storeBag.getView().addEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);	
			_storeBag.getView().addEventListener(StoreDargEvent.START_DARG,startShine);
			_storeBag.getView().addEventListener(StoreDargEvent.STOP_DARG,stopShine);
			
			_storeview.addEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT,refresh);
			_storeview.addEventListener(StoreIIEvent.EMBED_CLICK,embedClickHandler);
			_storeview.addEventListener(StoreIIEvent.EMBED_INFORCHANGE,embedInfoChangeHandler);
		}
		
		protected function removeEvents():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_COMPOSE,__showTipsIII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_STRENGTH,__showTip);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_FUSION,__showTipII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_TRANSFER,__showTipsIII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_REFINERY,__showTipsIII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_EMBED,__showTipsIII);
			
			_storeBag.getView().removeEventListener(CellEvent.DOUBLE_CLICK,__cellDoubleClick);	
			_storeBag.getView().removeEventListener(StoreDargEvent.START_DARG,startShine);
			_storeBag.getView().removeEventListener(StoreDargEvent.STOP_DARG,stopShine);
			
			_storeview.removeEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT,refresh);
			_storeview.removeEventListener(StoreIIEvent.EMBED_CLICK,embedClickHandler);
			_storeview.removeEventListener(StoreIIEvent.EMBED_INFORCHANGE,embedInfoChangeHandler);
		}
		
		public function setAutoLinkNum(num:int):void
		{
			_model.NeedAutoLink = num;
		}
		
		private function refresh(evt:ChoosePanelEvnet):void
		{
			_model.currentPanel = evt.currentPanle;
			_storeBag.setList(_model);
			_storeBag.changeMsg(_model.currentPanel+1);
		}
		
		private function __cellDoubleClick(evt:CellEvent):void
		{
			evt.stopImmediatePropagation();	
			if(PlayerManager.Instance.Self.bagLocked)
			{
				SoundManager.Instance.play("008");
				new BagLockedGetFrame().show();
				return;
			}
			var sourceCell:BagCell = evt.data as StoreBagCell;
			var currentPanel:IStoreViewBG = _storeview.currentPanel;         
            currentPanel.dragDrop(sourceCell);
		}
		
		private function autoLink(bagType:int,pos:int):void
		{
			var sourceCell:BagCell;
			var currentPanel:IStoreViewBG = _storeview.currentPanel; 
			if(bagType == BagInfo.EQUIPBAG)
			{
				sourceCell = _storeBag.getEquipCell(pos);
			}else{
				sourceCell = _storeBag.getPropCell(pos);
			}    
            currentPanel.dragDrop(sourceCell);
		}
		
		private function startShine(evt:StoreDargEvent):void
		{
			var currentPanel:IStoreViewBG = _storeview.currentPanel;
			if(currentPanel is StoreIIStrengthBG){ 
				var spnl:StoreIIStrengthBG = currentPanel as StoreIIStrengthBG;           	
		    	if(evt.sourceInfo.CanEquip)
		    	{
		    	    spnl.startShine(5)
		    	}else if(EquipType.isStrengthStone(evt.sourceInfo)){
		    	    spnl.startShine(0);
		    	    spnl.startShine(1);
		    	    spnl.startShine(2);
		    	}else if(evt.sourceInfo.Property1 == StoneType.LUCKY){
		    	    spnl.startShine(4);
		    	}else if(evt.sourceInfo.Property1 == StoneType.SOULSYMBOL){
		    	    spnl.startShine(3);
		    	}
            }else if(currentPanel is StoreIIComposeBG){            	
		    	var cpnl:StoreIIComposeBG = currentPanel as StoreIIComposeBG;
		    	if(evt.sourceInfo.CanEquip)
		    	{
		    		cpnl.startShine(1);
		    	}else if(EquipType.isComposeStone(evt.sourceInfo))
		    	{
		    	    cpnl.startShine(2);
		    	}else if(evt.sourceInfo.Property1 == StoneType.LUCKY)
		    	{
		    		cpnl.startShine(0);
		    	}else if(evt.sourceInfo.Property1 == StoneType.SOULSYMBOL)
		    	{
		    		cpnl.startShine(3);
		    	}
            }else if(currentPanel is StoreIIFusionBG){
                var fpnl:StoreIIFusionBG = currentPanel as StoreIIFusionBG;
                if(EquipType.isComposeStone(evt.sourceInfo)||EquipType.isStrengthStone(evt.sourceInfo)||EquipType.isRongLing(evt.sourceInfo)||(evt.sourceInfo.CategoryID == 11&& evt.sourceInfo.Property1 == "31"))
                {
                	fpnl.startShine(1);
                	fpnl.startShine(2);
                	fpnl.startShine(3);
                	fpnl.startShine(4);
                }else if(evt.sourceInfo.Property1 == StoneType.FORMULA)
                {
                	fpnl.startShine(0);
                }
            }else if(currentPanel is StoreLianhuaBG)
            {
            	var lp:StoreLianhuaBG = currentPanel as StoreLianhuaBG;
            	if(evt.sourceInfo.Refinery>=0 && evt.sourceInfo.CanEquip)
            	{
            		lp.startShine(0);
            	}else if(evt.sourceInfo.Property1 == "32")
            	{
            		lp.startShine(1);
            	}else if(evt.sourceInfo.Property1 == "33")
            	{
            		lp.startShine(2);
            		lp.startShine(3);
            		lp.startShine(4);
            	}else
            	{
            		lp.startShine(5);
            	}
            }else if(currentPanel is StoreEmbedBG)
            {
            	if(evt.sourceInfo.CanEquip) {
            		(currentPanel as StoreEmbedBG).startShine();
            	}
            	else{
            		//1三角  2方形  3圆形
            		if(evt.sourceInfo.Property1 == "31" && evt.sourceInfo.Property2 == "1"){
            			(currentPanel as StoreEmbedBG).stoneStartShine(1);	
            		}
            		if(evt.sourceInfo.Property1 == "31" && evt.sourceInfo.Property2 == "2"){
            			(currentPanel as StoreEmbedBG).stoneStartShine(2);	
            		}
            		if(evt.sourceInfo.Property1 == "31" && evt.sourceInfo.Property2 == "3"){
            			(currentPanel as StoreEmbedBG).stoneStartShine(3);	
            		}
            	}
            }
		}
		
		private function stopShine(evt:StoreDargEvent):void
		{
			if(_storeview.currentPanel is StoreIIStrengthBG)
			{
				(_storeview.currentPanel as StoreIIStrengthBG).stopShine();
			}else if(_storeview.currentPanel is StoreIIComposeBG)
			{
				(_storeview.currentPanel as StoreIIComposeBG).stopShine();
			}else if(_storeview.currentPanel is StoreIIFusionBG)
			{
				(_storeview.currentPanel as StoreIIFusionBG).stopShine();
			}else if(_storeview.currentPanel is StoreIITransferBG)
			{
				(_storeview.currentPanel as StoreIITransferBG).stopShine();
			}else if(_storeview.currentPanel is StoreLianhuaBG)
			{
				(_storeview.currentPanel as StoreLianhuaBG).stopShine();
			}else if(_storeview.currentPanel is StoreEmbedBG)
			{
				(_storeview.currentPanel as StoreEmbedBG).stopShine();
			}
		}
		
		private function __showTip(evt:CrazyTankSocketEvent):void
		{
			_tip.isDisplayerTip = true;
			var success:int = evt.pkg.readByte();  //0是成功 1是失败
			var tipFlag:Boolean = evt.pkg.readBoolean();
			if(success == 0)
			{
				TaskManager.checkHighLight();
				//if(true){
					_tip.showSuccess();	
				//}else{
				//	var info:InventoryItemInfo = (_storeview.currentPanel as StoreIIStrengthBG).getStrengthItemCellInfo();
					//appearHoleTips(info);
				//	checkHasStrengthLevelThree(info);
				//}
			}
			else
			{
				_tip.showFail();
			}
		}
		
		private function checkHasStrengthLevelThree(info:InventoryItemInfo):void{
			if(PlayerManager.Instance.Self.Grade < 15 && _model.checkEmbeded() && SharedManager.Instance.hasStrength3[PlayerManager.Instance.Self.ID] == undefined && info.StrengthenLevel == 3){
				matteGuideEmbed();
				SharedManager.Instance.hasStrength3[PlayerManager.Instance.Self.ID] = true;
				SharedManager.Instance.save();	
			}
		}
		
		private function __showTipsIII(evt:CrazyTankSocketEvent):void{
			_tip.isDisplayerTip = true;
			var success:int = evt.pkg.readByte();//0是成功 1是失败
			if(success == 0)
			{
				_tip.showSuccess();	
			}
			else
			{
				_tip.showFail();
			}
		}
		
		private function __showTipII(evt:CrazyTankSocketEvent):void
		{
            _tip.isDisplayerTip = false;
			if(evt.pkg.readBoolean() == 0)
			{
				_tip.showFail();
			}
			else
			{
				_tip.showSuccess();
			}
			
		}
		
		/**
		 * 强化369出孔提示
		 */
		 private function appearHoleTips(info:InventoryItemInfo):void{
		 	//CategoryId为1帽子 5衣服 7为武器
		 	SoundManager.Instance.play("1001");
		 	if(info.CategoryID == 1){
		 		if(info.StrengthenLevel == 3){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenProperty"));
		 		}
		 		if(info.StrengthenLevel == 6){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenDefense"));
		 		}
		 		if(info.StrengthenLevel == 9){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenProperty"));
		 		}
		 	}
		 	if(info.CategoryID == 5){
		 		if(info.StrengthenLevel == 3){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenProperty"));
		 		}
		 		if(info.StrengthenLevel == 6){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenDefense"));
		 		}
		 		if(info.StrengthenLevel == 9){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenProperty"));
		 		}
		 	}
		 	if(info.CategoryID == 7){
		 		if(info.StrengthenLevel == 3){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenAttack"));
		 		}
		 		if(info.StrengthenLevel == 6){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenProperty"));
		 		}
		 		if(info.StrengthenLevel == 9){
		 			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenProperty"));
		 		}
		 	}
		 	_storeview.shineEmbedBtn();
		 }
		 
		 /**
		 * 蒙板 镶嵌指引
		 */
		 protected function matteGuideEmbed():void{
		 	_guideEmbed = new TutorialStepAsset();
		 	_guideEmbed.gotoAndStop(1);
		 	TipManager.AddTippanel(_guideEmbed);
		 	BagStoreFrame.isTabStore = false;
		 }
		 
		 /**
		 * 蒙板状态下镶嵌按钮点击处理事件
		 */
		 private function embedClickHandler(event:StoreIIEvent):void{
		 	if(_guideEmbed){
		 		_guideEmbed.gotoAndStop(6);
		 	}
		 }
		 
		 /**
		 * 蒙板状态下放入镶嵌物品处理
		 */
		 private function embedInfoChangeHandler(event:StoreIIEvent):void{
		 	if(_guideEmbed){
		 		_guideEmbed.gotoAndStop(11);
		 		event.stopImmediatePropagation();
		 		HConfirmDialog.show(LanguageMgr.GetTranslation("store.states.embedTitle"),LanguageMgr.GetTranslation("ddt.view.store.matteTips"),true,okFunction,okFunction,true,null,null,0,true,false);
		 	}
		 }
		 
		 private function okFunction():void{
		 	TipManager.RemoveTippanel(_guideEmbed);
		 	_guideEmbed = null;
		 	BagStoreFrame.isTabStore = true;
		 }
		
		public function dispose():void
		{
			if(parent) parent.removeChild(this);
			removeEvents();
			_storeview.dispose();
			_tip.dispose();
			_storeBag.dispose();
			_controller = null;
			_model = null;
			_container = null;
		}
		
	}
}