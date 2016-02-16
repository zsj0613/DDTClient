package ddt.view.common
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.common.CellMenuAddPriceAsset;
	import game.crazyTank.view.common.CellMenuAsset;
	import game.crazyTank.view.common.CellMenuMoveAsset;
	import game.crazyTank.view.common.CellMenuOpenAsset;
	import game.crazyTank.view.common.CellMenuUseAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.BagCell;

	public class CellMenu extends CellMenuAsset
	{
		public static const ADDPRICE:String = "addprice";
		public static const MOVE:String = "move";
		public static const OPEN:String = "open";
		public static const USE:String = "use";
		
		private var _cell:BagCell;
		private var _addpriceitem:CellMenuAddPriceAsset;
		private var _moveitem:CellMenuMoveAsset;
//		private var _openitem:CellMenuOpenAsset;
		private var _openitem:CellMenuUseAsset;
		private var _useitem:CellMenuUseAsset;
		
		private var _list:SimpleGrid;
		
		public function CellMenu()
		{
			super();
		}
		
		public function init():void
		{
			graphics.beginFill(0x000000,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
			
			_list = new SimpleGrid(88,26);
			ComponentHelper.replaceChild(this,pos,_list);
			_list.verticalScrollPolicy = _list.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			addEventListener(MouseEvent.CLICK,__mouseClick);
			
			_addpriceitem = new CellMenuAddPriceAsset();
			_moveitem = new CellMenuMoveAsset();
//			_openitem = new CellMenuOpenAsset();
			_openitem = new CellMenuUseAsset();
			_useitem = new CellMenuUseAsset();
			_addpriceitem.addEventListener(MouseEvent.CLICK,__addpriceClick);
			_moveitem.addEventListener(MouseEvent.CLICK,__moveClick);
			_openitem.addEventListener(MouseEvent.CLICK,__openClick);
			_useitem.addEventListener(MouseEvent.CLICK,__useClick);
		}
		
		public function get cell():BagCell
		{
			return _cell;
		}
		
		private function __mouseClick(evt:MouseEvent):void
		{
			hide();
			SoundManager.Instance.play("008");
		}
		
		private function __addpriceClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			if(PlayerManager.Instance.Self.bagLocked)
			{
				hide();
				new BagLockedGetFrame().show();
				return;
			}
			dispatchEvent(new Event(ADDPRICE));
			hide();
		}
		
		private function __moveClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			dispatchEvent(new Event(MOVE));
			hide();
		}
		
		private function __openClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			if(PlayerManager.Instance.Self.bagLocked)
			{
				hide();
				new BagLockedGetFrame().show();
				return;
			}
			dispatchEvent(new Event(OPEN));
			hide();
		}
		
		private function __useClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			dispatchEvent(new Event(USE));
			hide();
		}
		
		public function show(cell:BagCell,x:int,y:int):void
		{
			_cell = cell;
			if(_cell == null)return;
			var info:ItemTemplateInfo = _cell.info;
			if(info == null)return;
			if(EquipType.isPackage(info))
			{
				_list.appendItem(_openitem);
			}
			else if((info as InventoryItemInfo).getRemainDate() <= 0)
			{
				_list.appendItem(_addpriceitem);
			}else if(EquipType.canBeUsed(info))
			{
				_list.appendItem(_useitem);
			}
			_list.appendItem(_moveitem);
			TipManager.AddTippanel(this);
			this.x = x;
			this.y = y;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
			_cell = null;
			_list.clearItems();
		}
		
		private static var _instance:CellMenu;
		public static function get instance():CellMenu
		{
			if(_instance == null)
			{
				_instance = new CellMenu();
				_instance.init();
			}
			return _instance;
		}
	}
}