package ddt.store.states
{
	import game.crazyTank.view.storeII.StoreIIBGAsset;
	import game.crazyTank.view.storeII.TutorialStepAsset;
	
	import road.ui.manager.UIManager;
	
	import ddt.store.StoreController;
	
	/**
	 * @author Wicki LA
	 * @time 12/10/2009
	 * @description 普通铁匠铺视图
	 * */
	
	public class GeneralStoreView extends BaseStoreView
	{
		public function GeneralStoreView(controller:StoreController)
		{
			super(controller);
		}
		
		override protected function init():void
		{
			super.init();
			var bg:StoreIIBGAsset = new StoreIIBGAsset();
			bg.ConsortiaStoreTitleAsset.visible = false;
			bg.store_pos.visible = false;
			addChildAt(bg,0);
			
			_container.x += bg.store_pos.x;
			_container.y += bg.store_pos.y;
		}
		
	}
}