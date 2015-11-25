package road.ui.controls.hframe.bitmap
{
	import flash.geom.Rectangle;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.ui.accect.FrameBlackBgAccect;

	public class BlackFrameBG extends ScaleBitmap
	{
		public function BlackFrameBG()
		{
			super(new FrameBlackBgAccect(0,0),"auto",true);
			var rt:Rectangle = new Rectangle();
			rt.left = 15;
			rt.right = 35;
			rt.top = 15;
			rt.bottom = 35;
			scale9Grid = rt;
		}
		
	}
}