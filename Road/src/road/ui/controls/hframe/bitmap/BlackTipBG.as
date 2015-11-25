package road.ui.controls.hframe.bitmap
{
	import flash.geom.Rectangle;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.ui.accect.FrameBlackTipBgAssect;

	public class BlackTipBG extends ScaleBitmap
	{
		public function BlackTipBG()
		{
			super(new FrameBlackTipBgAssect(0,0),"auto",true);
			var rt:Rectangle = new Rectangle();
			rt.left = 6.8;
			rt.right = 113;
			rt.top = 5.3;
			rt.bottom = 20;
			scale9Grid = rt;
		}
		
	}
}