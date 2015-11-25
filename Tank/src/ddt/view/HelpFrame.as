package ddt.view
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.view.bagII.bagStore.BagStore;

	public class HelpFrame extends HConfirmFrame
	{
		private var _helpIma : Bitmap;
		public function HelpFrame(ima : Bitmap)
		{
			super();
			blackGound = false;
			alphaGound = false;
			stopKeyEvent = true;
			
			_helpIma = ima;
			ima.x = -5;
			ima.y = -3;
			this.addContent(ima);
			this.setContentSize(ima.width-14,ima.height+26);
			this.showCancel = false;
			this.okFunction = close;
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		override public function show() : void
		{
			TipManager.AddTippanel(this,true);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_helpIma && _helpIma.parent)_helpIma.parent.removeChild(_helpIma);
			_helpIma = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
		}

		private function removeFromStageHandler(event:Event):void{
			BagStore.Instance.reduceTipPanelNumber();
		}
		
	}
}