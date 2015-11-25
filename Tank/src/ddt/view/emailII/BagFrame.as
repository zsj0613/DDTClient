package ddt.view.emailII
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
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
			fireEvent = false;
			showBottom = false;
			showClose = false;
			moveEnable = false;
			titleText = LanguageMgr.GetTranslation("ddt.view.emailII.BagFrame.selectBag");

			setContentSize(388,450);

			_bag = new BagIIController(PlayerManager.Instance.Self);
			_bag.setCellDoubleClickEnable(false);
			_bag.bagFinishingBtnEnable = false;
			var bagView:DisplayObject = _bag.getView();
			bagView.y = 0;
			addContent(_bag.getView() as Sprite);
			
			addEvent();
		}
		
		private function __keyDown(event:KeyboardEvent):void
		{
			
		}
		
		override public function show():void
		{
			//UIManager.AddDialog(this,false);
			TipManager.AddTippanel(this,false);
			x = 520;
			y = 40;
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			_bag.dispose();
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(null);
			_bag.setBagType(1);
			addEvent();
		}
		
		override protected function __removeToStage(e:Event):void
		{
			super.__removeToStage(null);
			removeEvent();
		}
		
		private function addEvent():void
		{
			addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		
		private function removeEvent():void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
	}
}