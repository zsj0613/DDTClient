package ddt.view.common
{
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.ShortCutBuyCard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.ToggleButtonGroup;
	import road.ui.controls.HButton.TogleButton;
	import road.ui.controls.HButton.togleButtonAsset;
	import road.ui.controls.HComboBox;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.utils.ClassFactory;
	
	import tank.common.hComboBoxAsset;
	import ddt.data.Price;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;

	public class BuyBuffCardFrame extends HConfirmFrame
	{
		private var _asset:ShortCutBuyCard;
		private static var _instance:BuyBuffCardFrame;

		private var _type:HComboBox;
		private var _dianquanRadioBtn:TogleButton;
		private var _liquanRadioBtn:TogleButton;
		private var _medalRadioBtn:TogleButton;
		private var _btnGroup:ToggleButtonGroup;
		private var _info:ItemTemplateInfo;
		
		private var _shopItems:Array;
		private var _currentShopItem:ShopIICarItemInfo;
		public function BuyBuffCardFrame()
		{
			init();
		}
		
		private function init():void
		{
			_asset = new ShortCutBuyCard();
			_shopItems = [];
			_asset.dianquanPos.visible = false;
			_asset.liquanPos.visible = false;
			_asset.typePos.visible = false;
			addContent(_asset,true);
			_asset.x = 30;
			
			titleText = "快捷购买";
			
			_type = new HComboBox(new hComboBoxAsset());
			_type.move(_asset.typePos.x,_asset.typePos.y);
			_type.textFeild.defaultTextFormat = new TextFormat(null,16);
			_type.textFeild.filters = [new GlowFilter(0x000000,1,5,5,3)];
			_type.setTextPosition(3,6);
			addContent(_type);
			
			_btnGroup = new ToggleButtonGroup();
			
			_dianquanRadioBtn = new TogleButton(new togleButtonAsset(),"点券");
			addContent(_dianquanRadioBtn);
			_dianquanRadioBtn.x = _asset.dianquanPos.x;
			_dianquanRadioBtn.y = _asset.dianquanPos.y;
			_dianquanRadioBtn.textGape = 30;
			_dianquanRadioBtn.addIcon(_asset.dianquanAsset,30,3);
			_btnGroup.addItem(_dianquanRadioBtn);
			_liquanRadioBtn = new TogleButton(new togleButtonAsset(),"礼金");
			addContent(_liquanRadioBtn);
			_liquanRadioBtn.x = _asset.liquanPos.x;
			_liquanRadioBtn.y = _asset.liquanPos.y;
			_liquanRadioBtn.textGape = 30;
			_liquanRadioBtn.addIcon(_asset.liquanAsset,30,3);
			_btnGroup.addItem(_liquanRadioBtn);
//			_medalRadioBtn = new TogleButton(new togleButtonAsset(),"勋章");
//			addContent(_medalRadioBtn);
//			_medalRadioBtn.x = _asset.medalPos.x;
//			_medalRadioBtn.y = _asset.medalPos.y;
//			_medalRadioBtn.textGape = 20;
//			_btnGroup.addItem(_medalRadioBtn);
			
			_dianquanRadioBtn.enableTextFormat = new TextFormat("黑体",15,0xf95f1b,true);
			_liquanRadioBtn.enableTextFormat = new TextFormat("黑体",15,0x0393dd,true);;
			_dianquanRadioBtn.unableTextFormat = _liquanRadioBtn.unableTextFormat = new TextFormat("黑体",18,0x515151,true);
			var filter:Array = [new GlowFilter(0xc0c1c3,1,5,5,100)];
			_dianquanRadioBtn.unableFilter = _liquanRadioBtn.unableFilter = filter;
			
			fireEvent = false;
			blackGound = false;
			alphaGound = true;
			showCancel = false;
			stopKeyEvent = true;
			okFunction = __doPayClick;
			okLabel = "购买";
			setContentSize(378,160);
			
			initEvents();
		}
		
		public static function get Instance():BuyBuffCardFrame
		{
			if(_instance == null)
			{
				_instance = new BuyBuffCardFrame();
			}
			return _instance
		}
		
		private function initEvents():void
		{
			_dianquanRadioBtn.addEventListener(MouseEvent.CLICK,__selectRadioBtn);
			_liquanRadioBtn.addEventListener(MouseEvent.CLICK,__selectRadioBtn);
		}
		
		private function removeEvents():void
		{
			_dianquanRadioBtn.removeEventListener(MouseEvent.CLICK,__selectRadioBtn);
			_liquanRadioBtn.removeEventListener(MouseEvent.CLICK,__selectRadioBtn);
		}
		
		private function fillToShopCarInfo(item:ShopItemInfo):ShopIICarItemInfo
		{
			if(!item)return null;
			var t:ShopIICarItemInfo = new ShopIICarItemInfo(item.GoodsID,item.TemplateID);
			ClassFactory.copyProperties(item,t);
			return t;
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
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			if(stopKeyEvent)
			{
				e.stopImmediatePropagation();
			}
			if(e.keyCode == Keyboard.ENTER)
			{
				if(okBtn.enable)
				{
					SoundManager.instance.play("008");
					if(okFunction != null)
						okFunction();
				}
			}else if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.instance.play("008");
				close();
			}
		}
		
		private function __doPayClick(evt:MouseEvent = null):void
		{
			if(_currentShopItem.getItemPrice(_type.selectedIndex+1).moneyValue>PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
			}else if(_currentShopItem.getItemPrice(_type.selectedIndex+1).giftValue>PlayerManager.Instance.Self.Gift)
			{
				MessageTipManager.getInstance().show("礼金不足");
			}else{
			    HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.common.AddPricePanel.pay"),true,doPay,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
			    TipManager.RemoveTippanel(this);
			    //ConfirmDialog.show("提示","确认支付?",true,doPay);
			}			
		}
		
		private function doPay():void
		{
			if(_info)
			{
				SocketManager.Instance.out.sendUseCard(-1,-1,_currentShopItem.GoodsID,_type.selectedIndex+1,true);
				dispose();
			}
		}
		
		public function setInfo(value:ItemTemplateInfo):void
		{
			_info = value;
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
			resetRadioBtn();
			updateComboBox();
		}
		
		private function resetRadioBtn():void
		{
			_dianquanRadioBtn.enable = _dianquanRadioBtn.selected = false;
			_liquanRadioBtn.enable = _liquanRadioBtn.selected = false;
			for(var i:int=0;i<_shopItems.length;i++)
			{
				if(_shopItems[i].getItemPrice(1).IsMoneyType)
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
		
		private function updateComboBox():void
		{
			_type.removeAll();
			var dp:DataProvider = new DataProvider();
			for(var i:int = 1; i < 4; i++)
			{
				if(_currentShopItem.getItemPrice(i).IsValid)
				{
					dp.addItem({label:_currentShopItem.getItemPrice(i).toString() + " " +_currentShopItem.getTimeToString(i),data:i});
				}
			}
			_type.dataProvider = dp;
			for(var j:int=0; j<_type.length; j++)
			{
				if(_type.getItemAt(j).data == _currentShopItem.currentBuyType)
				{
					_type.selectedIndex = j;
					break;
				}
			}
		}
		
		override public function close():void
		{
			super.close();
			_type.removeAll();
		}
		
		override public function set x (value:Number):void
		{
			if(width >1000) return;
			super.x = value;
		}
		
		override public function set y (value:Number):void
		{
			if(width >1000) return;
			super.y = value;
		}
		
		private function __close(evt:Event):void
		{
			dispose();
			_type.removeAll();
		}
		
		override public function dispose():void
		{
			_type.removeAll();
			_info = null;
			if(parent)parent.removeChild(this);
		}
		
	}
}