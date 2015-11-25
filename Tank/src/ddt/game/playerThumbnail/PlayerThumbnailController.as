package ddt.game.playerThumbnail
{
	import flash.display.Sprite;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	
	import ddt.data.GameInfo;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.game.objects.GameLiving;

	public class PlayerThumbnailController extends Sprite
	{
		private var _info:GameInfo;
		private var _team1:DictionaryData;
		private var _team2:DictionaryData;
		private var _list1:PlayerThumbnailList;
		private var _list2:PlayerThumbnailList;
		private var _bossThumbnailContainer : BossThumbnail;
		
		public function PlayerThumbnailController(info:GameInfo)
		{
			_info = info;
			_team1 = new DictionaryData();
			_team2 = new DictionaryData();
			super();
			init();
			initEvents();
		}
		
		private function init():void
		{
			initInfo();
			_list1 = new PlayerThumbnailList(_team1);
			_list2 = new PlayerThumbnailList(_team2);
			addChild(_list1);
			_list2.x = _list1.x+360;
			addChild(_list2);
			
			
		}
		
		private function initInfo():void
		{
			var players:DictionaryData = _info.livings;
			for each(var player:Living in players)
			{
				if(player is Player)
				{
					if(player.team==1)
					{
						_team1.add((player as Player).playerInfo.ID,player);
					}else
					{
						// 探险模式下不显示人形NPC血量缩略图
						if(_info.gameType != 5 && _info.roomType != 10)// 5为探险模式
						{
							_team2.add((player as Player).playerInfo.ID,player);
						}
					}
				}
			}
		}
		public function set currentBoss(living:Living):void{
			if(_bossThumbnailContainer)_bossThumbnailContainer.dispose();
			_bossThumbnailContainer = null;
			_bossThumbnailContainer = new BossThumbnail(living);
			_bossThumbnailContainer.x = _list1.x + 350;
			addChild(_bossThumbnailContainer);
		}
		
		public function addLiving(living:GameLiving):void
		{
//			_team2.add(living.info.Id,living);
			if(living.info.typeLiving == 4 || living.info.typeLiving == 5 || living.info.typeLiving == 6)
			{
				if(_info.gameType == 5 || _info.roomType == 10)// 探险模式为5
				{
//					var npcThumbnail:NPCThumbnail = new NPCThumbnail(living.info);
//					
//					_list2.appendItem(npcThumbnail);
				}
				else
				{
					currentBoss = living.info;
				}
			}
			else if(living.info.typeLiving == 1 || living.info.typeLiving == 2)
			{
				_team2.add(living.info.LivingID,living);
			}
		}
		
		private function initEvents():void
		{
			_info.livings.addEventListener(DictionaryEvent.REMOVE,__removePlayer);
		}
		
		private function removeEvents():void
		{
			_info.livings.removeEventListener(DictionaryEvent.REMOVE,__removePlayer);
		}
		
		private function __removePlayer(evt:DictionaryEvent):void
		{
			var player:Player = evt.data as Player;
			if(player == null) return;
			if(player.character)	
				player.character.resetShowBitmapBig();
			//大怪
			if(_bossThumbnailContainer && _bossThumbnailContainer.Id == player.LivingID)
			{
				_bossThumbnailContainer.dispose();
			}
			else if(player.team == 1)
			{
				_team1.remove((evt.data as Player).playerInfo.ID);
			}else
			{
				_team2.remove((evt.data as Player).playerInfo.ID);
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			
			if(parent) parent.removeChild(this);
			_info = null;
			_team1 = null;
			_team2 = null;
			_list1.dispose();
			_list2.dispose();
			_list1 = null;
			_list2 = null;
		}
		
	}
}