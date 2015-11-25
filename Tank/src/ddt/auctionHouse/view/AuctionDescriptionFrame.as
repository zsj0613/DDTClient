package ddt.auctionHouse.view
{
	import road.ui.controls.hframe.HConfirmFrame;
	import tank.auctionHouse.view.descriptionAsset;

	public class AuctionDescriptionFrame extends HConfirmFrame
	{
		public function AuctionDescriptionFrame()
		{
			super();
			init();
		}
		
		private function init():void
		{
			setContentSize(293,346);
			showClose = true;
			showCancel = false;
			moveEnable = false;
			titleText = "拍卖说明";
			addContent(new descriptionAsset(),true);
		}
		
	}
}