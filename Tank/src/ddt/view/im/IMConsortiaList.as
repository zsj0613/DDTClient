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
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.menu.RightMenu;
	import ddt.view.IDisposeable;

	public class IMConsortiaList extends Sprite implements IDisposeable
	{
		private var _controller:IMController;
		private var _onlineTitle:IMFriendListTitleAsset;
		private var _offlineTitle:IMFriendListTitleAsset;
		private var _onlineList:SimpleGrid;
//		private var _panel:ScrollPane;
		private var _uipanel:UIComponent;
		private var _ConsortiaListArray:Array;
		private var _isExpand:Boolean;
		private var _ConsortiaArray:Array;
		private var _sum:int;
		private var _onlineNum:int;
		private var _myColorMatrix_filter:ColorMatrixFilter;
		public function IMConsortiaList(controller:IMController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_uipanel = new UIComponent();
			_myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			_onlineTitle = new IMFriendListTitleAsset();
			
			_onlineTitle.title_txt.text = "公会";
			_onlineTitle.gotoAndStop(1);
			_onlineTitle.bg_mc.gotoAndStop(1);
			_onlineTitle.buttonMode = true;
			_onlineList = new SimpleGrid(330,27,1);
			_onlineList.marginHeight += 20;
			_onlineList.verticalScrollPolicy = _onlineList.horizontalScrollPolicy = ScrollPolicy.OFF;
			_uipanel.addChild(_onlineTitle);
			_uipanel.addChild(_onlineList);
			_uipanel.x = 5;
			addChild(_uipanel);
			updateOnlineNum();
		}
		private function initEvent():void
		{
			PlayerManager.Instance.consortiaMemberList.addEventListener(DictionaryEvent.ADD,__updateList);
			PlayerManager.Instance.consortiaMemberList.addEventListener(DictionaryEvent.CLEAR,__updateList);
			PlayerManager.Instance.consortiaMemberList.addEventListener(DictionaryEvent.REMOVE,__updateList);
//			PlayerManager.Instance.consortiaMemberList.addEventListener(DictionaryEvent.UPDATE,__updateList);
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPropChange);
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
		
		
		private function __onPropChange(e:PlayerPropertyEvent):void
		{
			if(e.changedProperties["ConsortiaRepute"])
			{
//				Repute_txt.text = LanguageMgr.GetTranslation("ddt.view.im.IMConsortiaList.paiming")+PlayerManager.Instance.Self.ConsortiaRepute;
			}
		}
		
		override public function get height():Number
		{
			return contentHeight;
		}
		
		public function get contentHeight():int
		{
			if(!_isExpand)
			{
				return _onlineTitle.height;
			}else
			{
				var contentHeight:int = _onlineTitle.height;
				if(!_ConsortiaListArray)
				{
					return contentHeight;
				}
				contentHeight +=  _ConsortiaListArray.length * 29;
				return contentHeight;
			}
		}
		
		private function __updateList(evt:DictionaryEvent):void
		{
			var player:ConsortiaPlayerInfo = evt.data as ConsortiaPlayerInfo;
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
				case DictionaryEvent.CLEAR:
				drawBackground();
			}
			if(_isExpand)
			{
				if(_onlineList)_onlineList.clearItems();
				drawBackground();
				_onlineTitle.gotoAndStop(2);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function __titleClick(evt:Event):void
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
				clearOnlineList();
				_onlineTitle.gotoAndStop(1);
				_onlineTitle.bg_mc.gotoAndStop(1);
			}
		}
		
		private function addOneToList(value:ConsortiaPlayerInfo):void
		{
			var item:IMFriendItem = new IMConsortiaItem(value);
			
			if(value.State == 1)
			{
				_onlineList.appendItem(item);
				updateOnLinePos();
			}else
			{
				_onlineList.appendItem(item);
				updateOnLinePos();
			}
			item.buttonMode = true;
			item.addEventListener(MouseEvent.CLICK,__itemClick);
		}
		
		
		private function removeOneFromList(value:ConsortiaPlayerInfo):void
		{
			var item:IMFriendItem = findItem(value.ID) as IMFriendItem;
			if(item)item.removeEventListener(MouseEvent.CLICK,__itemClick);
			_onlineList.removeItem(item);
			updateOnLinePos();
			if(item)item.dispose();
			item = null;
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
				return _tempList[i]
			}
			
			for(var j:int = 0;j<_tempList.length;j++)
			{
				if(_tempList[j].info["ID"] == id)
				return _tempList[j]
			}
			
		}
		
		private function drawBackground():void
		{
			var info:ConsortiaPlayerInfo;
			var item:IMConsortiaItem;
			var onlinelist:Array = PlayerManager.Instance.onlineConsortiaMemberList;
//			onlinelist = onlinelist.sortOn("DutyLevel");
			onlinelist = IMFriendList.taxis(onlinelist);
			clearOnlineList();
			_ConsortiaListArray = [];
			for each( info  in onlinelist)
			{
				item = new IMConsortiaItem(info);
				item.buttonMode = true;
				_onlineList.appendItem(item);
				_ConsortiaListArray.push(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick);
			}
			_onlineList.y = _onlineTitle.height-18;
			_onlineList.drawNow();
			_onlineList.setSize(_onlineList.getContentWidth() + 10,_onlineList.getContentHeight());
			
			
			var offlinelist:Array = PlayerManager.Instance.offlineConsortiaMemberList;
			offlinelist = IMFriendList.taxis(offlinelist);
			for each(info in offlinelist)
			{
				item = new IMConsortiaItem(info);
				if(info.info.ID != PlayerManager.Instance.Self.ID)
				{
					item.filters = [_myColorMatrix_filter];
				}
				item.buttonMode = true;
				_onlineList.appendItem(item);
				_ConsortiaListArray.push(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick);
			}
			_onlineList.y = _onlineTitle.height-18;
			_onlineList.drawNow();
			_onlineList.setSize(_onlineList.getContentWidth() + 10,_onlineList.getContentHeight());
			_onlineList.verticalScrollPolicy = _onlineList.horizontalScrollPolicy = ScrollPolicy.OFF;
			_uipanel.addChild(_onlineTitle);
			_uipanel.addChild(_onlineList);
			_uipanel.height = _onlineList.y + _onlineList.height;
			_uipanel.setSize(240 , _onlineList.getContentHeight()+10);
//			_panel.setSize(240 , _onlineList.getContentHeight()+10);
//			_panel.update();
			updateOnlineNum();
		}
		
		private function updateOnlineNum():void
		{
			_sum = PlayerManager.Instance.consortiaMemberList.length;
			_onlineNum =  PlayerManager.Instance.onlineConsortiaMemberList.length;
			if(_onlineTitle)
			{
				_onlineTitle.num_txt.text = "[" + String(_onlineNum) + "/" + String(_sum)+"]";
				_onlineTitle.num_txt.x = 55;
			}
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			if(_onlineList.selectedItem) 
			{
				(_onlineList.selectedItem as IMConsortiaItem).selected = false;
				_onlineList.selectedItem = null;
			}
			(evt.currentTarget as IMConsortiaItem).selected = true;
			_onlineList.selectedItem = evt.currentTarget as DisplayObject;
			if(evt.currentTarget as IMConsortiaItem)
			{
				RightMenu.show((evt.currentTarget as IMConsortiaItem).info.info as PlayerInfo);
			}
		}
		
		public function doPrivateChat(info:ConsortiaPlayerInfo):void
		{
			ChatManager.Instance.privateChatTo(info.NickName,info.UserId);
		}
		
		private function clearOnlineList():void
		{
			if(_onlineList)
			{
				for each(var i:IMConsortiaItem in _onlineList.items)
				{
					i.removeEventListener(MouseEvent.CLICK,__itemClick);
					i.dispose();
					i = null;
				}
				if(_onlineList && _onlineList.parent)
					_onlineList.parent.removeChild(_onlineList);
				_onlineList.clearItems();
			}
		}
		
		public function dispose():void
		{
			PlayerManager.Instance.consortiaMemberList.removeEventListener(DictionaryEvent.ADD,__updateList);
			PlayerManager.Instance.consortiaMemberList.removeEventListener(DictionaryEvent.CLEAR,__updateList);
			PlayerManager.Instance.consortiaMemberList.removeEventListener(DictionaryEvent.REMOVE,__updateList);
//			PlayerManager.Instance.consortiaMemberList.removeEventListener(DictionaryEvent.UPDATE,__updateList);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPropChange);
			
			if(_onlineTitle && _onlineTitle.parent)_onlineTitle.parent.removeChild(_onlineTitle);
			_onlineTitle = null;
			
			clearOnlineList();
			if(_onlineList && _onlineList.parent)_onlineList.parent.removeChild(_onlineList);
			_onlineList = null;
			
//			if(_panel)
//			{
//				_panel.source = null;
//				if(_uipanel && _uipanel.parent)_uipanel.parent.removeChild(_uipanel);
//				_uipanel = null;
//				if(_panel.parent)_panel.parent.removeChild(_panel);
//			}
//			_panel = null;
			
			_controller = null;
			
			if(parent)parent.removeChild(this);
		}
		
	}
}