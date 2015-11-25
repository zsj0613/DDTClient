package ddt.room
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.gameover.settlement.item.PlayerSettleItem;
	import ddt.manager.RoomManager;

	public class DuplicateSettleList extends Sprite
	{
		private var _playerSettleList:SimpleGrid;
		private var _players:DictionaryData;
		
		public function DuplicateSettleList()
		{
			init();
			initEvent();
		}
		
		private function init():void
		{
			_players = RoomManager.Instance.current.players;
			
			_playerSettleList = new SimpleGrid(155,138,4);
			
			_playerSettleList.verticalScrollPolicy = ScrollPolicy.OFF;
			_playerSettleList.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			for(var i:uint = 0; i < 4; i++)
			{
				var playersettle:PlayerSettleItem = new PlayerSettleItem(null);
				
				_playerSettleList.appendItem(playersettle);
			}
			
			_playerSettleList.drawNow();
			
			_playerSettleList.setSize(_playerSettleList.getContentWidth(),_playerSettleList.getContentHeight());
			
			addChild(_playerSettleList);
		}
		
		private function initEvent():void
		{
			_players.addEventListener(DictionaryEvent.REMOVE, __removePlayerHandler);
		}
		
		/**
		 * 玩家离开或被踢出房间时
		 * @param e
		 * 
		 */		
		private function __removePlayerHandler(e:DictionaryEvent):void
		{
			removePlayerItem(e.data as RoomPlayerInfo);
		}
		
		/**
		 * 移除玩家
		 * @param $info
		 * 
		 */		
		private function removePlayerItem($info : RoomPlayerInfo):void
		{
			_playerSettleList.items[$info.roomPos].info = null;
		}
		
		public function updateSettle(arr:Array):void
		{
			if(arr == null || arr.length == 0) return;
			
			for(var i:uint = 0; i < arr.length; i++)
			{
				var settle:BaseSettleInfo = arr[i] as BaseSettleInfo;
				var $roomplayerinfo:RoomPlayerInfo = RoomManager.Instance.current.players[settle.playerid] as RoomPlayerInfo;
				if($roomplayerinfo)
				{
					$roomplayerinfo.info.Grade = settle.level;
					_playerSettleList.items[$roomplayerinfo.roomPos].info = settle;
				}
			}
		}
		
		public function dispose():void
		{
			_players.removeEventListener(DictionaryEvent.REMOVE, __removePlayerHandler);
			
			for each(var j:PlayerSettleItem in _playerSettleList.items)
			{
				j.dispose();
				j = null;
			}
			
			_playerSettleList.clearItems();
			
			if(_playerSettleList && _playerSettleList.parent)
			{
				_playerSettleList.parent.removeChild(_playerSettleList);
			}
			_playerSettleList = null;
			
			
			_players = null;
		}
	}
}