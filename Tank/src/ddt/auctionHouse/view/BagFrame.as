package ddt.auctionHouse.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.BagIIController;

	public class BagFrame extends HFrame
	{
		private var _bag:BagIIController;
		public function BagFrame()
		{
			blackGound = false;
			alphaGound = false;
			showBottom = false;
			titleText = LanguageMgr.GetTranslation("ddt.auctionHouse.view.BagFrame.Choose");
			//setName("请选择背包上的物品进行拍卖");
			setContentSize(380,450);
			_bag = new BagIIController(PlayerManager.Instance.Self);
			_bag.setCellDoubleClickEnable(false);
			_bag.bagFinishingBtnEnable = false;
			var bagview:DisplayObject =  _bag.getView();
			bagview.x = -7;
			bagview.y = -5;
//			bagview.y = 10;
			addContent(bagview as Sprite);
			addEventListener(Event.CLOSE,__close);	
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);		
		}

		private function __close(event:Event):void
		{
			if(parent)
			{
				TipManager.AddTippanel(this);
			}
		}
		private function __onKeyDownd(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				hide();
			}
		}
	
		public function open():void
		{
			UIManager.AddDialog(this);
//			TipManager.AddToLayerNoClear(this);
			//TipManager.AddTippanel(this);
			x = (1000 - width) / 2;
			y = (600 - height) / 2;
			_bag.addStageInit();
		}
	
		public function hide():void
		{
			if(parent)
				parent.removeChild(this);
		}

		override public function dispose():void
		{
			super.dispose();
			removeEventListener(Event.CLOSE,__close);	
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
			hide();
			if(_bag)_bag.dispose();
			_bag = null;
		}	
	}
}