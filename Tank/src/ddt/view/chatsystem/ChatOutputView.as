package ddt.view.chatsystem
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.chat.ChatOutputBgAccect;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HFrameButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.HButton.TogleButton;
	
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	public class ChatOutputView extends ChatOutputBgAccect
	{
		public static const CHAT_OUPUT_CLUB:int = 1;
		public static const CHAT_OUPUT_CURRENT:int = 0;
		public static const CHAT_OUPUT_PRIVATE:int = 2;

		public function ChatOutputView()
		{
			initView();
			initEvent();
		}
		
		private var _btnClub:HFrameButton;
		
		private var _btnNormal:HFrameButton;
		
		private var _btnPrivate:HFrameButton;
		
		private var _channel:int = -1;
		
		private var _channelSelectVisible:Boolean = true;
		
		private var _clearnBtn:HBaseButton;
		
		private var _goBottomBtn:HBaseButton;
		
		private var _isLock:Boolean = false;
		
		private var _leftButtonConatiner:Sprite;
		
		private var _lockBtn:TogleButton;
		
		private var _model:ChatModel;
		
		private var _outputField:ChatOutputField;
		
		private var _scrollDownBtn:HTipButton;
		
		private var _scrollUpBtn:HTipButton;
		
		private var _slink_mc:MovieClip;
		
		private var _timerRollUp:Timer;
		
		private var _timerRolldown:Timer;
		
		private var _currentOffset:int = 0;
		
		public function __mouseOut(e:MouseEvent):void
		{
			_timerRolldown.stop();
			_timerRollUp.stop();
		}
		public function set channel($channel:int):void
		{
			if($channel < 0 || $channel > 2)return;
			if(_channel == $channel)return;
			_channel = $channel;
			updateCurrnetChannel();
		}
		public function set channelSelectVisible(value:Boolean):void
		{
			if(_channelSelectVisible == value)return;
			_channelSelectVisible = value;
			setChannelBtnVisible(value);
		}
		
		public function get contentField():ChatOutputField
		{
			return _outputField;
		}
		
		public function goBottom():void
		{
			_outputField.toBottom();
		}
		
		public function get isLock():Boolean
		{
			return _isLock;
		}
		public function set isLock(value:Boolean):void
		{
			if(_isLock == value)return;
			_isLock = value;
			_lockBtn.selected = _isLock;
			if(parent)parent.mouseEnabled = !_isLock;
			_outputField.mouseEnabled = !_isLock;
			_outputField.mouseChildren = !_isLock;
			mouseEnabled = !_isLock;
			bgAccect.visible = !_isLock;
			setChannelBtnVisible(!value);
		}
		
		public function set lockEnable(value:Boolean):void
		{
			_lockBtn.enable = value;
		}
		
		public function scrollDown(event:TimerEvent = null):void
		{
			if(_currentOffset > 0)
			{
				_currentOffset --;
				updateCurrnetChannel();
			}
		}
		
		public function scrollUp(event:TimerEvent = null):void
		{
			_currentOffset ++;
			updateCurrnetChannel();
		}
		
		public function setChannelBtnVisible(value:Boolean):void
		{
			if(!isInGame()){
				_btnPrivate.visible = value;
				_btnClub.visible = value;
				_btnNormal.visible = value;
			}
		}
		
		public function updateCurrnetChannel():void
		{
			var result:Object = _model.getChatsByOutputChannel(_channel,_currentOffset,6);
			_currentOffset = result["offset"];
			_outputField.setChats(result["result"]);
			goBottom();
			updateShine();
			_btnPrivate.selected = false;
			_btnClub.selected = false;
			_btnNormal.selected = false;
			if(_channel == CHAT_OUPUT_PRIVATE)_btnPrivate.selected = true;
			if(_channel == CHAT_OUPUT_CLUB)_btnClub.selected = true;
			if(_channel == CHAT_OUPUT_CURRENT)_btnNormal.selected = true;
		}
		
		private function __channelPanelSelected(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(event.currentTarget == _btnPrivate)
			{
				channel = CHAT_OUPUT_PRIVATE;
				_slink_mc.visible = false;
				_slink_mc.stop();
			}
			if(event.currentTarget == _btnClub)
			{
				channel = CHAT_OUPUT_CLUB;
				ChatManager.Instance.inputChannel = ChatInputView.CONSORTIA;
			}
			if(event.currentTarget == _btnNormal)
			{
				channel = CHAT_OUPUT_CURRENT;
				ChatManager.Instance.inputChannel = ChatInputView.CURRENT;
			}
		}
		
		private function __clearnClick(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_model.reset();
			updateCurrnetChannel();
			_slink_mc.visible = false;
			_slink_mc.stop();
		}
		
		private function __goBottomClick(event:MouseEvent):void
		{
			//goBottom();
			_currentOffset = 0;
			updateCurrnetChannel();
			SoundManager.Instance.play("008");
		}
		
		private function __lockClick(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			isLock = !isLock;
			if(_channelSelectVisible)setChannelBtnVisible(!_isLock);
		}
		
		private function __onAddChat(event:ChatEvent):void
		{
			
			var addedChatData:ChatData = event.data as ChatData;
			if(addedChatData.channel == ChatInputView.PRIVATE && 
			addedChatData.sender != PlayerManager.Instance.Self.NickName &&
			_channel != CHAT_OUPUT_PRIVATE &&
			_channel != CHAT_OUPUT_CURRENT)
			{
				_slink_mc.visible = true;
				_slink_mc.play();
			}
			if(_model.getInputInOutputChannel(addedChatData.channel,_channel))
			{
				if(_currentOffset == 0)updateCurrnetChannel();
			}
			
		}
		
		private function __onChatScrollChanged(event:ChatEvent):void
		{
//			设置是否闪光
//			goBottomGlow.visible = !_outputField.isBottom();
		}
		
		private function __scrollDownDown(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_timerRolldown.start();
			scrollDown();
		}
		
		private function __scrollDownUp(e:MouseEvent):void
		{
			_timerRolldown.stop();
		}
		
		private function __scrollUpDown(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_timerRollUp.start();
			scrollUp();
		}
		
		private function __scrollUpUp(e:MouseEvent):void
		{
			_timerRollUp.stop();
		}
		
		private function initEvent():void
		{
			_model.addEventListener(ChatEvent.ADD_CHAT,__onAddChat);
			_lockBtn.addEventListener(MouseEvent.CLICK,__lockClick);
			_clearnBtn.addEventListener(MouseEvent.CLICK,__clearnClick);
			_scrollUpBtn.addEventListener(MouseEvent.MOUSE_DOWN,__scrollUpDown);
			_scrollUpBtn.addEventListener(MouseEvent.MOUSE_UP,__scrollUpUp);
			_scrollUpBtn.addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			_scrollDownBtn.addEventListener(MouseEvent.MOUSE_DOWN,__scrollDownDown);
			_scrollDownBtn.addEventListener(MouseEvent.MOUSE_UP,__scrollDownUp);
			_scrollDownBtn.addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			_goBottomBtn.addEventListener(MouseEvent.CLICK,__goBottomClick);
			_outputField.addEventListener(ChatEvent.SCROLL_CHANG,__onChatScrollChanged);
			_outputField.addEventListener(MouseEvent.MOUSE_WHEEL,__onMouseWheel);
			_timerRolldown.addEventListener(TimerEvent.TIMER,scrollDown);
			_timerRollUp.addEventListener(TimerEvent.TIMER,scrollUp);
			_btnPrivate.addEventListener(MouseEvent.CLICK,__channelPanelSelected);
			_btnClub.addEventListener(MouseEvent.CLICK,__channelPanelSelected);
			_btnNormal.addEventListener(MouseEvent.CLICK,__channelPanelSelected);
		}
		
		private function __onMouseWheel(event:MouseEvent):void
		{
			if(event.delta > 0)
			{
				scrollUp();
			}else
			{
				scrollDown();
			}
		}
		
		private function updateShine():void
		{
			goBottomGlow.visible = _currentOffset != 0;
		}
		
		private function initView():void
		{
			_leftButtonConatiner = new Sprite();
			addChild(_leftButtonConatiner);
			
			_lockBtn = new TogleButton(lockAccect,"",LanguageMgr.GetTranslation("ddt.view.chat.MainChatShower.lock"),LanguageMgr.GetTranslation("ddt.view.chat.MainChatShower.off"));
			_lockBtn.useBackgoundPos = true;
			_lockBtn.setX = 5;
			_leftButtonConatiner.addChild(_lockBtn);
			
			_clearnBtn = new HTipButton(setingAccect,"",LanguageMgr.GetTranslation("ddt.view.chat.MainChatShower.clear"));
			_clearnBtn.useBackgoundPos = true;
			_leftButtonConatiner.addChild(_clearnBtn);
			
			_scrollUpBtn = new HTipButton(upBtnAccect,"",LanguageMgr.GetTranslation("ddt.view.chat.MainChatShower.up"));
			_scrollUpBtn.useBackgoundPos = true;
			_leftButtonConatiner.addChild(_scrollUpBtn);
			
			_scrollDownBtn = new HTipButton(downBtnAccect,"",LanguageMgr.GetTranslation("ddt.view.chat.MainChatShower.down"));
			_scrollDownBtn.useBackgoundPos = true;
			_leftButtonConatiner.addChild(_scrollDownBtn);
			
			_goBottomBtn = new HTipButton(bottomBtnAccect,"",LanguageMgr.GetTranslation("ddt.view.chat.MainChatShower.button"));
			_goBottomBtn.useBackgoundPos = true;
			_leftButtonConatiner.addChild(_goBottomBtn);
			
			_btnNormal = new HFrameButton(mc_normal);
			_btnNormal.useBackgoundPos = true;
			addChild(_btnNormal);
			_btnClub = new HFrameButton(mc_club);
			_btnClub.useBackgoundPos = true;
			addChild(_btnClub);
			_btnPrivate = new HFrameButton(mc_private);
			_btnPrivate.useBackgoundPos = true;
			addChild(_btnPrivate);
			
			goBottomGlow.mouseEnabled = false;
			goBottomGlow.mouseChildren = false;
			goBottomGlow.visible = false;
			addChild(goBottomGlow);
			
			_slink_mc = mc_private.slink_mc;
			_slink_mc.visible = false;
			_slink_mc.stop();
			_slink_mc.mouseEnabled = false;
			_slink_mc.mouseChildren = false;
			
			_outputField = new ChatOutputField();
			_outputField.x = 34;
			if(ChatFormats.hasYaHei)
			{
				_outputField.y = 8;
			}else
			{
				_outputField.y = 11;
			}
			addChild(_outputField);
			
			_timerRollUp = new Timer(100);
			_timerRolldown = new Timer(100);
			_model = ChatManager.Instance.model;
		}
		private function isInGame():Boolean
		{
			return bgAccect.currentFrame == 3;
		}

		chat_system function get currentOffset():int
		{
			return _currentOffset;
		}

		chat_system function set currentOffset(value:int):void
		{
			_currentOffset = value;
			updateCurrnetChannel();
		}

	}
}