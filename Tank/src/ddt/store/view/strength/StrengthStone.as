package ddt.store.view.strength
{
	import ddt.store.StoneCell;
	
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.cells.DragEffect;
	
	/**
	 * @author WickiLA
	 * @time 12/07/2009
	 * @description 强化的石头格子，需要根据其他格子的类型来判断是否能放东西进去
	 * */

	public class StrengthStone extends StoneCell
	{
		private var _stoneType:String = "";
		private var _itemType:int = -1;
		public function StrengthStone(stoneType:Array,i:int)
		{
			super(stoneType,i);
		}
		
		public function set itemType(value:int):void
		{
			_itemType = value;
		}
		
		public function get itemType():int
		{
			return _itemType;
		}
		
		public function get stoneType():String
		{
			return _stoneType;
		}
		
		public function set stoneType(value:String):void
		{
			_stoneType = value;
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked) return;
			
			var sourceInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
			if(sourceInfo.BagType == BagInfo.STOREBAG && info != null) return;
			if(_types.indexOf(sourceInfo.Property1)==-1) return;
			if(sourceInfo && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
//				if(_itemType == -1 || (_itemType == 0 && sourceInfo.Property1 == StoneType.STRENGTH) || (_itemType == 1 && sourceInfo.Property1 == StoneType.STRENGTH_1))
				//				{
					if(_stoneType == "" || _stoneType == sourceInfo.Property1)
					{
						_stoneType =sourceInfo.Property1;
						SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,1);
						DragManager.acceptDrag(this,DragEffect.NONE);
						reset();
					}else
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
					}
					//				}else
					//				{
					//					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
					//				}
			}
		}
		
		private function reset():void
		{
			_stoneType = "";
			_itemType = -1;
		}
		
	}
}