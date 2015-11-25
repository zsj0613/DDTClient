package ddt.store.view.fusion
{
	import game.crazyTank.view.storeII.FushionCellBg;
	
	import ddt.store.StoreCell;
	
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.cells.DragEffect;
	
	/**002
	 * 熔炼列表的单元格
	 */

	public class FusionItemCell extends StoreCell
	{
		
		public function FusionItemCell($index:int)
		{
			super(new FushionCellBg(),$index);
		}
		
		override public function startShine():void
		{
			_shiner.x = -3;
			_shiner.y = 4;
			_shiner.width = _shiner.height = 76;
			super.startShine();
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var sourceInfo:InventoryItemInfo  = effect.data as InventoryItemInfo;
			if(sourceInfo.BagType == BagInfo.STOREBAG && this.info != null) return;
			if(sourceInfo && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
				if(sourceInfo.getRemainDate() <= 0)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.overdue"));
					//MessageTipManager.getInstance().show("此物品已过期!");
					return;
				}
				if(sourceInfo.Property1 == StoneType.FORMULA)
				{
					return;
				}
				else if(sourceInfo.FusionType == 0 )//应为不等于0
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.fusion"));
					//MessageTipManager.getInstance().show("此物品不可熔炼!");
					return;
					
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