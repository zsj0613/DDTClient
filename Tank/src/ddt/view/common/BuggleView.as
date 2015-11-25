package ddt.view.common
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.common.BugleAsset;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.utils.Helpers;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatEvent;
	import ddt.view.chatsystem.ChatFormats;
	import ddt.view.chatsystem.ChatInputView;

	public class BuggleView extends BugleAsset
	{
		private static var _instance:BuggleView;
		private var _timer:Timer;
		private var _isplayer:Boolean;
		/* 喇叭，公告队列 */
		private var _bugleList:Array;
		private var _currentBugle:String;
		private var _currentBugleType:int;
		
		public function BuggleView()
		{
			super();
			mouseChildren= false;
			mouseEnabled = false;
			bugle_mc.mouseEnabled = false;
			content_txt.mouseEnabled = false;
		}
		
		public function setup():void
		{
			_timer = new Timer(55);
			_isplayer = false;
			_bugleList = [];
			x = 4;
			y = 12;
			_currentBugleType = -1;
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_timer.addEventListener(TimerEvent.TIMER,__timer);
			ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,__onAddChat);
		}
		
		private function __onAddChat(event:ChatEvent):void
		{
			if(ChatManager.Instance.state == ChatManager.CHAT_WEDDINGROOM_STATE ||
				ChatManager.Instance.state == ChatManager.CHAT_CHURCH_CHAT_VIEW ||
				ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW
			)return;
			var o:ChatData = event.data as ChatData;
			var result:String = "";
			var chatMsg:String = o.msg.replace("&lt;","<").replace("&gt;",">");
			chatMsg = Helpers.deCodeString(chatMsg);
			if(o.link)
			{
				var offset:int=0;
				o.link.sortOn("index");
				for each(var i:Object in o.link)
				{
					var ItemID:Number=i.ItemID;
					var TemplateID:int=i.TemplateID;
					var info:ItemTemplateInfo=ItemManager.Instance.getTemplateById(TemplateID);
					var index:uint=i.index+offset;
					chatMsg=chatMsg.substring(0,index)+"["+info.Name+"]"+chatMsg.substring(index);
					
					offset+=info.Name.length;
				}
			}
			if(o.channel == ChatInputView.SMALL_BUGLE)
			{
				result = "s                                                                                                                                                                                                              [" + o.sender + LanguageMgr.GetTranslation("ddt.view.common.BuggleView.small") + chatMsg + "              ";
			}else if(o.channel == ChatInputView.BIG_BUGLE)
			{
				result = "b                                                                                                                                                                                                      [" + o.sender + LanguageMgr.GetTranslation("ddt.view.common.BuggleView.big") + chatMsg + "                       ";
			}else if(o.channel == ChatInputView.CROSS_BUGLE)
			{
				result = "c                                                                                                                                                                                                      [" + o.sender + LanguageMgr.GetTranslation("ddt.view.common.BuggleView.cross") + chatMsg + "                       ";
			}else if(o.channel == ChatInputView.DEFY_AFFICHE)
			{
				result = "d                                                                                                                                                                                                      " + chatMsg +"              ";
			}else if((o.channel == ChatInputView.SYS_NOTICE)||(o.channel == ChatInputView.SYS_TIP))
			{
				if(o.type == 1)
				{
					result = LanguageMgr.GetTranslation("ddt.view.common.BuggleView.news") + chatMsg + LanguageMgr.GetTranslation("ddt.view.common.BuggleView.news2") + chatMsg + "              ";
				}
				else
				{
					return;
				}
			}else
			{
				return;
			}
			_bugleList.push(result);
			checkPlay();
		}
		
		private function __timer(evt:TimerEvent):void
		{
			if(_currentBugle == "")
			{
				_isplayer = false;
				_timer.stop();
				checkPlay();
			}
			else
			{
				if(content_txt.text != "")
				{
					if(content_txt.getCharBoundaries(0) == null)
					{
						_currentBugle = "";
						SocketManager.Instance.out.sendErrorMsg("Bugle bugleText:" + content_txt.text + "    length:" + content_txt.length);
					}
					else if(content_txt.getCharBoundaries(0).width < 5)
						_currentBugle = _currentBugle.slice(1);
					else if(content_txt.getCharBoundaries(0).width < 10)
						_currentBugle = " " + _currentBugle.slice(1);
					else
						_currentBugle = "   " + _currentBugle.slice(1);	
				}	
				content_txt.text = _currentBugle;
			}
		}
		
		private function checkPlay():void
		{
			if(_isplayer)return;
			if(_bugleList.length > 0)
			{
				var s:String = _bugleList.splice(0,1)[0];
				var ss:String = s.slice(0,1);
				_currentBugleType = 1;
				if(ss == "s")_currentBugleType = 2;
				else if(ss == "y")_currentBugleType = 3;
				else if(ss == "d")_currentBugleType = 3;
				else if(ss == "c")_currentBugleType = 4;
				bugle_mc.gotoAndStop(_currentBugleType);
				if(_currentBugleType == 1)
				{
					content_txt.textColor = ChatFormats.getColorByChannel(ChatInputView.BIG_BUGLE);
				}
				else if(_currentBugleType == 2)
				{
					content_txt.textColor = ChatFormats.getColorByChannel(ChatInputView.SMALL_BUGLE);
				}
				else if(_currentBugleType == 3 && ss == "y")
				{
					content_txt.textColor = ChatFormats.getColorByChannel(ChatInputView.ADMIN_NOTICE);
				}
				else if(_currentBugleType == 3 && ss == "d")
				{
					content_txt.textColor = ChatFormats.getColorByChannel(ChatInputView.DEFY_AFFICHE);
				}
				else if(_currentBugleType == 4 && ss == "c")
				{
					content_txt.textColor = ChatFormats.getColorByChannel(ChatInputView.CROSS_BUGLE);
				}
				_currentBugle = s.slice(1);
				_isplayer = true;
				_timer.reset();
				_timer.start();
				show();
			}
			else
			{
				hide();
			}
		}
		
		public function show():void
		{
			if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.SHOP || (StateManager.currentStateType == StateType.HOT_SPRING_ROOM && ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW)) return;
			if(StateManager.currentStateType == StateType.TRAINER || StateManager.currentStateType == StateType.LODING_TRAINER) return;
			if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW) return;
			if(_currentBugleType == 3)
			{
				
				TipManager.AddToLayerNoClear(this);
				return;
			}
			
			if(SharedManager.Instance.showTopMessageBar)
			{
				TipManager.AddToLayerNoClear(this);
			}
			else hide();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public static function get instance():BuggleView
		{
			if(_instance == null)
			{
				_instance = new BuggleView();
			}
			return _instance;
		}
	}
}