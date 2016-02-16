package ddt.hall
{
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.view.bagII.BagIIView;
	import ddt.view.common.BellowStripViewII;
	
	public class NoviceGiveWindow extends HFrame
	{
		//private var _asset:NoviceGiveAccect;
		private var _closeBtn:HLabelButton;
		public function NoviceGiveWindow()
		{
			super();
			configUI();
		}
		private function configUI():void
		{
			BellowStripViewII.Instance.showHightLightButton(1);
			setSize(490,280);
			//_asset = new NoviceGiveAccect();
			//_asset.closeBtn.visible = false;
			//addChild(_asset);
			
			_closeBtn = new HLabelButton();
			_closeBtn.label = LanguageMgr.GetTranslation("ok");
			_closeBtn.x = 385;
			_closeBtn.y = 240;
			addChild(_closeBtn);
			_closeBtn.addEventListener(MouseEvent.CLICK,__btnCancelClick);
		}

		private function __btnCancelClick(e:MouseEvent) : void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK,__btnCancelClick);
			//this.removeChild(_asset);
			//_asset = null;
			if(parent)
			this.parent.removeChild(this);
			BagIIView.DEFAULT_SHOW_TYPE = 1;
			SoundManager.Instance.play("003");
		}
		
		override public function show() : void
		{
			TipManager.AddTippanel(this,true);
		}
		
	}
}