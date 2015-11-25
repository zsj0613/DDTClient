package ddt.auctionHouse.view
{
	import flash.text.TextField;
	
	import game.crazyTank.view.AuctionHouse.StripCurPriceAsset;
	
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.manager.PlayerManager;

	internal class StripCurPriceView extends StripCurPriceAsset
	{
		private var _info:AuctionGoodsInfo;
		
		internal function set info(value:AuctionGoodsInfo):void
		{
			_info = value;
			update();
		}
		
		public function StripCurPriceView()
		{
			mouseEnabled = false;
		}
		
		private function update():void
		{
			if(_info.AuctioneerID != PlayerManager.Instance.Self.ID && _info.BuyerID == PlayerManager.Instance.Self.ID)
			{
				yourPrice_mc.visible = true;
//				currentMaxPrice_mc.visible = false;
				maxPrice_txt.text = _info.Price.toString();
			}
			else
			{
				yourPrice_mc.visible = false;
//				currentMaxPrice_mc.visible = true;
				maxPrice_txt.text = _info.Price.toString();
			}
			mouthPrice_txt.text = _info.Mouthful.toString();
			if(_info.PayType == 0)
			{
				gotoAndStop(1);				
			}
			else
			{
				gotoAndStop(2);
			}
			goldMoney_mc.gotoAndStop(_info.PayType + 1);
			goldMoneyMouth_mc.gotoAndStop(_info.PayType + 1);
			setMouse();
		}
		
		private function setMouse():void
		{
			if(_info.Mouthful == 0)
			{
				goldMoneyMouth_mc.visible = false;
				mouthPrice_txt.text = "";
				goldMoney_mc.y = 19;
				maxPrice_txt.y = 9;
				mouth_mc.visible =false;
				yourPrice_mc.y = 10;
			}
			else
			{
				goldMoney_mc.gotoAndStop(_info.PayType + 1);
				goldMoney_mc.visible = true;
				maxPrice_txt.y = - 1.6;
				goldMoney_mc.y = 9;
				mouth_mc.y = 21;
				mouth_mc.visible = true;
				mouthPrice_txt.y = 19;
				goldMoneyMouth_mc.y =30;
				yourPrice_mc.y = 0;
			}
			maxPrice_txt.mouseEnabled = false;
			mouthPrice_txt.mouseEnabled = false;
		}
		
		internal function dispose():void
		{
			if(parent)parent.removeChild(this);
			_info = null;
		}
		
	}
}