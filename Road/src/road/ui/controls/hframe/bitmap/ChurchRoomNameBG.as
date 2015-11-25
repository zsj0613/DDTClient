package road.ui.controls.hframe.bitmap
{
	import flash.geom.Rectangle;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.ui.accect.WeddingRoomNameBGAsset;

	public class ChurchRoomNameBG extends ScaleBitmap
	{
		public function ChurchRoomNameBG()
		{
			super(new WeddingRoomNameBGAsset(0,0),"auto",true);
			var rt:Rectangle = new Rectangle();
			rt.left = 6.8;
			rt.right = 42.3;
			rt.top = 5.7;
			rt.bottom = 28.7;
			scale9Grid = rt;
		}
		
	}
}