package ddt.store
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

	public class StoreDragInArea extends Sprite implements IAcceptDrag
	{
		protected var _cells:Array;
		
		public function StoreDragInArea(cells:Array)
		{
			_cells = cells;
			init();
		}
		
		private function init():void
		{
			graphics.beginFill(0x0000ff,0);
			graphics.drawRect(0,0,340,360);
			graphics.endFill();
		}
		
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
							MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"),false);
							//MessageTipManager.getInstance().show("该类物品已满或类型不符!");
						}
						DragManager.acceptDrag(this);
					}
				}
			}
		}
		
		public function dispose():void
		{
			_cells = null;
			if(parent) parent.removeChild(this);
		}
	}
}