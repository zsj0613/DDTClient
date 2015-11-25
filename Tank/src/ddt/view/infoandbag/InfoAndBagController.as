package ddt.view.infoandbag
{
	import flash.display.Sprite;
	
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.SocketManager;
	import ddt.utils.MenoryUtil;
	import ddt.view.cells.BagCell;

	public class InfoAndBagController implements IInfoAndBagController
	{
		private var _view:InfoAndBagView;
		private var _info:PlayerInfo;
		
		public function InfoAndBagController(info:PlayerInfo)
		{
			_info = info;
			init();
			initEvent();
		}
		
		private function init():void
		{
			TipManager.clearTipLayer();
			_view = new InfoAndBagView(this,_info);
			_view.x = 91;
			_view.y = 38;
		}
		
		public function setBagType(type:uint):void
		{
			_view.setBagType(type);
		}
		
		public function set blackMode(value:Boolean):void
		{
			_view.blackMode = value;
		}
		
		private function initEvent():void
		{
			
		}
		
		public function switchVisible():void
		{
			_view.visible = !_view.visible;
			UIManager.AddDialog(_view);
			_view.stage.focus = _view;
			_view.setBagType(0);
			if(!_view.visible || _view.parent == null)
			{
				SocketManager.Instance.out.sendSaveDB();
				_view.closeKeySetFrame();
			}
		}
		
		/**
		 *重置背包内物品列表 
		 */		
		public function restBagList():void
		{
			//重置单元锁定状态
			if(_view.bagCells)
			{
				for each(var bagCell:BagCell in _view.bagCells)
				{
					if(bagCell.locked) bagCell.locked=false;
				}
			}
		}

		public function getView():Sprite
		{
			return _view;
		}
		
		public function dispose():void
		{
			_view.dispose();
			_view = null;
			_info = null;
			MenoryUtil.clearMenory();
		}
	}
}