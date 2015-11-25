package ddt.game.playerThumbnail
{
	import flash.geom.Point;
	
	import road.ui.manager.TipManager;
	
	import ddt.menu.RightMenuPanel;

	public class ThumbnailTip extends RightMenuPanel
	{
		public function ThumbnailTip()
		{
			super();
		}
		
		override public function show():void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			TipManager.AddTippanel(this);
			if(stage && parent)
			{
				var pos:Point = parent.globalToLocal(new Point(stage.mouseX,stage.mouseY));
				this.x = pos.x + 15;
				this.y = pos.y + 15;
				
				//调整位置，目前长宽，舞台长宽写死，有空再改
				if(x + 182 > 1000)
				{
					this.x = x - 182;
				}
				if(y + 234 > 600)
				{
					y = 600-234;
				}
			}
		}
		
	}
}