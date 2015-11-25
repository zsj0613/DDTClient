package ddt.view.chatsystem
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import game.crazyTank.view.chat.ChatInputBgAccect;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.Helpers;
	import ddt.view.emailII.FriendListView;
	import ddt.view.scenechatII.SceneChatIIFacePanel;
	
	use namespace chat_system; 
	
	public class ChatInputView extends ChatInputBgAccect
	{
		
		public static const ADMIN_NOTICE:int = 8;
		
		/* 大喇叭 */
		public static const BIG_BUGLE:uint = 0;
		/* 跨区喇叭 */
		public static const CROSS_BUGLE:uint = 12;
		/**
		 *结婚系统 
		 */
		public static const CHURCH_CHAR:int = 9;
		
		/* 公会按钮的序号 */
		public static const CONSORTIA:uint = 3;
		
		/* 当前 */
		public static const CURRENT:uint = 5;
		/**
		 * 防御宝珠发动提示
		 */		 
		public static const DEFENSE_TIP:int = 10;
		/**
		 *挑战公告
		 */
		public static const DEFY_AFFICHE:uint = 11;
		
		/* 私聊按钮的序号 */
		public static const PRIVATE:uint = 2;
		
		/* 小喇叭 */
		public static const SMALL_BUGLE:uint = 1;
		
		/* 系统公告 */
		public static const SYS_NOTICE:uint = 6;
		
		/**
		 * 系统提示 
		 */		
		public static const SYS_TIP:uint = 7;
		
		/* 组队按钮的序号 */
		public static const TEAM:uint = 4;
		
		/**
		 *温泉房间内聊天 
		 */		
		public static const HOTSPRING_ROOM:uint = 13;
		
		public function ChatInputView()
		{
			initView();
			initEvent();
		}
		
		private var _btnEnter:HBaseButton;
		
		private var _channel:int = 0;
		
		private var _channelList:ChatChannelListView;
		
		private var _channelListBtn:HBaseButton;
		
		private var _faceBtn:HTipButton;
		/* 表情列表 */
		private var _faceList:SceneChatIIFacePanel;
		
		private var _fastReplyBtn:HTipButton;
		
		/* 快速回复列表 */
		private var _fastReplyPanel:SceneChatIIFastReply;
		
		/* 好友列表 */
		private var _friendList:FriendListView;
		
		private var _friendListBtn:HTipButton;
		
		private var _inputField:ChatInputField;
		
		private var _lastRecentSendTime:int = - 30000;
		
		private var _lastSendChatTime:int = -30000;
		
		public function set channel($channel:int):void
		{
			if(_channel == $channel)return;
			/**
			 * greater than 5 unacceptable value;
			 */
			//			if($channel > 6 || $channel < 0) return;
			_channel = $channel;
			channelLabelMC.gotoAndStop(_channel+1);
			_inputField.channel = _channel; 
			ChatManager.Instance.setFocus();
			if(_channel == PRIVATE)
			{
				UIManager.AddDialog(new SelectPlayerChatView());
			}
		}
		
		public function set faceEnabled(value:Boolean):void
		{
			_faceBtn.enable = value;
		}
		
		public function getCurrentInputChannel():int
		{
			if(_channel != CURRENT)return _channel;
			var result:int = _channel;
			switch(ChatManager.Instance.state)
			{
				case ChatManager.CHAT_WEDDINGROOM_STATE:
				case ChatManager.CHAT_CHURCH_CHAT_VIEW:
					result = CHURCH_CHAR;
					break;
				case ChatManager.CHAT_HOTSPRING_ROOM_VIEW:
				case ChatManager.CHAT_HOTSPRING_ROOM_GOLD_VIEW:
					result = HOTSPRING_ROOM;
					break;
			}
			return result;
		}
		
		public function get inputField():ChatInputField
		{
			return _inputField;
		}
		
		public function sendCurrentText():void
		{
			_inputField.sendCurrnetText();
		}
		
		public function setInputText(txt:String):void
		{
			_inputField.setInputText(txt);
		}
		
		public function setPrivateChatTo(nickname:String,uid:int = 0):void
		{
			_channel = PRIVATE;
			channelLabelMC.gotoAndStop(_channel+1);
			_inputField.channel = _channel;
			_inputField.setPrivateChatName(nickname,uid);
			ChatManager.Instance.setFocus();
			if(ChatManager.Instance.visibleSwitchEnable)visible = true;
		}
		
		public function switchVisible():void
		{
			visible = !visible;
		}
		
		private function __faceClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			panelClickLogic(_faceList);
		}
		
		private function __fastReplyClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			panelClickLogic(_fastReplyPanel);
		}
		
		private function __friendListBtnClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			_friendList.refreshAllList();
			_friendList.x = localToGlobal(new Point(friendListPos.x,friendListPos.y)).x;
			_friendList.y = localToGlobal(new Point(friendListPos.x,friendListPos.y)).y;
			stage.addChild(_friendList);
			panelClickLogic(_friendList);
		}
		
		private function __onChannelListBtnClicked(event:Event):void
		{
			SoundManager.instance.play("008");
			_channelList.visible = true;
		}
		
		private function __onChannelSelected(event:ChatEvent):void
		{
			channel = int(event.data);
		}
		
		private function __onEnterClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			sendCurrentText();
		}
		
		private function __onFaceSelect(event:Event):void
		{
			ChatManager.Instance.sendFace(_faceList.selected);
		}
		
		private function __onFastSelect(event:Event):void
		{
			
			setInputText(_fastReplyPanel.selectedWrod);
			sendCurrentText();
//			setInputText("");
		}
		
		private function __onInputTextChanged(event:ChatEvent):void
		{
			var data:ChatData = new ChatData();
			data.channel = getCurrentInputChannel();
			data.msg = String(event.data);
			data.sender = PlayerManager.Instance.Self.NickName;
			data.senderID = PlayerManager.Instance.Self.ID;
			data.receiver = _inputField.privateChatName;
			data.sender = ChatFormats.replaceUnacceptableChar(data.sender);
			data.receiver = ChatFormats.replaceUnacceptableChar(_inputField.privateChatName);
			if(checkCanSendChannel(data))
			{
				var ifCanSend:Boolean=false;
				ifCanSend=data.channel==CROSS_BUGLE||data.channel==BIG_BUGLE||data.channel==SMALL_BUGLE||checkCanSendTime();
				if(ifCanSend){
					ChatManager.Instance.sendChat(data);
					/**
					 * 如果是大小跨区喇叭就等服务器返回再显示，如果是其他频道就先显示再等服务器返回
					 */				
					if((data.channel != BIG_BUGLE) && (data.channel != SMALL_BUGLE) && (data.channel != CROSS_BUGLE)) 
					{
						data.msg=Helpers.enCodeString(data.msg);
						ChatManager.Instance.chat(data);
					}
					
				}
			}
			ChatManager.Instance.output.currentOffset=0;
		}
		
		
		private function __stagePanelClick (event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(stage)
			{
				stage.removeEventListener(MouseEvent.CLICK,__stagePanelClick);
			}
			event.stopImmediatePropagation();
			_fastReplyPanel.visible = false;
			_friendList.visible = false;
			_faceList.visible = false;
			_friendList.bg.gotoAndStop(1);
			ChatManager.Instance.setFocus();
		}
		
		private function checkCanSendChannel(data:ChatData):Boolean
		{
			if(data.channel == ChatInputView.PRIVATE && data.receiver == PlayerManager.Instance.Self.NickName)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.ChatManagerII.cannot"));
				return false;
			}
			if(data.channel == ChatInputView.CONSORTIA && PlayerManager.Instance.Self.ConsortiaID == 0)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.ChatManagerII.you"));
				return false;
			}
			if(data.channel == ChatInputView.TEAM)
			{
				if(ChatManager.Instance.state != ChatManager.CHAT_ROOM_STATE && 
					ChatManager.Instance.state != ChatManager.CHAT_GAME_STATE && 
					ChatManager.Instance.state != ChatManager.CHAT_GAMEOVER_STATE &&
					ChatManager.Instance.state != ChatManager.CHAT_DUNGEON_STATE &&
					ChatManager.Instance.state != ChatManager.CHAT_GAME_LOADING
				)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.manager.ChatManagerII.now"));
					return false;
				}
			}
			
			return true;
		}
		private function checkCanSendTime():Boolean
		{
			/**
			 * 一秒限制 
			 */			
			if(getTimer() - _lastSendChatTime < 1000)
			{
				ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("ddt.view.chat.ChatInput.time"));
				return false;
			}else
			{
				_lastSendChatTime = getTimer();
			}
			/**
			 * 30秒限制
			 */
			if(ChatManager.Instance.state == ChatManager.CHAT_CHURCH_CHAT_VIEW)
			{
				_lastRecentSendTime = -30000;
			}
			if(_channel != CURRENT) return true;
			if(getTimer() - _lastRecentSendTime < 30000)
			{
				if((ChatManager.Instance.state == ChatManager.CHAT_WEDDINGLIST_STATE ||
					ChatManager.Instance.state == ChatManager.CHAT_DUNGEONLIST_STATE ||
					ChatManager.Instance.state == ChatManager.CHAT_ROOMLIST_STATE ||
					ChatManager.Instance.state == ChatManager.CHAT_HALL_STATE || 
					ChatManager.Instance.state == ChatManager.CHAT_CONSORTIA_CHAT_VIEW ||
					ChatManager.Instance.state == ChatManager.CHAT_CLUB_STATE ||
					ChatManager.Instance.state == ChatManager.CHAT_CIVIL_VIEW ||
					ChatManager.Instance.state == ChatManager.CHAT_TOFFLIST_VIEW ||
					ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_VIEW		
				)&& _channel == CURRENT)
				{
					ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("ddt.view.chat.ChatInputView.channel"));
					return false;
				}else
				{
					_lastRecentSendTime = getTimer();
				}
			}else
			{
				_lastRecentSendTime = getTimer();
			}
			return true;
		}
		
		private function initEvent():void
		{
			_channelListBtn.addEventListener(MouseEvent.CLICK,__onChannelListBtnClicked);
			_channelList.addEventListener(ChatEvent.INPUT_CHANNEL_CHANNGED,__onChannelSelected);
			_inputField.addEventListener(ChatEvent.INPUT_CHANNEL_CHANNGED,__onChannelSelected);
			_inputField.addEventListener(ChatEvent.INPUT_TEXT_CHANGED,__onInputTextChanged);
			_btnEnter.addEventListener(MouseEvent.CLICK,__onEnterClick);
			_friendListBtn.addEventListener(MouseEvent.CLICK,__friendListBtnClick);
			_fastReplyBtn.addEventListener(MouseEvent.CLICK,__fastReplyClick);
			_faceBtn.addEventListener(MouseEvent.CLICK,__faceClick);
			_fastReplyPanel.addEventListener(Event.SELECT,__onFastSelect);
			_faceList.addEventListener(Event.SELECT,__onFaceSelect);
		}
		
		private function initView():void
		{
			_friendListBtn = new HTipButton(friendListBtnAccect,"",LanguageMgr.GetTranslation("ddt.view.chat.ChatInputView.friend"));
			_friendListBtn.useBackgoundPos = true;
			addChild(_friendListBtn);
			
			_faceBtn = new HTipButton(faceBtnAccect,"",LanguageMgr.GetTranslation("ddt.view.chat.ChatInputView.face"));
			_faceBtn.useBackgoundPos = true;
			addChild(_faceBtn);
			
			_fastReplyBtn = new HTipButton(fastReplyBtnAccect,"",LanguageMgr.GetTranslation("ddt.view.chat.ChatInputView.speed"));
			_fastReplyBtn.useBackgoundPos = true;
			addChild(_fastReplyBtn);
			
			_btnEnter = new HTipButton(mc_enter,"",LanguageMgr.GetTranslation("ddt.view.chat.ChatInputView.send"));
			_btnEnter.useBackgoundPos = true;
			addChild(_btnEnter);
			
			_channelListBtn = new HBaseButton(channelListBtnAccect);
			_channelListBtn.useBackgoundPos = true;
			addChild(_channelListBtn);
			
			removeChild(channelListPos);
			_channelList = new ChatChannelListView();
			_channelList.x = channelListPos.x;
			_channelList.y = channelListPos.y;
			addChild(_channelList);
			
			_inputField = new ChatInputField();
			_inputField.x = inputPos.x;
			_inputField.y = inputPos.y;
			_inputField.maxInputWidth = inputPos.width;
			addChild(_inputField);
			
			_friendList = new FriendListView(setPrivateChatTo,false);
			_friendList.visible = false;
			friendListPos.visible = false;
			addChild(_friendList);
			
			_fastReplyPanel = new SceneChatIIFastReply(false);
			_fastReplyPanel.visible = false;
			_fastReplyPanel.x = fastReplayListPos.x;
			_fastReplyPanel.y = fastReplayListPos.y;
			fastReplayListPos.visible = false;
			addChild(_fastReplyPanel);
			
			_faceList = new SceneChatIIFacePanel(false);
			_faceList.visible = false;
			_faceList.x = faceListPos.x;
			_faceList.y = faceListPos.y;
			faceListPos.visible = false;
			addChild(_faceList);
		}
		
		private function panelClickLogic(panel:DisplayObject):void
		{
			SoundManager.instance.play("008");
			panel.visible = true;
			stage.addEventListener(MouseEvent.CLICK,__stagePanelClick);
		}
	}
}