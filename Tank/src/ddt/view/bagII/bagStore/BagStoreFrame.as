package ddt.view.bagII.bagStore
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.BufferManager;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.data.store.StoreState;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.view.common.BellowStripViewII;

	/**
	 * @author Wicki LA
	 * @time 12/10/2009
	 * @description 背包铁匠铺弹出窗
	 * */

	public class BagStoreFrame extends HFrame
	{
		private var _controller:BagStore;
		public var _view:Sprite;
		public static var isTabStore:Boolean = true;
		
		public function BagStoreFrame(controller:BagStore)
		{
			super();
			_controller = controller;
			_view = _controller.Controller.getView(getStoreType());
			init();
		}
		
		private function init():void
		{
			titleText = LanguageMgr.GetTranslation("ddt.view.store.title");
			showClose = true;
			showBottom = false;
			fireEvent = true;
			IsSetFouse = true;
			addContent(_view);
			adaptPos();
		}
		
		private function getStoreType():String
		{
			var type:String = "";
			if(PlayerManager.Instance.Self.ConsortiaID != 0)
			{
				type = "bagTab";
			}else
			{
				type = "bagSingle";
			}
			return type;
		}
		
		private function adaptPos():void
		{
			if(getStoreType() == "bagTab")
			{
				setSize(805,505);
				_view.x = 15;
				_view.y = 70;
			}else
			{
				setSize(800,480);
				_view.x = 5;
				_view.y = 40;
			}
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
			blackGound = true;
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			setTimeout(getFocus,30);
		}
		
		private function getFocus():void
		{
			stage.focus = this;
		}
		
		override public function show():void
		{
			UIManager.AddDialog(this,false);
			BufferManager.Instance.isBuffering = true;
		}
		
		private function onKeyDown(evt:KeyboardEvent):void
		{
			if(evt.keyCode == Keyboard.ESCAPE && BagStoreFrame.isTabStore)
			{
				evt.stopImmediatePropagation();
				SoundManager.Instance.play("008");
				close();
			}
		}
		
		override public function close():void
		{
			TipManager.clearNoclearLayer();
			UIManager.clear();
			removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			super.close();
			StoreState.storeState = StoreState.BASESTORE;
			BufferManager.Instance.isBuffering = false;
			BufferManager.Instance.clearBuff();
			BagStore.Instance.closed();
			dispose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_view)_view = null;
			_controller.dispose();
			_controller = null;
			BellowStripViewII.Instance.openBag();
		}
		
	}
}