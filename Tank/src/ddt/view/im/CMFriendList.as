package ddt.view.im
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.im.CMFriendListBgAsset;
	import game.crazyTank.view.im.IMFriendListTitleAsset;
	
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	import road.utils.StringHelper;
	
	import ddt.data.CMFriendInfo;
	import ddt.data.player.FriendListPlayer;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.request.LoadCMFriendList;

	public class CMFriendList extends CMFriendListBgAsset
	{
		public static const PlayDDTTitle:String = "已经加入弹弹堂的好友";
		public static const UnPlayDDTTitle:String = "暂未加入弹弹堂的好友";
		
		private var _uipanel:UIComponent;
		
		private var _panel:ScrollPane;
		
		private var _playDDTTitle:IMFriendListTitleAsset;
		private var _unplayDDTTitle:IMFriendListTitleAsset;
		private var _upPageBtn:HBaseButton;
		private var _downPageBtn:HBaseButton;
		private var _hasPlayList:SimpleGrid;
		private var _unPlayList:SimpleGrid;
		private var _isExpandHasPlayList:Boolean;
		private var _isExpandUnPlayList:Boolean;
		private var _currentSelectedItem:CMFriendItem;
		private var _playCurrentPage:int;
		private var _unplayCurrentPage:int;
		private var _playDDTListTotalPage:int;
		private var _unplayDDTListTotalPage:int;
		public static const ON_SELECTED:String = "onSelected";
		private var _currentType:int;
		public function CMFriendList()
		{
			super();
			init();
			initEvent();
		}
		private function init():void
		{
			_upPageBtn = new HBaseButton(this.upPage_mc);
			_upPageBtn.enable = false;
			_downPageBtn = new HBaseButton(this.downPage_mc);
			_downPageBtn.enable = false;
			// 已加入弹弹堂的好友标题
			_playDDTTitle = new IMFriendListTitleAsset();
			_playDDTTitle.buttonMode = true;
			_playDDTTitle.gotoAndStop(1);
			_playDDTTitle.bg_mc.gotoAndStop(1);
			_playDDTTitle.title_txt.text = CMFriendList.PlayDDTTitle;
			// 未加入弹弹堂的好友标题
			_unplayDDTTitle = new IMFriendListTitleAsset();
			_unplayDDTTitle.buttonMode = true;
			_unplayDDTTitle.gotoAndStop(1);
			_unplayDDTTitle.bg_mc.gotoAndStop(1);
			_unplayDDTTitle.title_txt.text = CMFriendList.UnPlayDDTTitle;
			// 已加入弹弹堂的好友列表
			_hasPlayList = new SimpleGrid(310,48);
			_hasPlayList.marginHeight += 20
			// 未加入弹弹堂的好友列表
			_unPlayList = new SimpleGrid(310,48);
			_unPlayList.marginHeight += 20
			
			_uipanel = new UIComponent();
			// 含滚动条的列表框
			_panel = new ScrollPane();
			_panel.setStyle("upSkin",new Sprite());
			_panel.setStyle("skin",new Sprite());
			_panel.horizontalScrollPolicy = ScrollPolicy.OFF;
			_panel.x = 4;
			_panel.y = 3;
			ComponentHelper.replaceChild(this,list_pos,_panel);
			_panel.source = _uipanel;
			
			_uipanel.addChild(_playDDTTitle);
			_uipanel.addChild(_unplayDDTTitle);
			_uipanel.addChild(_upPageBtn);
			_uipanel.addChild(_downPageBtn);
			
			_hasPlayList.y = _playDDTTitle.height;
			_unplayDDTTitle.y = _hasPlayList.y + _hasPlayList.height;
			_unPlayList.y = _unplayDDTTitle.y + _unplayDDTTitle.height
			_isExpandUnPlayList  = false;
			_isExpandHasPlayList = false;
			_playCurrentPage = 1;
			_unplayCurrentPage = 1;
			_currentType = 0;
			handleDate();
//			_updateCMFriendList();//测试
			_panel.update();
			updateBrnEnable();
		}
		private function initEvent():void
		{
			PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,__addCompleteHandler);
			_playDDTTitle.addEventListener(MouseEvent.CLICK , __playTitleClick);
			_unplayDDTTitle.addEventListener(MouseEvent.CLICK , __unplayTitleClick);
			_playDDTTitle.addEventListener(MouseEvent.MOUSE_OVER , __titleOver);
			_playDDTTitle.addEventListener(MouseEvent.MOUSE_OUT , __titleOut);
			_unplayDDTTitle.addEventListener(MouseEvent.MOUSE_OVER , __titleOverII);
			_unplayDDTTitle.addEventListener(MouseEvent.MOUSE_OUT , __titleOutII);
			_upPageBtn.addEventListener(MouseEvent.CLICK , __upPageBtnClick);
			_downPageBtn.addEventListener(MouseEvent.CLICK ,__downPageBtnClick );
		}
		
		private function __upPageBtnClick(evt:Event):void
		{
			SoundManager.Instance.play("008");
			if(_currentType == 0)
			{
				_playCurrentPage--;
				if(_playCurrentPage <= 1)
				{
					_playCurrentPage = 1;
					_upPageBtn.enable = false;
				}
				updatePlayDDTList();
			}else
			{
				_unplayCurrentPage--;
				if(_unplayCurrentPage <= 1)
				{
					_unplayCurrentPage = 1;
					_upPageBtn.enable = false;
				}
				updateHasPlayDDTList()
			}
			updateBrnEnable();
		}
		
		private function __downPageBtnClick(evt:Event):void
		{
			SoundManager.Instance.play("008");
			if(_currentType == 0)
			{
				_playCurrentPage++;
				if(_playCurrentPage > _playDDTListTotalPage)
				{
					_playCurrentPage = _playDDTListTotalPage;
				}
				updatePlayDDTList();
			}else
			{
				_unplayCurrentPage++;
				if(_unplayCurrentPage > _unplayDDTListTotalPage)
				{
					_unplayCurrentPage = _unplayDDTListTotalPage;
				}
				updateHasPlayDDTList()
			}
			updateBrnEnable();
		}
		
		private function updateBrnEnable():void
		{
			if(_currentType == 0)
			{
				if(_playCurrentPage >= _playDDTListTotalPage)
				{
					_downPageBtn.enable = false;
					_upPageBtn.enable = true;
				}else if(_playCurrentPage <= 1)
				{
					_upPageBtn.enable = false;
					_downPageBtn.enable = true;
				}else
				{
					_downPageBtn.enable = true;
					_upPageBtn.enable = true;
				}
				if((_hasPlayList && _hasPlayList.items.length <= 0) || !_hasPlayList || PlayerManager.Instance.PlayCMFriendList.length <= 4)
				{
					_downPageBtn.enable = false;
					_upPageBtn.enable = false;
				}
			}else
			{
				if(_unplayCurrentPage >= _unplayDDTListTotalPage)
				{
					_downPageBtn.enable = false;
					_upPageBtn.enable = true;
				}else if(_unplayCurrentPage <= 1 )
				{
					_downPageBtn.enable = true;
					_upPageBtn.enable = false;
				}else
				{
					_downPageBtn.enable = true;
					_upPageBtn.enable = true;
				}
				if((_unPlayList && _unPlayList.items.length <= 0) || !_unPlayList || PlayerManager.Instance.UnPlayCMFriendList.length <= 4)
				{
					_downPageBtn.enable = false;
					_upPageBtn.enable = false;
				}
			}
			if(!_isExpandUnPlayList && !_isExpandHasPlayList)
			{
				_downPageBtn.enable = false;
				_upPageBtn.enable = false;
			}
		}
		
		private function __titleOver(evt:Event):void
		{
			if(_isExpandUnPlayList)
			{
				_playDDTTitle.bg_mc.gotoAndStop(3);
			}else
			{
				_playDDTTitle.bg_mc.gotoAndStop(2);
			}
		}
		
		private function __titleOut(evt:Event):void
		{
			if(_isExpandUnPlayList)
			{
				_playDDTTitle.bg_mc.gotoAndStop(3);
			}else
			{
				_playDDTTitle.bg_mc.gotoAndStop(1);
			}
		}
		
		private function __titleOverII(evt:Event):void
		{
			if(_isExpandHasPlayList)
			{
				_unplayDDTTitle.bg_mc.gotoAndStop(3);
			}else
			{
				_unplayDDTTitle.bg_mc.gotoAndStop(2);
			}
		}
		
		private function __titleOutII(evt:Event):void
		{
			if(_isExpandHasPlayList)
			{
				_unplayDDTTitle.bg_mc.gotoAndStop(3);
			}else
			{
				_unplayDDTTitle.bg_mc.gotoAndStop(1);
			}
		}
		
		private function __playTitleClick(evt:MouseEvent):void
		{
			cleanCurrentSelectedItem();
			SoundManager.Instance.play("008");
			_isExpandUnPlayList  = _isExpandUnPlayList ? false : true;
			_isExpandHasPlayList = false;
			if(_isExpandUnPlayList)
			{
				_currentType = 0;
			} 
			updatePlayDDTList();
			_playDDTTitle.bg_mc.gotoAndStop(3);
			if(!_isExpandUnPlayList)
			{
				disposeList();
			}
			updateList();
			updateBrnEnable();
		}
		
		private function __unplayTitleClick(evt:MouseEvent):void
		{
			cleanCurrentSelectedItem();
			SoundManager.Instance.play("008");
			_isExpandHasPlayList = _isExpandHasPlayList ? false:true;
			_isExpandUnPlayList  = false;
			if(_isExpandHasPlayList)
			{
				_currentType = 1;
			} 
			updateHasPlayDDTList();
			_unplayDDTTitle.bg_mc.gotoAndStop(3);
			if(!_isExpandHasPlayList)
			{
				disposeList();
			}
			updateList();
			updateBrnEnable();
		}
		
		private function __addCompleteHandler(e:DictionaryEvent):void
		{
			if(_hasPlayList)
			{
				var player:FriendListPlayer = e.data as FriendListPlayer;
				for(var i:uint = 0; i < _hasPlayList.itemCount; i++)
				{
					if(player.LoginName == (_hasPlayList.items[i] as CMFriendItem).info.UserName)
					{
						(_hasPlayList.items[i] as CMFriendItem).disAbleAdd();
						break;
					}
				}
			}
		}
		
		// 处理加载数据
		private function handleDate():void
		{
			// 因为要在点击时，再去加载数据，所以由外部实现
			if(!StringHelper.IsNullOrEmpty(PathManager.CommunityFriendList()))
			{
				if(PlayerManager.Instance.CMFriendList != null && PlayerManager.Instance.CMFriendList.length > 0)
				{
//					_updateCMFriendList(null);
				}
				else
				{
					new LoadCMFriendList(PlayerManager.Instance.Account.Account).loadSync(_updateCMFriendList);
//					new LoadCMFriendList().loadSync(_updateCMFriendList);
				}
			}
			else
			{
				MessageTipManager.getInstance().show("该功能尚未配置");
			}
		}
		private var allItems:Array;
		private function _updateCMFriendList(request:LoadCMFriendList = null):void
		{
//			updatePlayDDTList();
		}
		
		private function updatePlayDDTList():void
		{
			var info:CMFriendInfo;
			var item:CMFriendItem;
			if(!PlayerManager.Instance.CMFriendList)return;
			var playList:Array = PlayerManager.Instance.PlayCMFriendList;
			_playDDTListTotalPage = Math.ceil(playList.length / 4);
			disposeList();
			_hasPlayList = new SimpleGrid(310,48);
			_hasPlayList.marginHeight += 20
			var i:int = 0;
			allItems = [];
			for each(info in playList)
			{
				if(i< (_playCurrentPage-1)*4) 
				{
					i++;
					continue;
				}
				if(i >= _playCurrentPage*4) break;
				item = new CMFriendItem(info);
				_hasPlayList.appendItem(item);
				item.addEventListener(MouseEvent.CLICK, __itemClick);
				allItems.push(item);
				i++;
			}
			_hasPlayList.y = _playDDTTitle.y + _playDDTTitle.height;
			_hasPlayList.drawNow();
			_hasPlayList.setSize(_hasPlayList.getContentWidth()+10,_hasPlayList.getContentHeight());
			_hasPlayList.verticalScrollPolicy = _hasPlayList.horizontalScrollPolicy = ScrollPolicy.OFF;
			_uipanel.setSize(240 ,280);
			_uipanel.addChild(_hasPlayList);
			_panel.setSize(240 , 280);
			updateList();
			_panel.update();
			startQueueLoad();
			updateBrnEnable();
		}
		
		private function updateHasPlayDDTList():void
		{
			
			var info:CMFriendInfo;
			var item:CMFriendItem;
			if(!PlayerManager.Instance.CMFriendList)return;
			var unPlayList:Array = PlayerManager.Instance.UnPlayCMFriendList;
			_unplayDDTListTotalPage = Math.ceil(unPlayList.length / 4);
			disposeList();
			_unPlayList = new SimpleGrid(310,48);
			_unPlayList.marginHeight += 20
			var i:int = 0;
			allItems = [];
			for each(info in unPlayList)
			{
				if(i< (_unplayCurrentPage-1)*4) 
				{
					i++;
					continue;
				}
				if(i >= _unplayCurrentPage*4) break;
				item = new CMFriendItem(info);
				_unPlayList.appendItem(item);
				item.addEventListener(MouseEvent.CLICK, __itemClick);
				allItems.push(item);
				i++;
			}
			_unPlayList.y = _unplayDDTTitle.y + _unplayDDTTitle.height - 18;
			_unPlayList.verticalScrollPolicy = _unPlayList.horizontalScrollPolicy = ScrollPolicy.OFF;
			if(PlayerManager.Instance.CMFriendList.length > 0)
			{
//				if(_hasPlayList.itemCount > 0)
//				{
//					_unplayDDTTitle.y = _hasPlayList.getContentHeight() - 20;
//				}
//				else
//				{
					_unplayDDTTitle.y = _playDDTTitle.height + 5;
//				}
			}
			_unPlayList.y = _unplayDDTTitle.y + _unplayDDTTitle.height - 18;
			_unPlayList.drawNow();
			_unPlayList.setSize(_unPlayList.getContentWidth() + 10, _unPlayList.getContentHeight());
			_uipanel.addChild(_unPlayList);
			_panel.setSize(240 , 280);
			updateList();
			_panel.update();
			startQueueLoad();
//			dispatchEvent(new Event(Event.CHANGE));
			updateBrnEnable();
		}
		
		public function updateList():void
		{
			if(_isExpandUnPlayList)
			{
				_playDDTTitle.gotoAndStop(2);
				
			}else
			{
				_playDDTTitle.gotoAndStop(1);
				_playDDTTitle.bg_mc.gotoAndStop(1);
			}
			if(_isExpandHasPlayList)
			{
				_unplayDDTTitle.gotoAndStop(2);
			}else
			{
				_unplayDDTTitle.gotoAndStop(1);
				_unplayDDTTitle.bg_mc.gotoAndStop(1);
			}
			if(_hasPlayList)_hasPlayList.y = _playDDTTitle.height - 18;
			if(_isExpandUnPlayList)
			{
				_unplayDDTTitle.y = 225;
			}
			else
			{
				_unplayDDTTitle.y = 27;
			}
			if((_hasPlayList && _hasPlayList.items.length <= 0) || !_hasPlayList)
			{
				_unplayDDTTitle.y = 27;
			}
		}
		
		private function startQueueLoad():void
		{
			loadNext();
		}
		
		private function loadNext(e:Event = null):void
		{
			if(e)
			{
				e.target.removeEventListener(Event.COMPLETE,loadNext);
			}
			for(var i:int = 0;i<allItems.length;i++)
			{
				if(!allItems[i].photoLoaded)
				{
					var item:CMFriendItem = allItems[i] as CMFriendItem;
					item.sendRequest();
					item.addEventListener(Event.COMPLETE,loadNext);
					return;
				}
			}
		}
		
		private function __itemClick(e:Event):void
		{
			SoundManager.Instance.play("008");
			
			if(_hasPlayList && _hasPlayList.selectedItem)
			{
				(_hasPlayList.selectedItem as CMFriendItem).Selected = false;
				_hasPlayList.selectedItem = null;
			}
			
			if(_unPlayList && _unPlayList.selectedItem)
			{
				(_unPlayList.selectedItem as CMFriendItem).Selected = false;
				_unPlayList.selectedItem = null;
			}
			
			(e.currentTarget as CMFriendItem).Selected = true;
			
			if(((e.currentTarget as CMFriendItem).info as CMFriendInfo).IsExist)
			{
				_hasPlayList.selectedItem = e.currentTarget as DisplayObject;
			}
			else
			{
				_unPlayList.selectedItem = e.currentTarget as DisplayObject;
			}
			_currentSelectedItem = e.currentTarget as CMFriendItem;
			dispatchEvent(new Event(ON_SELECTED));
		}
		
		private function cleanCurrentSelectedItem():void
		{
			_currentSelectedItem.Selected = false;
			dispatchEvent(new Event(ON_SELECTED));
		}
		
		public function get currentSelectedItem():CMFriendItem
		{
			return _currentSelectedItem;
		}
		
		private function disposeList():void
		{
			if(_hasPlayList)
			{
				for(var i:uint = 0; i < _hasPlayList.itemCount; i++)
				{
					_hasPlayList.items[i].removeEventListener(Event.CHANGE, __itemClick);
					_hasPlayList.items[i].removeEventListener(Event.COMPLETE,loadNext);
					_hasPlayList.items[i].dispose();
				}
				
				_hasPlayList.clearItems();
				
				if(_hasPlayList && _hasPlayList.parent)
					_hasPlayList.parent.removeChild(_hasPlayList);
			}
			_hasPlayList = null;
			
			if(_unPlayList)
			{
				for(var j:uint = 0; j < _unPlayList.itemCount; j++)
				{
					_unPlayList.items[i].removeEventListener(Event.CHANGE, __itemClick);
					_unPlayList.items[j].removeEventListener(Event.COMPLETE,loadNext);
					_unPlayList.items[j].dispose();
				}
				
				_unPlayList.clearItems();
				
				if(_unPlayList && _unPlayList.parent)
					_unPlayList.parent.removeChild(_unPlayList);
			}
			_unPlayList = null;
		}
		
		public function dispose():void
		{
			PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.ADD,__addCompleteHandler);
			if(_hasPlayList)
			{
				for(var i:uint = 0; i < _hasPlayList.itemCount; i++)
				{
					_hasPlayList.items[i].removeEventListener(Event.CHANGE, __itemClick);
					_hasPlayList.items[i].removeEventListener(Event.COMPLETE,loadNext);
					_hasPlayList.items[i].dispose();
				}
				_hasPlayList.clearItems();
			}
			if(_hasPlayList && _hasPlayList.parent)
				_hasPlayList.parent.removeChild(_hasPlayList);
			
			_hasPlayList = null;
			if(_unPlayList)
			{
				for(var j:uint = 0; j < _unPlayList.itemCount; j++)
				{
					_unPlayList.items[i].removeEventListener(Event.CHANGE, __itemClick);
					_unPlayList.items[j].removeEventListener(Event.COMPLETE,loadNext);
					_unPlayList.items[j].dispose();
				}
				_unPlayList.clearItems();
				if(_unPlayList && _unPlayList.parent)
					_unPlayList.parent.removeChild(_unPlayList);
				_unPlayList = null;
			}
			if(_panel)
			{
				_panel.source = null;
				
				if(_uipanel && _uipanel.parent)
					_uipanel.parent.removeChild(_uipanel);
				_uipanel = null;
				
				if(_panel.parent)
					_panel.parent.removeChild(_panel);
			}
			_panel = null;
			
			allItems = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}