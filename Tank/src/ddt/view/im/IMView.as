package ddt.view.im
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.im.IMFriendBGAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.UIManager;
	import road.utils.StringHelper;
	
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.request.LoadCMFriendList;
	import ddt.view.IDisposeable;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ShowCharacter;
	import ddt.view.common.LevelIcon;
	import ddt.view.common.SimpleLoading;

	public class IMView extends HFrame
	{
		private var _bg:IMFriendBGAsset;
		private var _controller:IMController;
		private var _friendlist:IMFriendList;
		private var _consortiaList:IMConsortiaList;
		private var _blackList:IMBlackList;
		private var _currentContent:IDisposeable;
		private var _panel:ScrollPane;
		private var _contentII:Sprite;
		
		private var _addFriendBtn:HBaseButton;
		private var _communityBtn:HLabelButton;
		private var _cancelBtn:HLabelButton;
		private var _addBlackBtn:HBaseButton;
		private var _fr:AddFriendFrame;
		private var _addBlackList:AddBlackListFrame;
		
		private var _lookUpView:IMLookupView;
		private var _levelIcon:LevelIcon;
		private var _info:SelfInfo;
		private var _inviteBtn:HBaseButton;
		private var _cmFriendList:CMFriendList;
		private var _figure:Bitmap;
		private var character:ShowCharacter;
		private var _currentListType:int;
		public static var IS_SHOW_SUB:Boolean;
		public static const FRIEND_LIST:int= 0;
		public static const CMFRIEND_LIST:int = 1;
		public function IMView(controller:IMController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			blackGound = false;
			alphaGound = false;
			showBottom = true;
			setContentSize(245,470);
			
			titleText = LanguageMgr.GetTranslation("ddt.view.chat.ChatInputView.friend");
			
			_bg = new IMFriendBGAsset();
			_bg.btn_1.buttonMode = true;
			_bg.btn_1.gotoAndStop(1);
			if(PathManager.CommunityExist())
			{
				_bg.btn_2.buttonMode = true;
				_bg.btn_2.gotoAndStop(2);
			}else
			{
				_bg.btn_2.visible = false;
			}
			_bg.x = -6;
			_bg.y = 3;
			addContent(_bg);
			
//			_cmFriendList = new CMFriendList();
			_friendlist = new IMFriendList(_controller);
			_consortiaList = new IMConsortiaList(_controller);
			_blackList = new IMBlackList(_controller);
//			
			_panel = new ScrollPane();
			_panel.setStyle("upSkin",new Sprite());
			_panel.setStyle("skin",new Sprite());
			_panel.horizontalScrollPolicy = ScrollPolicy.OFF;
			_panel.setSize(240,278);
			
			_addFriendBtn = new HBaseButton(_bg.addFriend_ben)
//			_addFriendBtn.label = LanguageMgr.GetTranslation("ddt.view.im.IMFriendList.addFriend");
			_addFriendBtn.useBackgoundPos = true;
			_addFriendBtn.x = _bg.add_pos.x;
			_addFriendBtn.y = _bg.add_pos.y;
			_bg.add_pos.visible = false;
			addChild(_addFriendBtn);

			_communityBtn = new HLabelButton();
			_communityBtn.label = LanguageMgr.GetTranslation("community");
			_communityBtn.x = _bg.cancel_pos.x;
			_communityBtn.y = _bg.cancel_pos.y;

			_cancelBtn = new HLabelButton();
			_cancelBtn.label = LanguageMgr.GetTranslation("cancel");
			_cancelBtn.x = _bg.cancel_pos.x;
			_cancelBtn.y = _bg.cancel_pos.y;
			
			_addBlackBtn = new HBaseButton(_bg.addBlack_btn);
//			_addBlackBtn.label = LanguageMgr.GetTranslation("ddt.view.im.IMBlackList.add");
			_addBlackBtn.useBackgoundPos = true;
			_addBlackBtn.x = _bg.cancel_pos.x;
			_addBlackBtn.y = _bg.cancel_pos.y;
			addChild(_addBlackBtn);
			
			_inviteBtn = new HBaseButton(_bg.inviteBtn);
			_inviteBtn.useBackgoundPos = true;
			_inviteBtn.enable = true;
			_inviteBtn.buttonMode = true;
			_inviteBtn.visible = false;
			_inviteBtn.x = _bg.cancel_pos.x;
			_inviteBtn.y = _bg.cancel_pos.y;
			addChild(_inviteBtn);
			
			_lookUpView = new IMLookupView();
			_lookUpView.x = _bg.lookUp_Pos.x+20;
			_lookUpView.y = _bg.lookUp_Pos.y+55;
			addChild(_lookUpView);
			
			_info = PlayerManager.Instance.Self;
			_bg.name_txt.text = _info.NickName;
			_levelIcon = new LevelIcon("s",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			_levelIcon.x = _bg.level_pos.x;
			_levelIcon.y = _bg.level_pos.y;
			_levelIcon.width = 35;
			_levelIcon.height = 35;
			addChild(_levelIcon);
			showFigure();
			addItem();
			_currentListType = FRIEND_LIST;
//			showList(0);
		}
		
		private function initLoadCMFriendList():void
		{
			if(!_cmFriendList)
			{
				if(!StringHelper.isNullOrEmpty(PathManager.CommunityFriendList()))
				{
					if(PlayerManager.Instance.CMFriendList != null && PlayerManager.Instance.CMFriendList.length > 0)
					{
						initLoadCMFriendListView();
					}
					else
					{
						new LoadCMFriendList(PlayerManager.Instance.Account.Account).loadSync(initLoadCMFriendListView);
//						new LoadCMFriendList().loadSync(initLoadCMFriendListView);
					}
				}
				else
				{
					MessageTipManager.getInstance().show("该功能尚未配置");
				}
			}
		}
		
		private function initLoadCMFriendListView(request:LoadCMFriendList = null):void
		{
			_cmFriendList = new CMFriendList();
			if(_cmFriendList)_cmFriendList.addEventListener(CMFriendList.ON_SELECTED , __updateBtnState);
			showCMlist();
		}
		
		private function showFigure():void
		{
			_bg.head_portrait_pos.scrollRect = new Rectangle(0,0,_bg.head_portrait_pos.width,_bg.head_portrait_pos.height);
			var info:PlayerInfo = PlayerManager.Instance.Self;
			character = CharactoryFactory.createCharacter(info) as ShowCharacter;
			character.show(true,-1);
			character.showGun = false;
			character.doAction(ShowCharacter.STAND);
			character.x = 0;
			character.y = 0;
			character.setShowLight(false,null);
			character.stopAnimation();
			character.addEventListener(Event.COMPLETE , __characterComplete);
		}
		
		private function __characterComplete(evt:Event):void
		{
			var bitmapdata:BitmapData  = character.characterBitmapdata.clone();
			var  temp:BitmapData = new BitmapData(100,100,true,0);
			temp.copyPixels(bitmapdata, new Rectangle(0,0,100,100),new Point(0,0));
			if(_figure)
			{
				_figure.parent.removeChild(_figure)
				_figure = null;
			}
			_figure = new Bitmap(temp);
			_figure.smoothing = true;
			_figure.scaleX = -0.9;
			_figure.scaleY = 0.9;
			_figure.x = _bg.head_portrait_pos.x + 55;
			_figure.y = _bg.head_portrait_pos.y - 30;
			_bg.head_portrait_pos.addChild(_figure);
			bitmapdata = null;
			temp = null;
		}
		
		private function addItem():void
		{
			if(_contentII)
			{
				_contentII = null;
			}
			if(_panel)
			{
				if(_panel.parent)_panel.parent.removeChild(_panel);
				_panel = null;
			}
			_panel = new ScrollPane();
			_panel.setStyle("upSkin",new Sprite());
			_panel.setStyle("skin",new Sprite());
			_panel.horizontalScrollPolicy = ScrollPolicy.OFF;
			_panel.verticalScrollPolicy = ScrollPolicy.ON;
			_panel.setSize(240,278);
			_contentII = new Sprite();
			_contentII.addChild(_friendlist);
			_consortiaList.y = _friendlist.y+_friendlist.contentHeight+2;
			_contentII.addChild(_consortiaList);
			_blackList.y = _consortiaList.y+_consortiaList.contentHeight+2;
			_contentII.addChild(_blackList);
			_contentII.x = _bg.content_pos.x;
			_contentII.y = _bg.content_pos.y;
			_panel.source = _contentII;
			_panel.y = 150;
			_panel.x = 2;
			_panel.update();
			addContent(_panel);
			updateScrollPolicy();
		}
		
		private function updateScrollPolicy():void
		{
			if(_friendlist.height + _consortiaList.height + _blackList.height >= 280)
			{
				_panel.verticalScrollPolicy = ScrollPolicy.ON;
			}else
			{
				_panel.verticalScrollPolicy = ScrollPolicy.OFF;
			}
		}
		
		override public function show():void
		{
			UIManager.AddDialog(this,false);
			x = 665;
			y = 15;
		}
		
		override public function close():void
		{
			_controller.hide();
		}

		private function initEvent():void
		{
			_bg.btn_1.addEventListener(MouseEvent.CLICK,__bgCellClick);
			_bg.btn_2.addEventListener(MouseEvent.CLICK,__bgCellClick);
			addEventListener(Event.ADDED_TO_STAGE,__addToSatge);
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
			_friendlist.addEventListener(Event.CHANGE , __updateFriendlist);
			_consortiaList.addEventListener(Event.CHANGE , __updateConsortialist);
			_blackList.addEventListener(Event.CHANGE , __updateBlacklist);
			_addFriendBtn.addEventListener(MouseEvent.CLICK,__addFriendClick);
			_cancelBtn.addEventListener(MouseEvent.CLICK,__cancel);
			_addBlackBtn.addEventListener(MouseEvent.CLICK,__addBlackClick);
			_inviteBtn.addEventListener(MouseEvent.CLICK , __inviteBtnClick);
			_lookUpView.addEventListener(Event.CHANGE , __lookUpItemClick);
			addEventListener(MouseEvent.MOUSE_DOWN , __mouseDown);
		}
		private function removeEvent():void{
			removeEventListener(Event.ADDED_TO_STAGE,__addToSatge);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
			_addFriendBtn.removeEventListener(MouseEvent.CLICK,__addFriendClick);
			_friendlist.addEventListener(Event.CHANGE , __updateFriendlist);
			_consortiaList.addEventListener(Event.CHANGE , __updateConsortialist);
			_blackList.addEventListener(Event.CHANGE , __updateBlacklist);
			if(_cmFriendList)_cmFriendList.removeEventListener(Event.CHANGE , __updateCMlist);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,__cancel);
			_addBlackBtn.removeEventListener(MouseEvent.CLICK,__addBlackClick);
			_inviteBtn.removeEventListener(MouseEvent.CLICK , __inviteBtnClick);
			_lookUpView.removeEventListener(Event.CHANGE , __lookUpItemClick);
			removeEventListener(MouseEvent.MOUSE_DOWN , __mouseDown);
		}
		
		private function __mouseDown(evt:MouseEvent):void
		{
			if(evt.target.name =="delIcon")
			{
				return;
			}
			if((evt.target is TextField && evt.target.type == "input") || evt.target.name == "bg" || evt.target.name =="flexBg_mc")
			{
				_lookUpView.search();
			}else
			{
				_lookUpView.hide();
			}
		}
		
		private function __updateFriendlist(evt:Event):void
		{
			if(_currentListType == CMFRIEND_LIST)return;
			_consortiaList.isExpand = false;
			_blackList.isExpand     = false;
			addItem();
		}
		
		private function __updateConsortialist(evt:Event):void
		{
			if(_currentListType == CMFRIEND_LIST)return;
			_friendlist.isExpand 	= false;
			_blackList.isExpand     = false;
			addItem();
		}
		
		private function __updateBlacklist(evt:Event):void
		{
			if(_currentListType == CMFRIEND_LIST)return;
			_consortiaList.isExpand  = false;
			_friendlist.isExpand     = false;
			addItem();
			
		}
		
		private function __updateBtnState(evt:Event):void
		{
			if(_currentListType == CMFRIEND_LIST)
			{
				if(_cmFriendList.currentSelectedItem.info.IsExist)
				{
					_addFriendBtn.visible = true;
					_addFriendBtn.enable = true;
					_inviteBtn.visible = true;
					_inviteBtn.enable = false;
				}else
				{
					_addFriendBtn.enable = false;
					_inviteBtn.visible = true;
					_inviteBtn.enable = true;
				}
				if(!_cmFriendList.currentSelectedItem.Selected)
				{
					_addFriendBtn.enable = false;
					_inviteBtn.enable = false;
				}
			}
		}
		
		private function __close(evt:Event):void
		{
			SimpleLoading.instance.hide();
			_controller.hide();
			SoundManager.instance.play("008");
		}
	
		private function __bgCellClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(evt.currentTarget == _bg.btn_1)
			{
				_bg.btn_1.gotoAndStop(1);
				_bg.btn_2.gotoAndStop(2);
				showList(0);
			}else if(evt.currentTarget == _bg.btn_2)
			{
				_bg.btn_1.gotoAndStop(2);
				_bg.btn_2.gotoAndStop(1);
				showList(1);
			}
			
		}
	
		private function showList(n:int):void
		{
			
			switch (n){
				case 0:
					_currentListType = FRIEND_LIST;
					_lookUpView.listType = FRIEND_LIST;
					addItem();
					_addFriendBtn.enable = true;
					_inviteBtn.visible = false;
					_addBlackBtn.visible = true;
					break;
				case 1:
					{
						if(!_cmFriendList)
						{
							initLoadCMFriendList();
						}else
						{
							showCMlist();
						}
					}
					break;
			}
		}
		
		private function showCMlist():void
		{
			_currentListType = CMFRIEND_LIST;
			_lookUpView.listType = CMFRIEND_LIST;
			if(_contentII)
			{
				_contentII = null;
			}
			_contentII = new Sprite();
			_contentII.addChild(_cmFriendList)
			if(_panel)
			{
				_panel.parent.removeChild(_panel);
				_panel = null;
			}
			_panel = new ScrollPane();
			_panel.setStyle("upSkin",new Sprite());
			_panel.setStyle("skin",new Sprite());
			_panel.horizontalScrollPolicy = ScrollPolicy.OFF;
			_panel.setSize(240,278);
			_panel.source = _contentII;
			_panel.y = 150;
			_panel.x = 2;
			_panel.verticalScrollPolicy = ScrollPolicy.OFF;
			addContent(_panel);
			_addFriendBtn.enable = false;
			_inviteBtn.visible = true;
			_inviteBtn.enable = false;
			_addBlackBtn.visible = false;
		}
		
		private function __updateCMlist(evt:Event):void
		{
			showList(1);
		}
		
		private function __addFriendClick(evt:MouseEvent):void
		{
			if(_currentListType == FRIEND_LIST)
			{
				if(!_fr){
					_fr= new AddFriendFrame(_controller);	
				}
				SoundManager.instance.play("008");
				if(_fr.parent)
				{
					_fr.hide();
				}
				else
				{
					_fr.show();
				}
				if(_addBlackList && _addBlackList.parent)
				{
					_addBlackList.hide();
				}
			}else if(_currentListType == CMFRIEND_LIST)
			{
				if(_cmFriendList &&_cmFriendList.currentSelectedItem && _cmFriendList.currentSelectedItem.info && _cmFriendList.currentSelectedItem.info.IsExist)
				{
					SoundManager.instance.play("008");
					IMController.Instance.addFriend(_cmFriendList.currentSelectedItem.info.NickName);
				}
			}
		}
		
		private function __addBlackClick(evt:MouseEvent):void
		{
			if(!_addBlackList){
				_addBlackList= new AddBlackListFrame(_controller);
			}
			if(_fr && _fr.parent)
			{
				_fr.hide();
			}
			SoundManager.instance.play("008");
			_addBlackList.show();
		}
		
		private function __lookUpItemClick(evt:Event):void
		{
			if(!_lookUpView.currentItemInfo)return;
			if(_lookUpView.currentItemInfo.IsExist && _currentListType == CMFRIEND_LIST)
			{
				_addFriendBtn.visible = true;
				_addFriendBtn.enable = true;
				_inviteBtn.visible = true;
				_inviteBtn.enable = false;
			}else if(_currentListType == CMFRIEND_LIST)
			{
				_addFriendBtn.enable = false;
				_inviteBtn.visible = true;
				_inviteBtn.enable = true;
			}
		}
		
		public function __inviteBtnClick(evt:Event):void
		{
			//			trace("邀请");
			if(!_cmFriendList)
			{
				_inviteBtn.enable = false;
				return;
			}else
			{
				_inviteBtn.enable = true;
			}
			MessageTipManager.getInstance().show("已通过社区消息发送邀请");
			SoundManager.instance.play("008");
			if(!StringHelper.isNullOrEmpty(PathManager.CommunityInvite()))
			{
				var req:URLRequest = new URLRequest(PathManager.CommunityInvite());
				
				var data:URLVariables = new URLVariables();
				
				data["fuid"] = String(PlayerManager.Instance.Self.LoginName);
				data["fnick"] = PlayerManager.Instance.Self.NickName; 
				data["tuid"] =_cmFriendList.currentSelectedItem.info.UserName; 
				data["serverid"] = String(ServerManager.Instance.AgentID); 
				data["rnd"] = Math.random(); 
				
				req.data = data;
				
				var loader:URLLoader = new URLLoader(req);
				loader.load(req);
				//				MessageTipManager.getInstance().show("操作成功");
			}
		}
		
		private function __cancel(evt:MouseEvent):void
		{
			_controller.hide();
			SoundManager.instance.play("008");
		}
		
		private function setContent(content:IDisposeable):void{
			if(_currentContent){
				_currentContent.dispose();
			}
			_currentContent = content;
			content.x = _bg.content_pos.x;
			content.y = _bg.content_pos.y;
			
			addContent(_currentContent as Sprite);
		}
		public function doPrivateChat(info:PlayerInfo):void
		{
			_friendlist.doPrivateChat(info);
		}
		
		private function __onKeyDown(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.instance.play("008");
				close();
			}
		}
		
		private function __addToSatge(e:Event):void
		{
			stage.focus = this;
		}
		
		override public function dispose():void
		{
			removeEvent();
			_bg.parent.removeChild(_bg);
			_bg = null;
			if(_cmFriendList)_cmFriendList.dispose();
			if(_friendlist)_friendlist.dispose();
			if(_blackList)_blackList.dispose();
			if(_consortiaList)_consortiaList.dispose();
			if(character)character.removeEventListener(Event.COMPLETE , __characterComplete);
			if(_figure && _figure.parent)
			{
				_figure.parent.removeChild(_figure)
			}
			if(character)
			{
				character.dispose();
			}
			_friendlist = null;
			_blackList = null;
			_consortiaList = null;
			_controller = null;
			if(_addFriendBtn)
			{
				_addFriendBtn.dispose();
				_addFriendBtn = null;
			}
			if(_communityBtn)
			{
				_communityBtn.dispose();
				_communityBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			super.dispose();
		}
	}
}