package ddt.room
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomII.DuplicateDropCellAsset;
	
	import ddt.view.cells.DragEffect;
	import ddt.view.cells.LinkedBagCell;

	public class DuplicateDropCell extends LinkedBagCell
	{
		public function DuplicateDropCell()
		{
			super(new DuplicateDropCellAsset());
			this.allowDrag= false;
			removeEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown);
		}
		override public function dragDrop(effect:DragEffect):void
		{
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CHANGE));
			
			super.onMouseOver(evt);
			if(Tip)Tip.showBound = false;
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			super.onMouseOut(evt);
		}
		
		override protected function onMouseClick(evt:MouseEvent):void
		{
			
		}
		
		override protected function createContentComplete():void
		{
			super.createContentComplete();
			_pic.width = 45;
			_pic.height = 46;
		}
	}
}