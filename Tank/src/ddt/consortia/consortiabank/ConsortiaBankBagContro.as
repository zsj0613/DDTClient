package ddt.consortia.consortiabank
{
	import flash.display.DisplayObject;
	
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.PlayerManager;
	import ddt.request.bag.LoadBagThing;
	import ddt.view.bagII.*;

	public class ConsortiaBankBagContro implements IBagIIController
	{
		private var _model:IBagIIModel;
		private var _info: SelfInfo;
		private var _view: ConsortiaBankBagView;
		private var _enabled:Boolean;
		
		public function ConsortiaBankBagContro(info:SelfInfo)
		{
			_info = info;
			init();
		}
		
		private function init():void
		{
			_model = new BagIIModel(_info);
			_view = new ConsortiaBankBagView(this,_model);
			loadList();
			_enabled = true;
		}
		
		public function getView():DisplayObject
		{
			return _view;
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
//			setList(loader.list);
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