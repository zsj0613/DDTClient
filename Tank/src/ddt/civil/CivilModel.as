package ddt.civil
{
	import flash.events.EventDispatcher;
	
	import ddt.data.player.CivilPlayerInfo;
	import ddt.manager.PlayerManager;
	
	public class CivilModel extends EventDispatcher
	{

		/* 民政中心注册的玩家,按注册顺序排列 */
		private var _civilPlayers:Array;
		private var _currentcivilItemInfo : CivilPlayerInfo;
		private var _totalPage:int;
		private var _currentLeafSex:Boolean = true;
		
		public function set currentcivilItemInfo($info : CivilPlayerInfo) : void
		{
			if($info == null) return;
			_currentcivilItemInfo = $info;
			update();
		}
		
		public function get currentcivilItemInfo() : CivilPlayerInfo
		{
			return _currentcivilItemInfo ;
		}
		public function upSelfPublishEquit(b : Boolean) : void
		{
			for(var i:int=0;i<_civilPlayers.length ;i++)
			{
				if(PlayerManager.Instance.Self.ID == _civilPlayers[i].UserId)
				{
					(_civilPlayers[i] as CivilPlayerInfo).IsPublishEquip = b;
					break;
				}
			}
			
		}
		public function upSelfIntroduction(msg : String) : void
		{
			for(var i:int=0;i<_civilPlayers.length ;i++)
			{
				if(PlayerManager.Instance.Self.ID == _civilPlayers[i].UserId)
				{
					(_civilPlayers[i] as CivilPlayerInfo).Introduction = msg;
					break;
				}
			}
		}
		public function CivilModel()
		{
			
		}
		
		public function set civilPlayers(value:Array):void
		{
			_civilPlayers = [];
			
			_civilPlayers = value;
			_currentcivilItemInfo = _civilPlayers[0];
			for(var i:int=0;i<_civilPlayers.length ;i++)
			{
				if(PlayerManager.Instance.Self.ID == _civilPlayers[i].UserId && PlayerManager.Instance.Self.Introduction == "")
				{
					PlayerManager.Instance.Self.Introduction = (_civilPlayers[i] as CivilPlayerInfo).Introduction;
					break;
				}
			}
			dispatchEvent(new CivilDataEvent(CivilDataEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE));
		}
		public function update():void
		{
			dispatchEvent(new CivilDataEvent(CivilDataEvent.CIVIL_UPDATE));
		}
		
		public function updateBtn():void
		{
			dispatchEvent(new CivilDataEvent(CivilDataEvent.CIVIL_UPDATE_BTN));
		}
		
		public function get civilPlayers():Array
		{
			return _civilPlayers;
		}
		
		public function set TotalPage(value:int):void
		{
			_totalPage = value;
			update();
		}
		public function get TotalPage():int
		{
			return _totalPage;
		}
		
		public function get sex():Boolean
		{
			return _currentLeafSex;
		}
		
		public function set sex(value:Boolean):void
		{
			_currentLeafSex = value;
			update();
		}
		
		public function dispose():void
		{
			_civilPlayers = null;
			currentcivilItemInfo = null;
		}
	}
	
}