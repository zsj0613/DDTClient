package ddt.consortia.myconsortia.frame
{
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import tank.consortia.accect.ConsortiaRichesTipAsset;
	import ddt.view.consortia.MyConsortiaTax;

	public class ConosritaRichesTipsFrame extends HConfirmFrame
	{
		private var _bgAsset : ConsortiaRichesTipAsset;
		public function ConosritaRichesTipsFrame()
		{
			super();
			blackGound = false;
			alphaGound = false;
			this.buttonGape = 100;
			init();
		}
		private function init() : void
		{
			_bgAsset = new ConsortiaRichesTipAsset();
			this.addContent(_bgAsset);
			this.setContentSize(_bgAsset.width,_bgAsset.height+40);
			this.okFunction = __okFunction;
			this.closeCallBack = dispose;
			this.cancelFunction = dispose;
		}
		private function __okFunction() : void
		{
			TipManager.AddTippanel(new MyConsortiaTax(),true);
			dispose();
		}
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		override public function dispose():void
		{
			super.dispose();
			if(_bgAsset && _bgAsset.parent)_bgAsset.parent.removeChild(_bgAsset);
			_bgAsset = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
	}
}