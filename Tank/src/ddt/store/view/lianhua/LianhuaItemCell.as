package ddt.store.view.lianhua
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

	/**
	 * @author wicki LA
	 * @time 11/24/2009
	 * @description 炼化的装备格子
	 * */
	public class LianhuaItemCell extends StoreCell
	{
		public function LianhuaItemCell($index:int)
		{
			super(new BlankCellBgAsset(),$index);
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var info:InventoryItemInfo  = effect.data as InventoryItemInfo;
			if(info && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
				if(info.getRemainDate()<0)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
					//MessageTipManager.getInstance().show("此物品已过期");
					return;
				}else if(info.CanEquip && info.Refinery>=0 && info.StrengthenLevel >= 7)
				{
					SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,1);
					effect.action = DragEffect.NONE;
					DragManager.acceptDrag(this);
				}
			}
		}
		
	}
}