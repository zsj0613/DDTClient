package ddt.store.view.storeBag
{
	import flash.display.Sprite;
	
	
	import ddt.store.events.StoreDargEvent;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;

	public class StoreBagCell extends BagCell
	{
		public function StoreBagCell(index:int, info:ItemTemplateInfo=null, showLoading:Boolean=true, bg:Sprite=null)
		{
			super(index, info, showLoading, bg);
			bagLocked = true;
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var dragItemInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
			if(!checkBagType(dragItemInfo)) return;
			SocketManager.Instance.out.sendMoveGoods(dragItemInfo.BagType,dragItemInfo.Place,bagType,getPlace(dragItemInfo),1);
			effect.action = DragEffect.NONE;
			DragManager.acceptDrag(this);
		}
		
		override public function dragStart():void 
		{
			if(_info && !locked && stage)
			{
				if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,true))
				{
					locked = true;
					dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.START_DARG,true));					
				}
			}
		}
		
		override public function dragStop(effect:DragEffect):void
		{			
			if(PlayerManager.Instance.Self.bagLocked && bagLocked)
			{
				effect.action = DragEffect.NONE;
				super.dragStop(effect);
			}
			else if(effect.action == DragEffect.MOVE && effect.target == null)
			{
				sellItem();
			}
			else if(effect.action == DragEffect.SPLIT && effect.target == null)
			{
				locked = false;
			}
			else
			{
				super.dragStop(effect);
			}
			dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.STOP_DARG,true));
		}
		
		private function getPlace(dragItemInfo:InventoryItemInfo):int
		{
			return -1;
		}
		
		private function checkBagType(info:InventoryItemInfo):Boolean
		{
			if(info == null) return false;
			if(info.BagType == bagType) return false;
			if(info.CategoryID == 10 || info.CategoryID == 11 || info.CategoryID == 12)
			{
				if(bagType == BagInfo.EQUIPBAG)
				{
					return false;
				}else
				{
					return true;
				}
			}else
			{
				if(bagType == BagInfo.EQUIPBAG)
				{
					return true;
				}else
				{
					return false;
				}
			}
			return false;
		}
	}
}