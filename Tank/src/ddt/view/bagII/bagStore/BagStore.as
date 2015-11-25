package ddt.view.bagII.bagStore
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	

	
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.view.common.WaitingView;
	import road.utils.ClassUtils;
	import ddt.store.StoreController;
	
	/**
	 * @author Wicki LA
	 * @time 12/10/2009
	 * @description 背包铁匠铺
	 * */
	public class BagStore extends EventDispatcher
	{
		public static var OPEN_BAGSTORE:String = "openBagStore";
		public static var CLOSE_BAGSTORE:String = "closeBagStore";
		
		private static var _instance:BagStore;
		private var _controllerInstance:*;
		private var _frame:BagStoreFrame;
		private var _tipPanelNumber:int = 0;
		private var _passwordOpen:Boolean = true;
		
		public function BagStore(singleton:BagStoreSingleton)
		{
			
		}
		
		public function show():void
		{
			//if(ModelManager.hasDefinition("store.StoreController"))
			//{
				createStoreFrame();
			//}else
			//{
			//	_loader = ModelManager.addModelFile("6.png");
			//	_loader.addEventListener(ModelEvent.MODEL_COMPLETE,__complete);
			//	_loader.addEventListener(ProgressEvent.PROGRESS,__progress);
			//	if(!_loader.isStarted())
			//	{
			//		_loader.loadAtOnce();	
			//	}
			//	WaitingView.instance.show(WaitingView.LOAD,LanguageMgr.GetTranslation("BaseStateCreator.LoadingTip"));
			//	WaitingView.instance.addEventListener(WaitingView.WAITING_CANCEL,__cancel);
			//}
			
		}
		
		
		
		
		private function createStoreFrame():void
		{
			_controllerInstance = new StoreController();
//			StoreState.storeState = StoreState.BAGBASESTORE;
			_frame = new BagStoreFrame(this);
			_frame.x = 115;
			_frame.y = 37;
			_frame.moveEnable = false;
			_frame.show();
			dispatchEvent(new Event(OPEN_BAGSTORE));
			if(PlayerManager.Instance.Self.ConsortiaID != 0){
				_frame.x -= 10;
				_frame.y -= 30;
			}
		}
		
		public function closed():void
		{
			dispatchEvent(new Event(CLOSE_BAGSTORE));
		}
		
		public function get Controller():*
		{
			return _controllerInstance;
		}
		
		public function set Controller(controller:*):void{
			_controllerInstance = controller;
		}
		
		public function get frame():BagStoreFrame{
			return _frame;
		}
		
		public function dispose():void
		{
			_frame = null;
			_controllerInstance.dispose();
			_controllerInstance = null;
		}
		
		public static function get Instance():BagStore
		{
			if(_instance == null) _instance = new BagStore(new BagStoreSingleton);
			return _instance;
		}
		
		public function get tipPanelNumber():int{
			return _tipPanelNumber;
		}
		
		public function set tipPanelNumber(value:int):void{
		    _tipPanelNumber = value;	
		}
		
		public function reduceTipPanelNumber():void{
			_tipPanelNumber--;
		}
		
		public function get passwordOpen():Boolean{
			return _passwordOpen;
		}
		
		public function set passwordOpen(value:Boolean):void{
			_passwordOpen = value;
		}

	}
}

class BagStoreSingleton{}