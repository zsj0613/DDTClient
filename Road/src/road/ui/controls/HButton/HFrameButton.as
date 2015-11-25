package road.ui.controls.HButton
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	public class HFrameButton extends HBaseButton
	{
		
		private var _selected :Boolean = false;
		private var myColorMatrix_filter:ColorMatrixFilter;
		public function HFrameButton($bg:DisplayObject, $label:String="")
		{
			if($bg is MovieClip) 
			{
				($bg as MovieClip).gotoAndStop(1);
			}
			setUpGrayFilter();
			super($bg, $label);
		}
		
		override protected function creatButtonFormat():void
		{
			_buttonFormat = new GoFrameFormat();
		}
		
		public function set selected (b:Boolean):void
		{
			_selected = b;
			if(b)
			{
				if((bg as MovieClip).totalFrames>=3)
				{
					(bg as MovieClip).gotoAndStop(3);
				}
				buttonMode = false;
				removeEvent();
			}else
			{
				if(bg is MovieClip)
				{
					(bg as MovieClip).gotoAndStop(1);
				}
				buttonMode = true;
				addEvent();
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			if(!enable || selected)
			{
				evt.stopImmediatePropagation();
			}
		}
		
		override public function set enable(b:Boolean):void
		{
			_enable = this.buttonMode = this.mouseEnabled = b;
			if(b)
			{
				this.filters = null;
				this.addEvent();
				
			}else
			{
				this.filters = [myColorMatrix_filter];
				this.removeEvent();
				if(bg is MovieClip) 
				{
					(bg as MovieClip).gotoAndStop(1);
				}
			}
		}
		
		override public function get enable():Boolean
		{
			return _enable;
		}
		
		private function setUpGrayFilter():void {
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			myColorMatrix_filter = new ColorMatrixFilter(myElements_array);
		}
		public function setNotEnable(b:HBaseButton):void
		{
			
			b.filters = [myColorMatrix_filter];
		}
		
		override public function dispose():void
		{
			super.dispose();
			myColorMatrix_filter = null;
		}
	}
}