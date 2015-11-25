package ddt.church.churchScene
{
	import flash.events.EventDispatcher;
	
	import road.data.DictionaryData;
	
	import ddt.data.player.ChurchPlayerInfo;
	import ddt.events.ChurchRoomEvent;
	
	public class SceneModel extends EventDispatcher
	{
		private var _players:DictionaryData;
		
		public function get players():DictionaryData
		{
			return _players;
		}
		
		public function SceneModel()
		{
			_players = new DictionaryData(true);
		}
		
		public function addPlayer(player:ChurchPlayerInfo):void
		{
			_players.add(player.info.ID,player);
		}
		
		public function removePlayer(id:int):void
		{
			_players.remove(id);
		}
		
		public function getPlayers():DictionaryData
		{
			return _players;
		}
		
		public function getPlayerFromID(id:int):ChurchPlayerInfo
		{
			return _players[id];
		}
		
		public function reset():void
		{
			dispose();
			_players = new DictionaryData(true);
		}
		
		public function dispose():void
		{
			_players = null;
		}
	}
}