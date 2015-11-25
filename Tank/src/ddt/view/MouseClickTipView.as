package ddt.view
{
	import game.crazyTank.view.MouseFocusAsset;

	public class MouseClickTipView extends MouseFocusAsset
	{
		public function MouseClickTipView()
		{
			super();
			this.graphics.beginFill(0,.5);
			this.graphics.drawRect(-3000,-3000,6000,6000);
			this.graphics.endFill();
			this.buttonMode = true;
		}
		
	}
}