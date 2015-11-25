package ddt.view.common
{
	import game.crazyTank.view.common.OfferAsset;
	public class OfferText extends OfferAsset
	{
		public function OfferText(count:int)
		{
			Offer = String(count);
		}
		public function set Offer(count:String):void
		{
			exploit_txt.text = count;
		}
		
		public function dispose():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}