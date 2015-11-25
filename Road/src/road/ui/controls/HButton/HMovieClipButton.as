package road.ui.controls.HButton
{
	import flash.display.MovieClip;
	
	/**
	 * @author WickiLA
	 * @time 0318/10
	 * @description 动画按钮
	 * */

	public class HMovieClipButton extends HBaseButton
	{
		public function HMovieClipButton($bg:MovieClip)
		{
			super($bg);
		}
		
		override protected function init():void
		{
			(_bg as MovieClip).stop();
			super.init();
		}
		
		override public function set enable(b:Boolean):void
		{
			super.enable = b;
			if(b) 
			{
				(_bg as MovieClip).play();
			}else
			{
				(_bg as MovieClip).stop();
			}
		}
		
	}
}