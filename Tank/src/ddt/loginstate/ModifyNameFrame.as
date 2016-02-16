package ddt.loginstate
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HFrame;
	import road.utils.StringHelper;
	
	import tank.loading.ModifyNameFrameAsset;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.request.LoadRenameConsortiaName;
	import ddt.request.LoadRenameNick;

	public class ModifyNameFrame extends HFrame
	{
		private var _asset:ModifyNameFrameAsset;
		private var _tipText:TextField;
		private var _warnText:TextField;
		private var _tipTextFormat:TextFormat;
		private var _warnTextFormat:TextFormat;
		private var _inputText:TextField;
		private var _info:Object;
		private var _modifyBtn:HBaseButton;
		public function ModifyNameFrame(info:Object)
		{
			super();
			_info = info;
			init();
		}
		
		private function init():void
		{
			showClose = false;
			showBottom = false;
			centerTitle = true;
			moveEnable = false;
			
			setSize(376,230);
			_asset = new ModifyNameFrameAsset();
			_asset.x = 16;
			_asset.y = 77;
			addChild(_asset);
			
			_tipText = creatTextField();
			_tipText.defaultTextFormat = creatTextFormat(0x50300f);
			_tipText.wordWrap = true;
			_tipText.width = 330;
			_tipText.x = 23;
			_tipText.y = 43;
			_tipText.mouseEnabled = false;
			_tipText.selectable   = false;
			_tipText.filters = creatFilter();
			addChild(_tipText);
			_warnText = creatTextField();
			_warnText.y = 130;
			_warnText.mouseEnabled = false;
			_warnText.selectable   = false;
			_warnText.defaultTextFormat = creatTextFormat(0xf91900);
			_warnText.filters = creatFilter();
			addChild(_warnText);
			
			_inputText = creatTextField();
			_inputText.type = TextFieldType.INPUT;
			_inputText.autoSize = TextFieldAutoSize.NONE;
			_inputText.multiline = false;
			_inputText.width = 150;
			_inputText.height = 35;
			_inputText.x = 102;
			_inputText.y = 96;
			_inputText.defaultTextFormat = creatTextFormat(0x000000);
			_inputText.text = "请输入用户名!";
			_inputText.restrict = "a-z 0-9 ([\u4e00-\u9fa5]*)  -~^ ";
			addChild(_inputText);
			_inputText.addEventListener(TextEvent.TEXT_INPUT,  __inputTextHandler);
			_inputText.addEventListener(FocusEvent.FOCUS_IN,   __getTextFocusHandler);
			_inputText.addEventListener(FocusEvent.FOCUS_OUT,  __outTextFocusHandler);
			_modifyBtn = new HBaseButton(_asset.modifyBtnAsset,"");
			_modifyBtn.useBackgoundPos = true;
			_asset.addChild(_modifyBtn);
			
			setWarnText("请输入用户名!");
			_modifyBtn.addEventListener(MouseEvent.CLICK,modifyClicked);
		}
		
		override protected function __addToStage(e:Event):void
		{
//			stage.focus = _inputText;
            blackGound = false;
            blackGound = true;
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				SoundManager.Instance.play("008");
				commitName();
			}
			else if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				dispose();
			}
		}
		
		private function modifyClicked(e:MouseEvent):void
		{
			commitName();
		}
		//获得焦点时
		private function __getTextFocusHandler(evt : FocusEvent) : void
		{
			if(!textFouceHandler())
			{
				_inputText.text = "";
				_inputText.stage.focus = _inputText;
			}
		}
		//失去焦点时
		private function __outTextFocusHandler(evt : FocusEvent) : void
		{
			if(_inputText.text != "")return;
			if(_state == NICKNAME_MODIFY)
			{
				_inputText.text = "请输入角色名!";
			}
			else
			{
				_inputText.text = "请输入公会名!";
			}
		}
		//更改文本时
		private function __inputTextHandler(evt : TextEvent) : void
		{
			if(_state == NICKNAME_MODIFY)
			{
				StringHelper.checkTextFieldLength(_inputText,14);
			}
			else
			{
				StringHelper.checkTextFieldLength(_inputText,12);
			}
			if(!textFouceHandler())_inputText.text = "";
			_modifyBtn.enable = true;
		}
		
		public function commitName():void
		{
			SoundManager.Instance.play("008");
			if(!textFouceHandler())
			{
				_inputText.text = "";
				_inputText.stage.focus = _inputText;
			}
			var nameText:String = StringHelper.trim(_inputText.text);
			if(_state == NICKNAME_MODIFY)
			{
				if(nameInputCheck())
				{
					new LoadRenameNick(PlayerManager.Instance.Account,_info.NickName,nameText).loadSync(onChangeNickNameReturn);
				}else
				{
					_modifyBtn.enable = false;
				}
			}else
			{
				if(nameInputCheck())
				{
					new LoadRenameConsortiaName(PlayerManager.Instance.Account,_info.NickName,nameText).loadSync(onChangeConsortiaNameReturn);
				}else
				{
					_modifyBtn.enable = false;
				}
			}
		}
		
		public function nameInputCheck():Boolean
		{
			if(_inputText.text != "")
			{
				if(FilterWordManager.isGotForbiddenWords(_inputText.text,"name"))
				{
					setWarnText(LanguageMgr.GetTranslation("ddt.loginstate.inputInvalidate"));
					return false;
				}
				if(FilterWordManager.IsNullorEmpty(_inputText.text))
				{
					setWarnText(LanguageMgr.GetTranslation("ddt.loginstate.allNull"));
					return false;
					
				}
				if(FilterWordManager.containUnableChar(_inputText.text))
				{
					setWarnText(LanguageMgr.GetTranslation("ddt.loginstate.inputInvalidate"));
					return false;
				}
				return true;
			}
			setWarnText(LanguageMgr.GetTranslation("ddt.loginstate.inputNickName"));
			return false;
			
		}
		
		private function onChangeNickNameReturn(loader:*):void
		{
			_modifyBtn.enable = true;
			if(loader.isSuccess)
			{
				_info.NameChanged = true;
				dispatchEvent(new Event(Event.COMPLETE));
				dispose();
			}else
			{
				setWarnText(loader.errMsg);
			}
		}
		
		private function onChangeConsortiaNameReturn(loader:*):void
		{
			_modifyBtn.enable = true;
			if(loader.isSuccess)
			{
				_info.ConsortiaNameChanged = true;
				dispatchEvent(new Event(Event.COMPLETE));
				dispose();
			}else
			{
				setWarnText(loader.errMsg);
			}
		}
		
		private function setWarnText(msg:String):void
		{
			_warnText.text = msg;this.
			_warnText.x = (_inputText.width-_warnText.textWidth)/2+_inputText.x;
		}
		
		public static const NICKNAME_MODIFY:int = 0;
		public static const GUILD_MODIFY:int = 1;
		private var _state:int = NICKNAME_MODIFY;
		public function set state (s:int):void
		{
			_state = s;
			if(_state == NICKNAME_MODIFY)
			{
				var NickName : String = _info.NickName.toString();
				if(NickName.indexOf("$") != -1)
				NickName = NickName.substr(0,NickName.indexOf("$"));
				_tipText.text = LanguageMgr.GetTranslation("ddt.loginstate.characterNameExist",NickName);
				titleText = LanguageMgr.GetTranslation("ddt.loginstate.characterModify");
				_inputText.text = LanguageMgr.GetTranslation("ddt.loginstate.inputCharacterName");
				setWarnText(LanguageMgr.GetTranslation("ddt.loginstate.inputCharacterName"));
			}else
			{
				var consortiaName : String = _info.ConsortiaName.toString();
				if(consortiaName.indexOf("$") != -1)
				consortiaName = consortiaName.substr(0,consortiaName.indexOf("$"));
				_tipText.text = LanguageMgr.GetTranslation("ddt.loginstate.guildNameExist",consortiaName);
				titleText = LanguageMgr.GetTranslation("ddt.loginstate.guildNameModify");
				_inputText.text = LanguageMgr.GetTranslation("ddt.loginstate.inputGuildName");
				setWarnText(LanguageMgr.GetTranslation("ddt.loginstate.inputGuildName"));
			}
		}
		private function textFouceHandler() : Boolean
		{
			if(_inputText.text == LanguageMgr.GetTranslation("ddt.loginstate.inputGuildName"))
			{
				return false;
			}
			if(_inputText.text == LanguageMgr.GetTranslation("ddt.loginstate.inputCharacterName"))
			{
				return false;
			}
			return true;
		}
		
		private function creatTextField():TextField
		{
			var tf:TextField = new TextField;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			return tf;
		}
		
		private function creatTextFormat(color:int):TextFormat
		{
			var format:TextFormat = new TextFormat(null,14,color,true);
			return format;
		}
		
		private function creatFilter():Array
		{
			var filter:GlowFilter = new GlowFilter(0xffffff,1,2,2,10);
			return [filter];
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_inputText)
			{
				_inputText.removeEventListener(FocusEvent.FOCUS_IN,   __getTextFocusHandler);
				_inputText.removeEventListener(TextEvent.TEXT_INPUT,  __inputTextHandler);
				_inputText.removeEventListener(FocusEvent.FOCUS_OUT,  __outTextFocusHandler);
			}
			if(_modifyBtn)_modifyBtn.removeEventListener(MouseEvent.CLICK,      modifyClicked);
			removeEventListener(KeyboardEvent.KEY_DOWN,                         onKeyDown);
			if(this.parent)this.parent.removeChild(this);
		}
	}
}