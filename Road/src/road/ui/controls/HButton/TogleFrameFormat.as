package road.ui.controls.HButton
{
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	
	public class TogleFrameFormat implements IButtonFormat
	{
		private var myColorMatrix_filter:ColorMatrixFilter;
		
		public function TogleFrameFormat()
		{
			var myElements_array:Array = [0.4, 0.6, 0.2, 0, 0, 
										  0.4, 0.6, 0.2, 0, 0,  
										  0.4, 0.6, 0.2, 0, 0, 
										  0, 0, 0, 1, 0];
			myColorMatrix_filter = new ColorMatrixFilter(myElements_array);
		}
		
		public function setOverFormat(b:HBaseButton):void
		{
			if(b.enable)
			{
				(b.bg as MovieClip).gotoAndStop(2);
			}else
			{
				(b.bg as MovieClip).gotoAndStop(4);
			}
		}
		
		public function setUpFormat(b:HBaseButton):void
		{
			b.container.x = 0;
			b.container.y = 0;
		}
		
		public function setDownFormat(b:HBaseButton):void
		{
			b.container.x = 1;
			b.container.y = 1;
		}
	
		public function setOutFormat(b:HBaseButton):void
		{
			if(b.enable)
			{
				(b.bg as MovieClip).gotoAndStop(1);
			}else
			{
				(b.bg as MovieClip).gotoAndStop(3);
			}
		}
		
		public function setEnable(b:HBaseButton):void
		{
			b.filters = null;
		}
		
		public function setNotEnable(b:HBaseButton):void
		{
			b.filters = [myColorMatrix_filter];
		}
		
		public function setSelected(b:HBaseButton):void
		{
			(b.bg as MovieClip).gotoAndStop(1);
		}
		
		public function setNotSelected(b:HBaseButton):void
		{
			(b.bg as MovieClip).gotoAndStop(3);
		}
		
		public function dispose():void
		{
			myColorMatrix_filter = null;
		}
		
	}
}