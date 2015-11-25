package ddt.gameover.settlement
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import game.crazyTank.view.gameOverSettle.duplicateSettleAsset;
	
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.GameInfo;
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.gameover.settlement.item.DuplicateSettleItem;
	import ddt.manager.RoomManager;
	import ddt.manager.UserGuideManager;
	
	public class OverDuplicateSettleView extends duplicateSettleAsset
	{
		private var _fbList:Array;
		private var _list:SimpleGrid;
		private var _game:GameInfo;
		public function OverDuplicateSettleView($game:GameInfo)
		{
			super();
			_fbList = $game.missionInfo.missionOverPlayer;
			_game = $game;
			init();
			initEvent();
			clearMC();
		}
		
		private function init():void
		{
			this.stop();
			
			_list = new SimpleGrid(154,199,4);
			ComponentHelper.replaceChild(this,settlelist_pos,_list);
			
			if(_game && _game.dungeonInfo)
				tollgatename_txt.htmlText = _game.dungeonInfo.Name + "  <FONT COLOR='#BC0001'>[" + RoomManager.Instance.current.getDifficulty(RoomManager.Instance.current.hardLevel) + "]</FONT>";
//				tollgatename_txt.text = _game.dungeonInfo.Name + "  [" + RoomManager.Instance.current.getDifficulty(RoomManager.Instance.current.hardLevel) + "]";
			
//			tollgatename_txt.text = _game.missionInfo.name + "(" + _game.missionInfo.missionIndex + "/" + _game.missionInfo.totalMissiton + ")";
			
			showSettleInfo();
			
			clearMC();
		}
		
		private function initEvent():void
		{
			addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			UserGuideManager.Instance.beginUserGuide2();
		}
		
		private function __addToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			setTimeout(timeOut,4000);
		}
		
		private function timeOut():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 显示四个位置中的玩家结算信息
		 * 
		 */		
		private function showSettleInfo():void
		{
			if(_fbList == null)
			{
				_fbList = new Array();
			}
			
			for(var i:uint = 0; i < 4; i++)
			{
				var m_fb:BaseSettleInfo;
				var duplicateSettleitem:DuplicateSettleItem;
				
				if(_fbList.length > i)
				{
					m_fb = _fbList[i] as BaseSettleInfo;
					duplicateSettleitem = new DuplicateSettleItem(m_fb,_game.findPlayerByPlayerID(m_fb.playerid));
				}
				else
				{
					duplicateSettleitem = new DuplicateSettleItem(null,null);
				}
				
				_list.appendItem(duplicateSettleitem);
			}
			
			_list.verticalScrollPolicy = "off";
			_list.horizontalScrollPolicy = "off";
			
			_list.drawNow();
			
			_list.setSize(_list.getContentWidth(), _list.getContentHeight());
		}
		
		/**
		 * 清除用于定位的MovieClip
		 * 
		 */		
		private function clearMC():void
		{
		}
		
		/**
		 * 析构函数
		 * 
		 */		
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			if(_list)
			{
				for(var i:uint = 0; i < _list.itemCount; i++)
				{
					var tmp:DuplicateSettleItem = _list.items[i] as DuplicateSettleItem;
					tmp.dispose();
					tmp = null;
				}
				
				if(_list && _list.parent)_list.parent.removeChild(_list);
				
				if(_list)
				{
					_list.clearItems();
				}
				_list = null;
			}
			_game = null;
			_fbList = null;
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}

	}
}