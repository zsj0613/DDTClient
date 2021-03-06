package ddt.store.view.lianhua
{
	import game.crazyTank.view.storeII.lianhuaCellBGAsset;
	
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
	 * @description 炼化辅助材料格子
	 * */
	public class LianhuaAidedMatieriaCell extends StoreCell
	{
		public function LianhuaAidedMatieriaCell($index:int)
		{
			super(new lianhuaCellBGAsset(),$index);
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
				}else if(info.CategoryID == 11 && info.Property1=="33")
				{
					SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,1);
					effect.action = DragEffect.NONE;
					DragManager.acceptDrag(this);
				}
			}
		}
		
		override public function updateCount():void
		{
			if(_tbxCount)
			{
				if(_info && itemInfo && itemInfo.MaxCount > 1)
				{
					_tbxCount.text = String(itemInfo.Count) + "/3";
					_tbxCount.visible = true;
					addChild(_tbxCount);
				}
				else
				{
					_tbxCount.visible = false;
				}
			}
		}

	}
}