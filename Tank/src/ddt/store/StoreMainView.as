package ddt.store
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.storeII.StoreIIAsset;
	
	import road.manager.SoundManager;
	
	import ddt.store.events.ChoosePanelEvnet;
	import ddt.store.events.StoreIIEvent;
	import ddt.store.view.Compose.StoreIIComposeBG;
	import ddt.store.view.embed.StoreEmbedBG;
	import ddt.store.view.fusion.StoreIIFusionBG;
	import ddt.store.view.lianhua.StoreLianhuaBG;
	import ddt.store.view.strength.StoreIIStrengthBG;
	import ddt.store.view.transfer.StoreIITransferBG;
	
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.BagEvent;
	import ddt.view.consortia.ConsortiaAssetManagerFrame;
	
	public class StoreMainView extends StoreIIAsset
	{
		private var _composePanel:StoreIIComposeBG;//合成
		private var _strengthPanel:StoreIIStrengthBG;//强化
		private var _fusionPanel : StoreIIFusionBG;//熔炼
		private var _lianhuaPanel:StoreLianhuaBG;//炼化
		private var _embedPanel:StoreEmbedBG;//镶嵌
		private var _transferPanel : StoreIITransferBG;//转移
		private var _currentPanelIndex:int;
		
		public function StoreMainView()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			panel_pos.visible = false;
			_composePanel    = new StoreIIComposeBG();
			_strengthPanel   = new StoreIIStrengthBG();
			_fusionPanel     = new StoreIIFusionBG();
			_transferPanel   = new StoreIITransferBG();
			_lianhuaPanel    = new StoreLianhuaBG();
			_embedPanel      = new StoreEmbedBG();
			_strengthPanel.x = _composePanel.x = _fusionPanel.x  = _lianhuaPanel.x = _embedPanel.x = panel_pos.x;
			_strengthPanel.y = _composePanel.y = _fusionPanel.y  = _lianhuaPanel.y = _embedPanel.y = panel_pos.y;
			addChild(_fusionPanel);
			addChild(_transferPanel);
			addChild(_composePanel);
			addChild(_lianhuaPanel);
			addChild(_embedPanel);
			addChild(_strengthPanel);
			_strengthPanel.show();
			_currentPanelIndex=0;
			
			strength_btn.buttonMode = compose_btn.buttonMode = fusion_btn.buttonMode = embed_btn.buttonMode = transfBtn.buttonMode = true;

			bg.gotoAndStop(1);
			embed_btn.gotoAndStop(1);
			
			posOne.visible = false;
			sortBtn();
		}
		
		public function changeToConsortiaState() : void
		{
			fusion_btn.visible = false;
			transfBtn.visible = false;
			__strengthClick(null);
			_strengthPanel.consortiaRate();
		}
		
		public function changeToBaseState():void
		{
			fusion_btn.visible = true;
			transfBtn.visible = true;
			__strengthClick(null);
			_strengthPanel.consortiaRate();
		}
		
		private function initEvent():void
		{
			PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,__updateStoreBag);
			
			strength_btn.addEventListener(MouseEvent.CLICK,__strengthClick);
			compose_btn.addEventListener(MouseEvent.CLICK,__composeClick);
			fusion_btn.addEventListener(MouseEvent.CLICK,__fusionClick);
//			lianhua_btn.addEventListener(MouseEvent.CLICK,__lianhuaClick);
			embed_btn.addEventListener(MouseEvent.CLICK,__embedBtnClick);
			transfBtn.addEventListener(MouseEvent.CLICK,__transferClick);
			_embedPanel.addEventListener(StoreIIEvent.EMBED_INFORCHANGE,embedInfoChangeHandler);
			_strengthPanel.addEventListener(Event.CHANGE,changeHandler);
		}
		
		private function removeEvents():void
		{
			PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,__updateStoreBag);
			strength_btn.removeEventListener(MouseEvent.CLICK,__strengthClick);
			compose_btn.removeEventListener(MouseEvent.CLICK,__composeClick);
			fusion_btn.removeEventListener(MouseEvent.CLICK,__fusionClick);
//			lianhua_btn.addEventListener(MouseEvent.CLICK,__lianhuaClick);
			embed_btn.removeEventListener(MouseEvent.CLICK,__embedBtnClick);
			transfBtn.addEventListener(MouseEvent.CLICK,__transferClick);
			_embedPanel.removeEventListener(StoreIIEvent.EMBED_INFORCHANGE,embedInfoChangeHandler);
			_strengthPanel.removeEventListener(Event.CHANGE,changeHandler);
		}
		
		private function changeHandler(evt:Event):void
		{
			embed_btn.gotoAndStop(1);
		}
		
		private function __updateStoreBag(evt:BagEvent):void
		{
			currentPanel.refreshData(evt.changedSlots);
		}
		
		public function set currentPanelIndex(cp:int):void
		{
			_currentPanelIndex=cp;
			dispatchEvent(new ChoosePanelEvnet(_currentPanelIndex));
		}		
		
		public function get currentPanelIndex():int
		{
			return _currentPanelIndex;
		}
		
		public function get currentPanel():IStoreViewBG
		{
			switch(this.currentPanelIndex)
			{
				case 0:
				    return _strengthPanel;
				case 1:
				    return _composePanel;
				case 2:
				    return _fusionPanel;
		    	case 3:
		    		return _embedPanel;
//    			case 4:
//    				return _embedPanel;
				case 5:
				    return _transferPanel;
			}
			return null;
		}
		
		private function __strengthClick(evt:MouseEvent):void
		{
			if(currentPanelIndex == 0)return;
			currentPanelIndex = 0;
			if(evt == null){
				changeToTab(currentPanelIndex,false);
			}else{
				changeToTab(currentPanelIndex);
			}
			sortBtn();
			addChild(strength_btn);
		}
		
		private function __composeClick(evt:MouseEvent):void
		{
			if(currentPanelIndex == 1)return;
			currentPanelIndex = 1;
			changeToTab(currentPanelIndex);
			sortBtn();
			addChild(compose_btn);
		}
		
		private function __fusionClick(evt:MouseEvent):void
		{
			if(currentPanelIndex == 2)return;
			currentPanelIndex = 2;
			changeToTab(currentPanelIndex);
			sortBtn();
			addChild(fusion_btn);
		}
		
		private function __lianhuaClick(evt:MouseEvent):void
		{
			
		}
		
		private function __embedBtnClick(evt:MouseEvent):void
		{
			if(currentPanelIndex == 3)return;
			currentPanelIndex = 3;
			changeToTab(currentPanelIndex);
			sortBtn();
			addChild(embed_btn);
			dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_CLICK));
		}
		
		private function __transferClick(evt : MouseEvent) : void
		{
			if(currentPanelIndex == 5)return;
			currentPanelIndex = 5;
			changeToTab(currentPanelIndex);
			sortBtn();
			addChild(transfBtn);
			
		}
		
		private function changeToTab(panelIndex:int,playMusic:Boolean = true):void
		{
			SocketManager.Instance.out.sendClearStoreBag();
			if(playMusic){
				SoundManager.instance.play("008");
			}
			_composePanel.hide();
			_strengthPanel.hide();
			_fusionPanel.hide();
			_lianhuaPanel.hide();
			_embedPanel.hide();
			_transferPanel.hide();
			currentPanel.show();
			bg.gotoAndStop(panelIndex+1);
			embed_btn.gotoAndStop(1);
		}
		
		private function __openAssetManager(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			var assetManager : ConsortiaAssetManagerFrame = new ConsortiaAssetManagerFrame();
			assetManager.show();
			ConsortiaAssetManagerFrame.setConsortiaAssetState(true);
		}
		
		private function sortBtn():void
		{
			addChild(fusion_btn);
			addChild(transfBtn);
			addChild(compose_btn);
			addChild(embed_btn);
			addChild(strength_btn);
		}
		
		public function shineEmbedBtn():void{
			embed_btn.play();
		}
		
		 private function embedInfoChangeHandler(event:StoreIIEvent):void{
		 	dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_INFORCHANGE));
		 }
		
		public function dispose():void
		{
			removeEvents();
			_composePanel.dispose();
			_composePanel = null;
			_strengthPanel.dispose();
			_strengthPanel = null;
			_transferPanel.dispose();
			_transferPanel = null;
			_fusionPanel.dispose();
			_fusionPanel = null;
			_lianhuaPanel.dispose();
			_lianhuaPanel = null;
			_embedPanel.dispose();
			_embedPanel = null;
			SocketManager.Instance.out.sendClearStoreBag();
			SocketManager.Instance.out.sendSaveDB();
			if(parent)parent.removeChild(this);
		}
	}
}