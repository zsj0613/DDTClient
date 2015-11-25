package ddt.view.emailII
{
	import flash.events.MouseEvent;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.LinkedBagCell;

	public class EmaillIIBagCell extends LinkedBagCell
	{	
		public function EmaillIIBagCell()
		{
			super(null);
			_bg.alpha = 0;
		}
		
		override protected function __onMouseDown(evt:MouseEvent):void
		{
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked)return;
			var info:InventoryItemInfo = effect.data as InventoryItemInfo;
			if(info && effect.action == DragEffect.MOVE)
			{
				effect.action = DragEffect.NONE;
				if(info.IsBinds)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.EmaillIIBagCell.isBinds"));
					//MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("此物品已经绑定"));
				}
				else if(info.getRemainDate() <= 0)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.EmaillIIBagCell.RemainDate"));
					//MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("此物品已经过期"));
				}
				else
				{
					bagCell = effect.source as BagCell;
					effect.action = DragEffect.LINK;
				}
				DragManager.acceptDrag(this);
			}
		}
	}
}