package ddt.church.weddingRoom
{
	import flash.display.Sprite;
	
	import tank.church.RoomListBGAsset;
	import ddt.manager.ChatManager;
	import ddt.manager.ItemManager;
	import ddt.manager.SocketManager;
	import ddt.view.ClientDownloading;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.PersonalInfoCell;
	import ddt.view.common.BellowStripViewII;

	public class WeddingRoomView extends RoomListBGAsset
	{
		public static const BTN_PANEL:String = "btn panel";
		public static const ROOM_LIST:String = "room list";
		private var currentState:String = BTN_PANEL;
		
		private var _model:WeddingRoomModel;
		private var _controler:WeddingRoomControler;
		
		private var _btnPanel:RoomListBtnPanel;
		private var _roomList:WeddingRoomListView;
		
		private var chatFrame:Sprite;
		
		private var _cell:BagCell;
		
		private var clientDownloading:ClientDownloading;
		
		public function WeddingRoomView(controler:WeddingRoomControler,model:WeddingRoomModel)
		{
			this._controler = controler;
			this._model = model;
			init();
		}
		
		private function init():void
		{
			_btnPanel = new RoomListBtnPanel(_controler);
			_roomList = new WeddingRoomListView(_controler,_model);
			
			updateViewState();
			
			_cell = new PersonalInfoCell(-1);
			_cell.width = 55;
			_cell.height= 55 
			_cell.x = cell_pos.x;
			_cell.y = cell_pos.y;
			cell_pos.visible = false;
			_cell.info = ItemManager.Instance.getTemplateById(9022);
			addChild(_cell);
			
			ChatManager.Instance.state = ChatManager.CHAT_CONSORTIA_CHAT_VIEW;
			chatFrame = ChatManager.Instance.view;
			addChild(chatFrame);
			ChatManager.Instance.setFocus();
			
//			clientDownloading = new ClientDownloading();
//			clientDownloading.x = this.downBtnPos.x;
//			clientDownloading.y = this.downBtnPos.y;
//			addChild(clientDownloading);
//			removeChild(downBtnPos);
		}
		
		public function changeState(state:String):void
		{
			if(currentState == state)return;
			
			currentState = state;
			updateViewState();
		}
		
		private function updateViewState():void
		{
			if(currentState == BTN_PANEL)
			{
				addChild(_btnPanel);
				BellowStripViewII.Instance.backFunction = null;
				if(_roomList.parent)
				{
					removeChild(_roomList);
					_roomList.updateList();
				}
			}else if(currentState == ROOM_LIST)
			{
				/* 在这里发送进入房间列表的消息 */
				
				SocketManager.Instance.out.sendMarryRoomLogin();
				
				addChild(_roomList);
				_roomList.updateList();
				BellowStripViewII.Instance.backFunction = returnClick;
				if(_btnPanel.parent)removeChild(_btnPanel);
			}else
			{
				return;
			}
		}
		
		private function returnClick ():void
		{
			changeState(BTN_PANEL);
		}
		
		public function dispose():void
		{
			if(chatFrame&&chatFrame.parent)removeChild(chatFrame);
			if(_roomList)_roomList.dispose();
			if(_btnPanel)_btnPanel.dispose();
			
//			if(clientDownloading)
//			{
//				clientDownloading.dispose();
//			}
//			clientDownloading = null;
			
			if(parent)parent.removeChild(this);
		}
	}
}