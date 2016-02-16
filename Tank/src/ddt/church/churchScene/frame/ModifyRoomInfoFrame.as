package ddt.church.churchScene.frame
{
	import ddt.church.churchScene.SceneControler;
	
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_21;
	import tank.church.ModifyRoomInfoAsset;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.utils.DisposeUtils;
	
	public class ModifyRoomInfoFrame extends HConfirmFrame
	{
		private var _bg:ModifyRoomInfoAsset;
		private var _assetBg : ScaleBMP_21;
		
		private var _name_txt:TextInput;
		private var _pass_check:HCheckBox;
		private var _pass_txt:TextInput;
		private var _remark_txt:TextArea;
		
		private var passwordTextGray:Sprite;
		
		private var _controler:SceneControler;
		
		public function ModifyRoomInfoFrame(controler:SceneControler)
		{
			this._controler = controler;
			this.titleText = LanguageMgr.GetTranslation("church.churchScene.frame.ModifyRoomInfoFrame.titleText");
			//this.titleText = "房间设置";
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.buttonGape = 100;
			this.setContentSize(275,419);
			
			this.okFunction =__confirm ;
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			_bg = new ModifyRoomInfoAsset();
			addContent(_bg,true);
			
			_assetBg = new ScaleBMP_21();
			ComponentHelper.replaceChild(_bg,_bg.BgPos,_assetBg);
			
			_name_txt = new TextInput();
			_name_txt.setStyle("textFormat",new TextFormat(null,14,0x000000,true));
			_name_txt.setStyle("upSkin",new Sprite());
			_name_txt.maxChars = 20;
			_name_txt.text = ChurchRoomManager.instance.currentRoom.roomName;
			ComponentHelper.replaceChild(_bg,_bg.name_pos,_name_txt);
			
			_bg.pass_mc.y = -2;
			_pass_check = new HCheckBox("",_bg.pass_mc);
			_pass_check.labelGape = 2;
			_pass_check.fireAuto = true;
			_pass_check.buttonMode = true;
			_pass_check.x = _bg.checkBox_pos.x;
			_pass_check.y = _bg.checkBox_pos.y;
			_pass_check.width +=2;
			_bg.addChild(_pass_check);
			_bg.checkBox_pos.visible = false;
			
			_pass_txt = new TextInput();
			_pass_txt.displayAsPassword = true;
			_pass_txt.maxChars = 6;
			_pass_txt.setStyle("textFormat",new TextFormat(null,12,0x000000,true));
			ComponentHelper.replaceChild(_bg,_bg.password_pos,_pass_txt);
			
			_remark_txt = new TextArea();
			_remark_txt.setStyle("upSkin",new Sprite());
			_remark_txt.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 16;
			format.color = 0x000000;
			format.leading = 4;
			_remark_txt.setStyle("disabledTextFormat",format);
			_remark_txt.setStyle("textFormat",format);
			_remark_txt.setSize(_bg.remark_pos.width,_bg.remark_pos.height);
			_remark_txt.textField.defaultTextFormat = new TextFormat("Arial",16,0x013465);
			_remark_txt.x = _bg.remark_pos.x;
			_remark_txt.y = _bg.remark_pos.y;
			_bg.addChild(_remark_txt);
			_remark_txt.maxChars = 300;
			onRemarkChange(null);
			
			passwordTextGray = new Sprite();
			passwordTextGray.graphics.beginFill(0x999997);
			passwordTextGray.graphics.drawRect(0,0,_bg.password_pos.width,_bg.password_pos.height);
			passwordTextGray.graphics.endFill();
			passwordTextGray.visible = true;
			passwordTextGray.x = _bg.password_pos.x;
			passwordTextGray.y = _bg.password_pos.y;
			_bg.addChild(passwordTextGray);
		}
		
		private function addEvent():void
		{
			_pass_check.addEventListener(Event.CHANGE,__passCheckClick);
			_remark_txt.addEventListener(Event.CHANGE,onRemarkChange);
		}
		
		private function removeEvent():void
		{
			_pass_check.removeEventListener(Event.CHANGE,__passCheckClick);
			_remark_txt.removeEventListener(Event.CHANGE,onRemarkChange);
		}
		
		private function __passCheckClick(event:Event):void
		{
			passwordTextGray.visible = !_pass_check.selected;
			
			_pass_txt.enabled = _pass_check.selected;
			if(_pass_check.selected)
			{
				_pass_txt.setFocus();
			}else
			{
				_pass_txt.text ="";
			}
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
			_name_txt.text = ChurchRoomManager.instance.currentRoom.roomName;
			
			_pass_check.selected = false;
			__passCheckClick(null);
			
			_remark_txt.text = ChurchRoomManager.instance.currentRoom.discription;
			_remark_txt.textField.setTextFormat(new TextFormat("Arial",16,0x000000));
			onRemarkChange(null);
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			if(e.keyCode == Keyboard.ESCAPE)
			{
				if(cancelBtn.enable)
				{
					SoundManager.Instance.play("008");
					if(cancelFunction != null)
					{
						cancelFunction();
					}else
					{
						close();
					}
				}
			}
		}

		private function onRemarkChange(e:Event):void
		{
			_bg.count_tip.text = LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.spare")+String(_remark_txt.maxChars - _remark_txt.text.length)+LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.word");
			_remark_txt.textField.setTextFormat(new TextFormat("Arial",16,0x000000));
		}

		private function __confirm():void
		{
			if(!checkRoom())
			{
				return;
			}
			
			var str:String = FilterWordManager.filterWrod(_remark_txt.text);
			ChurchRoomManager.instance.currentRoom.roomName = _name_txt.text;
			ChurchRoomManager.instance.currentRoom.discription = str;
			
			_controler.modifyDiscription(_name_txt.text,_pass_check.selected,_pass_txt.text,str);
			
			close();
		}
		
		private function checkRoom():Boolean
		{
			if(FilterWordManager.IsNullorEmpty(_name_txt.text))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.name"));
				return false;
			}
			else if(FilterWordManager.isGotForbiddenWords(_name_txt.text,"name"))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.string"));
				return false;
			}
			else if(_pass_check.selected && FilterWordManager.IsNullorEmpty(_pass_txt.text))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.set"));
				_pass_txt.stage.focus = _pass_txt;
				return false;
			}
			
			return true;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			DisposeUtils.disposeDisplayObject(_bg);
			DisposeUtils.disposeDisplayObject(_remark_txt);
			if(this.parent)this.parent.removeChild(this);
		}
	}	
}