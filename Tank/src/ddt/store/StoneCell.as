package ddt.store
{
	import game.crazyTank.view.common.BlankCellBgAsset;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.manager.DragManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.cells.DragEffect;

	public class StoneCell extends StoreCell
	{
		protected var _types:Array;
		
		public function StoneCell(stoneType:Array,$index:int)
		{
			super(new BlankCellBgAsset(),$index);
			_types = stoneType;
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(PlayerManager.Instance.Self.bagLocked) return;
			
			var sourceInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
			if(sourceInfo.BagType == BagInfo.STOREBAG && info != null) return;
			if(sourceInfo && effect.action != DragEffect.SPLIT)
			{
				effect.action = DragEffect.NONE;
				if(sourceInfo.CategoryID == 11 && _types.indexOf(sourceInfo.Property1)>-1 && sourceInfo.getRemainDate() > 0 )
				{
					SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,1);
					effect.action = DragEffect.NONE;
					DragManager.acceptDrag(this);
				}
			}
		}
		
		public function get types():Array
		{
			return _types;
		}
	}
}