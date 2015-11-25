package ddt.fightLib
{
	import flash.display.Sprite;
	
	import ddt.gameLoad.GameLoadingControler;
	import ddt.manager.ChatManager;
	import ddt.manager.PlayerManager;

	public class FightLibView extends Sprite
	{
		private var _figure:FightLibPlayerInfoView;
		private var _chooseMapView:ChooseFightLibTypeView;
		private var _loadingGame:GameLoadingControler;
		
		public function FightLibView()
		{
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_figure = new FightLibPlayerInfoView(PlayerManager.Instance.Self);
			_figure.x = 11;
			_figure.y = 33;
			addChild(_figure);
			
			_chooseMapView = new ChooseFightLibTypeView();
			_chooseMapView.x = 270;
			_chooseMapView.y = 20;
			addChild(_chooseMapView);
			hideGuide();
			
			ChatManager.Instance.state = ChatManager.CHAT_ROOM_STATE;
			addChild(ChatManager.Instance.view);
		}
		
		public function showGuide1():void
		{
			_chooseMapView.guideMc.visible = true;
			_chooseMapView.guideMc.gotoAndStop(1);
		}
		
		public function showGuide2():void
		{
			_chooseMapView.guideMc.visible = true;
			_chooseMapView.guideMc.gotoAndStop(2);
		}
		
		public function hideGuide():void
		{
			_chooseMapView.guideMc.visible = false;
		}
		
		private function initEvents():void
		{
			
		}
		
		private function removeEvents():void
		{

		}
		
		public function dispose():void
		{
			removeEvents();
			_figure.dispose();
			_figure = null;
			_chooseMapView.dispose();
			_chooseMapView = null;
		}
	}
}