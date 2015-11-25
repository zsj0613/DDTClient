package ddt.store.view.Compose
{
	import game.crazyTank.view.common.BlankCellBgAsset;
	
	import ddt.store.StoreCell;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.cells.DragEffect;

	public class ComposeItemCell extends StoreCell
	{
		public function ComposeItemCell($index:int)
		{
			super(new BlankCellBgAsset(),$index);
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var info:InventoryItemInfo  = effect.data as InventoryItemInfo;
			if(!info.CanCompose) return;
			if(info && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
				if(info.getRemainDate() <= 0)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
					//MessageTipManager.getInstance().show("此物品已过期");
				}
				else
				{
                    if(info.AgilityCompose == 40 && info.DefendCompose == 40 && info.AttackCompose == 40 && info.LuckCompose == 40)
                    {
                    	MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.ComposeItemCell.up"));
						return;
                    }
					SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,1);
					effect.action = DragEffect.NONE;
					DragManager.acceptDrag(this);
				}
			}
		}
		
	}
}