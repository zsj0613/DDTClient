package ddt.church.weddingRoom
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import tank.church.RoomBtnPanelAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.DisposeUtils;
	import ddt.utils.LeavePage;
	
	public class RoomListBtnPanel extends RoomBtnPanelAsset
	{
		private var creactBtn:HBaseButton;
		private var enterBtn:HBaseButton;
		private var unmarryBtn:HBaseButton;
		
		private var _controler:WeddingRoomControler;
		
		private static var DIVORCE_PRICE:int = 5214;
		
		public function RoomListBtnPanel(controler:WeddingRoomControler)
		{
			this._controler = controler;
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			creactBtn = new HBaseButton(creactBtnAsset);
			creactBtn.useBackgoundPos = true;
			creactBtn.useHandCursor = true
			addChild(creactBtn);
			enterBtn = new HBaseButton(enterBtnAsset);
			enterBtn.useBackgoundPos = true;
			enterBtn.useHandCursor = true;
			addChild(enterBtn);
			unmarryBtn = new HBaseButton(unmarryBtnAsset);
			unmarryBtn.useBackgoundPos = true;
			unmarryBtn.useHandCursor = true;
			addChild(unmarryBtn);
		}
		
		private function addEvent():void
		{
			creactBtn.addEventListener(MouseEvent.CLICK,clickListener);
			enterBtn.addEventListener(MouseEvent.CLICK,clickListener);
			unmarryBtn.addEventListener(MouseEvent.CLICK,clickListener);
		}
		
		private function removeEvent():void
		{
			creactBtn.removeEventListener(MouseEvent.CLICK,clickListener);
			enterBtn.removeEventListener(MouseEvent.CLICK,clickListener);
			unmarryBtn.removeEventListener(MouseEvent.CLICK,clickListener);
		}
		
		private function clickListener(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			switch(event.currentTarget)
			{
				case creactBtn:
					_controler.showCreateFrame();
					break;
				case enterBtn:
					_controler.changeViewState(WeddingRoomView.ROOM_LIST);
					break;
				case unmarryBtn:
					if(!PlayerManager.Instance.Self.IsMarried)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.RoomListBtnPanel.clickListener"));
						//MessageTipManager.getInstance().show("您还未结婚，不可离婚");
						return;
					}
					
					if(PlayerManager.Instance.Self.Money<5214)
					{
						HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
					}else
					{
						_controler.showUnmarryFrame();
					}
					break;
				default:
					break;
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			DisposeUtils.disposeHBaseButton(creactBtn);
			DisposeUtils.disposeHBaseButton(enterBtn);
			DisposeUtils.disposeHBaseButton(unmarryBtn);
			if(this.parent)this.parent.removeChild(this);
		}
	}
}