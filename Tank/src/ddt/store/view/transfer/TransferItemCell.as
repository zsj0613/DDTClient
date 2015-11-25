package ddt.store.view.transfer
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.common.BlankCellBgAsset;
	import game.crazyTank.view.storeII.cellShine;
	
	import road.manager.SoundManager;
	
	import ddt.store.StoreCell;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.BagIIEquipListView;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.common.ShineObject;


	public class TransferItemCell extends StoreCell
	{
		private var _categoryID : Number = -1;
		private var _isComposeStrength : Boolean;
		private var _refinery:int = -1;
		private var _timer:Timer = new Timer(BagIIEquipListView.DoubleClickSpeed,1);
		
		public function TransferItemCell(i:int)
		{
			super(new BlankCellBgAsset(),i);
			_isComposeStrength = false;
			bagLocked = true;
		}
		
		public function set Refinery(value:int):void
		{
			_refinery = value;
		}
		
		public function get Refinery():int
		{
			return _refinery;
		}
		
		public function set isComposeStrength(b : Boolean) : void
		{
			this._isComposeStrength = b;
		}
		
		public function set categoryId(i : Number) : void
		{
			this._categoryID = i;
		}
		
		
	
		
		private function checkComposeStrengthen() : Boolean
		{
			if(itemInfo.StrengthenLevel >0)return true;
			if(itemInfo.AttackCompose > 0)return true;
			if(itemInfo.DefendCompose > 0)return true;
			if(itemInfo.LuckCompose > 0)return true;
			if(itemInfo.AgilityCompose > 0)return true;
			return false;
		}
		
		public function set index(value:int):void{
			_index = value;
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked )return;
			var info:InventoryItemInfo  = effect.data as InventoryItemInfo;
			if(info && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
				if(info.getRemainDate() <= 0)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));	
					return;	
				}
				if(!info.CanCompose && !info.CanStrengthen)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.object"));	
					//MessageTipManager.getInstance().show("该装备类型不符！");	
					return;	
				}
				if(info.Level != 3)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.object"));	
					//MessageTipManager.getInstance().show("该装备类型不符！");	
					return;	
				}
				if(_isComposeStrength)
				{
					if(!checkComposeStrengthen())return;
				}
				if(_categoryID > 0)
				{
					if(info.CategoryID != this._categoryID)
					{
						if(info.CanEquip == 0)
						{
							MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.current"));
							//MessageTipManager.getInstance().show("当前类型不符！");	
							return;
						}
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));	
						//MessageTipManager.getInstance().show("请放入相同部位的装备。");	
						return;	
					}
				
				}
//				if(Refinery != -1 && Refinery != info.Refinery)
//				{
//					MessageTipManager.getInstance().show("请放入炼化等级相同的装备!");
//					return;
//				}
				
				if(info.CanEquip)//改成可转移的
				{
//					bagCell = effect.source as BagCell;
//					DragManager.acceptDrag(this,DragEffect.LINK);
					 SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,1);
					DragManager.acceptDrag(this,DragEffect.NONE);
					return;
				}
				else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.current"));	
					//MessageTipManager.getInstance().show("当前类型不符！");	
				}
				
			}
		}
	}
}