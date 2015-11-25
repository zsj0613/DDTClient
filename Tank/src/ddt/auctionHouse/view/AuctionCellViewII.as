package ddt.auctionHouse.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.AuctionHouse.CellBgAsset;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.LinkedBagCell;
	
	/***************************************
	 *    拍卖行,不可接受拖放的格子
	 *   和AuctionCellView差不多
	 * ************************************/

	public class AuctionCellViewII extends LinkedBagCell
	{
		public static const SELECT_BID_GOOD:String = "selectBidGood";
		public static const SELECT_GOOD:String = "selectGood";
		
		public function AuctionCellViewII()
		{
			super(new CellBgAsset());
			this.mouseSilenced = true;
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
		
		}
		
		override protected function onMouseClick(evt:MouseEvent):void
		{
		}
	}
}