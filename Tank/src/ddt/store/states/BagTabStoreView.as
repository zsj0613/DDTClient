package ddt.store.states
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.storeII.BagTabStoreAsset;
	import game.crazyTank.view.storeII.TutorialStepAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HOverIconButton;
	import road.ui.manager.TipManager;
	
	import ddt.store.StoreController;
	
	import ddt.data.store.StoreState;
	import ddt.manager.SocketManager;
	import ddt.view.consortia.ConsortiaAssetManagerFrame;
	
	public class BagTabStoreView extends BaseStoreView
	{
		private var _bg:BagTabStoreAsset;
		private var _assetRightBtn:HOverIconButton;
		
		public function BagTabStoreView(controller:StoreController)
		{
			super(controller);
		}
		
		override protected function init():void
		{
			super.init();
			_bg = new BagTabStoreAsset();
			addChildAt(_bg,0);
			
			_bg.gonghui.buttonMode = _bg.tiejiang.buttonMode = true;
			_bg.gonghui.gotoAndStop(2);
			_bg.tiejiang.gotoAndStop(2);
			_bg.assetManagerEffect.visible = false;
			_bg.consortiaAssetManagerBtn.visible = false;
			StoreState.storeState = StoreState.BASESTORE;
			_storeview.changeToBaseState();
			
			_assetRightBtn = new HOverIconButton(_bg.consortiaAssetManagerBtn);
			_assetRightBtn.useBackgoundPos = true;
			addChild(_assetRightBtn);
			_bg.assetManagerEffect.mouseChildren = _bg.assetManagerEffect.mouseEnabled = false;
			addChild(_bg.assetManagerEffect);
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			_bg.gonghui.addEventListener(MouseEvent.CLICK,__changeToConsortia);
			_bg.tiejiang.addEventListener(MouseEvent.CLICK,__changeToBase);
			_assetRightBtn.addEventListener(MouseEvent.CLICK,__managerAsset);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_bg.gonghui.removeEventListener(MouseEvent.CLICK,__changeToConsortia);
			_bg.tiejiang.removeEventListener(MouseEvent.CLICK,__changeToBase);
			_assetRightBtn.removeEventListener(MouseEvent.CLICK,__managerAsset);
		}
		
		private function __changeToConsortia(evt:MouseEvent):void
		{
			if(_bg.gonghui.currentFrame == 1) return;
			SoundManager.Instance.play("008");
			_bg.gonghui.gotoAndStop(1);
			_bg.tiejiang.gotoAndStop(1);
			_bg.assetManagerEffect.visible = true;
			_bg.consortiaAssetManagerBtn.visible = true;
			StoreState.storeState = StoreState.CONSORTIASTORE;
			_storeview.changeToConsortiaState();
			SocketManager.Instance.out.sendClearStoreBag();
			_storeview.currentPanel.updateData();
		}
		
		public function __changeToBase(evt:MouseEvent):void
		{
			if(_bg.gonghui.currentFrame == 2) return;
			SoundManager.Instance.play("008");
			_bg.gonghui.gotoAndStop(2);
			_bg.tiejiang.gotoAndStop(2);
			_bg.assetManagerEffect.visible = false;
			_bg.consortiaAssetManagerBtn.visible = false;
			StoreState.storeState = StoreState.BASESTORE;
			_storeview.changeToBaseState();
			SocketManager.Instance.out.sendClearStoreBag();
			_storeview.currentPanel.updateData();
		}
		
		private function __managerAsset(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			var assetManager : ConsortiaAssetManagerFrame = new ConsortiaAssetManagerFrame();
			assetManager.show();
			_bg.assetManagerEffect.visible = false;
			ConsortiaAssetManagerFrame.setConsortiaAssetState(true);
		}

	}
}