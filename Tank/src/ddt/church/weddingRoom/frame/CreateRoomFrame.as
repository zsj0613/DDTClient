package ddt.church.weddingRoom.frame
{
	import ddt.church.weddingRoom.WeddingRoomControler;
	
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.events.ComponentEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_22;
	import tank.church.CreactRoomAsset;
	import ddt.data.ChurchRoomInfo;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.DisposeUtils;
	import ddt.utils.LeavePage; 
	
	public class CreateRoomFrame extends HConfirmFrame
	{
		private var _bg:CreactRoomAsset;
		private var _controler:WeddingRoomControler;
		private var _assetBg : ScaleBMP_22;
		
		private var _name_txt:TextInput;
		private var _pass_check:HCheckBox;
		private var _pass_txt:TextInput;
		private var _remark_txt:TextArea;
		
		private var _secondType:uint = 2;
		
		private var _invite_check:HCheckBox;
		private var _canInvite:Boolean;
		
		private var passwordTextGray:Sprite;
		
		private static var PRICE:Array = [2000,2700,3400];
		
		public function CreateRoomFrame(controler:WeddingRoomControler)
		{
			this.titleText = LanguageMgr.GetTranslation("church.weddingRoom.frame.CreateRoomFrame.titleText");
			//this.titleText = "举办婚礼";
			this.centerTitle = true;
			this._controler = controler;
			this.blackGound = false;
			this.alphaGound = false;
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.buttonGape = 100;
			this.setContentSize(547,320);
			
			this.cancelFunction =__cancel;
			this.okFunction =__confirm ;
			
			init();
			addEvent();
		}
	
		private function init():void
		{
			_bg = new CreactRoomAsset();
			addContent(_bg,true);
			
			_assetBg = new ScaleBMP_22();
			ComponentHelper.replaceChild(_bg,_bg.BgPos,_assetBg);
			
			_name_txt = new TextInput();
			_name_txt.setStyle("textFormat",new TextFormat(null,14,0x000000,true));
			_name_txt.setStyle("upSkin",new Sprite());
			_name_txt.maxChars = 20;
			_name_txt.text = LanguageMgr.GetTranslation("hurch.weddingRoom.frame.CreateRoomFrame.name_txt",PlayerManager.Instance.Self.NickName,PlayerManager.Instance.Self.SpouseName);
			ComponentHelper.replaceChild(_bg,_bg.name_pos,_name_txt);
			
			_bg.pass_mc.y = -2;
			_pass_check = new HCheckBox("",_bg.pass_mc);
			_pass_check.labelGape = 2;
			_pass_check.fireAuto = true;
			_pass_check.buttonMode = true;
			_pass_check.x = _bg.checkBox_pos.x;
			_pass_check.y = _bg.checkBox_pos.y;
			_bg.addChild(_pass_check);
			_bg.checkBox_pos.visible = false;
			
			_pass_txt = new TextInput();
			_pass_txt.displayAsPassword = true;
			_pass_txt.maxChars = 6;
//			_pass_txt.enabled = false;
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
			
			var groomName:String = "";
			var brideName:String = "";
			if(PlayerManager.Instance.Self.Sex)
			{
				groomName = PlayerManager.Instance.Self.NickName;
				brideName = PlayerManager.Instance.Self.SpouseName;
			}else
			{
				groomName = PlayerManager.Instance.Self.SpouseName;
				brideName = PlayerManager.Instance.Self.NickName;
			}
			_remark_txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.CreateRoomFrame._remark_txt",groomName,brideName);
			//_remark_txt.text = "在这个新旧交替，举世欢腾，万众瞩目的日子里，英俊潇洒的"+groomName+"和漂亮温柔的"+brideName+"的结婚大典将在这里举行。这将是一个因心与心的结合让寒冷变得火热的日子，一个令一对新人刻骨铭心、终生难忘的日子！在此，我们热烈欢迎前来参加庆典的朋友们，来一起分享我们的幸福与喜悦！";
			onRemarkChange(null);
			
			_pass_txt.setStyle("textFormat",new TextFormat(null,12,0x000000,true));
			ComponentHelper.replaceChild(_bg,_bg.remark_pos,_remark_txt);
			_bg.invent_mc.y = -2;
			_invite_check = new HCheckBox("",_bg.invent_mc);
			_invite_check.labelGape = 2;
			_invite_check.fireAuto = true;
			_invite_check.buttonMode = true;
			_invite_check.x = _bg.checkBox2_pos.x;
			_invite_check.y = _bg.checkBox2_pos.y;
			_bg.addChild(_invite_check);
			_bg.checkBox2_pos.visible = false;
		
			for(var i:uint = 0;i<3;i++)
			{
				var m:MovieClip = (_bg["time"+i+"_mc"] as MovieClip);
				m.buttonMode = true;
			}
			
			resetSecondBtn();
			
			_bg.time0_mc.gotoAndStop(2);
			
			_bg.hourLight_mc.mouseEnabled = false;
			
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
			_invite_check.addEventListener(Event.CHANGE,__inviteCheckClick);
			_remark_txt.addEventListener(Event.CHANGE,onRemarkChange);
			for(var i:uint = 0;i<3;i++)
			{
				var m:MovieClip = (_bg["time"+i+"_mc"] as MovieClip);
				m.addEventListener(MouseEvent.CLICK,__secondClick);
			}
			
			_name_txt.addEventListener(ComponentEvent.ENTER,__create);
			_pass_txt.addEventListener(ComponentEvent.ENTER,__create);
		}
		
		private function removeEvent():void
		{
			_pass_check.removeEventListener(Event.CHANGE,__passCheckClick);
			_invite_check.removeEventListener(Event.CHANGE,__inviteCheckClick);
			_remark_txt.removeEventListener(Event.CHANGE,onRemarkChange);
			for(var i:uint = 0;i<3;i++)
			{
				var m:MovieClip = (_bg["time"+i+"_mc"] as MovieClip);
				m.removeEventListener(MouseEvent.CLICK,__secondClick);
			}
			
			_name_txt.removeEventListener(ComponentEvent.ENTER,__create);
			_pass_txt.removeEventListener(ComponentEvent.ENTER,__create);
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
						hide();
					}
				}
			}
		}

		private function onRemarkChange(e:Event):void
		{
			_bg.count_tip.text = LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.spare")+String(_remark_txt.maxChars - _remark_txt.text.length)+LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.word");
			_remark_txt.textField.setTextFormat(new TextFormat("Arial",16,0x000000));
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
		
		private function __inviteCheckClick(event:Event):void
		{
			_canInvite = _invite_check.selected;
		}

		private function __secondClick(event:MouseEvent):void
		{
			SoundManager.Instance.play("043");
			
			var index:Number = Number(event.currentTarget.name.slice(4,5));
			
			resetSecondBtn();
			
			(_bg["time"+index+"_mc"] as MovieClip).gotoAndStop(2);
			
			_secondType = index+2;
			
			_bg.hourLight_mc.x = (event.currentTarget as MovieClip).x -4;
		}
		
		private function resetSecondBtn():void
		{
			for(var i:uint = 0;i<3;i++)
			{
				var m:MovieClip = (_bg["time"+i+"_mc"] as MovieClip);
				m.gotoAndStop(1);
			}
		}
		
		private function __create(event:ComponentEvent):void
		{
			__confirm();
		}
		
		private function __confirm():void
		{
			if(PlayerManager.Instance.Self.Money<PRICE[_secondType-2])
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				return;
			}
			
			if(!checkRoom())
			{
				return;
			}
			
			var room:ChurchRoomInfo = new ChurchRoomInfo();
			room.roomName = _name_txt.text;
			//room.isLocked = _pass_check.selected;
			room.password = _pass_txt.text;
			room.valideTimes = _secondType;
			room.canInvite = _canInvite;
			room.discription =FilterWordManager.filterWrod(_remark_txt.text);
			_controler.createRoom(room);
			dispose();
			
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
				return false;
			}
			
			return true;
		}

		override public function show():void
		{
			TipManager.AddTippanel(this,true);
			blackGound = true;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			DisposeUtils.disposeDisplayObject(_bg);
			DisposeUtils.disposeDisplayObject(_pass_txt);
			if(_pass_check)_pass_check.dispose();
			DisposeUtils.disposeDisplayObject(_pass_check);
			DisposeUtils.disposeDisplayObject(_name_txt);
			DisposeUtils.disposeDisplayObject(_remark_txt);
			DisposeUtils.disposeDisplayObject(_invite_check);
			if(parent)parent.removeChild(this);
		}
		
		private function __cancel():void
		{
			dispose();
		}
	}
}