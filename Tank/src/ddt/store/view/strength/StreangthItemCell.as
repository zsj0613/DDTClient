package ddt.store.view.strength
{
	import game.crazyTank.view.common.BlankCellBgAsset;
	
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.store.StoreCell;
	
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.view.cells.DragEffect;

	public class StreangthItemCell extends StoreCell
	{
		private var _stoneType:String = "";
		
		public function StreangthItemCell($index:int)
		{
			super(new BlankCellBgAsset(),$index);
		}
		
		public function set stoneType(value:String):void
		{
			_stoneType = value;
		}
		
		override public function dragDrop(effect:DragEffect):void
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
				}
				else if(info.CanStrengthen&&isAdaptToStone(info))
				{
					if(info.StrengthenLevel == StoreIIStrengthBG.STRENGTH_MAX_LEVEL)
					{
						
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.ComposeItemCell.up"),false);
						//MessageTipManager.getInstance().show("该装备已经升级到最高级.");
						return;
					}
					if(info.StrengthenLevel == 9 && !SharedManager.Instance.isAffirm)
					{
						SharedManager.Instance.isAffirm = true;
						SharedManager.Instance.save();
						HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.game.GameViewBase.HintTitle"),LanguageMgr.GetTranslation("store.view.strength.clew"),true,null,null,true,"确定",null,0,true,false);
					}
					SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,1);
					effect.action = DragEffect.NONE;
					DragManager.acceptDrag(this);
					reset();
				}else if(!isAdaptToStone(info))
				{
//					MessageTipManager.getInstance().show("石头与装备不符111111");
				}
			}
		}
		
		private function isAdaptToStone(info:InventoryItemInfo):Boolean
		{
			if(_stoneType == "") return true;
			if(_stoneType == StoneType.STRENGTH && info.Refinery <= 0) return true;
			if(_stoneType == StoneType.STRENGTH_1 && info.Refinery > 0) return true;
			return false;
		}
		
		private function reset():void
		{
			_stoneType = "";
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}