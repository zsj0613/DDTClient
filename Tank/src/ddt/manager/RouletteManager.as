package ddt.manager
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import road.comm.PackageIn;
	import road.ui.manager.TipManager;
	
	import ddt.data.EquipType;
	import ddt.data.bossBoxInfo.BoxGoodsTempInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.view.bagII.BagEvent;
	import ddt.view.cells.BagCell;
	import ddt.view.common.QuickBuyFrame;
	import ddt.view.roulette.RouletteBoxPanel;
	import ddt.view.roulette.RouletteEvent;
	
	public class RouletteManager extends EventDispatcher
	{
		private static var _instance:RouletteManager = null;
		private var _keyCount:int = -1;
		private var _templateIDList:Array;
		/**
		 *购买钥匙后的处理    0:不做其他处理     1:直接打开宝箱     2:直接转动宝箱 
		 */		
		private var _stateAfterBuyKey:int = 0;
		
		private var _boxCell:BagCell;
		
		public function RouletteManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function setup():void
		{
			init();
			initEvent();
		}
		
		private function init():void
		{
			_templateIDList = new Array();
		}
		
		private function initEvent():void
		{
			PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE , _bagUpdate);
		//	SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST , _showRoultteView);
		}
		
		private function _showRoultteView(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			for(var i:int = 0 ; i < 18 ; i++)
			{
				try{
					var info:BoxGoodsTempInfo = new BoxGoodsTempInfo();
					info.TemplateId = pkg.readInt();
					info.IsBind = pkg.readBoolean();
					info.ItemCount = pkg.readByte();
					info.ItemValid = pkg.readByte();
					_templateIDList.push(info);
				}catch(e:Error)
				{
				}
			}
			_randomTemplateID();
			showRouletteView();
		}
		
		public function useRouletteBox(cell:BagCell):void
		{
			_keyCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.ROULETTE_KEY);
			_boxCell = cell;
			if(_keyCount >= 1)
			{
				SocketManager.Instance.out.sendRouletteBox(cell.itemInfo.BagType , cell.itemInfo.Place);
			}
			else
			{
				_stateAfterBuyKey = 1;
				showBuyRouletteKey(1);
			}
		}
		/**
		 *购买钥匙后,更新宝箱的状态 
		 * 
		 */		
		private function updateState():void
		{
			switch(_stateAfterBuyKey)
			{
				case 0:
					break;
				case 1:
					if(_keyCount >= 1)
					{
						SocketManager.Instance.out.sendRouletteBox(_boxCell.itemInfo.BagType , _boxCell.itemInfo.Place);
					}
					_stateAfterBuyKey = 0;
					break;
				case 2:
					break;
				default:
					break;
			}
		}
		
		public function showRouletteView():void
		{
			TipManager.AddTippanel(new RouletteBoxPanel(_templateIDList , _keyCount),true);
		}
		
		public function showBuyRouletteKey(needKeyCount:int):void
		{
			var _buyKeyFrame:QuickBuyFrame = new QuickBuyFrame(LanguageMgr.GetTranslation("ddt.view.store.matte.goldQuickBuy"),"");
			_buyKeyFrame.itemID = EquipType.ROULETTE_KEY;
			_buyKeyFrame.stoneNumber = needKeyCount;
			_buyKeyFrame.x = 350;
			_buyKeyFrame.y = 200;
			_buyKeyFrame.cancelFunction = _closeFun;
			_buyKeyFrame.show();
		}
		
		private function _closeFun():void
		{
			_stateAfterBuyKey = 0;
		}
		
		private function _randomTemplateID():void
		{
			var itemID:BoxGoodsTempInfo = null;
			for(var i:int = 0 ; i < _templateIDList.length ; i++)
			{
				var ran:int = Math.floor(Math.random()*_templateIDList.length);
				itemID = _templateIDList[i] as BoxGoodsTempInfo;
				_templateIDList[i] = _templateIDList[ran];
				_templateIDList[ran] = itemID;
			}
		}
		
		private function _bagUpdate(e:BagEvent):void
		{
			var number:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.ROULETTE_KEY);
			if(_keyCount != number)
			{
				var evt:RouletteEvent = new RouletteEvent(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE);
				evt.keyCount = _keyCount = number;
				dispatchEvent(evt);
				
				updateState();
			}
		}
		
		public static function get Instance():RouletteManager
		{
			if(_instance == null)
			{
				_instance = new RouletteManager();
			}
			return _instance;
		}
	}
}