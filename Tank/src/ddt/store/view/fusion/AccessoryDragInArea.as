package ddt.store.view.fusion
{
	import flash.display.Sprite;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.interfaces.IAcceptDrag;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.view.cells.DragEffect;

	public class AccessoryDragInArea extends Sprite implements IAcceptDrag
	{
		private var _cells:Array;
		
		public function AccessoryDragInArea(cells:Array)
		{
			super();
			
			_cells = cells;
			
			graphics.beginFill(0x0000ff,0);
			//graphics.drawRect(0,0,0,0);
			graphics.drawRect(-40,-40,280,230);
			graphics.endFill();
		}
		
		
		/****************************************
		 * 先判断是否过期
		 * 后遍历容器各对象,如果为空
		 * 则进入dragDrop进行判断
		 * 如果正确,则其target为true
		 * *****************************/
		public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var info:InventoryItemInfo = effect.data as InventoryItemInfo;
			if(info.BagType == BagInfo.STOREBAG)
			{
				effect.action = DragEffect.NONE;
				DragManager.acceptDrag(this);
				return;
			}
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
					var hasEmpty:Boolean = false;
					var hasCell : Boolean = false;
					for(var i: int = 0 ;i< _cells.length;i++)
					{
						if(_cells[i].info == null)
						{
							hasEmpty = true;
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
							if(hasEmpty)
							{
								
								MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"));
								//MessageTipManager.getInstance().show("该类物品已满或类型不符!");
							}
							else
							{
								
								MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.more"));
								//MessageTipManager.getInstance().show("您不能放入更多!");
							}
						}
						DragManager.acceptDrag(this);
					}
						
						
						
					
					//}
				}
			}
		}
	}
}