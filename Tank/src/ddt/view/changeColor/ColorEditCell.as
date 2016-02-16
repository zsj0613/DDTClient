package ddt.view.changeColor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.manager.PlayerManager;
	import ddt.view.cells.LinkedBagCell;

	public class ColorEditCell extends LinkedBagCell
	{
		public function ColorEditCell(bg:Sprite)
		{
			super(bg);
			super.DoubleClickEnabled = false;
		}
		
		override protected function onMouseClick(evt:MouseEvent):void
		{
			if(this.itemInfo!=null)
			{
				TipManager.setCurrentTarget(null,null);
				SoundManager.Instance.play("008");
				if(_bagCell.itemInfo && _bagCell.itemInfo.lock)
				{
					if(_bagCell.itemInfo.BagType == 0)
					{
						PlayerManager.Instance.Self.Bag.unlockItem(_bagCell.itemInfo);
					}else
					{
						PlayerManager.Instance.Self.PropBag.unlockItem(_bagCell.itemInfo);
					}
				}
				bagCell.locked = false;
				bagCell = null;
			}
		}
		
	}
}