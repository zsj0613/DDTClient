package ddt.view.changeColor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.DragManager;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;

	public class ChangeColorBagCell extends BagCell
	{
		public function ChangeColorBagCell(index:int, info:ItemTemplateInfo=null, showLoading:Boolean=true, bg:Sprite=null)
		{
			super(index, info, showLoading, bg);
		}
		
		/**
		 * 重写方法，拖拽回背包的时候不换位置
		 * */
		override public function dragDrop(effect:DragEffect):void
		{
			if(effect.data is InventoryItemInfo)
			{
				var info:InventoryItemInfo = effect.data as InventoryItemInfo;
				if(locked)
				{
					if(info == this.info)
					{
						this.locked = false;
						DragManager.acceptDrag(this);
					}
					else
					{
						DragManager.acceptDrag(this,DragEffect.NONE);
					}
				}
				else
				{
		        	effect.action = DragEffect.NONE;
					DragManager.acceptDrag(this);					
				}
				
			}
		}
		
	}
}