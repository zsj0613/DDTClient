package ddt.view.roulette
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HFrame;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	
	public class RouletteBoxPanel extends HFrame
	{
		private var _view:RouletteView;
		private var _templateIDList:Array;
		private var _keyCount:int;
		
		public function RouletteBoxPanel(templateIDList:Array , keyCount:int)
		{
			super();
			//blackGound = false;
			alphaGound = true;
			showBottom = false;
			moveEnable = false;
			showClose = true;
			closeCallBack = __close;
			autoDispose = true;
			_templateIDList = templateIDList;
			_keyCount = keyCount;
			//SoundManager.instance.playMusic("065");
			SoundManager.Instance.pauseMusic();
			initView();
		}
		
		private function initView():void
		{
			_view = new RouletteView(_templateIDList);
			_view.x = 10;
			_view.y = 35;
			_view.keyCount = _keyCount;
			addContent(_view,true);
			setSize(_view.width +15 , _view.height + 40);
			this.titleText =  LanguageMgr.GetTranslation("ddt.view.rouletteView.title");
			
			this.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		
		private function __keyDown(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				__close();
			}
		}
		
		private function __close():void
		{
			if(!_view.isCanClose && _view.selectNumber < 8)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.rouletteview.quit"));
			}
			else
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("ddt.view.rouletteview.close"),true,close);
				//if(parent)parent.removeChild(this);
			}
		}
		override public function dispose():void
		{
			SoundManager.Instance.resumeMusic();
			this.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			_view.dispose();
			super.dispose();
		}
	}
}



