package ddt.view.emailII
{
	import flash.filters.GlowFilter;
	
	import game.crazyTank.view.emailII.DiamondAsset;
	
	import ddt.data.EmailInfo;
	import ddt.view.cells.DragEffect;

	/**
	 * 附件基类
	 * @author SYC
	 * 
	 */
	internal class DiamondBase extends DiamondAsset
	{
		protected var _info:EmailInfo;
		internal function get info():EmailInfo
		{
			return _info;
			
		}
		internal function set info(value:EmailInfo):void
		{
			_info = value;
			if(_info)
			{
				update();
			}
			else
			{
				mouseEnabled = false;
				mouseChildren = false;
				click_mc.visible = false;
				charged_mc.visible = false;
				count_txt.text = "";
				_cell.visible = false;
			}
		}
		
		protected var _cell:EmaillIIBagCell;
		
		protected var _index:int;
		
		public function DiamondBase(index:int)
		{
			_index = index;
			initView();
			addEvent();
		}
		
		protected function initView():void
		{
			charged_mc.visible = false;
			picPos_mc.visible = false;
			click_mc.visible = false;
			count_txt.mouseEnabled = false;
			count_txt.text = "";
			//this.gotoAndStop(1);
			_cell = new EmaillIIBagCell();
			_cell.x = picPos_mc.x;
			_cell.y = picPos_mc.y;
			_cell.visible = false;
			_cell.allowDrag = false;
			addChild(_cell);
			swapChildren(_cell,picPos_mc);
			buttonMode = true;
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function dragDrop(effect:DragEffect):void
		{
			_cell.dragDrop(effect);
		}
		
		protected function addEvent():void{}
		
		protected function removeEvent():void{}
		
		protected function update():void{}

		public function dispose():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			removeEvent();
			if(_cell.parent)
			{
				removeChild(_cell);
			}
			_cell = null;
			_info = null;
		}
	}
}