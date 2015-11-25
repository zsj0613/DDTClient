package ddt.store
{
	import flash.display.Sprite;
	
	import ddt.store.data.StoreModel;
	import ddt.store.states.BagTabStoreView;
	import ddt.store.states.BaseStoreView;
	import ddt.store.states.ConsortiaStoreView;
	import ddt.store.states.GeneralStoreView;
	
	import ddt.data.store.StoreState;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	
	
	/**
	 * @author Wicki LA
	 * @time 12/10/2009
	 * @description 铁匠铺的控制器
	 * */
	public class StoreController
	{
		public static const GENERAL:String = "general";    //普通铁匠铺
		public static const CONSORTIA:String = "consortia";//公会铁匠铺
		public static const BAGSINGLE:String = "bagSingle";//背包单个视图的铁匠铺（没有加入工会时）
		public static const BAGTAB:String = "bagTab";//背包TAB页的铁匠铺
		
		private var _type:String;
		private var _model:StoreModel;
		private var _view:BaseStoreView;
		
		public function StoreController()
		{
			init();
			initEvents();
		}
		
		private function init():void
		{
			_model = new StoreModel(PlayerManager.Instance.Self);
		}
		
		private function initEvents():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,__givceOffer);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL, __onConsortiaEquipControl);
		}
		
		private function removeEvents():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,__givceOffer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL, __onConsortiaEquipControl);
		}
		
		/*上缴会费的返回*/
		private function __givceOffer(e:CrazyTankSocketEvent):void
		{
			if(StateManager.currentStateType != StateType.STORE_ARM  && StoreState.storeState != StoreState.CONSORTIAIISTORE)
			{
				removeEvents();
				return;
			}
			var num:int = e.pkg.readInt();
			var isSuccess:Boolean = e.pkg.readBoolean();
			var msg:String = e.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
		}
		
		/**修改公会设备管理**/
		private function __onConsortiaEquipControl(evt : CrazyTankSocketEvent) : void
		{
			var offer : int = evt.pkg.readInt();
			offer = evt.pkg.readInt();
			offer = evt.pkg.readInt();
			offer = evt.pkg.readInt();
			offer = evt.pkg.readInt();
			offer     = evt.pkg.readInt();
			var isSuccess       : Boolean = evt.pkg.readBoolean();
			var msg             : String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
		}
		
		public function getView(type:String):Sprite
		{
			switch(type)
			{
				case GENERAL:
					_view = new GeneralStoreView(this);
					break;
				case CONSORTIA:
					_view = new ConsortiaStoreView(this);
					break;
				case BAGSINGLE:
					_view = new BaseStoreView(this);
					break;
				case BAGTAB:
					_view = new BagTabStoreView(this);
					break;
				default:
					_view = new GeneralStoreView(this);
					break;
			}
			return _view;
		}
		
		public function get Type():String
		{
			return _type;
		}
		
		public function get Model():StoreModel
		{
			return _model;
		}
		
		public function dispose():void
		{
			removeEvents();
			_view.dispose();
			_model.clear();
			_model = null;
		}

	}
}