package ddt.store.states
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.storeII.MaterialEffectBtn;
	import game.crazyTank.view.storeII.StoreIIBGAsset;
	
	import road.ui.controls.HButton.HOverIconButton;
	
	import ddt.store.StoreController;
	import road.manager.SoundManager;
	
	import ddt.view.consortia.ConsortiaAssetManagerFrame;
	
	/**
	 * @author Wicki LA
	 * @time 12/10/2009
	 * @description 公会铁匠铺视图
	 * */
	
	public class ConsortiaStoreView extends BaseStoreView
	{
		protected var bg:StoreIIBGAsset;
		protected var _effectBtn:MaterialEffectBtn;
		private var _assetRightBtn:HOverIconButton;
		
		public function ConsortiaStoreView(controller:StoreController)
		{
			super(controller);
		}
		
		override protected function init():void
		{
			super.init();
			_storeview.changeToConsortiaState();
			bg = new StoreIIBGAsset();
			bg.BaseStoreTitleAsset.visible = false;
			bg.store_pos.visible = false;
			addChildAt(bg,0);
			
			_container.x += bg.store_pos.x;
			_container.y += bg.store_pos.y;
			createEffectBtn();
		}
		
		public function createEffectBtn():void{
			_effectBtn = new MaterialEffectBtn();
			_assetRightBtn = new HOverIconButton(_effectBtn.materialBtn);
			_assetRightBtn.x = 754;
			_assetRightBtn.y = 59;
			_assetRightBtn.useBackgoundPos = false;
			addChild(_assetRightBtn);
			_assetRightBtn.addEventListener(MouseEvent.CLICK,assetBtnClickHandler);
		}
		
		/**
		 * 设施管理按钮点击
		 */
		 private function assetBtnClickHandler(event:MouseEvent):void{
		 	SoundManager.instance.play("008");
			var assetManager : ConsortiaAssetManagerFrame = new ConsortiaAssetManagerFrame();
			assetManager.show();
			_effectBtn.hoverEffect.visible = false;
			ConsortiaAssetManagerFrame.setConsortiaAssetState(true);
		 }
	}
}