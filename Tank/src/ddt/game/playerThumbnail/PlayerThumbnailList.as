package ddt.game.playerThumbnail
{
	import fl.controls.ScrollPolicy;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.game.Player;
	import ddt.game.objects.GameLiving;
	import ddt.game.objects.GameTurnedLiving;

	public class PlayerThumbnailList extends SimpleGrid
	{
		private var _info:DictionaryData;
		private var _players:DictionaryData;
		public function PlayerThumbnailList(info:DictionaryData)
		{
			_info = info;
			super(98,32,2);
			init();
			initEvents();
		}
		
		private function init():void
		{
			setSize(205,75);
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			_players = new DictionaryData();
			if(_info)
			{
				var j:int = 0;
				for(var i:String in _info)
				{
					var player:PlayerThumbnail = new PlayerThumbnail(_info[i]);
					_players.add(i,player);
					appendItem(player);
				}
			}
		}
		
		private function initEvents():void
		{
			_info.addEventListener(DictionaryEvent.REMOVE,__removePlayer);
			_info.addEventListener(DictionaryEvent.ADD,__addLiving);
		}
		
		private function removeEvents():void
		{
			_info.removeEventListener(DictionaryEvent.REMOVE,__removePlayer);
			_info.removeEventListener(DictionaryEvent.ADD,__addLiving);
		}
		
		private function __addLiving(e:DictionaryEvent):void
		{
//			if(e.data is GameTurnedLiving){
//			var NPC:NPCThumbnail = new NPCThumbnail((e.data as GameLiving).info);
//			_players.add(e.data.info.Id,NPC);
//			appendItem(NPC);
//			}
		}
		
		public function __removePlayer(evt:DictionaryEvent):void
		{
			var info : Player = evt.data as Player;
			if(info && info.playerInfo)
			{
				if(_players[info.playerInfo.ID])
				{
//					_players[info.playerInfo.ID].info = null;
					_players[info.playerInfo.ID].dispose();
					removeItem(_players[info.playerInfo.ID]);
					delete _players[info.playerInfo.ID];
				}
			}
//			_players[(evt.data as Player).playerInfo.ID].info = null;
		}

		public function dispose():void
		{
			removeEvents();
			if(parent) parent.removeChild(this);
			for(var i:String in _players)
			{
				if(_players[i])
				{
					_players[i].dispose();
				}
			}
			_players = null;
		}
		
	}
}