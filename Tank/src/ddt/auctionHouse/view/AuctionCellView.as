package ddt.auctionHouse.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.AuctionHouse.CellBgIIAsset;
	
	import road.manager.SoundManager;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.DragManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.LinkedBagCell;

	public class AuctionCellView extends LinkedBagCell
	{
		public static const SELECT_BID_GOOD:String = "selectBidGood";
		public static const SELECT_GOOD:String = "selectGood";
		
		public function AuctionCellView()
		{
			super(new CellBgIIAsset());
			_bg.graphics.beginFill(0,0);
			_bg.graphics.drawRect(0,0,45,45);
			_bg.graphics.endFill();
//			_bg.alpha = 0;
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
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionCellView.Object"));
					//MessageTipManager.getInstance().show("物品已过期");
				}
				else if(info.IsBinds)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionCellView.Sale"));
					//MessageTipManager.getInstance().show("物品已绑定,不能拍卖");
				}
				else
				{
					DragManager.acceptDrag(this,DragEffect.LINK);
					bagCell = effect.source as BagCell;
				}
			}
		}
		
		override public function dragStop(effect:DragEffect):void{
			super.dragStop(effect);
		}
		override protected function onMouseClick(evt:MouseEvent):void
		{
			super.onMouseClick(evt);
			dispatchEvent(new Event(AuctionCellView.SELECT_BID_GOOD));
		}
		public function onObjectClicked():void{
//			SoundManager.instance.play("008");
			super.dragStart();
		}
	}
}