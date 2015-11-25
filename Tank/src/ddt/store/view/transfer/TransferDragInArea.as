package ddt.store.view.transfer
{
	import flash.display.Sprite;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.interfaces.IAcceptDrag;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.view.cells.DragEffect;

	public class TransferDragInArea extends Sprite implements IAcceptDrag
	{
		private var _cells:Array;
		
		public function TransferDragInArea(cells:Array)
		{
			super();
			
			_cells = cells;
			
			graphics.beginFill(0x0000ff,0);
			graphics.drawRect(57,0,345,360);
			graphics.endFill();
//			init();
		}
		
//		private function init():void
//		{
//			for(var i:int = 0;i<_cells.length;i++)
//			{
//				_cells[i].addEventListener(CellEvent.DOUBLE_CLICK,__doubleClick);
//			}
//		}
//		
//		private function __doubleClick(evt:CellEvent):void
//		{
//			(evt.data as LinkedBagCell).bagCell.locked = false;
//			(evt.data as LinkedBagCell).bagCell = null;
//		}
		
		public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var info:InventoryItemInfo = effect.data as InventoryItemInfo;
			if(info && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
				if(info.getRemainDate() <= 0)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
					//MessageTipManager.getInstance().show("此物品已过期");
					DragManager.acceptDrag(this);
				}
				else
				{
					var hasCell:Boolean = false;
					for(var i:int = 0; i < _cells.length; i ++)
					{
						if(_cells[i].info == null)
						{
							_cells[i].dragDrop(effect);
							if(effect.target)
							{
								break;
							}
						}
						else if(_cells[i].info == info)
						{
							hasCell = true;
						}
					}
					
					if(effect.target == null)
					{
						if(!hasCell)
						{
//							MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"));
//							MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.move"));
							//MessageTipManager.getInstance().show("物品已满或做为原装备无属性可转移!");
							MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.info"))
						}
						DragManager.acceptDrag(this);
					}
				}
			}
		}
	}
}