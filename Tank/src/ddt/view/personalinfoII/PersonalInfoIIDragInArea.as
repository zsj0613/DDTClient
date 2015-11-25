package ddt.view.personalinfoII
{
	import flash.display.Sprite;
	
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.interfaces.IAcceptDrag;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.cells.DragEffect;

	public class PersonalInfoIIDragInArea extends Sprite implements IAcceptDrag
	{
		public function PersonalInfoIIDragInArea()
		{
			super();
			init();
		}
		
		private function init():void
		{
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,450,310);
			graphics.endFill();
		}
		
		public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked)return;
			var info:InventoryItemInfo = effect.data as InventoryItemInfo;
			if((info.BindType ==1 || info.BindType == 2 || info.BindType == 3) && info.IsBinds == false)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.bagII.BagIIView.BindsInfo"),true,sendDefy,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
				temInfo = info;
				temEffect = effect;
				DragManager.acceptDrag(this,DragEffect.NONE);
				return;
			}
			if(info)
			{
				effect.action = DragEffect.NONE;
				if(info.Place < 31)
				{
					DragManager.acceptDrag(this);
				}
				else if(PlayerManager.Instance.Self.canEquip(info))
				{
					//位子设置为1,让服务器自动分配装备的位置
					SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getDressEquipPlace(info));
					DragManager.acceptDrag(this,DragEffect.MOVE);
				}
				else
				{
					DragManager.acceptDrag(this);
				}
			}
		}
		
		private var temInfo:InventoryItemInfo;
		private var temEffect:DragEffect
		private function sendDefy():void
		{
			if(temInfo)
			{
				temEffect.action = DragEffect.NONE;
				if(temInfo.Place < 31)
				{
					DragManager.acceptDrag(this);
				}
				else if(PlayerManager.Instance.Self.canEquip(temInfo))
				{
					//位子设置为1,让服务器自动分配装备的位置
					SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,temInfo.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getDressEquipPlace(temInfo));
					DragManager.acceptDrag(this,DragEffect.MOVE);
				}
				else
				{
					DragManager.acceptDrag(this);
				}
			}
		}
	}
}