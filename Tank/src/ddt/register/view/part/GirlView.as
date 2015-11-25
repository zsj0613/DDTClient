package ddt.register.view.part
{
	import choicefigure.view.GirlAsset;
	
	import flash.events.Event;

	public class GirlView extends GirlAsset
	{
		public function GirlView()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			this.gotoAndStop(1);
			addFrameScript(8,complete);
			addFrameScript(15,complete);
		}
		
		public function show():void
		{
			if(this.currentFrame == 1 || this.currentFrame == 15)
				this.gotoAndPlay(2);
		}
		
		public function hide():void
		{
			if(this.currentFrame <= 8)
				this.gotoAndPlay(9);
		}
		private var isStop:Boolean = false;
		public function hideAndStop():void
		{
			isStop = true;
			hide();
		}
		
		private function complete():void
		{
			if(!isStop)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function dispose():void
		{
			if(parent)
				parent.removeChild(this);
		}
	}
}