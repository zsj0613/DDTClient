package ddt.manager
{
	import flash.events.Event;
	
	import road.ui.manager.UIManager;
	
	import ddt.view.common.PlayerInfoPanel;
	
	public class PersonalInfoManager
	{
		private static var _instance:PersonalInfoManager;
		
		private var _currentPanel:PlayerInfoPanel;
		
		public function PersonalInfoManager()
		{
		}
		
		public function addPersonalInfo(id:int,zoneID:int):void
		{
			if(id > 0)
			{
				if(_currentPanel)
				{
					_currentPanel.removeEventListener(Event.CLOSE,__playerInfoClose);
					_currentPanel.dispose();
					_currentPanel = null;
				}
				
				if(_currentPanel == null)
				{
					_currentPanel = new PlayerInfoPanel();
					_currentPanel.addEventListener(Event.CLOSE,__playerInfoClose);
					_currentPanel.info = PlayerManager.Instance.findPlayer(id,zoneID);
				}
				UIManager.AddDialog(_currentPanel);	
//				TipManager.AddTippanel(_currentPanel,true);
			}
		}
		
		private function __playerInfoClose(evt:Event):void
		{
			_currentPanel = null;
		}
		
		public static function get instance():PersonalInfoManager
		{
			if(_instance == null)
			{
				_instance = new PersonalInfoManager();
			}
			return _instance;
		}
	}
}