package ddt.store.view.fusion
{
	import game.crazyTank.view.storeII.FushionCellBg;
	
	import ddt.store.StoreCell;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.cells.DragEffect;
	
	/**
	 * 熔炼附加列表的单元格
	 */
	public class AccessoryItemCell extends StoreCell
	{
		public function AccessoryItemCell($index:int)
		{
			super(new FushionCellBg(),$index);
			bagLocked = true;
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var sourceInfo:InventoryItemInfo  = effect.data as InventoryItemInfo;
			if(sourceInfo.BagType == BagInfo.STOREBAG && info != null) return;
			if(sourceInfo && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
				if(sourceInfo.getRemainDate() <= 0)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.overdue"));	
					//MessageTipManager.getInstance().show("此物品已过期!");			
				}
				else if(sourceInfo.FusionType == 0)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.fusion"));	
					//MessageTipManager.getInstance().show("此物品不可熔炼!");			
				}
				else
				{
					SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,1);
					effect.action = DragEffect.NONE;
					DragManager.acceptDrag(this);
				}
			}
		}
		
	}
}