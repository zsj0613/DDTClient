package ddt.hotSpring.view.frame
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.data.EquipType;
	import ddt.data.HotSpringRoomInfo;
	import ddt.events.ShortcutBuyEvent;
	import ddt.hotSpring.controller.HotSpringRoomController;
	import tank.hotSpring.roomEnterConfirmAsset;
	import tank.hotSpring.roomPlayerContinueConfirmAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.utils.LeavePage;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.QuickBuyFrame;
	
	public class RoomPlayerContinueConfirmView extends HConfirmFrame
	{
		private var _controller:HotSpringRoomController;
		private var _roomPlayerContinueConfirmAsset:roomPlayerContinueConfirmAsset;
		private var _roomVO:HotSpringRoomInfo;
		private var _fastPurchaseGoldBox:FastPurchaseGoldBox;
		private var _quickBuyFrame:QuickBuyFrame;
		
		public function RoomPlayerContinueConfirmView(controller:HotSpringRoomController, roomVO:HotSpringRoomInfo)
		{
			_controller = controller;
			_roomVO=roomVO;
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		private function initialize():void
		{
			this.okFunction = confirmContinue;
			this.cancelFunction=cancelContinue;
			this.closeCallBack=cancelContinue;
			
			this.titleText=LanguageMgr.GetTranslation("AlertDialog.Info");
			this.setContentSize(440,100);
			_roomPlayerContinueConfirmAsset=new roomPlayerContinueConfirmAsset();
			addContent(_roomPlayerContinueConfirmAsset);
			
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
					_roomPlayerContinueConfirmAsset.lblMsg.text=_roomPlayerContinueConfirmAsset.lblMsg.text.replace("{0}", "10000"+LanguageMgr.GetTranslation("ddt.hotSpring.gold"));
					break;
				case 2://高级公共房间(2元房)
					_roomPlayerContinueConfirmAsset.lblMsg.text=_roomPlayerContinueConfirmAsset.lblMsg.text.replace("{0}", "200"+LanguageMgr.GetTranslation("ddt.hotSpring.money"));
					break;
			}
		}
		
		/**
		 * 是否继续操作
		 */		
		private function confirmContinue():void
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
			
			dispose();
			super.close();
			_controller.roomPlayerContinue(true);
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
		
		private function cancelContinue():void
		{
			dispose();
			super.close();
			_controller.roomPlayerContinue(false);
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
			if(_roomPlayerContinueConfirmAsset && _roomPlayerContinueConfirmAsset.parent) _roomPlayerContinueConfirmAsset.parent.removeChild(_roomPlayerContinueConfirmAsset);
			_roomPlayerContinueConfirmAsset=null;
			
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