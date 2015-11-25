package ddt.view.transferProp
{
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.PlayerManager;
	import ddt.view.changeColor.ColorChangeBagListView;
	import tank.view.transferProp.TransferBagAsset;
	
	
	/**
	 * @author wicki LA
	 * @time 11/26/2009
	 * @description 右边背包的视图。用的是变色卡的bagListView
	 * */
	
	public class TransferBagView extends TransferBagAsset
	{
		private var _model:TransferModel;
		private var _bagListView:ColorChangeBagListView;
		public function TransferBagView()
		{
			init();
			initEvents();
		}
		
		private function init():void
		{
			_model = new TransferModel();
			_bagListView = new ColorChangeBagListView();
			_bagListView.x = bagListPos.x;
			_bagListView.y = bagListPos.y;
			addChild(_bagListView);
			_bagListView.setData(_model.TransferBag);
			
			goldTxt.text = PlayerManager.Instance.Self.Gold.toString();
			moneyTxt.text = PlayerManager.Instance.Self.Money.toString();
		}
		
		private function initEvents():void
		{
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateMoney);
		}
		
		private function removeEvents():void
		{
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__updateMoney);
		}
		
		private function __updateMoney(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties[PlayerInfo.GOLD] || evt.changedProperties[PlayerInfo.MONEY])
			{
				goldTxt.text = PlayerManager.Instance.Self.Gold.toString();
				moneyTxt.text = PlayerManager.Instance.Self.Money.toString();
			}
		}
		
		public function get BagList():ColorChangeBagListView
		{
			return _bagListView;
		}
		
		public function dispose():void
		{
			removeEvents();
			_model.dispose();
			_bagListView.dispose();
			
			_model = null;
			_bagListView = null;
			if(parent) parent.removeChild(this);
		}

	}
}