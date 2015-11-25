package ddt.menu
{
	import ddt.data.player.PlayerInfo;
	import ddt.manager.PlayerManager;
	
	public class RightMenu
	{
		private static var _menu:RightMenuPanel;
		public static function show(info:PlayerInfo):void
		{
			if(info == null) return;
			if(info.ID == PlayerManager.Instance.Self.ID)
			{
				Instance.setSelfDisable(true);
			}else
			{
				Instance.setSelfDisable(false);
				if(PlayerManager.Instance.Self.IsMarried)
				{
					Instance.proposeEnable(false)
				}
			}
			
			
			Instance.playerInfo = info;	
			//Instance.y - 
			Instance.show();
			
		}
		
		public static function get Instance ():RightMenuPanel
		{
			if(_menu == null)
			{
				_menu = new RightMenuPanel();
			}
			return _menu
		}
		
		public static function hide():void
		{
			Instance.hide();
		}
	}
}