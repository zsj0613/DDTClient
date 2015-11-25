package ddt.gameLoad
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.view.common.BellowStripViewII;

	public class GameLoadingControler extends Sprite
	{
		private var _gameLoadView:RoomLoading;
		private var _sendData : Boolean ;
		public function GameLoadingControler($sendData : Boolean = true)
		{
			_sendData = $sendData;
			super();
			enter();
		}
		
		
		public function enter():void
		{
			ChatManager.Instance.state = ChatManager.CHAT_GAME_LOADING;
			ChatManager.Instance.setFocus();
			BellowStripViewII.Instance.hide();
			
			_gameLoadView = new RoomLoading(GameManager.Instance.Current,ChatManager.Instance.view);
			addChild(_gameLoadView);
			_gameLoadView.sendData = _sendData
			_gameLoadView.addEventListener(Event.COMPLETE,__complete);
		}
		
		private function __complete(event:Event):void
		{
			dispatchEvent(event);
		}
		
		public function dispose ():void
		{
			if(_gameLoadView)
			{
				_gameLoadView.removeEventListener(Event.COMPLETE,__complete);
				_gameLoadView.dispose();
			}
			_gameLoadView = null;
			BellowStripViewII.Instance.hide();
		}
	}
}