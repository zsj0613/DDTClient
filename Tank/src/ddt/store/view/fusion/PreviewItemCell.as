package ddt.store.view.fusion
{
	import flash.events.MouseEvent;
	import game.crazyTank.view.common.BlankCellBgAsset;
	
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.LinkedBagCell;
	
	
	/******************************************
	 *      只是用来显示,不可操作的节点
	 * ***************************************/
	public class PreviewItemCell extends LinkedBagCell
	{
		public function PreviewItemCell()
		{
			super(new BlankCellBgAsset());
		}
		override public function dragDrop(effect:DragEffect):void
		{
		}
				
		override protected function __onMouseDown(evt:MouseEvent):void
		{
			
		}
	}
}