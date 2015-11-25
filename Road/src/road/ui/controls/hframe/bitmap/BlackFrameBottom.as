package road.ui.controls.hframe.bitmap
{
	import flash.geom.Rectangle;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.ui.accect.FrameBlackBottomAccect;

	public class BlackFrameBottom extends ScaleBitmap
	{
		public function BlackFrameBottom()
		{
			super(new FrameBlackBottomAccect(0,0), "auto", true);
			var rt1:Rectangle = new Rectangle();
			rt1.left = 15;
			rt1.right = 35;
			rt1.top = 15;
			rt1.bottom = 35;
			scale9Grid = rt1;
		}
		
	}
}