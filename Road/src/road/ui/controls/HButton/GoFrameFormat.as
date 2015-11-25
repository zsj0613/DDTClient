package road.ui.controls.HButton
{
	import flash.display.MovieClip;
	
	public class GoFrameFormat implements IButtonFormat
	{
		public function GoFrameFormat()
		{
			
		}

		public function setOverFormat(b:HBaseButton):void
		{
			(b.bg as MovieClip).gotoAndStop(2);
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
			(b.bg as MovieClip).gotoAndStop(1);
		}
		
		public function setEnable(b:HBaseButton):void
		{
			if((b.bg as MovieClip))
			{
				(b.bg as MovieClip).gotoAndStop(1);
			}
		}
		
		public function setNotEnable(b:HBaseButton):void
		{
			if((b.bg as MovieClip).totalFrames >= 4)
			{
				(b.bg as MovieClip).gotoAndStop(4);
			}
			else
			{
				(b.bg as MovieClip).gotoAndStop(1);
			}
		}
		
		public function dispose():void
		{
			
		}
		
	}
}