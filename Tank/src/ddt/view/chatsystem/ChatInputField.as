package ddt.view.chatsystem
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	import road.utils.StringHelper;
	
	import ddt.manager.ChatManager;
	import ddt.manager.FilterWordManager;
	import ddt.manager.IMEManager;
	import ddt.manager.LanguageMgr;
	import ddt.utils.Helpers;
	import ddt.view.common.BellowStripViewII;

	public class ChatInputField extends Sprite
	{
		public static const INPUT_MAX_CHAT:int = 100;
		private static const CHANNEL_KEY_SET:Array = ["d","x","w","g","p","s","k"];
		private static const CHANNEL_SET:Array = [0,1,2,3,4,5,12];//对应CHANNEL_KEY_SET，表示对应channel

		public function ChatInputField()
		{
			initView();
		}
		
		private var _channel:int = -1;
		private var _currentHistoryOffset:int = 0;
		private var _inputField:TextField;
		private var _maxInputWidth:Number;
		private var _nameTextField:TextField;
		private var _old_focus:InteractiveObject;
		private var _privateChatName:String;
		private var _userID:int;
		
		public function get channel():int
		{
			return _channel;
		}
		public function set channel(channel:int):void
		{
			if(_channel == channel)return;
			_channel = channel;
			setPrivateChatName("");
			setTextFormat(ChatFormats.getTextFormatByChannel(_channel));
		}
		public function isFocus():Boolean
		{
			var isF:Boolean;
			if(stage)
			{
				isF = (stage.focus == _inputField);
			}
			return isF;
		}
		
		public function set maxInputWidth($width:Number):void
		{
			_maxInputWidth = $width;
			updatePosAndSize();
		}
		
		public function get privateChatName():String
		{
			return _privateChatName;
		}
		
		public function get privateUserID():int
		{
			return _userID;
		}
		
		public function sendCurrnetText():void
		{
			var allLowString:String = _inputField.text.toLocaleLowerCase();
			if(allLowString.indexOf("/") == 0)
			{
				for(var i:int = 0;i<CHANNEL_KEY_SET.length;i++)
				{
					if(allLowString.indexOf("/"+CHANNEL_KEY_SET[i]) == 0)
					{
						SoundManager.Instance.play("008");
						_inputField.text = allLowString.substring(2);
						dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED,CHANNEL_SET[i]));
						
						//return;
					}
				}
			}
			if(allLowString.substr(0,2)!= "/"+CHANNEL_KEY_SET[2])
			{
				var msgs:String = parasMsgs(_inputField.text);
				_inputField.text = "";
				if(msgs == "")return;
				dispatchEvent(new ChatEvent(ChatEvent.INPUT_TEXT_CHANGED,msgs));
			}
		}
		public function setFocus():void
		{
			if(stage)
			{
				setTextFocus();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,__onAddToStage);
			}
		}
		
		public function setInputText(text:String):void
		{
			_inputField.text = text;
		}
		public function setPrivateChatName(name:String,useID:int = 0):void
		{
			if(_privateChatName == name)return;
			_privateChatName = name;
			_userID = useID;
			if(_privateChatName != "")
			{
				_nameTextField.text = LanguageMgr.GetTranslation("ddt.view.chat.ChatInput.usernameField.text",_privateChatName);
			}else
			{
				_nameTextField.text = "";
			}
			updatePosAndSize();
		}
		
		public function unFocus():void
		{
			if(stage)stage.focus = null;
		}
		private function __onAddToStage(e:Event):void
		{
			setTextFocus();
			removeEventListener(Event.ADDED_TO_STAGE,arguments.callee);
		}
		
		private function __onFieldKeyDown(event:KeyboardEvent):void
		{
			if(isFocus())
			{
				event.stopImmediatePropagation();
				event.stopPropagation();
				if(event.keyCode == Keyboard.UP)
				{
					currentHistoryOffset --;
					_inputField.text = getHistoryChat(currentHistoryOffset);
					_inputField.addEventListener(Event.ENTER_FRAME,__setSelectIndexSync);
					
				}else if(event.keyCode == Keyboard.DOWN)
				{
					currentHistoryOffset ++;
					_inputField.text = getHistoryChat(currentHistoryOffset);
				}
				
			}
			
			//BellowStrip 快捷键   add by Freeman
//			if(!isFocus(event.shiftKey)){
//				BellowStripViewII.Instance.__hotKeyPressed(event);
//			}
			//BellowStrip 快捷键   add by Freeman
			
			
			if(event.keyCode == Keyboard.ENTER)
			{
				//聊天框可见并且包含文字
				if(_inputField.text != "" && parasMsgs(_inputField.text) != "" && ChatManager.Instance.input.visible)
				{
					//聊天框有焦点时, 发出信息,否则让聊天框获得焦点
					if(isFocus()){
						if(ChatManager.Instance.state != ChatManager.CHAT_SHOP_STATE)
						{
							SoundManager.Instance.play("008");
							sendCurrnetText();
							_currentHistoryOffset = ChatManager.Instance.model.resentChats.length;
						}
					} else {
						if(ChatManager.Instance.input.visible)
						{
							ChatManager.Instance.setFocus();
						}
					}
				}else
				{
//					if(ChatManager.Instance.visibleSwitchEnable)
//					{
						ChatManager.Instance.switchVisible();
						if(ChatManager.Instance.input.visible)
						{
							ChatManager.Instance.setFocus();
						}
						if(ChatManager.Instance.visibleSwitchEnable)
						{
							SoundManager.Instance.play("008");
						}
//					}
				}
			}
			if(ChatManager.Instance.input.visible)
			{
				if(ChatManager.Instance.visibleSwitchEnable)
				{
					IMEManager.enable();
				}
			}
		}
		private function __onInputFieldChange(e:Event):void
		{
			if(_inputField.text)
			{
				_inputField.text=_inputField.text.replace("\n","").replace("\r","");
			}
		}
		
		private function __setSelectIndexSync(event:Event):void
		{
			_inputField.removeEventListener(Event.ENTER_FRAME,__setSelectIndexSync);
			_inputField.setSelection(_inputField.text.length,_inputField.text.length);
		}
		
		private function get currentHistoryOffset():int
		{
			return _currentHistoryOffset;
		}
		private function set currentHistoryOffset(value:int):void
		{
			if(value < 0)value = 0;
			if(value > ChatManager.Instance.model.resentChats.length - 1)
			{
				value = ChatManager.Instance.model.resentChats.length - 1;
			}
			_currentHistoryOffset = value;
		}
		
		
		
		private function getHistoryChat(chatOffset:int):String
		{
			if(chatOffset == -1) return "";
			return Helpers.deCodeString(ChatManager.Instance.model.resentChats[chatOffset].msg);
		}
		
		private function initEvent(event:Event = null):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,__onFieldKeyDown,false,int.MAX_VALUE);
		}
		private function initView():void
		{
			_nameTextField = new TextField();
			_nameTextField.type = TextFieldType.DYNAMIC;
			_nameTextField.mouseEnabled = false;
			_nameTextField.selectable = false;
			_nameTextField.autoSize = TextFieldAutoSize.LEFT;
			addChild(_nameTextField);
			
			_inputField = new TextField();
			_inputField.type = TextFieldType.INPUT;
			_inputField.autoSize = TextFieldAutoSize.NONE;
			_inputField.multiline = false;
			_inputField.wordWrap = false;
			_inputField.maxChars = INPUT_MAX_CHAT;
			addChild(_inputField);
			addEventListener(Event.ADDED_TO_STAGE,initEvent);
			_inputField.addEventListener(Event.CHANGE,__onInputFieldChange);
		}
		private function parasMsgs(fieldText:String):String
		{
			var result:String = fieldText;
			result = StringHelper.trim(result);
			result = FilterWordManager.filterWrod(result);
			result = StringHelper.rePlaceHtmlTextField(result);
			return result;
		}
		private function setTextFocus():void
		{
			_old_focus=stage.focus;
			stage.focus = _inputField;
			_inputField.setSelection(_inputField.text.length,_inputField.text.length);
		}
		
		private function setTextFormat(textFormat:TextFormat):void
		{
			_nameTextField.defaultTextFormat = textFormat;
			_nameTextField.setTextFormat(textFormat);
			_inputField.defaultTextFormat = textFormat;
			_inputField.setTextFormat(textFormat);
		}
		
		private function updatePosAndSize():void
		{
			_inputField.x = _nameTextField.textWidth;
			if(_nameTextField.textWidth > _maxInputWidth) return;
			_inputField.width = _maxInputWidth - _nameTextField.textWidth;
		}
	}
}