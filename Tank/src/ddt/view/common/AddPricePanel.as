package ddt.view.common
{
	import fl.controls.Button;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.ContinuaSingle;
	
	import road.comm.PackageOut;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.ToggleButtonGroup;
	import road.ui.controls.HButton.TogleButton;
	import road.ui.controls.HButton.togleButtonAsset;
	import road.ui.controls.HComboBox;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.utils.ClassFactory;
	
	import tank.common.hComboBoxAsset2;
	import ddt.data.EquipType;
	import ddt.data.Price;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.data.socket.ePackageType;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;

	public class AddPricePanel extends HConfirmFrame
	{
		private var _asset:ContinuaSingle;
		private var _delete:Button;
		private var _dopay:Button;
		private var _type:HComboBox;
		private var _dianquanRadioBtn:TogleButton;
		private var _liquanRadioBtn:TogleButton;
		private var _btnGroup:ToggleButtonGroup;
		private var _isDress:Boolean;
		private var _info:InventoryItemInfo;
		private var label:TextField;
		
		private var _shopItems:Array;
		private var _currentShopItem:ShopIICarItemInfo;
		public function AddPricePanel()
		{
			init();
		}
		
		private function init():void
		{
			_asset = new ContinuaSingle();
			_shopItems = [];
			_asset.dianquanPos.visible = false;
			_asset.liquanPos.visible = false;
			_asset.typePos.visible = false;
			addContent(_asset,true);
			
			titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
			var t:TextFormat = new TextFormat(LanguageMgr.GetTranslation("ddt.auctionHouse.view.BaseStripView.Font"),14,0x2C1525);
			
			t.leading = 14;
			
			_type = new HComboBox(new hComboBoxAsset2());
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
			_dianquanRadioBtn.textGape = 10;
			_btnGroup.addItem(_dianquanRadioBtn);
			_liquanRadioBtn = new TogleButton(new togleButtonAsset(),"礼金");
			addContent(_liquanRadioBtn);
			_liquanRadioBtn.x = _asset.liquanPos.x;
			_liquanRadioBtn.y = _asset.liquanPos.y;
			_liquanRadioBtn.textGape = 10;
			_btnGroup.addItem(_liquanRadioBtn);
			
			var tf:TextFormat = new TextFormat("黑体",18,0xff0000,true);
			_dianquanRadioBtn.enableTextFormat = _liquanRadioBtn.enableTextFormat = tf;
			var utf:TextFormat = new TextFormat("黑体",18,0x515151,true);
			_dianquanRadioBtn.unableTextFormat = _liquanRadioBtn.unableTextFormat = utf;
			var filter:Array = [new GlowFilter(0xc0c1c3,1,5,5,100)];
			_dianquanRadioBtn.unableFilter = _liquanRadioBtn.unableFilter = filter;
			
			fireEvent = false;
			blackGound = false;
			alphaGound = true;
			showCancel = true;
			stopKeyEvent = true;
			okFunction = __doPayClick;
			okLabel = LanguageMgr.GetTranslation("ddt.view.common.AddPricePanel.xu");
			setContentSize(378,160);
			
			initEvents();
		}
		private static var _instance:AddPricePanel;
		public static function get Instance():AddPricePanel
		{
			if(_instance == null)
			{
				_instance = new AddPricePanel();
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
			SoundManager.Instance.play("008");
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
					SoundManager.Instance.play("008");
					if(okFunction != null)
						okFunction();
				}
			}else if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				close();
			}
		}
		
		
		private function doDel():void
		{
			var pkg:PackageOut = new PackageOut(ePackageType.DELETE_GOODS);
			pkg.writeByte(_info.BagType);
			pkg.writeInt(_info.Place);
			SocketManager.Instance.out.sendPackage(pkg);
			dispose();
		}
		
		private function __doPayClick(evt:MouseEvent = null):void
		{
			if(_currentShopItem.getItemPrice(_type.selectedIndex+1).moneyValue>PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
			}else if(_currentShopItem.getItemPrice(_type.selectedIndex+1).giftValue>PlayerManager.Instance.Self.Gift)
			{
				MessageTipManager.getInstance().show("礼金不足");
			}else if(PlayerManager.Instance.Self.getMedalNum() < _currentShopItem.getItemPrice(_type.selectedIndex + 1).getOtherValue(EquipType.MEDAL))
			{
				MessageTipManager.getInstance().show("勋章不足");
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
				var arr:Array = [];
				arr.push([_info.BagType,_info.Place,_currentShopItem.GoodsID,_type.selectedIndex+1,_isDress]);
				SocketManager.Instance.out.sendGoodsContinue(arr);
				dispose();
			}
		}
		
		public function setInfo(value:InventoryItemInfo,isDress:Boolean):void
		{
			_info = value;
			_isDress = isDress;
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
				if(_shopItems[i].getItemPrice(1).IsMixed||_shopItems[i].getItemPrice(2).IsMixed||_shopItems[i].getItemPrice(3).IsMixed)
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
		
		private function updateComboBox():void
		{
			_type.removeAll();
			var dp:DataProvider = new DataProvider();
			for(var i:int = 1; i < 4; i++)
			{
				if(_currentShopItem.getItemPrice(i).IsValid)
				{
					dp.addItem({label:_currentShopItem.getItemPrice(i).toString() + " " + _currentShopItem.getTimeToString(i),data:i});
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