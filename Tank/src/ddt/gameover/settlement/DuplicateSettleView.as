package ddt.gameover.settlement
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.gameOverSettle.duplicateSettleAsset;
	
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HFrame;
	import road.utils.ComponentHelper;
	
	import ddt.data.GameInfo;
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.gameover.settlement.item.DuplicateSettleItem;
	import ddt.manager.LanguageMgr;
	import ddt.manager.RoomManager;

	public class DuplicateSettleView extends HFrame//duplicateSettleAsset
	{
		private var _fbList:Array;
		private var _list:SimpleGrid;
		private var _game:GameInfo;
		private var _asset:duplicateSettleAsset;
		private var _closeBtn:HLabelButton;
		
		public function DuplicateSettleView($game:GameInfo)
		{
			super();
			_asset = new duplicateSettleAsset();
			
			blackGound = false;
			alphaGound = false;
			autoDispose = true;
			titleText = "";
			centerTitle = true;
			
			setContentSize(710,323);
			addContent(_asset,true);
			
			_closeBtn = new HLabelButton();
			_closeBtn.label = LanguageMgr.GetTranslation("close");
			_closeBtn.x = _asset.closeBtnPos.x;
			_closeBtn.y = _asset.closeBtnPos.y;
			_asset.closeBtnPos.parent.removeChild(_asset.closeBtnPos);
			_asset.addChild(_closeBtn);
			
			_fbList = $game.missionInfo.missionOverPlayer;
			_game = $game;
			init();
			initEvent();
			clearMC();
		}
		
		private function init():void
		{
			_asset.stop();
			
			_list = new SimpleGrid(154,199,4);
			ComponentHelper.replaceChild(_asset,_asset.settlelist_pos,_list);
			
			if(_game && _game.dungeonInfo)
				_asset.tollgatename_txt.htmlText= _game.dungeonInfo.Name + "  <FONT COLOR='#BC0001'>[" + RoomManager.Instance.current.getDifficulty(RoomManager.Instance.current.hardLevel) + "]</FONT>";
//				_asset.tollgatename_txt.text = _game.dungeonInfo.Name + "  [" + RoomManager.Instance.current.getDifficulty(RoomManager.Instance.current.hardLevel) + "]";
//			_asset.tollgatename_txt.text = _game.missionInfo.name + "(" + _game.missionInfo.missionIndex + "/" + _game.missionInfo.totalMissiton + ")";
			
			showSettleInfo();
			
			clearMC();
		}
		
		private function initEvent():void
		{
			addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDownHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK, __closePanel);
		}
		
		private function __onKeyDownHandler(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			if(e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.SPACE)
			{
//				SoundManager.instance.play("008");
				__closePanel(null);
			}
		}
		
		override public function show():void
		{
			super.show();
		}
		
		override public function close():void
		{
			super.close();
		}
		
		private function __closePanel(evt:MouseEvent):void
		{
			__closeClick(evt);
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
			
			_list.verticalScrollPolicy = ScrollPolicy.OFF;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			
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
		override public function dispose():void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDownHandler);
			if(_list)
			{
				for(var i:uint = 0; i < _list.itemCount; i++)
				{
					var tmp:DuplicateSettleItem = _list.items[i] as DuplicateSettleItem;
					tmp.dispose();
					tmp = null;
				}
				
				if(_list.parent)
					_list.parent.removeChild(_list);
				
				_list.clearItems();
			}
			_list = null;
			
			if(_closeBtn)
			{
				_closeBtn.removeEventListener(MouseEvent.CLICK, __closePanel);
				_closeBtn.dispose()
			}
			_closeBtn = null;
			
			if(_asset && _asset.parent)
				_asset.parent.removeChild(_asset);
			_asset = null;
			
			_game = null;
			_fbList = null;
			
			super.dispose();
		}
	}
}