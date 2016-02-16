package ddt.view.im
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import game.crazyTank.view.im.IMFriendListTitleAsset;
	
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.FriendListPlayer;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.menu.RightMenu;
	import ddt.view.IDisposeable;
	
	public class IMFriendList extends Sprite implements IDisposeable
	{	
		private var _controller:IMController;
		private var _onlineTitle:IMFriendListTitleAsset;
		private var _offlineTitle:IMFriendListTitleAsset;
		private var _onlineList:SimpleGrid;
		private var _offlineList:SimpleGrid;
		private var _addFriendBtn:HLabelButton;
		private var _communityBtn:HLabelButton;
		private var _cancelBtn:HLabelButton;
		private var _uipanel:UIComponent;
		
		private var _fr:AddFriendFrame;
		private var _myColorMatrix_filter:ColorMatrixFilter;
		private var _isExpand:Boolean;
		private var _friendArray:Array;
		private var _sum:int;
		private var _onlineNum:int;
		public static const ON_CLICK:String = "onClick"
		public function IMFriendList(controller:IMController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
			
		}
		
		private function init():void
		{
			_myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			_uipanel = new UIComponent();
			_isExpand = true;
			_onlineTitle = new IMFriendListTitleAsset();
			_onlineTitle.title_txt.text = "好友";
			_onlineTitle.gotoAndStop(2);
			_onlineTitle.bg_mc.gotoAndStop(3);
			_onlineTitle.buttonMode = true;
			_onlineList = new SimpleGrid(330,27,1);
			_onlineList.marginHeight += 20;
			_onlineList.verticalScrollPolicy = _onlineList.horizontalScrollPolicy = ScrollPolicy.OFF;
			_offlineTitle = new IMFriendListTitleAsset();
			_offlineTitle.title_txt.text = LanguageMgr.GetTranslation("ddt.view.im.IMFriendList.offline");
		
			_uipanel.addChild(_onlineTitle);
			_uipanel.addChild(_onlineList);
			_uipanel.x = 5;
			addChild(_uipanel);
			updateOnlineNum();
			drawBackground();
		}
		
		private function initEvent():void
		{
			PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,__updateList);
			PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,__updateList);
//			PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.UPDATE,__updateList);
			_onlineTitle.addEventListener(MouseEvent.CLICK , __titleClick);
			_onlineTitle.addEventListener(MouseEvent.MOUSE_OVER , __titleOver);
			_onlineTitle.addEventListener(MouseEvent.MOUSE_OUT , __titleOut);
		}
		
		private function __titleOver(evt:Event):void
		{
			if(_isExpand)
			{
				_onlineTitle.bg_mc.gotoAndStop(3);
			}else
			{
				_onlineTitle.bg_mc.gotoAndStop(2);
			}
		}
		
		private function __titleOut(evt:Event):void
		{
			if(_isExpand)
			{
				_onlineTitle.bg_mc.gotoAndStop(3);
			}else
			{
				_onlineTitle.bg_mc.gotoAndStop(1);
			}
		}
		
		public function get contentHeight():int
		{
			if(!_isExpand)
			{
				return _onlineTitle.height;
			}else
			{
				var contentHeight:int = _onlineTitle.height;
				if(!_friendArray)return contentHeight;
				contentHeight +=  _friendArray.length * 29;
				return contentHeight;
			}
		}
		
		private function __updateList(evt:DictionaryEvent):void
		{
			var player:FriendListPlayer = evt.data as FriendListPlayer;
			if(player == null) return;
			if(!_isExpand)return;
			switch(evt.type)
			{
				case DictionaryEvent.ADD:
				addOneToList(player);
				break;
				case DictionaryEvent.REMOVE:
				removeOneFromList(player);
				break;
				case DictionaryEvent.UPDATE:
				removeOneFromList(player);
				addOneToList(player);
				break;
			}
			if(_isExpand)
			{
				if(_onlineList)_onlineList.clearItems();
				drawBackground();
				_onlineTitle.gotoAndStop(2);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function addOneToList(value:FriendListPlayer):void
		{
			var item:IMFriendItem = new IMFriendItem(value);
			_onlineList.appendItem(item);
			updateOnLinePos();
			item.buttonMode = true;
			item.addEventListener(MouseEvent.CLICK,__itemClick);
		}
		
		
		private function removeOneFromList(value:FriendListPlayer):void
		{
			var item:Object = findItem(value.ID);
			
			if(item)
			{
				item.removeEventListener(MouseEvent.CLICK,__itemClick);
				item.dispose();
			}
			_onlineList.removeItem(item as DisplayObject);
			updateOnLinePos();
		}
		
		
		private function updateOnLinePos():void
		{
			_onlineList.y = _onlineTitle.height-18;
			_onlineList.drawNow();
			_onlineList.setSize(_onlineList.getContentWidth() + 10,_onlineList.getContentHeight());
			
		}
		
		private function findItem(id:int):*
		{
			var _tempList:Array = [];
			_tempList = _onlineList.items;
			
			for(var i:int = 0;i<_tempList.length;i++)
			{
				if(_tempList[i].info["ID"] == id)
				return _tempList[i];
			}
			
			_tempList = _offlineList.items;
			
			for(var j:int = 0;j<_tempList.length;j++)
			{
				if(_tempList[j].info["ID"] == id)
				return _tempList[j];
			}
			
		}
		
		private function __titleClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(!_isExpand)
			{
				if(!_onlineList)
				{
					_onlineList = new SimpleGrid(330,27,1);
					_onlineList.marginHeight += 20;
				}
				drawBackground();
				_isExpand = true;
				_onlineTitle.gotoAndStop(2);
			}else
			{
				clearOnlineList()
				_isExpand = false;
				_onlineTitle.gotoAndStop(1);
			}
			_onlineTitle.bg_mc.gotoAndStop(3);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set isExpand(value:Boolean):void
		{
			_isExpand = value;
			update();
		}
		
		public  function get isExpand():Boolean
		{
			return _isExpand;
		}
		
		private function update():void
		{
			if(_isExpand)
			{
				if(!_onlineList)
				{
					_onlineList = new SimpleGrid(330,27,1);
					_onlineList.marginHeight += 20;
				}
				drawBackground();
				_onlineTitle.gotoAndStop(2);
			}else
			{
				clearOnlineList()
				_onlineTitle.gotoAndStop(1);
				_onlineTitle.bg_mc.gotoAndStop(1);
			}
		}
		
		private function __addFriendClick(evt:MouseEvent):void
		{
			if(!_fr){
				_fr= new AddFriendFrame(_controller);	
			}
			SoundManager.Instance.play("008");
			if(_fr.parent)
			{
				_fr.hide();
			}
			else
			{
				_fr.show();
			}
		}
		
		override public function get height():Number
		{
			return contentHeight;
		}
		
		private function __cancel(evt:MouseEvent):void
		{
			_controller.hide();
			SoundManager.Instance.play("008");
		}		
		
		private function menuClickHandler(e:Event):void
		{
			if(_onlineList.selectedItem as IMFriendItem)
			{
				RightMenu.show((_onlineList.selectedItem as IMFriendItem).info as PlayerInfo);
			}
			if(_offlineList.selectedItem as IMFriendItem)
			{
				RightMenu.show((_offlineList.selectedItem as IMFriendItem).info as PlayerInfo);
			}
		}
		
		private function drawBackground():void
		{
			var info:PlayerInfo;
			var item:IMFriendItem;
			var onlinelist:Array = PlayerManager.Instance.onlineFriendList;
			onlinelist = taxis(onlinelist);
			_onlineList.clearItems();
			_friendArray = [];
			var i:int = 0;
			for each( info  in onlinelist)
			{
				if(i <= 200)i++;
				if(i == 200)break;
				item = new IMFriendItem(info);
				item.buttonMode = true;
				_onlineList.appendItem(item);
				_friendArray.push(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick);
			}
			
			var offlinelist:Array = PlayerManager.Instance.offlineFriendList;
			offlinelist = taxis(offlinelist);
			_offlineTitle.y = _onlineList.height + _onlineList.y;
			for each(info in offlinelist)
			{
				if(i <= 200)i++;
				if(i == 200)break;
				item = new IMFriendItem(info);
				item.filters = [_myColorMatrix_filter];
				item.buttonMode = true;
				_onlineList.appendItem(item);
				_friendArray.push(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick);
			}
			
			_onlineList.y = _onlineTitle.height-18;
			_onlineList.drawNow();
			_onlineList.setSize(_onlineList.getContentWidth() + 10,_onlineList.getContentHeight());
			_uipanel.height = _onlineList.y + _onlineList.height;
			_onlineList.verticalScrollPolicy = _onlineList.horizontalScrollPolicy = ScrollPolicy.OFF;
			if(_onlineList.itemCount == 0)
			{
				_onlineTitle.gotoAndStop(1);
				_onlineTitle.bg_mc.gotoAndStop(1);
			}
			_uipanel.addChild(_onlineTitle);
			_uipanel.addChild(_onlineList);
			_uipanel.setSize(240 , _onlineList.getContentHeight());
			updateOnlineNum();
		}
		
		private function updateOnlineNum():void
		{
			_sum = PlayerManager.Instance.friendList.length;
			_onlineNum =  PlayerManager.Instance.onlineFriendList.length;
			if(_onlineTitle)
			{
				_onlineTitle.num_txt.text = "[" + String(_onlineNum) + "/" + String(_sum)+"]";
				_onlineTitle.num_txt.x = 55;
			}
		}
		
		public static function taxis(origin:Array):Array
		{
			return origin.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_onlineList.selectedItem) 
			{
				(_onlineList.selectedItem as IMFriendItem).selected = false;
				_onlineList.selectedItem = null;
			}
			(evt.currentTarget as IMFriendItem).selected = true;
			_onlineList.selectedItem = evt.currentTarget as DisplayObject;
			if(_onlineList.selectedItem as IMFriendItem)
			{
				RightMenu.show((_onlineList.selectedItem as IMFriendItem).info as PlayerInfo);
			}
		}
		
		public function doPrivateChat(info:PlayerInfo):void
		{
			ChatManager.Instance.privateChatTo(info.NickName,info.ID);
		}
		
		private function clearOnlineList():void
		{
			if(_onlineList)
			{
				for(var i:int = 0;i<_onlineList.itemCount;i++)
				{
					_onlineList.items[i].removeEventListener(MouseEvent.CLICK,__itemClick);
					_onlineList.items[i].dispose();
				}
				_onlineList.clearItems();
			}
			if(_onlineList && _onlineList.parent)
				_onlineList.parent.removeChild(_onlineList);
			
			_onlineList = null;
		}
		
		public function dispose():void
		{
			if(_onlineTitle && _onlineTitle.parent)
				_onlineTitle.parent.removeChild(_onlineTitle);
			_onlineTitle = null;
			
			if(_offlineTitle && _offlineTitle.parent)
				_offlineTitle.parent.removeChild(_offlineTitle);
			_offlineTitle = null;
			
			clearOnlineList();
			if(_onlineList && _onlineList.parent)
				_onlineList.parent.removeChild(_onlineList);
			_onlineList = null;
			
			PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.ADD,__updateList);
			PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE,__updateList);
//			PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.UPDATE,__updateList);	
			
			if(_fr)_fr.dispose();
			_fr = null;
			
			_controller = null;
			
			if(parent)parent.removeChild(this);
		}
	}
}