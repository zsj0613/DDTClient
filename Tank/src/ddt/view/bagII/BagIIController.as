package ddt.view.bagII
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	
	import ddt.data.player.BagInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.PlayerManager;
	import ddt.request.bag.LoadBagThing;

	public class BagIIController implements IBagIIController
	{
		private var _model:IBagIIModel;
		private var _info:PlayerInfo;
		private var _view:BagIIView;
		private var _enabled:Boolean;
		
		public function BagIIController(info:PlayerInfo)
		{
			_info = info;
			init();
		}
		
		private function init():void
		{
			_model = new BagIIModel(_info);
			_view = new BagIIView(this,_model);
			loadList();
			_enabled = true;
		}
		
		public function getView():DisplayObject
		{
			return _view;
		}
		
		public function getBagCells():Array
		{
			return _view.cells;	
		}
		
		public function set bagFinishingBtnEnable(value:Boolean):void {
			_view.bagFinishingBtnEnable = value;
		}
		
		public function setBagType(type:int):void
		{
			_view.showBag(type);
		}
		public function addStageInit() : void
		{
			_view.addStageInit();
		}
		
		public function setCellDoubleClickEnable (b:Boolean):void
		{
			_view.cellDoubleClickEnable = b;
		}
		
		public function loadList():void
		{
			if(_info is SelfInfo)
			{
				setList();
			}
			else
			{
				if(_info.Bag == null)
				{
					new LoadBagThing(_info.ID).loadSync(loadBagThingComplete);
				}
				else
				{
					setList();
				}
			}
		}
		
		private function loadBagThingComplete(loader:LoadBagThing):void
		{
			setList();
		}
		
		public function setList():void
		{
			_view.setData(PlayerManager.Instance.Self);
		}
		
		public function getEnabled():Boolean
		{
			return _enabled;
		}
		
		public function setEnabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		public function dispose():void
		{
			_info = null;
			_view.dispose();
			_view = null;
			_model.dispose();
			_model = null;
		}
	}
}