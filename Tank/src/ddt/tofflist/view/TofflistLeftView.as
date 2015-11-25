package ddt.tofflist.view
{
	import flash.display.Sprite;
	
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.tofflist.TofflistModel;

	public class TofflistLeftView extends Sprite
	{
		private var _leftInfo      : TofflistLeftInfo;
		private var _currentPlayer : TofflistLeftCurrentCharcter;
		private var chatFrame:Sprite;
		
		public function TofflistLeftView()
		{
			super();
			init();
			addEvent();
		}
		private function init() :  void
		{
			_currentPlayer = new TofflistLeftCurrentCharcter();
			addChild(_currentPlayer);
			_leftInfo = new TofflistLeftInfo();
			addChild(_leftInfo);

			ChatManager.Instance.state = ChatManager.CHAT_TOFFLIST_VIEW;
			chatFrame = ChatManager.Instance.view;
			addChild(chatFrame);
		}
		
		public function updateTime():void
		{
			_leftInfo.updateTimeTxt.text = LanguageMgr.GetTranslation("ddt.tofflist.view.lastUpdateTime")+ TofflistModel.Instance.lastUpdateTime;
		}
		
		private function addEvent() : void
		{
			
		}
		private function removeEvent() : void
		{
			
		}
		public function dispose() : void
		{
			removeEvent();
			_leftInfo.dispose();
			_currentPlayer.dispose();
			if(chatFrame && chatFrame.parent) chatFrame.parent.removeChild(chatFrame);
			chatFrame=null;
		}
		
	}
}