package ddt.view.im
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.im.LookupAsset;
	
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	
	import ddt.data.CMFriendInfo;
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.data.player.FriendListPlayer;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.PlayerManager;
	import ddt.menu.RightMenu;

	public class IMLookupView extends LookupAsset
	{
		private var currentList:Array;
		private var itemArray:Array;
		private var result:SimpleGrid;
		private var _listType:int;
		private var _currentItemInfo:CMFriendInfo;
		private var _currentItem:IMLookupItem;
		public function IMLookupView()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			lookupInput_txt.maxChars = 14;
			lookupInput_txt.textColor = 0x000000;
			lookupInput_txt.multiline = false;
			
			currentList = PlayerManager.Instance.friendList.list;
			currentList = currentList.concat(PlayerManager.Instance.onlineConsortiaMemberList);
			currentList = currentList.concat(PlayerManager.Instance.offlineConsortiaMemberList);
			currentList = currentList.concat(PlayerManager.Instance.blackList.list);
			
			result = new SimpleGrid(220,27,1);
			result.horizontalScrollPolicy = ScrollPolicy.OFF;
			result.verticalScrollPolicy = ScrollPolicy.OFF;
			result.setSize(220,250);
			result.marginHeight += 20;
			result.x = bg_mc.x;
			result.y = bg_mc.y + bg_mc.height;
			flexBg_mc.visible = false;
			flexBg_mc.x = bg_mc.x + 10;
			flexBg_mc.y = bg_mc.y + 28;
			addChild(result);
			listType = IMView.FRIEND_LIST;
			clew_txt.visible = false;
		}
		
		private function initEvent():void
		{
			lookupInput_txt.addEventListener(Event.CHANGE , __textInput);
			PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,__updateList);
		}
		
		private function __textInput(evt:Event):void
		{
			strTest();
		}
		
		private function __updateList(evt:DictionaryEvent):void
		{
			strTest();
		}
		
		private function strTest():void
		{
			itemArray = [];
			disposeItems();
			clew_txt.visible = false;
			flexBg_mc.visible = false;
			updateList();
			if(_listType == IMView.FRIEND_LIST)
			{
				var isHae:Boolean = false;
				for(var i:int = 0 ; i < currentList.length ;i++)
				{
					if(itemArray.length >= 8)
					{
						setFlexBg();
						return;
					}
					var name:String = "";
					var temp:String = "";
					if(currentList[i] is PlayerInfo)
					{
						name = (currentList[i] as PlayerInfo).NickName;
						temp = lookupInput_txt.text;
					}else if(currentList[i] is ConsortiaPlayerInfo)
					{
						name = (currentList[i] as ConsortiaPlayerInfo).NickName;
						temp = lookupInput_txt.text;
					}
					if(temp == "")
					{
						setFlexBg();
						return;
					}
					if(!name)
					{
						setFlexBg();
						return;
					}
					if(name.indexOf(lookupInput_txt.text) != -1)
					{
						isHae = true;
						if(currentList[i] is PlayerInfo)
						{
							var item:IMLookupItem = new IMLookupItem((currentList[i]) as PlayerInfo);
							item.doubleClickEnabled = true;
							item.addEventListener(MouseEvent.MOUSE_DOWN , __doubleClick);
							result.appendItem(item);
							itemArray.push(item);
						}else if(currentList[i] is ConsortiaPlayerInfo)
						{
							if(testAlikeName((currentList[i] as ConsortiaPlayerInfo).info.NickName))
							{
								var itemI:IMLookupItem = new IMLookupItem((currentList[i]) as ConsortiaPlayerInfo);
								itemI.doubleClickEnabled = true;
								itemI.addEventListener(MouseEvent.MOUSE_DOWN , __doubleClick);
								result.appendItem(itemI);
								itemArray.push(itemI);
							}
						}
					}
				}
			}else if(_listType == IMView.CMFRIEND_LIST)
			{
				for(var j:int = 0 ; j < currentList.length ;j++)
				{
					if(itemArray.length >= 8)
					{
						setFlexBg();
						return;
					}
					var nameII:String = (currentList[j] as CMFriendInfo).NickName;
					if(nameII == "")
					{
						nameII = (currentList[j] as CMFriendInfo).OtherName;
					}
					var tempII:String = lookupInput_txt.text;
					if(tempII == "")
					{
						setFlexBg();
						return;
					}
					if(nameII.indexOf(lookupInput_txt.text) != -1)
					{
						isHae = true;
						var itemII:IMLookupItem = new IMLookupItem((currentList[j]) as CMFriendInfo);
						itemII.doubleClickEnabled = true;
						itemII.addEventListener(MouseEvent.MOUSE_DOWN , __doubleClick);
						result.appendItem(itemII);
						itemArray.push(itemII);
					}
				}
			}
			if(lookupInput_txt.text == "")isHae = true;
			setFlexBg();
			if(!isHae)
			{
				clew();
			}
		}
		
		public function search():void
		{
			strTest();
		}
		
		public function hide():void
		{
			disposeItems();
			flexBg_mc.visible = false;
			clew_txt.visible  = false;
		}
		
		private function clew():void
		{
			clew_txt.visible = true;
			flexBg_mc.visible = true;
			flexBg_mc.height = 34;
		}
		
		private function testAlikeName(name:String):Boolean
		{
			var temList:Array = [];
			temList = PlayerManager.Instance.friendList.list;
			temList = temList.concat( PlayerManager.Instance.blackList.list);
			for(var i:int = 0 ; i<temList.length ; i++)
			{
				if((temList[i] as FriendListPlayer).NickName == name)
					return false;
			}
			return true;
		}
		
		private function setFlexBg():void
		{
			if(lookupInput_txt.text.length == 0)
			{
				flexBg_mc.visible = false;
			}else
			{
				flexBg_mc.visible = true;
				if(itemArray)
				{
					var height:int = 0;
					for(var i:int = 0 ; i<itemArray.length ; i++)
					{
						height += (itemArray[i] as IMLookupItem).height-2;
						
					}
					flexBg_mc.height = height;
				}
				flexBg_mc.x = bg_mc.x + 10;
				flexBg_mc.y = bg_mc.y + 28;
				result.x    = flexBg_mc.x;
				result.y    = flexBg_mc.y - 20;
			}
		}

		
		public function set listType(value:int):void
		{
			_listType = value;
			updateList();
		}
		
		private function updateList():void
		{
			if(_listType == 0)
			{
				currentList = [];
				currentList = PlayerManager.Instance.friendList.list;
				currentList = currentList.concat(PlayerManager.Instance.onlineConsortiaMemberList);
				currentList = currentList.concat(PlayerManager.Instance.offlineConsortiaMemberList);
				currentList = currentList.concat(PlayerManager.Instance.blackList.list);
			}else if(_listType == 1)
			{
				currentList = [];
				if(!PlayerManager.Instance.CMFriendList)return;
				currentList = PlayerManager.Instance.CMFriendList.list;
			}
		}
		
		private function disposeItems():void
		{
			if(result && itemArray)
			{
				for(var i:int = 0; i<itemArray.length ; i++)
				{
					(itemArray[i] as IMLookupItem).removeEventListener(MouseEvent.MOUSE_DOWN , __doubleClick);
				}
				result.clearItems();
			}
		}
		private var _isDoubleClick:Boolean;
		private var _timer:Timer;
		private var info:PlayerInfo;
		private function __doubleClick(evt:Event):void
		{
			if(evt.target.name == "delIcon")return;
			if(_listType == IMView.FRIEND_LIST)
			{
				_isDoubleClick =true;
				if(_timer && _timer.running)
				{
					_isDoubleClick = false;
				}
				if(!_timer)
				{
					_timer=new Timer(350,1)
					_timer.start();
					_timer.addEventListener(TimerEvent.TIMER, clickOrDouble);
				}
				if((evt.currentTarget as IMLookupItem).info is PlayerInfo)
				{
					info = (evt.currentTarget as IMLookupItem).info as PlayerInfo;
				}else
				{
					info = (evt.currentTarget as IMLookupItem).info.info as PlayerInfo;
				}
				_currentItem     = evt.currentTarget as IMLookupItem;
			}else if(_listType == IMView.CMFRIEND_LIST)
			{
				_currentItemInfo = evt.currentTarget.info;
				_currentItem     = evt.currentTarget as IMLookupItem;
				dispatchEvent(new Event(Event.CHANGE));
			}
			SoundManager.instance.play("008");
			if(result.selectedItem) 
			{
				(result.selectedItem as IMLookupItem).selected = false;
				result.selectedItem = null;
			}
			(_currentItem as IMLookupItem).selected = true;
			result.selectedItem = _currentItem as DisplayObject;
		}
		
		public function get currentItemInfo():CMFriendInfo
		{
			return _currentItemInfo;
		}
		
		private  function clickOrDouble(event:TimerEvent):void 
		{
			if(_isDoubleClick)
			{
				RightMenu.show(info);
			}else if(info)
			{
				ChatManager.Instance.privateChatTo(info.NickName,info.ID);
			}
			_timer.removeEventListener(TimerEvent.TIMER, clickOrDouble);
			_timer = null;
		}
		
		public function dispose():void
		{
			disposeItems();
			lookupInput_txt.removeEventListener(Event.CHANGE , __textInput);
			PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE,__updateList);
			currentList = null;
			itemArray = null;
			if(result && result.parent)
				result.parent.removeChild(result);
			result = null;
		}
	}
}