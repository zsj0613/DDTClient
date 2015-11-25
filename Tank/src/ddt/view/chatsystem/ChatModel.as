package ddt.view.chatsystem
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.PlayerManager;

	public final class ChatModel extends EventDispatcher
	{
		private static const OVERCOUNT:int = 200;

		public function ChatModel()
		{
			reset();
		}

		private var _clubChats:Array;
		private var _currentChats:Array;
		private var _privateChats:Array;
		private var _resentChats:Array;
		
		private var _linkInfoMap:Dictionary;

		public function addChat(data:ChatData):void
		{
			tryAddToCurrentChats(data);
			tryAddToRecent(data);
			tryAddToClubChats(data);
			tryAddToPrivateChats(data);
			dispatchEvent(new ChatEvent(ChatEvent.ADD_CHAT,data));
		}
		
		public function get clubChats():Array
		{
			return _clubChats;
		}
		
		public function get currentChats():Array
		{
			return _currentChats;
		}
		public function addLink(itemID:int,info:ItemTemplateInfo):void
		{
			_linkInfoMap[itemID]=info;
		}
		public function getLink(itemID:int):ItemTemplateInfo
		{
			return _linkInfoMap[itemID];
		}
		public function removeAllLink():void
		{
			_linkInfoMap=new Dictionary();
		}
		public function getChatsByOutputChannel(channel:int,offset:int,count:int):Object
		{
			offset = offset < 0 ? 0: offset;
			var list:Array = [];
			if(channel == ChatOutputView.CHAT_OUPUT_CURRENT)
			{
				list = _currentChats;
			}else if(channel == ChatOutputView.CHAT_OUPUT_CLUB)
			{
				list = _clubChats;
			}else if(channel == ChatOutputView.CHAT_OUPUT_PRIVATE)
			{
				list = _privateChats;
			}
			if(list.length <= count)
			{
				return {offset:0, result:list};
			}
			else if(list.length <= count + offset)
			{
				return {offset:list.length - count, result:list.slice(0,count)};
			}
			else
			{
				return {offset:offset,result:list.slice(list.length - count - offset,list.length - offset)};
			}
		}
		
		public function getInputInOutputChannel(inputChannel:int,outputChannel:int):Boolean
		{
			if(outputChannel == ChatOutputView.CHAT_OUPUT_CLUB)
			{
				switch(inputChannel)
				{
					case ChatInputView.CONSORTIA:
					case ChatInputView.SYS_NOTICE:
					case ChatInputView.SYS_TIP:
					case ChatInputView.BIG_BUGLE:
					case ChatInputView.SMALL_BUGLE:
					case ChatInputView.DEFY_AFFICHE:
					case ChatInputView.CROSS_BUGLE:
						return true;
						break;
				}
			}else if(outputChannel == ChatOutputView.CHAT_OUPUT_PRIVATE)
			{
				switch(inputChannel)
				{
					case ChatInputView.PRIVATE:
					case ChatInputView.SYS_NOTICE:
					case ChatInputView.SYS_TIP:
					case ChatInputView.BIG_BUGLE:
					case ChatInputView.SMALL_BUGLE:
					case ChatInputView.DEFY_AFFICHE:
					case ChatInputView.CROSS_BUGLE:
						return true;
						break;
				}
			}else if(outputChannel == ChatOutputView.CHAT_OUPUT_CURRENT)
			{
				return true;
			}
			return false;
		}
		
		public function get privateChats():Array
		{
			return _privateChats;
		}
		
		public function get resentChats():Array
		{
			return _resentChats;
		}
		
		public function reset():void
		{
			_currentChats = [];
			_clubChats = [];
			_privateChats = [];
			_resentChats = [];
			_linkInfoMap = new Dictionary();
		}
		
		
		private function checkOverCount(chatDatas:Array):void
		{
			if(chatDatas.length > OVERCOUNT)chatDatas.shift();
		}
		
		private function tryAddToClubChats(data:ChatData):void
		{
			if(getInputInOutputChannel(data.channel,ChatOutputView.CHAT_OUPUT_CLUB))
			{
				_clubChats.push(data);
			}
			checkOverCount(_clubChats);
		}
		
		private function tryAddToCurrentChats(chats:ChatData):void
		{
			_currentChats.push(chats);
			checkOverCount(_currentChats);
		}
		
		private function tryAddToPrivateChats(data:ChatData):void
		{
			if(getInputInOutputChannel(data.channel,ChatOutputView.CHAT_OUPUT_PRIVATE))
			{
				_privateChats.push(data);
			}
			checkOverCount(_privateChats);
		}
		
		private function tryAddToRecent(data:ChatData):void
		{
			if(data.sender == PlayerManager.Instance.Self.NickName)
			{
				_resentChats.push(data);
			}
			checkOverCount(_resentChats);
		}
	}
}