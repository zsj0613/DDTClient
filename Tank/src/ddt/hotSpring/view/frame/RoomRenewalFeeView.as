package ddt.hotSpring.view.frame
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.hotSpring.controller.HotSpringRoomController;
	import tank.hotSpring.roomRenewalFeeAsset;
	import ddt.manager.LanguageMgr;
	
	public class RoomRenewalFeeView extends HConfirmFrame
	{
		private var _controller:HotSpringRoomController;
		private var _roomVO:HotSpringRoomInfo;
		private var _roomRenewalFeeAsset:roomRenewalFeeAsset;
		
		public function RoomRenewalFeeView(controller:HotSpringRoomController, roomVO:HotSpringRoomInfo)
		{
			_controller=controller;
			_roomVO=roomVO;
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		private function initialize():void
		{
			this.okFunction = okClick;
			this.cancelFunction=cancelClick;
			this.closeCallBack=cancelClick;
			
			this.titleText=LanguageMgr.GetTranslation("AlertDialog.Info");
			this.setContentSize(400,100);
			this.centerTitle = true;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.buttonGape = 100;
			
			_roomRenewalFeeAsset=new roomRenewalFeeAsset();
			addContent(_roomRenewalFeeAsset);
			
			if(_roomVO.roomType==3)
			{
				switch(_roomVO.maxCount)
				{
					case 4://4人房
						_roomRenewalFeeAsset.lblMsg.text=_roomRenewalFeeAsset.lblMsg.text.replace("{0}", "800");
						break;
					case 8://8人房
						_roomRenewalFeeAsset.lblMsg.text=_roomRenewalFeeAsset.lblMsg.text.replace("{0}", "1600");
						break;
				}
			}
		}
		
		private function okClick():void
		{
			_controller.roomRenewalFee(_roomVO);
			dispose();
			super.close();
		}
		
		private function cancelClick():void
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
			if(_roomRenewalFeeAsset && _roomRenewalFeeAsset.parent) _roomRenewalFeeAsset.parent.removeChild(_roomRenewalFeeAsset);
			_roomRenewalFeeAsset=null;
			
			_roomVO=null;
			super.close();
			super.dispose();
		}
	}
}