package ddt.view.shop
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import ddt.data.EquipType;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	public class ShopBugleFrame extends HConfirmFrame
	{
		private var _list : SimpleGrid;
		private var _currentItem : ShopItemView;
//		public static const BBUGLE : int = 0;
//		public static const SBUGLE : int = 1;
//		public static const CBUGLE : int = 2;
		private var _type : int ;//大喇叭，小喇叭，跨区喇叭(物品ID)
		public function ShopBugleFrame()
		{
			super();
			blackGound = false;
			alphaGound = true;
			showBottom = true;
			buttonGape = 70;
			fireEvent = true;
			okLabel = LanguageMgr.GetTranslation("ddt.dialog.showbugleframe.ok");
			init();
		}
		public function set type(i : int) : void
		{
			_type = i;
			upView();
			if(_info)
			{
				show();
			}
		}
		public function get type() : int
		{
			return _type;
		}
//		override public function show():void
//		{
//			blackGound = false;
//			super.show();
//			blackGound = true;
//		}
		override public function show():void{
			TipManager.AddTippanel(this,true);
			
			if(stage)stage.focus = this;
		}
		private function init() : void
		{
			this.setContentSize(330,170);
			_list = new SimpleGrid(110,125,3);
			_list.setSize(330,170);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "off";
			this.addContent(_list);
			this.okFunction = __okHandler;
			this.cancelFunction = __cancelHandler;
			upView();
		}
		private function __okHandler() : void
		{
			SoundManager.instance.play("008");
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			if(PlayerManager.Instance.Self.Money <  _currentItem.money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				return;
			}
			var items:Array = new Array();
			var types:Array = new Array();
			var colors:Array = new Array();
			var dresses:Array = new Array();
			var places:Array = new Array();
			var skins:Array = [];
			
			items.push(_info.GoodsID);
			types.push(_currentItem.types);
			colors.push("");
			places.push(0);
			skins.push("");
			dresses.push(false);
			SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins,3);
			__cancelHandler();
			
		}
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			super.__onKeyDownd(e);
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		private function __cancelHandler() : void
		{
			SoundManager.instance.play("008");
			dispose();
		}
		
		private function upView() : void
		{
			clearAllItem();
			addItems();
		}
		private var _info : ShopItemInfo;
		private function addItems() : void
		{
			var id : int;
			if(_type == EquipType.T_BBUGLE)
			{
				id = EquipType.T_BBUGLE;
				this.titleText = LanguageMgr.GetTranslation("ddt.dialog.showbugleframe.bigbugletitle");
//				this.titleText = "大喇叭快速购买";
			}
			else if(_type == EquipType.T_SBUGLE)
			{
				id = EquipType.T_SBUGLE;
				this.titleText = LanguageMgr.GetTranslation("ddt.dialog.showbugleframe.smallbugletitle");
//				this.titleText = "小喇叭快速购买";
			}else if(_type == EquipType.T_CBUGLE)
			{
				id = EquipType.T_CBUGLE;
				this.titleText = LanguageMgr.GetTranslation("ddt.dialog.showbugleframe.crossbugletitle");
//				this.titleText = "跨区大喇叭快速购买";
			}else if(_type == 88)
			{
				id = 88;
				this.titleText = LanguageMgr.GetTranslation("副本通行证快速购买");
			}
			
			_info = ShopManager.Instance.getMoneyShopItemByTemplateID(id);
			if(_info)
			{
				if(_info.getItemPrice(1).IsValid)addItem(_info,1,true);
				if(_info.getItemPrice(2).IsValid)addItem(_info,2);
				if(_info.getItemPrice(3).IsValid)addItem(_info,3);
			}
		}
		private function addItem(info : ShopItemInfo,index:int,defalutItem : Boolean=false) : void
		{
			var cell : ShopCell = new ShopCell(70,70,info.TemplateInfo);
			var item : ShopItemView = new ShopItemView(index,info.getTimeToString(index),info.getItemPrice(index).moneyValue,cell,false);
			item.addEventListener(MouseEvent.CLICK, __onClickHandler);
			_list.appendItem(item);
			if(defalutItem)selectItem(item);
		}
		private function clearAllItem() : void
		{
			for each(var item : ShopItemView in _list.items)
			{
				item.removeEventListener(MouseEvent.CLICK, __onClickHandler);
				item.dispose();
				item = null;
			}	
			if(_list)_list.clearItems();
			_currentItem = null;
		}
		private function __onClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			selectItem(evt.currentTarget as ShopItemView);
		}
		private function selectItem(item : ShopItemView) : void
		{
			if(_currentItem)_currentItem.gotoAndStopHandler(1);
			_currentItem = item; 
			if(_currentItem)_currentItem.gotoAndStopHandler(2);
		}
		override public function dispose():void
		{
			_currentItem = null;
			clearAllItem();
			if(_list && _list.parent)
				_list.parent.removeChild(_list);
			_list = null;
			super.dispose();
		}
		
//		private static var _instance:ShopBugleFrame
//		public static function get Instance():ShopBugleFrame
//		{
//			if(_instance == null)
//			{
//				_instance = new ShopBugleFrame();
//			}
//			return _instance;
//		}
	}
}