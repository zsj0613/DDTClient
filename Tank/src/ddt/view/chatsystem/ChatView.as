package ddt.view.chatsystem
{
	import flash.display.Sprite;
	
	import ddt.manager.ChatManager;
	import ddt.utils.Helpers;
	
	use namespace chat_system;
	
	public class ChatView extends Sprite
	{
		public function ChatView()
		{
			initView();
		}

		private var _input:ChatInputView;
		private var _output:ChatOutputView;
		private var _state:int = -1;

		public function getChatViewState():int
		{
			return _state;
		}
		
		public function get input():ChatInputView
		{
			return _input;
		}
		
		public function get output():ChatOutputView
		{
			return _output;
		}
		
		private static const BACKGROUND_HALL:uint = 1;
		private static const BACKGROUND_ROOM_LIST:uint = 2;
		private static const BACKGROUND_ROOM:uint = 2;
		private static const BACKGROUND_DUNGEON_LIST:uint = 4;
		private static const BACKGROUND_LOADING:uint = 2;
		private static const BACKGROUND_GAME:uint = 3;
		private static const BACKGROUND_GAME_OVER:uint = 3;
		private static const BACKGROUND_CHURCH:uint = 1;
		private static const BACKGROUND_CONSORTIA:uint = 2;
		private static const BACKGROUND_CIVIL:uint = 2;
		private static const BACKGROUND_TOFFLIST:uint = 2;
		private static const BACKGROUND_HOTSPRING:uint = 2;
		private static const BACKGROUND_HOTSPRING_ROOM:uint = 1;
		private static const BACKGROUND_CLUB:uint = 2;
		
		public function setChatViewState(state:int):void
		{
			if(_state == state)return;
			_state = state;
			_output.channelSelectVisible = true;
			_output.lockEnable = false;
			_output.contentField.contentWidth = ChatOutputField.NORMAL_WIDTH;
			ChatManager.Instance.visibleSwitchEnable = false;
			_output.isLock=false;
			ChatManager.Instance.setFocus();
			_output.contentField.style = ChatOutputField.NORMAL_STYLE;
			if(_output.contentField.isBottom()) _output.goBottom();
			
			//回到大厅
			if(_state == ChatManager.CHAT_HALL_STATE)
			{
				_input.visible  = true;
				_input.faceEnabled = false;
				_output.lockEnable = true;
				_output.isLock=false;
				_output.bgAccect.gotoAndStop(BACKGROUND_HALL);
				_output.x = 0;
				_output.y = 435;
				_input.y = 570;
				_input.x = 6;
			}
			//房间列表
			else if(_state == ChatManager.CHAT_ROOMLIST_STATE)
			{
				_input.visible  = true;
				_input.faceEnabled = false;
				_output.bgAccect.gotoAndStop(BACKGROUND_ROOM_LIST);
				_output.x = 6;
				_output.y = 430;
				_input.x = 12; 
				_input.y = 565;
			}else if(_state == ChatManager.CHAT_ROOM_STATE || _state == ChatManager.CHAT_DUNGEON_STATE)
			{
				_input.visible  = true;
				_input.faceEnabled = true;
				_output.bgAccect.gotoAndStop(BACKGROUND_ROOM);
				_output.x = 6;
				_output.y = 430;
				_input.y = 565;
				_input.x = 12; 
			}else if(_state == ChatManager.CHAT_DUNGEONLIST_STATE)
			{
				_input.visible  = true;
				_input.faceEnabled = false;
				_output.bgAccect.gotoAndStop(BACKGROUND_DUNGEON_LIST);
				_output.x = 6;
				_output.y = 427;
				_input.x = 12; 
				_input.y = 562;
			}else if(_state == ChatManager.CHAT_GAME_LOADING)
			{
				_input.visible  = true;
				_input.faceEnabled = false;
				_output.bgAccect.gotoAndStop(BACKGROUND_LOADING);
				_output.x = 6;
				_output.y = 430;
				_input.y = 565;
				_input.x = 12; 
			}else if(_state == ChatManager.CHAT_GAME_STATE)
			{
				_output.channelSelectVisible = false;
				_output.contentField.style = ChatOutputField.GAME_STYLE;
				ChatManager.Instance.visibleSwitchEnable = true;
				_input.faceEnabled = true;
				_input.visible = false;
				_output.lockEnable = true;
				_output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
				_output.bgAccect.gotoAndStop(BACKGROUND_GAME);
				_output.x = 3;
				_output.y = 140;
				_input.y = 480;
				_input.x = 280; 
				
			}else if( _state == ChatManager.CHAT_GAMEOVER_STATE)
			{
				_output.channelSelectVisible = false;
				_output.contentField.style = ChatOutputField.GAME_STYLE;
				ChatManager.Instance.visibleSwitchEnable = true;
				_input.faceEnabled = false;
				_output.lockEnable = true;
				_output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
				_output.bgAccect.gotoAndStop(BACKGROUND_GAME_OVER);
				_output.x = 0;
				_output.y = 380;
				_input.y = 480;
				_input.x = 280; 
			}
			else if(_state == ChatManager.CHAT_CLUB_STATE)
			{
				_input.visible  = true;
				_input.faceEnabled = false;
				_output.bgAccect.gotoAndStop(BACKGROUND_CLUB);
				_output.x = 12;
				_output.y = 408;
				_input.y = 541;
				_input.x = 18;
			}else if(_state == ChatManager.CHAT_CHURCH_CHAT_VIEW)
			{
				_input.visible  = true;
				_output.lockEnable = true;
				_input.faceEnabled = true;
				_output.bgAccect.gotoAndStop(BACKGROUND_CHURCH);
				_output.x = 0;
				_output.y = 425;
				_input.y = 560;
				_input.x = 6; 
			}else if(_state == ChatManager.CHAT_CONSORTIA_CHAT_VIEW)
			{
				_input.visible  = true;
				_input.faceEnabled = false;
				_output.bgAccect.gotoAndStop(BACKGROUND_CONSORTIA);
				_output.x = 0;
				_output.y = 425;
				_input.y = 560;
				_input.x = 6; 
			}else if(_state == ChatManager.CHAT_CIVIL_VIEW)
			{
				_input.visible  = true;
				_input.faceEnabled = false;
				_output.bgAccect.gotoAndStop(BACKGROUND_CIVIL);
				_output.x = 0;
				_output.y = 425;
				_input.y = 560;
				_input.x = 6; 
			}
			else if(_state == ChatManager.CHAT_TOFFLIST_VIEW)
			{
				_input.faceEnabled = false;
				_output.bgAccect.gotoAndStop(BACKGROUND_TOFFLIST);
				_output.x = 9;
				_output.y = 425;
				_input.y = 560;
				_input.x = 15; 
			}
			else if(_state == ChatManager.CHAT_HOTSPRING_VIEW)
			{
				_input.faceEnabled = false;
				_output.bgAccect.gotoAndStop(BACKGROUND_HOTSPRING);
				_output.isLock=false;
				_output.x = 5;
				_output.y = 424;
				_input.y = 559;
				_input.x = 11; 
			}
			else if(_state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW || _state == ChatManager.CHAT_HOTSPRING_ROOM_GOLD_VIEW)
			{
				_input.visible  = true;
				_output.lockEnable = true;
				_output.isLock=false;
				_input.faceEnabled = true;
				_output.bgAccect.gotoAndStop(BACKGROUND_HOTSPRING_ROOM);
				_output.x = 0;
				_output.y = 434;
				_input.y = 569;
				_input.x = 6;
			}
			
			_output.setChannelBtnVisible(!_output.isLock);
			ChatManager.Instance.setFocus();
			_output.goBottom();
		}
		
		private function initView():void
		{
			_input = new ChatInputView();
			_output = new ChatOutputView();
			addChild(_output);
			addChild(_input);
		}
	}
}