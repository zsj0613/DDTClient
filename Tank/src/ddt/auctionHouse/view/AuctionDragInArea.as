package ddt.auctionHouse.view
{
	import flash.display.Sprite;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.interfaces.IAcceptDrag;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.view.cells.DragEffect;
	
	
	/***************************************
	 *        拍卖行拍卖品的拖放范围
	 * ************************************/

	public class AuctionDragInArea extends Sprite implements IAcceptDrag
	{
		private var _cells: Array;
		public function AuctionDragInArea(cells : Array)
		{
			super();
			_cells = cells;
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(-100,-10,1000,370);
			this.graphics.endFill();
		}
		
		
		public function dragDrop(effect:DragEffect):void
		{
			var info:InventoryItemInfo = effect.data as InventoryItemInfo;
			if(info && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
				if(info.getRemainDate() <= 0)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionDragInArea.this"));
					//MessageTipManager.getInstance().show("此物品已过期");
					DragManager.acceptDrag(this);
				}
				else
				{
					if(effect.target == null)
					DragManager.acceptDrag(this);
				}
			}
		}
		
	}
}