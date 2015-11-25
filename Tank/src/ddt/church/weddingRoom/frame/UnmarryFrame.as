package ddt.church.weddingRoom.frame
{
	import ddt.church.weddingRoom.WeddingRoomControler;
	
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.church.UnmarryAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.DisposeUtils;
	
	public class UnmarryFrame extends HConfirmFrame
	{
		private var _bg:UnmarryAsset;
		private var _controler:WeddingRoomControler;
		
		public function UnmarryFrame(controler:WeddingRoomControler)
		{
			this._controler = controler;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.buttonGape = 110;
			this.setContentSize(475,155); 
			
			this.cancelFunction =__cancel;
			this.okFunction =__confirm;
			this.closeCallBack = dispose;
			
			init();
		}
		
		private function init():void
		{
			_bg = new UnmarryAsset();
			addContent(_bg,true);
		}
		
		private function __confirm():void
		{
			if(PlayerManager.Instance.Self.Money<5214)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
				//MessageTipManager.getInstance().show("点劵不足");
				return;
			}
			
			_controler.unmarry();
			dispose();
		}
		
		private function __cancel():void
		{
			dispose();
		}
		
		override public function show():void
		{
			this.blackGound = false;
			super.show();
			this.blackGound = true;
		}
		override public function dispose():void
		{
			DisposeUtils.disposeDisplayObject(_bg);
			_controler = null;
			this.cancelFunction = null;
			this.okFunction = null;
			this.closeCallBack = null;
			super.dispose();
		}
	}
}