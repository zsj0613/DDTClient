package ddt.store.view.strength
{
	
	import ddt.store.StoreDragInArea;
	
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.view.cells.DragEffect;
	
	/**
	 * @author WickiLA
	 * @time 12/07/2009
	 * @description 强化面板的拖拽区
	 * */

	public class StrengthDragInArea extends StoreDragInArea
	{
		private var _hasStone:Boolean = false;
		private var _hasItem:Boolean = false;
		private var _stonePlace:int = -1;
		private var _effect:DragEffect;
		
		public function StrengthDragInArea(cells:Array)
		{
			super(cells);
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var info:InventoryItemInfo = effect.data as InventoryItemInfo;
			_effect = effect;
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
					for(var i:int=0; i<5; i++)
					{
						if(i==0 || i==3 || i==4)
						{
							if(_cells[i].itemInfo != null)
							{
								_hasStone = true;
								_stonePlace = i;
								break;
							}
						}
					}
					if(_cells[2].itemInfo != null) _hasItem = true;
					
					if(info.CanEquip)
					{
						if(!_hasStone)
						{
							_cells[2].dragDrop(effect);
						}else
						{
							if((info.Refinery > 0 && _cells[_stonePlace].itemInfo.Property1 == "35") || (info.Refinery == 0 && _cells[_stonePlace].itemInfo.Property1 == StoneType.STRENGTH))
							{
								_cells[2].dragDrop(effect);
								reset();
							}else
							{
								MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
							}
						}
					}else
					{
						if((_cells[2].itemInfo.Refinery > 0 && info.Property1 == "35") || (_cells[2].itemInfo.Refinery == 0 && info.Property1 == StoneType.STRENGTH))
						{
							if(!_hasStone)
							{
								findCellAndDrop();
								reset();
							}else
							{
								if(_cells[_stonePlace].itemInfo.Property1 == info.Property1)
								{
									findCellAndDrop();
									reset();
								}else
								{
									MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
								}
							}
						}else
						{
							MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
						}
					}
				}
			}
		}
		
		private function findCellAndDrop():void
		{
			for(var i:int=0; i<5; i++)
			{
				if(i==0 || i==3 || i==4)
				{
					if(_cells[i].itemInfo == null)
					{
						_cells[i].dragDrop(_effect);
						reset();
						return;
					}
				}
			}
			_cells[0].dragDrop(_effect);
			reset();
		}
		
		private function reset():void
		{
			_hasStone = false;
			_hasItem = false;
			_stonePlace = -1;
			_effect = null;
		}
		
		override public function dispose():void
		{
			reset();
			super.dispose();
		}
		
	}
}