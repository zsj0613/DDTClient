package road.ui.controls.hframe.bitmap
{
	import flash.geom.Rectangle;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.ui.accect.FrameBlackHeaderAccect;

	public class BlackFrameHeader extends ScaleBitmap
	{
		public function BlackFrameHeader()
		{
			super(new FrameBlackHeaderAccect(0,0), "auto", true);
			var rt1:Rectangle = new Rectangle();
			rt1.left = 15;
			rt1.right = 35;
			rt1.top = 10;
			rt1.bottom = 20;
			scale9Grid = rt1;
			
		}
		
	}
}