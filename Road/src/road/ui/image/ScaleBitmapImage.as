package road.ui.image
{
	import road.utils.ClassUtils;
	import road.utils.ObjectUtils;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import org.bytearray.display.ScaleBitmap;
	/**
	 * 
	 * @author Herman
	 * 普通的9宫格拉伸图片
	 */	
	public class ScaleBitmapImage extends Image
	{
		public function ScaleBitmapImage(){}
		
		override protected function resetDisplay():void
		{
			ObjectUtils.disposeObject(_display);
			var bitmapData:BitmapData = ClassUtils.CreatInstance(_resourceLink,[_width,_height]);
			_display = new ScaleBitmap(bitmapData);
		}
	}
}