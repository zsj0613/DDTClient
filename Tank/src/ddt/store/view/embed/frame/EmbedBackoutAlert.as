package ddt.store.view.embed.frame
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.UIManager;
	
	public class EmbedBackoutAlert extends HConfirmFrame
	{
		private var _bg:MovieClip;
		public function EmbedBackoutAlert(bg:MovieClip)
		{
			super();
			stopKeyEvent = true;
			_bg = bg;
			init();
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(cancelFunction != null) cancelFunction();
			super.__closeClick(e);
		}
		
		private function init():void
		{
			setSize(420,130);
			showBottom = true;
			showClose = true;
			autoClearn = true;
			moveEnable = false;
			this.buttonGape = 110;
			addContent(_bg,true);
			setTimeout(getFocus,30);
		}
		
		private function getFocus():void
		{
			if(this.stage)
			{
				stage.focus = this;
			}
		}
	}
}