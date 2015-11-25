package ddt.shop.view
{
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.shopII.ShoppingCarItemAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HComboBox;
	import road.ui.manager.TipManager;
	
	import tank.common.hComboBoxAsset;
	import ddt.data.Price;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.view.cells.BaseCell;

	public class ShopShoppingCarItem extends BaseCell
	{
		public static const DELETE_ITEM:String = "deleteitem";
		public static const CONDITION_CHANGE:String = "conditionchange";
		
		private var _com:HComboBox;
		
		private var closeBtn:HBaseButton;
		private var _asset:ShoppingCarItemAsset;
		
		private var _shopItemInfo:ShopIICarItemInfo;
		
		public function ShopShoppingCarItem()
		{
			_asset = new ShoppingCarItemAsset();
			super(_asset);
			
			closeBtn = new HBaseButton(_bg["closeBtnAccect"]);
			closeBtn.useBackgoundPos = true;
			_bg.addChild(closeBtn);
			
			_com = new HComboBox(new hComboBoxAsset());
			_bg["com_pos"].visible = false;
			_com.x = _bg["com_pos"].x;
			_com.y = _bg["com_pos"].y;
			_com.textFeild.defaultTextFormat = new TextFormat(null,16);
			_com.textFeild.filters = [new GlowFilter(0x000000,1,5,5,3)];
			_com.setTextPosition(3,6);
			addChild(_com);
			initListener();
			_bg["figure_pos"].visible = false;
			_asset.dressModel_mc.visible = false;
			_asset.setChildIndex(_asset.dressModel_mc,_asset.numChildren -1);
		}
		
		private function initListener():void
		{
			closeBtn.addEventListener(MouseEvent.CLICK,__closeClick);
			_com.addEventListener(Event.CHANGE,_comChange);
			
		}
		
		private function onContentOver(e:MouseEvent):void
		{
			if(!locked)
			{
				TipManager.setCurrentTarget(_bg["figure_pos"],createTipRender(_bg["figure_pos"]));
			}
		}
		
		private function __closeClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			dispatchEvent(new Event(DELETE_ITEM));
		}
		
		private function _comChange(evt:Event):void
		{
			SoundManager.instance.play("008");
			_shopItemInfo.currentBuyType = _com.selectedItem.data;
			dispatchEvent(new Event(CONDITION_CHANGE));
		}
		
		public function set shopItemInfo(value:ShopIICarItemInfo):void
		{
			if(_shopItemInfo != value)
			{
				if(info)
				{
					_shopItemInfo.removeEventListener(Event.CHANGE,__updateItem);
				}
				
				super.info = value.TemplateInfo;
				_shopItemInfo = value;
				
				if(value == null)
				{
					_bg["item_txt"].text = "";
					_bg["priceMc"].visible = false;
					if(_com != null)
						_com.removeAll();
				}
				else
				{
					_bg["item_txt"].text = String(value.TemplateInfo.Name);
					initCom();
					initPriceMc();
					super.getContent().addEventListener(MouseEvent.ROLL_OVER,onContentOver);
					_shopItemInfo.addEventListener(Event.CHANGE,__updateItem);
				}
			}
		}
		
		public function get shopItemInfo():ShopIICarItemInfo
		{
			return _shopItemInfo;
		}
		
		private function initPriceMc():void
		{
			_bg["priceMc"].visible = true;
			switch(_shopItemInfo.getItemPrice(1).PriceType)
			{
				case Price.MONEY:
					_bg["priceMc"].gotoAndStop("money");
					break;
				case Price.GIFT:
					_bg["priceMc"].gotoAndStop("gift");
					break;
				case -5:
					_bg["priceMc"].gotoAndStop("medal");
					break;
				default:
					_bg["priceMc"].visible = false;
			}
		}
		
		private function __updateItem(event:Event):void
		{
			if(_shopItemInfo.currentBuyType == _com.selectedIndex + 1) return;
			setColor(_shopItemInfo.Color);
			initCom();
			dispatchEvent(new Event(CONDITION_CHANGE))
		}
		
		override protected function onMouseOver(evt:MouseEvent):void{}
		
		public function get TemplateID():int
		{
			if(_info == null)return -1;
			return _info.TemplateID;
		}
		
		
		private function initCom():void
		{
			_com.removeAll();
			var dp:DataProvider = new DataProvider();
			for(var i:int = 1; i < 4; i++)
			{
				if(_shopItemInfo.getItemPrice(i).IsValid)
				{
					dp.addItem({label:_shopItemInfo.getItemPrice(i).toString()+" "+_shopItemInfo.getTimeToString(i),data:i});
				}
			}
			_com.dataProvider = dp;
			for(var j:int=0; j<_com.length; j++)
			{
				if(_com.getItemAt(j).data == _shopItemInfo.currentBuyType)
				{
					_com.selectedIndex = j;
					break;
				}
			}
		}
		
		override public function dispose():void
		{
			if(super.getContent()) super.getContent().removeEventListener(MouseEvent.ROLL_OVER,onContentOver);
			_shopItemInfo.removeEventListener(Event.CHANGE,__updateItem);
			_shopItemInfo = null;
			closeBtn.removeEventListener(MouseEvent.CLICK,__closeClick);
			_com.removeEventListener(Event.CHANGE,_comChange);
			_com.dispose();
			super.dispose();
		}
	}
}