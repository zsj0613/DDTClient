package ddt.gameover.torphy
{
	import flash.events.MouseEvent;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.view.bagII.SellGoodsBtn;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.DragEffect;
	import ddt.view.infoandbag.CellEvent;

	public class TrophyCell extends BagCell
	{
		private var _isSellGoods:Boolean;
		
		public function TrophyCell(info:InventoryItemInfo, index:int)
		{
			super(index,info);
			addEventListener(MouseEvent.CLICK,__click);
		}
		
		override public function dragDrop(effect:DragEffect):void
		{
			if(effect.data is SellGoodsBtn)
			{
				_isSellGoods=true;
			}
			else
			{
				_isSellGoods=false;
			}
		}		
		override public function set info(value:ItemTemplateInfo):void
		{
			super.info = value;
			if(value != null)
				buttonMode = true;
			else
				buttonMode = false;
		}
		
		private function __click(event:MouseEvent):void
		{
			if(info && !_isSellGoods)
			{
				dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
			}
			_isSellGoods=false;
		}
		
	}
}