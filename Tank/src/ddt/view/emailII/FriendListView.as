package ddt.view.emailII
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.PlayerManager;
	
	import webGame.crazyTank.view.shopII.ShopIIPlayerListBGAsset;

	public class FriendListView extends ShopIIPlayerListBGAsset
	{
		private var _playerlist:SimpleGrid;
		
		private var _func:Function;
		private var _showOffLineList:Boolean;
		
		public function FriendListView(fun:Function,showOffLineList:Boolean = true)
		{
			_func = fun;
			_showOffLineList = showOffLineList;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			graphics.beginFill(0x000000,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
			
			bg.gotoAndStop(1);
			btn_1.buttonMode = true;
			_playerlist = new SimpleGrid(190,22,1);
			ComponentHelper.replaceChild(this,list_pos,_playerlist);
			_playerlist.verticalScrollPolicy = ScrollPolicy.AUTO;
			_playerlist.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			if(_showOffLineList)
			{
				setList(PlayerManager.Instance.friendList);//发邮件 添加好友列表默认显示 bret 09.5.14
			}else
			{
//				PlayerManager.Instance.addEventListener(PlayerManager.CONSORTIAMEMBER_STATE_CHANGED,__updateConsortiaList);
//				PlayerManager.Instance.addEventListener(PlayerManager.FRIEND_STATE_CHANGED,__updateFriendList);
				setList(PlayerManager.Instance.onlineFriendList);
			}
			
			PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,__onFriendListComplete);
		}
		
		
		public function refreshAllList():void
		{
			__onFriendListComplete(null);
			btn_0.buttonMode = false;
			btn_1.buttonMode = true;
		}
		
		private function __onFriendListComplete(e:Event):void
		{
			if(_showOffLineList)
			{
				setList(PlayerManager.Instance.friendList);
			}else
			{
				setList(PlayerManager.Instance.onlineFriendList);
			}
		}
		
		private function initEvent():void
		{
			btn_0.addEventListener(MouseEvent.CLICK,__btnClick);
			btn_1.addEventListener(MouseEvent.CLICK,__btnClick);
		}
		
		private function __btnClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			evt.stopImmediatePropagation();
			var index:int = Number(evt.currentTarget.name.slice(4,5));  //index = 0;
			bg.gotoAndStop(index + 1);
			if(index == 0)
			{
				btn_1.buttonMode = true;
				btn_0.buttonMode = false;
				if(_showOffLineList)
				{
					setList(PlayerManager.Instance.friendList);
				}else{
					setList(PlayerManager.Instance.onlineFriendList);
				}
			}else
			{ 
				btn_0.buttonMode = true;
				btn_1.buttonMode = false;
				if(_showOffLineList)
				{
					setList(PlayerManager.Instance.consortiaMemberList);
				}else
				{
					setList(PlayerManager.Instance.onlineConsortiaMemberList);
				}
			}
		}
		
		
		public function dispose():void
		{
			PlayerManager.Instance.removeEventListener(PlayerManager.FRIENDLIST_COMPLETE,__onFriendListComplete);
			
			clearList();
			
			if(_playerlist && _playerlist.parent)
				_playerlist.parent.removeChild(_playerlist);
			_playerlist = null;
			
			btn_0.removeEventListener(MouseEvent.CLICK,__btnClick);
			btn_1.removeEventListener(MouseEvent.CLICK,__btnClick);
			
			_func = null;
			_playerlist = null;
			
			if(parent)
				parent.removeChild(this);
		}
		
		private function clearList():void
		{
			for(var i:int = 0;i<_playerlist.itemCount;i++)
			{
				_playerlist.items[i].dispose();
			}
			
			_playerlist.clearItems();
		}
		
		private function setList(list:Object):void
		{
			clearList()
			if(list is DictionaryData)
			{
				for(var i:String in list)
				{
					var item1:PlayerListItem
					if(list[i] is ConsortiaPlayerInfo)
					{
						item1 = new PlayerListItem(list[i].info,_func);
					}else
					{
						item1 = new PlayerListItem(list[i],_func);
					}
					_playerlist.appendItem(item1);
				}
			}else if(list is Array)
			{
				for(var j:uint = 0;j<list.length;j++)
				{
					var item2:PlayerListItem
					if(list[j] is ConsortiaPlayerInfo)
					{
						item2 = new PlayerListItem(list[j].info,_func);
					}else
					{
						item2 = new PlayerListItem(list[j],_func);
					}
					_playerlist.appendItem(item2);
				}
			}
		}
		
		private function __updateFriendList(e:Event):void
		{
			setList(PlayerManager.Instance.onlineFriendList);
		}
		
		private function __updateConsortiaList(e:Event):void
		{
			setList(PlayerManager.Instance.onlineConsortiaMemberList);
		}
		
		public function get BG(): MovieClip
		{
			return bg;
		}
	}
}