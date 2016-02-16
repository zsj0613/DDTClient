package ddt.view
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import tank.commonII.asset.ClientDownloadingBGAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	
	public class DownloadingView extends HConfirmFrame
	{
		private var _asset:ClientDownloadingBGAsset;
		private var _dewnBtn:HBaseButton;
		public function DownloadingView()
		{
			super();
			init();
			initEvent();
			this.show();
		}
		
		private function init():void
		{
			blackGound = false;
			alphaGound = false;
			moveEnable = true;
			fireEvent = false;
			showBottom = false;
			showClose = true;
			closeCallBack = closeFunction;
//			titleText = "客户端下载";
			titleText = LanguageMgr.GetTranslation("ddt.view.DownloadingView.titleText");
			centerTitle = true;
			setSize(415,278);
			_asset = new ClientDownloadingBGAsset();
			_asset.x = 12;
			_asset.y = 35; 
			addChild(_asset);
			_dewnBtn = new HBaseButton(_asset.downBtn,"");
			_dewnBtn.y = 35;
			addChild(_dewnBtn);
		}
		
		private function initEvent():void
		{
			_dewnBtn.addEventListener(MouseEvent.CLICK , __downClick);
			addEventListener(KeyboardEvent.KEY_DOWN , __closeFunction);
		}
		
		private function __downClick(evt:Event):void
		{
			SoundManager.Instance.play("008");
			navigateToURL(new URLRequest(PathManager.solveClienDownLoading()),"_blank");
			this.hide()
			this.visible = false;
		}
		
		private function __closeFunction(evt:KeyboardEvent):void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				this.visible = false;
				SoundManager.Instance.play("008");
			}
		}
		
		override public function show():void
		{
//			UIManager.AddDialog(this);
			TipManager.AddTippanel(this,true);
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			close();
			SoundManager.Instance.play("008");
			this.visible = false;
		}

		
		private function closeFunction():void
		{
			this.visible = !this.visible;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_asset)
			{
				removeChild(_asset);
			}
			_asset = null;
			if(_dewnBtn)
			{
				_dewnBtn.removeEventListener(MouseEvent.CLICK , __downClick);
				removeChild(_dewnBtn);
				_dewnBtn.dispose();
			}
			removeEventListener(KeyboardEvent.KEY_DOWN , __closeFunction);
			_dewnBtn = null;
			if(this.parent)
			{
				parent.removeChild(this);
			}
		}

	}
}