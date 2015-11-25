package ddt.store.view.storeBag
{
	import tank.assets.ScaleBMP_1;
	import ddt.view.cells.DragEffect;
	import ddt.interfaces.IDragable;
	import ddt.manager.PlayerManager;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.DragManager;

	/**
	 * author stork  02/23 2010
	 * 背景位图类 实现dragDrop
	 */
	 
	public class StoreBagbgbmp extends ScaleBMP_1 implements IBagDrag
	{
		public function StoreBagbgbmp()
		{
			super();
		}
		
		public function dragDrop(effect:DragEffect):void{
			if(PlayerManager.Instance.Self.bagLocked )return;
			if(effect.data is InventoryItemInfo)
			{
				var info:InventoryItemInfo = effect.data as InventoryItemInfo;
				effect.action = DragEffect.NONE;
				DragManager.acceptDrag(this);					
			}
		}
		
		public function dragStop(effect:DragEffect):void{
			
		}
		
		public function getSource():IDragable{ return this};
		
	}
}