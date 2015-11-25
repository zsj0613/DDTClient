package ddt.view.personalinfoII
{
	import flash.display.DisplayObject;
	
	import road.data.DictionaryData;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.SelfInfo;
	import ddt.manager.SocketManager;
	import ddt.request.bag.LoadBodyThing;
	import ddt.view.bagII.BagEvent;

	public class PersonalInfoIIController implements IPersonalInfoIIController
	{
		private var _view:PersonalInfoIIView;
		private var _model:IPersonalInfoIIModel;
		private var _info:PlayerInfo;
		private var _enabled:Boolean;
		private var _showOption:Boolean;
		/**
		 * 是否从数据库更新数据。 房间中不需要。名人堂和普通查看资料需要
		 * 
		 */		
		private var _updateFromDB:Boolean;
		
		public function PersonalInfoIIController(info:PlayerInfo,showOption:Boolean = false,updateFromDB:Boolean = true)
		{
			_updateFromDB = updateFromDB;
			_info = info;
			_showOption = showOption;
			init();
			initEvent();
		}
		
		private function init():void
		{
			_model = new PersonalInfoIIModel(_info);
			_view = new PersonalInfoIIView(this,_model);
			loadList();
			_enabled = true;
		}
		
		private function initEvent():void
		{
			_info.Bag.addEventListener(BagEvent.UPDATE,__updateGoods);
		}

		public function getView():DisplayObject
		{
			return _view;
		}
		
		public function getShowOption():Boolean
		{
			return _showOption;
		}
		
		public function loadList():void
		{
			_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,popChange);
			if(_info is SelfInfo)
			{
				setList(_info.Bag.items);
				_view.updateInfo();
			}
			else
			{
				SocketManager.Instance.out.sendItemEquip(_info.ID);
			}
		}
		
		private function popChange(e:PlayerPropertyEvent):void
		{
			_view.updateInfo();
		}
		
		public function setList(list:DictionaryData):void
		{
			_view.setData(list);
		}
		
		private function updateInfo(loader:LoadBodyThing):void
		{
			_model.getPlayerInfo().Colors = loader.Colors;
			_model.getPlayerInfo().Style = loader.Style;
			_model.getPlayerInfo().Attack = loader.Attack;
			_model.getPlayerInfo().Defence = loader.Defence;
			_model.getPlayerInfo().Agility = loader.Agility;
			_model.getPlayerInfo().Luck = loader.Luck;
			_model.getPlayerInfo().Grade = loader.Grade;
			_model.getPlayerInfo().GP = loader.GP;
			_model.getPlayerInfo().Repute = loader.Repute;
			_model.getPlayerInfo().Offer = loader.Offer;
			_model.getPlayerInfo().ConsortiaName = loader.ConsortiaName;
			_model.getPlayerInfo().Offer = loader.Offer;
			_model.getPlayerInfo().LastSpaDate = loader.LastSpaDate;//最近退出温泉房间时间
			_view.updateInfo();
		}
		
		public function getEnabled():Boolean
		{
			return _enabled;
		}
		
		public function setEnabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		private function __updateGoods(evt:BagEvent):void
		{
			for each(var i:InventoryItemInfo in evt.changedSlots)
			{
				var c:InventoryItemInfo = _info.Bag.getItemAt(i.Place);
				if(c)
				{
					_view.setCellInfo(c.Place,c);
				}else
				{
					_view.setCellInfo(i.Place,null);
				}
			}
		}
		
		public function dispose():void
		{
			_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,popChange);
			_info.Bag.removeEventListener(BagEvent.UPDATE,__updateGoods);
			_info = null;
			_view.dispose();
			_view = null;
			_model.dispose();
			_model = null;
		}
	}
}