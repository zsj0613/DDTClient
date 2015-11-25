package ddt.view.common.church
{
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.church.UnmarriedAsset;

	public class DialogueUnmarried extends HConfirmFrame
	{
		private var _asset:UnmarriedAsset;
		
		public function DialogueUnmarried()
		{
			super();
			blackGound = false;
			alphaGound = false;
			fireEvent = false;
			showCancel = false;

			setContentSize(340,124);
			configUI();
		}
		private function configUI():void
		{
			_asset = new UnmarriedAsset();
			addContent(_asset,true);
		}

		override public function dispose():void
		{
			super.dispose();
			if(parent)parent.removeChild(this);
		}
	}
}