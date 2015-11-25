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
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.menu.RightMenu;
	import ddt.view.IDisposeable;
	
	public class IMBlackList extends Sprite implements IDisposeable
	{	
		private var _controller:IMController;
		private var _onlineList:SimpleGrid;
//		private var _panel:ScrollPane;
//		private var _addBlackBtn:HLabelButton;
		private var _uipanel:UIComponent;
		
		private var _fr:AddBlackListFrame;
		private var _blackTitle:IMFriendListTitleAsset;
		private var _isExpand:Boolean;
		private var _blackListArray:Array;
		private var _myColorMatrix_filter:ColorMatrixFilter;
		public function IMBlackList(controller:IMController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
			
		}
		
		private function init():void
		{
			_myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			_blackTitle = new IMFriendListTitleAsset();
			_blackTitle.buttonMode = true;
			_blackTitle.title_txt.text = "黑名单";
			_blackTitle.gotoAndStop(1);
			_blackTitle.bg_mc.gotoAndStop(1);
			_uipanel = new UIComponent();
			
			_onlineList = new SimpleGrid(330,27,1);
			_onlineList.verticalScrollPolicy = _onlineList.horizontalScrollPolicy = ScrollPolicy.OFF;
			_uipanel.addChild(_blackTitle);
			_uipanel.addChild(_onlineList);
			_uipanel.x = 5;
			addChild(_uipanel); 
			_blackTitle.num_txt.text = "[0/"+ String(PlayerManager.Instance.blackList.length) + "]"
			_blackTitle.num_txt.x = 65;
		}
		
		private function initEvent():void
		{
			if(PlayerManager.Instance.blackList)
			{
				PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.ADD,__updateList);
				PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.REMOVE,__updateList);
			}
			_blackTitle.addEventListener(MouseEvent.CLICK,__titlerClick)
			_blackTitle.addEventListener(MouseEvent.MOUSE_OVER , __titleOver);
			_blackTitle.addEventListener(MouseEvent.MOUSE_OUT , __titleOut);
		}
		
		
		private function __titleOver(evt:Event):void
		{
			if(_isExpand)
			{
				_blackTitle.bg_mc.gotoAndStop(3);
			}else
			{
				_blackTitle.bg_mc.gotoAndStop(2);
			}
		}
		
		private function __titleOut(evt:Event):void
		{
			if(_isExpand)
			{
				_blackTitle.bg_mc.gotoAndStop(3);
			}else
			{
				_blackTitle.bg_mc.gotoAndStop(1);
			}
		}
		
		private function __titlerClick(evt:Event):void
		{
			SoundManager.instance.play("008");
			if(!_isExpand)
			{
				if(!_onlineList)
				{
					_onlineList = new SimpleGrid(330,27,1);
				}
				drawBackground();
				_isExpand = true;
				_blackTitle.gotoAndStop(2);
			}else
			{
				clearOnlineList();
				_isExpand = false;
				_blackTitle.gotoAndStop(1);
			}
			_blackTitle.bg_mc.gotoAndStop(3);
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
			update();
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
				_blackTitle.gotoAndStop(2);
			}else
			{
				clearOnlineList();
				_blackTitle.gotoAndStop(1);
				_blackTitle.bg_mc.gotoAndStop(1);
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
				return _blackTitle.height;
			}else
			{
				var contentHeight:int = _blackTitle.height;
				if(!_blackListArray)return contentHeight;
				for(var i:int = 0 ; i< _blackListArray.length ; i++)
				{
					contentHeight +=  (_blackListArray[i] as IMBlackItem).height - 6;
				}
				return contentHeight;
			}
		}
		
		private function __updateList(evt:Event):void
		{
			_blackTitle.num_txt.text = "[0/"+ String(PlayerManager.Instance.blackList.length) + "]"
			_blackTitle.num_txt.x = 65;
			if(!_isExpand)return;
			drawBackground();
		}
		
		private function __addBlackClick(evt:MouseEvent):void
		{
			if(!_fr){
				_fr= new AddBlackListFrame(_controller);
			}
			SoundManager.instance.play("008");
			_fr.show();
		}
		
		
		private function menuClickHandler(e:Event):void
		{
			if(_onlineList.selectedItem as IMBlackItem)
			{
				RightMenu.show((_onlineList.selectedItem as IMBlackItem).info as PlayerInfo);
			}
		}
		
		private function drawBackground():void
		{
			var info:PlayerInfo;
			var item:IMBlackItem;
			if((!PlayerManager.Instance.blackList) || (!PlayerManager.Instance.blackList.list))return;
			_blackTitle.num_txt.text = "[0/"+ String(PlayerManager.Instance.blackList.length) + "]"
			_blackTitle.num_txt.x = 65;
			var onlinelist:Array = PlayerManager.Instance.blackList.list;
			onlinelist = IMFriendList.taxis(onlinelist);
			if(!_onlineList)return;
			_onlineList.clearItems();
			_blackListArray = [];
			for each( info  in onlinelist)
			{
				item = new IMBlackItem(info);
				item.filters = [_myColorMatrix_filter];
//				item.mouseEnabled = false;
				_onlineList.appendItem(item);
				_blackListArray.push(item);
			}
			_onlineList.drawNow();
			_onlineList.setSize(_onlineList.getContentWidth() + 10,_onlineList.getContentHeight());
			_onlineList.y = _blackTitle.height+_blackTitle.y;
			_uipanel.addChild(_blackTitle);
			_uipanel.addChild(_onlineList);
			_uipanel.height = _onlineList.y + _onlineList.height;
//			_panel.update();
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_onlineList.selectedItem) 
			{
				(_onlineList.selectedItem as IMBlackItem).selected = false;
			}
			(evt.currentTarget as IMBlackItem).selected = true;
			_onlineList.selectedItem = evt.currentTarget as DisplayObject;
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
			if(PlayerManager.Instance.blackList)
			{
				PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.ADD,__updateList);
				PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.REMOVE,__updateList);	
			}
			
			if(_onlineList)
			{
				for(var i:int = 0;i<_onlineList.itemCount;i++)
				{
					_onlineList.items[i].dispose();
				}
				_onlineList.clearItems();
				if(_onlineList.parent)_onlineList.parent.removeChild(_onlineList);
			}
			
			_onlineList = null;
			if(_fr)
				_fr.close();
			_fr = null;
			
			_controller = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}