package ddt.store.view.embed.frame
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.UIManager;
	
	/**
	 * @author WickiLA
	 * @time 12/19/2009
	 * @description 镶嵌的弹出框
	 * */

	public class EmbedAlert1 extends HConfirmFrame
	{
		private var _bg:MovieClip;
		public function EmbedAlert1(bg:MovieClip)
		{
			super();
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
			setSize(420,180);
			showBottom = true;
			showClose = true;
			autoClearn = true;
			this.buttonGape = 110;
			addContent(_bg,true);
		}
	}
}