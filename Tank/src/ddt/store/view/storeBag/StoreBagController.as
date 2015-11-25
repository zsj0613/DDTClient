package ddt.store.view.storeBag
{
	import flash.display.DisplayObject;
	
	import ddt.store.data.StoreModel;
	
	import ddt.view.cells.BagCell;

	public class StoreBagController
	{
		private var _model:StoreModel;
		private var _view:StoreBagView;
		public function StoreBagController(model:StoreModel)
		{
            _model = model;
			_view = new StoreBagView(this);
			loadList();
		}

		public function getView():DisplayObject
		{
			return _view;
		}
		
		public function getPropCell(pos:int):BagCell
		{
			if(pos<0) return null;
			return _view.getPropCell(pos);
		}
		
		public function getEquipCell(pos:int):BagCell
		{
			if(pos<0) return null;
			return _view.getEquipCell(pos);
		}
		
		public function loadList():void
		{
			setList(_model);
		}
		
		public function setList(storeModel:StoreModel):void
		{
			_view.setData(storeModel);
		}
		
		public function changeMsg(msg:int):void
		{
			_view.msg_txt.gotoAndStop(msg);
		}
		
		public function get currentPanel():int
		{
			return _model.currentPanel;
		}
		
		public function get model():StoreModel
		{
			return this._model;
		}
		
		public function getEnabled():Boolean
		{
			return false;
		}
		
		public function setEnabled(value:Boolean):void
		{
		}
		
		public function dispose():void
		{
			_view.dispose();
			_model=null;
		}
		
	}
}