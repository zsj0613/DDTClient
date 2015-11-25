package ddt.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HTipButton;
	
	import tank.commonII.asset.ClientDownloadingAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	
	public class ClientDownloading extends Sprite
	{
		private var _asset:ClientDownloadingAsset;
		private var downBtn:HTipButton;
		private var _dialog:DownloadingView;
		public function ClientDownloading()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			setUpGrayFilter();
			_asset = new ClientDownloadingAsset();
//			downBtn = new HTipButton(_asset.downBtn_mc ,"","使用客户端登陆，\n游戏更流畅!经验\n更高!奖励更丰厚！");
			downBtn = new HTipButton(_asset.downBtn_mc ,"",LanguageMgr.GetTranslation("ddt.view.ClientDownloading.Tip"));
			if(PathManager.hasClientDownland())
			{
				addChild(downBtn);
				_asset.play();
				addChild(_asset);
			}
			
		}
		
		private var _grayFilters:ColorMatrixFilter;
		private function setUpGrayFilter():void {
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			_grayFilters = new ColorMatrixFilter(myElements_array);
		}
		
		private function initEvent():void
		{
			downBtn.addEventListener(MouseEvent.CLICK , __downBtnClick);
			_asset.addEventListener(MouseEvent.MOUSE_OVER, __assetOver);
			downBtn.addEventListener(MouseEvent.MOUSE_OUT, __assetOut);
		}
		
		private function __downBtnClick(evt:Event):void
		{
//			var dialog:HConfirmDialog = HConfirmDialog.show("客户端下载","1.能够获得更流畅的游戏速度。\n2.在战斗中获得更高的经验加成。\n3.每日登陆可以领取更多奖励。\n4.拥有专属任务，丰厚奖励等你拿。",false,confirmDown,null);
			if(!_dialog)
			{
				_dialog = new DownloadingView();
			}else
			{
//				_dialog.visible = !_dialog.visible;
				if(_dialog.visible)
				{
					_dialog.hide();
					_dialog.visible = false;
				}else{
					_dialog.show();
					_dialog.visible = true;
				}
			}
			SoundManager.instance.play("008");
		}
		private function __assetOver(evt:Event):void
		{
			_asset.visible = false;
		}
		
		private function __assetOut(evt:Event):void
		{
			_asset.visible = true;
		}
		
		public function dispose():void
		{
			if(downBtn)
			{
				downBtn.removeEventListener(MouseEvent.CLICK , __downBtnClick);
				removeChild(downBtn);
				downBtn.dispose();
			}
			downBtn = null;
			
			if(_dialog)
			{
				_dialog.dispose();
			}
			_dialog = null;
			if(_asset)
			{
				_asset.addEventListener(MouseEvent.MOUSE_OVER, __assetOver);
				_asset.addEventListener(MouseEvent.MOUSE_OUT, __assetOut);
				_asset = null;
			}
			if(this.parent)
		 	{
		 		parent.removeChild(this);
		 	}
		}
	}
}