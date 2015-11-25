package ddt.hotSpring.view.frame
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.data.EquipType;
	import ddt.data.HotSpringRoomInfo;
	import ddt.events.ShortcutBuyEvent;
	import ddt.hotSpring.controller.HotSpringRoomListController;
	import tank.hotSpring.roomEnterConfirmAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.utils.LeavePage;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.QuickBuyFrame;
	
	public class RoomEnterConfirmView extends HConfirmFrame
	{
		private var _controller:HotSpringRoomListController;
		private var _roomEnterConfirmAsset:roomEnterConfirmAsset;
		private var _roomVO:HotSpringRoomInfo;
		private var _fastPurchaseGoldBox:FastPurchaseGoldBox;
		private var _quickBuyFrame:QuickBuyFrame;
		private var _inputPassword:String;
		
		public function RoomEnterConfirmView(controller:HotSpringRoomListController, roomVO:HotSpringRoomInfo, inputPassword:String="")
		{
			_controller = controller;
			_roomVO=roomVO;
			_inputPassword=inputPassword;
			init();
		}
		
		private function init():void
		{
			this.okFunction = confirmRoomEnter;
			this.cancelFunction=cancelRoomEnter;
			this.closeCallBack=cancelRoomEnter;
			
			this.titleText=LanguageMgr.GetTranslation("AlertDialog.Info");
			this.setContentSize(380,100);
			_roomEnterConfirmAsset=new roomEnterConfirmAsset();
			addContent(_roomEnterConfirmAsset);
			
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.buttonGape = 100;
			
			switch(_roomVO.roomType)
			{
				case 1://普通公共房间(金币房)
					_roomEnterConfirmAsset.lblMsg.text=_roomEnterConfirmAsset.lblMsg.text.replace("{0}", "10000"+LanguageMgr.GetTranslation("ddt.hotSpring.gold"));
					break;
				case 2://高级公共房间(2元房)
					_roomEnterConfirmAsset.lblMsg.text=_roomEnterConfirmAsset.lblMsg.text.replace("{0}", "200"+LanguageMgr.GetTranslation("ddt.hotSpring.money"));
					break;
			}
		}
		
		/**
		 * 进入房间
		 */		
		private function confirmRoomEnter():void
		{
			switch(_roomVO.roomType)
			{
				case 1://普通公共房间(金币房)
					if(PlayerManager.Instance.Self.Gold < 10000)
					{
						_fastPurchaseGoldBox=new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX);
						_fastPurchaseGoldBox.autoDispose=true;
						_fastPurchaseGoldBox.okFunction=okFastPurchaseGold;
						_fastPurchaseGoldBox.cancelFunction=cancelFastPurchaseGold;
						_fastPurchaseGoldBox.closeCallBack=cancelFastPurchaseGold;
						_fastPurchaseGoldBox.show();
						super.close();
						return;
					}
					break;
				case 2://高级公共房间(2元房)
					if(PlayerManager.Instance.Self.Money<200)
					{
						HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true, LeavePage.leaveToFill,null);
						dispose();
						super.close();
						return;
					}
					break;
			}
			
			_controller.roomEnter(_roomVO.roomID, _inputPassword);
		}
		
		private function okFastPurchaseGold():void
		{
			if(_fastPurchaseGoldBox)
			{
				_fastPurchaseGoldBox.close();
			}
			
			_quickBuyFrame = new QuickBuyFrame(LanguageMgr.GetTranslation("ddt.view.store.matte.goldQuickBuy"),"");
			_quickBuyFrame.cancelFunction=_quickBuyFrame.closeCallBack=cancelQuickBuy;
			_quickBuyFrame.itemID = EquipType.GOLD_BOX;
			_quickBuyFrame.x = 350;
			_quickBuyFrame.y = 200;
			_quickBuyFrame.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK,__shortCutBuyMoneyOkHandler);
			_quickBuyFrame.show();
		}
		
		private function cancelFastPurchaseGold():void
		{
			if(_fastPurchaseGoldBox)
			{
				_fastPurchaseGoldBox.close();
			}
		}
		
		private function __shortCutBuyMoneyOkHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			okFastPurchaseGold();
		}
		
		private function cancelQuickBuy():void
		{
			if(_quickBuyFrame)
			{
				_quickBuyFrame.dispose();
				_quickBuyFrame.close();
			}
		}
		
		private function cancelRoomEnter():void
		{
			dispose();
			super.close();
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(this.cancelFunction != null) this.cancelFunction();
			super.__closeClick(e);
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
		}
		
		override public function dispose():void
		{
			if(_roomEnterConfirmAsset && _roomEnterConfirmAsset.parent) _roomEnterConfirmAsset.parent.removeChild(_roomEnterConfirmAsset);
			_roomEnterConfirmAsset=null;
			
			if(_fastPurchaseGoldBox)
			{
				if (_fastPurchaseGoldBox.parent) _fastPurchaseGoldBox.parent.removeChild(_fastPurchaseGoldBox);
				_fastPurchaseGoldBox.dispose();
			}
			_fastPurchaseGoldBox=null;
			
			if(_quickBuyFrame)
			{
				if (_quickBuyFrame.parent) _quickBuyFrame.parent.removeChild(_quickBuyFrame);
				_quickBuyFrame.dispose();
			}
			_quickBuyFrame=null;
			
			_roomVO=null;
			super.dispose();
		}
	}
}