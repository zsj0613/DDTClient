package ddt.auctionHouse.view
{
	import game.crazyTank.view.AuctionHouse.StripCurBuyPriceAsset;
	
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.manager.PlayerManager;

	internal class StripCurBuyPriceView extends StripCurBuyPriceAsset
	{
		public function StripCurBuyPriceView(state:int)
		{
			mouseEnabled = false;
			curPricel_txt.mouseEnabled = false;
			mouthful_txt.mouseEnabled = false;
			
			goldMoney_mc.gotoAndStop(1);
			state_mc.gotoAndStop(state);
		}
		
		private var _info:AuctionGoodsInfo;
		internal function set info(value:AuctionGoodsInfo):void
		{
			_info = value;
			update();
		}
		
		private function update():void
		{
			curPricel_txt.text = _info.Price.toString();
			setMouth();
			if(_info.PayType == 0)
			{
				gotoAndStop(1);
			}
			else
			{
				gotoAndStop(2);
			}
			this.mouseEnabled = false;
			if(_info.BuyerID!=PlayerManager.Instance.Self.ID)
			{
				state_mc.gotoAndStop(2);
			}else
			{
				state_mc.gotoAndStop(1);
			}
		}
		
		private function setMouth():void
		{
			if(_info.Mouthful == 0)
			{
				goldMoney_mc.visible = false;	
				mouthful_txt.text = "";				
			}
			else
			{
				goldMoney_mc.gotoAndStop(_info.PayType + 1);
				goldMoney_mc.visible = true;
				mouthful_txt.text = _info.Mouthful.toString();
			}
			goldMoney_mc.mouseEnabled = false;
		}
		
		internal function dispose():void
		{
			if(parent)parent.removeChild(this);
			_info = null;
		}
		
	}
}