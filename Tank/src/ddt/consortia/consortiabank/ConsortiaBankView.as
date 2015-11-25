package ddt.consortia.consortiabank
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HFrame;
	
	import tank.consortia.accect.ConsortiaBankLeftAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;

	public class ConsortiaBankView extends HFrame
	{
		private var _bag      : ConsortiaBankBagContro;//背包的控制器
		
		private var _bg        : ConsortiaBankLeftAsset;
		private var _resultBtn : HBaseButton;
//		private var _tip       : BagTipAsset;
		public function ConsortiaBankView()
		{
			super();
			this.titleText = LanguageMgr.GetTranslation("ddt.consortia.consortiabank.ConsortiaBankView.titleText");
			//this.titleText = "个人保管箱";
			init();
			addEvent();
		}
		private function init() : void
		{
//			_leftView = new ConsortiaBankLeftView();
//			this.addContent(_leftView,true);
			this.setContentSize(900,510);
			this.showBottom = false;
			this.fireEvent = false;
			this.moveEnable = false;
			_bg = new ConsortiaBankLeftAsset();
			addContent(_bg);
//			_bg.x = -18;
//			_bg.y = 13;
			
			_resultBtn = new HBaseButton(_bg.ResultBtnAsset);
			_resultBtn.useBackgoundPos = true;
			_bg.addChild(_resultBtn);
			
			
			_bag = new ConsortiaBankBagContro(PlayerManager.Instance.Self);
			_bag.getView().x = 500;
			_bag.getView().y = 0;
			addContent(_bag.getView() as Sprite);
			
//			_tip = new BagTipAsset();
//			addContent(_tip);
		}
		private function addEvent() : void
		{
			_resultBtn.addEventListener(MouseEvent.CLICK,  __resultHandler);
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		private  function removeEvent() : void
		{
			_resultBtn.removeEventListener(MouseEvent.CLICK,  __resultHandler);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		protected function __onKeyDownd(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ESCAPE)
			{
				__resultHandler(null);
			}
		}
		override public function dispose() : void
		{
			super.dispose();
			removeEvent();
			if(_resultBtn)
			{
				_resultBtn.dispose();
				if(_resultBtn.parent)_resultBtn.parent.removeChild(_resultBtn);
			}
			_resultBtn = null;
			if(_bg.parent)_bg.parent.removeChild(_bg);
			_bg = null;
			if(_bag)_bag.dispose();
			_bag = null;
			while(this.numChildren)
			{
				var mc : DisplayObject = getChildAt(0) as DisplayObject;
				removeChild(mc);
				mc = null;
			}
			if(parent)parent.removeChild(this);
		}
		
		private function __resultHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
//			dispose();
			if(parent)this.parent.removeChild(this);
		}
		
	}
}