package ddt.roomlist
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import game.crazyTank.view.roomlistII.RoomListIIAsset;
	
	import ddt.data.SimpleRoomInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.PathManager;
	import ddt.manager.ServerManager;

	public class RoomListIIView extends RoomListIIAsset
	{
		private var _controller:IRoomListIIController;
		private var _playerlist:RoomListIIPlayerListView;
		private var _roomlist:RoomListIIBGView;
		private var _btnpanel:RoomListIIRoomBtnPanel;
		private var _chat:Sprite;
		private var _model:IRoomListIIModel;
		
		public function RoomListIIView(controller:IRoomListIIController,model:IRoomListIIModel)
		{
			_controller = controller;
			_model = model;
			super();
			init();
		}
		
		private function init():void
		{
			_roomlist = new RoomListIIBGView(_model);
			_roomlist.x = roomlist_pos.x;
			_roomlist.y = roomlist_pos.y;
			removeChild(roomlist_pos);
			addChild(_roomlist);
			
			_playerlist = new RoomListIIPlayerListView(_model.getSelfPlayerInfo(),_model.getPlayerList());
			_playerlist.x = playerlist_pos.x;
			_playerlist.y = playerlist_pos.y - 5;
			removeChild(playerlist_pos);
			addChild(_playerlist);
			
			_btnpanel = new RoomListIIRoomBtnPanel(_controller);
			_btnpanel.x = btnpanel_pos.x;
			_btnpanel.y = btnpanel_pos.y;
			removeChild(btnpanel_pos);
			addChild(_btnpanel);
			
			room_txt.text = String(ServerManager.Instance.current.Name);
			ChatManager.Instance.state = ChatManager.CHAT_ROOMLIST_STATE;
			_chat = ChatManager.Instance.view;
			removeChild(chat_pos);
			addChild(_chat);
		}
		
		private function __trainerClick(event:Event):void
		{
			if(PathManager.solveTrainerPage())
			{
				navigateToURL(new URLRequest(PathManager.solveTrainerPage()));
			}
		}
		
		public function sendGointoRoom(info:SimpleRoomInfo):void
		{
			_roomlist.gotoIntoRoom(info);
		}
		
		public function setMenuDisvisiable():void
		{
			_playerlist.setMenuDisvisiable();
//			_chat.hideMenu();
		}
		
		public function dispose():void
		{
//			_chat.dispose();
			_chat = null;
			_roomlist.dispose();
			_roomlist = null;
			_playerlist.dispose();
			_playerlist = null;
			_btnpanel.dispose();
			_btnpanel = null;
			_controller = null;
			_model = null;
			if(parent)
				parent.removeChild(this);
		}
	}
}