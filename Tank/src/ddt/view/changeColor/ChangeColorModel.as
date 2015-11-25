package ddt.view.changeColor
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import road.data.DictionaryData;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.player.BagInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.ChangeColorCellEvent;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.BagEvent;

	public class ChangeColorModel extends EventDispatcher
	{
		private var _colorEditableThings:DictionaryData;
		private var _self:SelfInfo;
		private var _currentItem:InventoryItemInfo;
		private var _oldHideHat:Boolean;
		private var _oldHideGlass:Boolean;
		private var _oldHideSuit:Boolean;
		private var _changed:Boolean = false;
		
		private var _tempColor:String = "";
		private var _tempSkin:String = "";
		private var _equipBag:BagInfo;
		
		public var place:int = -1;
		public var colorEditableBag:BagInfo;
		public function ChangeColorModel()
		{
			init();
		}
		
		private function init():void
		{
			_self = new SelfInfo();
			_self.beginChanges();
			_self.Sex = PlayerManager.Instance.Self.Sex;
			_self.Hide = PlayerManager.Instance.Self.Hide;
			_self.Style = PlayerManager.Instance.Self.getPrivateStyle();
			_self.Colors = PlayerManager.Instance.Self.Colors;
			_self.Skin = PlayerManager.Instance.Self.Skin;
			_self.commitChanges();
			_oldHideHat = _self.getHatHide();
			_oldHideGlass = _self.getGlassHide();
			_oldHideSuit = _self.getSuitesHide();
			
			_equipBag = PlayerManager.Instance.Self.Bag;
			colorEditableBag = new BagInfo(BagInfo.EQUIPBAG,76);
			_colorEditableThings = new DictionaryData();
			colorEditableBag.items = _colorEditableThings;
			getColorEditableThings();
			initEvents();
		}
		
		//TODO: Fix this?
		private function initEvents():void
		{
			_equipBag.addEventListener(BagEvent.UPDATE,__updateItem);
		}
		
		private function removeEvents():void
		{
			_equipBag.removeEventListener(BagEvent.UPDATE,__updateItem);
		}
		
		private function __updateItem(evt:BagEvent):void
		{
			var changedSlots:Dictionary = evt.changedSlots;
			evt.stopImmediatePropagation();
			colorEditableBag.dispatchEvent(new BagEvent(BagEvent.UPDATE,changedSlots));
		}
		
		/**
		 * 取装备包中的可变色装备
		 * */
		private function getColorEditableThings():void
		{
			var i:int = 0;
			var item:InventoryItemInfo
			for each(item in _equipBag.items)
			{
				if(item.Place<=30) continue;
				if((EquipType.isEditable(item)||item.CategoryID==EquipType.FACE)&&item.getRemainDate()>0)
				{
					_colorEditableThings.add(i++,item);
				}
			}
		}
		
		public function savaItemInfo():void
		{
			_tempColor = _currentItem.Color;
			_tempSkin = _currentItem.Skin;
		}
		
		public function restoreItem():void
		{
			_currentItem.Color = _tempColor;
			_currentItem.Skin = _tempSkin;
		}
		
		public function get colorEditableThings():DictionaryData
		{
			return _colorEditableThings;
		}
		
		public function set self(value:SelfInfo):void
		{
			
		}
		
		public function get self():SelfInfo
		{
			return _self;
		}
		
		public function set currentItem(value:InventoryItemInfo):void
		{		
			_currentItem = value;
		}
		
		public function findBodyThingByCategoryID(id:int):InventoryItemInfo
		{
			return _equipBag.findFirstItem(id);
		}
		
		public function get currentItem():InventoryItemInfo
		{
			return _currentItem;
		}
		
		public function set changed(value:Boolean):void
		{
			_changed = value;
			dispatchEvent(new Event(ChangeColorCellEvent.SETCOLOR));
		}
		
		public function get changed():Boolean
		{
			return _changed;
		}
		
		public function get oldHideHat():Boolean
		{
			return _oldHideHat;
		}
		
		public function get oldHideGlass():Boolean
		{
			return _oldHideGlass;
		}
		
		public function get oldHideSuit():Boolean
		{
			return _oldHideSuit;
		}
		
		public function unlockAll():void
		{
			_equipBag.unLockAll();
		}
		
		public function clear():void
		{
			removeEvents();
			_colorEditableThings = null;
			_equipBag = null;
			_self = null;
		}
	}
}