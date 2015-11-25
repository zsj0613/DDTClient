package ddt.hall
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	import road.loader.LoaderSavingManager;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.UIManager;
	import road.utils.ClassUtils;
	
	import ddt.manager.PathManager;
	import ddt.manager.StatisticManager;
	//import ddt.request.StatAction;
	//import ddt.manager.ComponentManager;

	public class SaveFileWindow extends HFrame
	{
		private var _asset:MovieClip;
		private var _acceptBtn:SimpleButton;
		
		public function SaveFileWindow()
		{
			super();
			
			alphaGound = false;
			
			fireEvent = false;
			showBottom = false;
			showClose = true;
			moveEnable = false;
			
			closeCallBack = disagree;
			
			initView();
		}
	
		private function initView():void
		{
			_asset = ClassUtils.CreatInstance("ddt.asset.hall.SaveFileDialogAsset") as MovieClip;
			addContent(_asset);
			setContentSize(673,383);
			
			_acceptBtn = ClassUtils.CreatInstance("ddt.asset.hall.SaveFileDialogAcceptBtnAsset") as SimpleButton;
			_acceptBtn.x = 294;
			_acceptBtn.y = 339;
			_asset.addChild(_acceptBtn);
			
			_acceptBtn.addEventListener(MouseEvent.CLICK,__btnOkClick);
			addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
	
		private function __btnOkClick(event:Event):void
		{
			SoundManager.instance.play("008");
			doClosing();
			LoaderSavingManager.cacheAble = true;
			LoaderSavingManager.saveFilesToLocal();
			sendStatInfo("yes");
			
		}
		
		private function disagree():void
		{
			doClosing();
			sendStatInfo("no");
		}
		
		private function __keyDown(evt:KeyboardEvent):void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.instance.play("008");
		    	disagree();
			}
		}
		
		
		/*********************************************
		 *     发送信息给服务器,统计玩家选择本地缓存
		 * ******************************************/
		private function sendStatInfo(status : String) : void
		{
			if(PathManager.solveParterId() == null)
			return;
			StatisticManager.Instance().startAction(StatisticManager.SAVEFILE,status);
		}
		//private function onDateReturn(evt : StatAction) : void
		//{
			//trace("return data : " + evt.ReturnNum);
		//}
		//
		private function doClosing() : void
		{
			super.dispose();
			removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			if(_acceptBtn)
			{
				_acceptBtn.removeEventListener(MouseEvent.CLICK,__btnOkClick);
			}
			if(_asset.parent)_asset.parent.removeChild(_asset);
			_asset = null;
			if(parent)
			this.parent.removeChild(this);
		}
		
		override public function show() : void
		{
			UIManager.AddDialog(this);
			blackGound = true;
		}
	}
}