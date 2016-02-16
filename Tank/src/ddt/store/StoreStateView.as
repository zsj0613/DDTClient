package ddt.store
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import road.manager.SoundManager;
	
	import ddt.data.store.StoreState;
	import ddt.manager.SocketManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;

	public class StoreStateView extends BaseStateView 
	{
		private var _controller:StoreController;
		
		private var _container:Sprite;
		
		public function StoreStateView()
		{
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			_container = new Sprite();
			_controller = new StoreController();
			_container.addChild(_controller.getView(getStateViewType()));
			super.enter(prev,data);
			
			SocketManager.Instance.out.sendCurrentState(1);
			
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.setShopState();
		}
		
		override public function getType():String
		{
			if(StoreState.storeState == StoreState.CONSORTIASTORE)return StateType.CONSORTIASTORE;
			return StateType.STORE_ARM;
		}
		
		private function getStateViewType():String
		{
			if(StoreState.storeState == StoreState.CONSORTIASTORE)return StoreController.CONSORTIA;
			return StoreController.GENERAL;
		}
		
		override public function getView():DisplayObject
		{
			return _container;
		}
		
		
		override public function leaving(next:BaseStateView):void
		{
			StoreState.storeState = StoreState.BASESTORE;
			super.leaving(next);
			dispose();
		}
		
		override public function getBackType():String
		{
		    if(StoreState.storeState == StoreState.CONSORTIASTORE)
			{
				return StateType.CONSORTIA;
			}
			return StateType.MAIN;
		}
		
		override public function dispose():void
		{
			SoundManager.Instance.resumeMusic();
			_controller.dispose();
			_controller = null;
			if(_container.parent) _container.parent.removeChild(_container);
			BellowStripViewII.Instance.hide();
		}
	}
}