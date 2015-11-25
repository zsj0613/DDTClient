package ddt.view.continuation
{
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.ShortcutpayitemAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.ToggleButtonGroup;
	import road.ui.controls.HButton.TogleButton;
	import road.ui.controls.HButton.togleButtonAsset;
	import road.ui.controls.HComboBox;
	import road.ui.manager.TipManager;
	import road.utils.ClassFactory;
	
	import tank.common.hComboBoxAsset;
	import ddt.data.Price;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.ShopManager;
	import ddt.view.cells.BaseCell;

	public class ContinuationItem extends BaseCell
	{
		public static const DELETE_ITEM:String = "deleteitem";
		public static const CONDITION_CHANGE:String = "conditionchange";
		
		private var _isDelete:Boolean=false;
		private var _asset:ShortcutpayitemAsset;
		private var _dianquanRadioBtn:TogleButton;
		private var _liquanRadioBtn:TogleButton;
		private var closeBtn:HBaseButton;
		private var _com:HComboBox;
		private var _currentShopItem:ShopIICarItemInfo;
		private var _btnGroup:ToggleButtonGroup;
		private var _shopItems:Array;
		public function ContinuationItem()
		{
			_asset=new ShortcutpayitemAsset;
			super(_asset);
			init();
			initEventListener();
		}
		private function init():void
		{
			_dianquanRadioBtn=new TogleButton(new togleButtonAsset(),"点券");
			_liquanRadioBtn=new TogleButton(new togleButtonAsset(),"礼金");
			closeBtn = new HBaseButton(_asset.closeBtnAccect);
			_asset.addChild(closeBtn);
			_com = new HComboBox(new hComboBoxAsset());
			_btnGroup = new ToggleButtonGroup();
			
			_bg["com_pos"].visible = false;
			_com.x = _bg["com_pos"].x;
			_com.y = _bg["com_pos"].y;
			_com.textFeild.defaultTextFormat = new TextFormat(null,16);
			_com.textFeild.filters = [new GlowFilter(0x000000,1,5,5,3)];
			_com.setTextPosition(3,6);
			addChild(_com);
			
			addChild(_dianquanRadioBtn);
			_dianquanRadioBtn.x = _asset.dianquan_pos.x;
			_dianquanRadioBtn.y = _asset.dianquan_pos.y;
			_dianquanRadioBtn.textGape = 4;
			
			addChild(_liquanRadioBtn);
			_liquanRadioBtn.x = _asset.lijing_pos.x;
			_liquanRadioBtn.y = _asset.lijing_pos.y;
			_liquanRadioBtn.textGape = 4;
			
			_asset.dianquan_pos.visible=false;
			_asset.lijing_pos.visible=false;
			
			var tf:TextFormat = new TextFormat("黑体",16,0xff0000,true);
			_dianquanRadioBtn.enableTextFormat = tf;
			var tf_l:TextFormat =new TextFormat("黑体",16,0x45B5FE,true);
			_liquanRadioBtn.enableTextFormat = tf_l; 
			var utf:TextFormat = new TextFormat("黑体",16,0x515151,true);
			_dianquanRadioBtn.unableTextFormat = _liquanRadioBtn.unableTextFormat = utf;
			var filter:Array = [new GlowFilter(0xc0c1c3,1,5,5,100)];
			_dianquanRadioBtn.unableFilter = _liquanRadioBtn.unableFilter = filter;
						
			_btnGroup.addItem(_dianquanRadioBtn);
			_btnGroup.addItem(_liquanRadioBtn);
			
		}
		private function initEventListener():void
		{
			closeBtn.addEventListener(MouseEvent.CLICK,__closeClick);
			_com.addEventListener(Event.CHANGE,_comChange);
			_dianquanRadioBtn.addEventListener(MouseEvent.CLICK,__selectRadioBtn);
			_liquanRadioBtn.addEventListener(MouseEvent.CLICK,__selectRadioBtn);
		}
		public function set shopItemInfo(value_sinfo:InventoryItemInfo):void
		{
			super.info = value_sinfo;
			_shopItems = ShopManager.Instance.getShopItemByTemplateId(_info.TemplateID);
			_currentShopItem = null;
			for(var i:int=0; i<_shopItems.length; i++)
			{
				if(_shopItems[i].getItemPrice(1).IsMoneyType)
				{
					_currentShopItem = fillToShopCarInfo(_shopItems[i]);
					break;
				}
			}
			if(_currentShopItem == null) _currentShopItem = fillToShopCarInfo(_shopItems[0]);
			super.getContent().addEventListener(MouseEvent.ROLL_OVER,onContentOver);
			resetRadioBtn();
			updateComboBox();
			_asset.item_txt.text=value_sinfo.Name;
		}
		protected override function onMouseOver(evt:MouseEvent):void
		{
			
		}
		private function __selectRadioBtn(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(evt.currentTarget == _dianquanRadioBtn)
			{
				updateCurrentShopItem(Price.MONEY);
			}else if(evt.currentTarget == _liquanRadioBtn)
			{
				updateCurrentShopItem(Price.GIFT);
			}
			updateComboBox();
			dispatchEvent(new Event(CONDITION_CHANGE));
		}
		public function get currentShopItem():ShopIICarItemInfo
		{
			return _currentShopItem;
		}
		public function get isDelete():Boolean
		{
			return _isDelete;
		}
		private function _comChange(evt:Event):void
		{
			SoundManager.instance.play("008");
			_currentShopItem.currentBuyType = _com.selectedItem.data;
			dispatchEvent(new Event(CONDITION_CHANGE));
		}
		private function updateCurrentShopItem(type:int):void
		{
			for(var i:int=0;i<_shopItems.length;i++)
			{
				if(_shopItems[i].getItemPrice(1).PriceType == type)
				{
					_currentShopItem = fillToShopCarInfo(_shopItems[i]);
					break;
				}
			}
		}
		private function updateComboBox():void
		{
			_com.removeAll();
			var dp:DataProvider = new DataProvider();
			for(var i:int = 1; i < 4; i++)
			{
				if(_currentShopItem.getItemPrice(i).IsValid)
				{
					dp.addItem({label:_currentShopItem.getItemPrice(i).toString() + " " + _currentShopItem.getTimeToString(i),data:i});
				}
			}
			_com.dataProvider = dp;
			for(var j:int=0; j<_com.length; j++)
			{
				if(_com.getItemAt(j).data == _currentShopItem.currentBuyType)
				{
					_com.selectedIndex = j;
					break;
				}
			}
		}
		private function resetRadioBtn():void
		{
			_dianquanRadioBtn.enable = _dianquanRadioBtn.selected = false;
			_liquanRadioBtn.enable = _liquanRadioBtn.selected = false;
			for(var i:int=0;i<_shopItems.length;i++)
			{
				if(_shopItems[i].getItemPrice(1).IsMixed||_shopItems[i].getItemPrice(2).IsMixed)
				{
					throw new Error("续费价格填错了！！！");
				}else if(_shopItems[i].getItemPrice(1).IsMoneyType)
				{
					_dianquanRadioBtn.enable = true;
				}else if(_shopItems[i].getItemPrice(1).IsGiftType)
				{
					_liquanRadioBtn.enable = true;
				}
			}
			if(_currentShopItem.getItemPrice(1).IsMoneyType)
			{
				_dianquanRadioBtn.selected = true;
			}else if(_currentShopItem.getItemPrice(1).IsGiftType)
			{
				_liquanRadioBtn.selected = true;
			}
		}
		private function onContentOver(e:MouseEvent):void
		{
			if(!locked)
			{
				TipManager.setCurrentTarget(_asset.figure_pos,createTipRender(_bg["figure_pos"]));
			}
		}
		private function __closeClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			filters=[new ColorMatrixFilter([
                        0.3086, 0.6094, 0.0820, 0, 0,
                        0.3086, 0.6094, 0.0820, 0, 0,
                        0.3086, 0.6094, 0.0820, 0, 0,
                        0, 0, 0, 1, 0
            ])];
			_isDelete=true;
			mouseChildren=false;
			evt.stopPropagation();
			addEventListener(MouseEvent.CLICK,function(e:Event):void
			{
				SoundManager.instance.play("008");
				mouseChildren=true;
				_isDelete=false;
				filters=null;
				dispatchEvent(new Event(CONDITION_CHANGE));
				removeEventListener(MouseEvent.CLICK,arguments.callee);
			});
			dispatchEvent(new Event(CONDITION_CHANGE));
		}
		private function fillToShopCarInfo(item:ShopItemInfo):ShopIICarItemInfo
		{
			if(!item)return null;
			var t:ShopIICarItemInfo = new ShopIICarItemInfo(item.GoodsID,item.TemplateID);
			ClassFactory.copyProperties(item,t);
			return t;
		}
		
		
		override public function dispose():void
		{
			if(closeBtn.parent)closeBtn.parent.removeChild(closeBtn);
			closeBtn.dispose();
			closeBtn.removeEventListener(MouseEvent.CLICK,__closeClick);
			closeBtn = null;
			
			if(_com.parent)_com.parent.removeChild(_com);
			_com.dispose();
			_com.removeEventListener(Event.CHANGE,_comChange);
			_com = null;
			
			if(_dianquanRadioBtn.parent)_dianquanRadioBtn.parent.removeChild(_dianquanRadioBtn);
			_dianquanRadioBtn.dispose();
			_dianquanRadioBtn.removeEventListener(MouseEvent.CLICK,__selectRadioBtn);
			_dianquanRadioBtn = null;
			
			if(_liquanRadioBtn.parent)_liquanRadioBtn.parent.removeChild(_liquanRadioBtn);
			_liquanRadioBtn.dispose();
			_liquanRadioBtn.removeEventListener(MouseEvent.CLICK,__selectRadioBtn);
			_liquanRadioBtn = null;
			
			_shopItems = null;
			super.getContent().removeEventListener(MouseEvent.ROLL_OVER,onContentOver);
			super.dispose();
		}
	}
}