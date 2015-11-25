package road.ui.image
{
	import road.ui.Component;
	import road.utils.ClassUtils;
	
	import flash.display.MovieClip;

	/**
	 * 
	 * @author Herman
	 * 影片剪辑的图片
	 */	
	public class MovieImage extends Image
	{
		
		public function MovieImage(){}
		
		public function get movie():MovieClip
		{
			return _display as MovieClip;
		}
		
		override public function setFrame(frameIndex:int):void
		{
			movie.gotoAndStop(frameIndex);
			if(_width != Math.round(movie.width))
			{
				_width = Math.round(movie.width);
				_changedPropeties[Component.P_width] = true;
			}
		}
		
		override protected function resetDisplay():void 
		{
			if(_display)removeChild(_display);
			_display = ClassUtils.CreatInstance(_resourceLink);
		}
	}
}