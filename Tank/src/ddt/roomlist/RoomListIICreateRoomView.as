package ddt.roomlist
{
	import fl.controls.TextInput;
	import fl.events.ComponentEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import org.aswing.KeyStroke;
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_2;
	import tank.assets.ScaleBMP_3;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.UserGuideManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.RoomIIPropTip;
	import ddt.view.common.WaitingView;
	
	import trank.roomlist.CreateRoomAsset;
	
	public class RoomListIICreateRoomView extends CreateRoomAsset
	{
		
		public static var PREWORD:Array = [LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.tank"),LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.go"),LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.fire"),LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.happy")];
		private static var DESCRIPTION:Array = ["",LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.DESCRIPTION"),LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.DESCRIPTION2")];
		private var _controller:IRoomListIIController;
		private var _bg:HFrame;
		private var _name_txt:TextInput;
		private var _pass_check:HCheckBox;
		private var _pass_txt:TextInput;
		private var _roomType:int;
//		private var _teamModel:int;
		private var _yesornot:int;
		private var _secondType:int=1;
		private var btnOk:HBaseButton;
		private var btnCancel:HBaseButton;
		private var _bottomBMP1:ScaleBMP_2;
		private var _bottomBMP2:ScaleBMP_3;
		private var myColorMatrix_filter:ColorMatrixFilter;
		
		public function RoomListIICreateRoomView(controller:IRoomListIIController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
		}
		
		public function init():void
		{
			myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			_bg = new HFrame();
			_bg.blackGound = false;
			_bg.alphaGound = false;
			_bg.moveEnable = false;
			_bg.fireEvent = false;
			_bg.showBottom = true;
			_bg.showClose = false;
			_bg.titleText = LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.titleText");
			//_bg.titleText = "创建房间";
			_bg.centerTitle = true;
			
			_bg.setSize(311,410);
			_bg.x = 20;
			_bg.y = 16;
			addChildAt(_bg,0);
			_bottomBMP1 = new ScaleBMP_2();
			_bottomBMP1.x = ascertainPos_mc.x + 145;
			_bottomBMP1.y = ascertainPos_mc.y + 29;
			addChildAt(_bottomBMP1,1);
			_bottomBMP2 = new ScaleBMP_3();
			_bottomBMP2.x = ascertainPos_mc.x + 153;
			_bottomBMP2.y = ascertainPos_mc.y + 260;
			addChildAt(_bottomBMP2,2);
			removeChild(ascertainPos_mc);
			ascertainPos_mc = null;
			BellowStripViewII.Instance.visible = true;
		
			_name_txt = new TextInput();
			_name_txt.setStyle("textFormat",new TextFormat(null,14,0x000000,true));
			_name_txt.setStyle("upSkin",new Sprite());
			_name_txt.maxChars = 20;
			ComponentHelper.replaceChild(this,tbx_name,_name_txt);
			pos_password.visible = false;
			_pass_check = new HCheckBox("");
			_pass_check.x = pos_password.x;
			_pass_check.y = pos_password.y;
			_pass_check.fireAuto = true;
//			_pass_check.visible = false;
			addChild(_pass_check);
//			ComponentHelper.replaceChild(this,pos_password,_pass_check);
			_pass_check.x -= 2;
			_pass_check.y -= 1;
			_pass_check.buttonMode = true;
			
			pass_mc.buttonMode = true;
			
			_pass_txt = new TextInput();
			_pass_txt.displayAsPassword = true;
			_pass_txt.maxChars = 6;
			_pass_txt.enabled = false;
			_pass_txt.setStyle("textFormat",new TextFormat(null,12,0x000000,true));
			_pass_txt.x = tbx_password.x;
			_pass_txt.y = tbx_password.y;
			_pass_txt.width = tbx_password.width;
			_pass_txt.height = tbx_password.height;
			
			addChild(tbx_password);


			RoomExplain_mc.gotoAndStop(1);
			
			var i:int = 0;
			type_1.gotoAndStop(1);
			type_1.buttonMode = true;
			type_2.gotoAndStop(2);
			type_2.buttonMode = true;
			
			_roomType = 2; 
			_secondType = 3;
			if(!false)
			{
				type_1.filters = [myColorMatrix_filter]
				type_1.mouseChildren = false;
				type_1.mouseEnabled  = false;
				_roomType = 0;
				RoomExplain_mc.gotoAndStop(2);
			}
			
			
			btnOk = new HLabelButton();
			btnOk.label = LanguageMgr.GetTranslation("ok");
			btnOk.x = okBtnPos.x;
			btnOk.y = okBtnPos.y;
			removeChild(okBtnPos);
			addChild(btnOk);
			btnCancel = new HLabelButton();
			btnCancel.label = LanguageMgr.GetTranslation("cancel");
			btnCancel.x = cancelBtnPos.x;
			btnCancel.y = cancelBtnPos.y;
			removeChild(cancelBtnPos);
			addChild(btnCancel);

			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		private function __addToStage(evt:Event):void
		{
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000,0.8);
			_bg.graphics.drawRect(-500,-500,2000,2000);
			_bg.graphics.endFill();
			
			
			_name_txt.text = PREWORD[int(Math.random()*PREWORD.length)];
			_name_txt.setFocus();
			_name_txt.setSelection(0,0);
			KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_ENTER,__keyDown);
			KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_ESCAPE,__cancelDown);
			_name_txt.addEventListener(ComponentEvent.ENTER,__okClick);
			_pass_txt.addEventListener(ComponentEvent.ENTER,__okClick);
			
		}
		
		private function initEvent():void
		{
//			_name_txt.addEventListener(Event.CHANGE,__txtChange);
//			_pass_txt.addEventListener(Event.CHANGE,__txtChange);
			pass_mc.addEventListener(MouseEvent.CLICK,__checkChange,false,0,true);
			_pass_check.addEventListener(Event.CHANGE,__checkChange,false,0,true);
			btnOk.addEventListener(MouseEvent.CLICK,__okClick,false,0,true);
			//btnOk.addEventListener(Event.ADDED_TO_STAGE,userGuide);
			btnCancel.addEventListener(MouseEvent.CLICK,__cancelClick,false,0,true);
			var i:int = 0;
			//改动房间类型 改为两个 竞技  训练
			for(i = 1; i <= 2; i++)
			{
				this["type_" + i].addEventListener(MouseEvent.CLICK,__roomTypeClick,false,0,true);
				this["type_" + i].addEventListener(MouseEvent.MOUSE_OUT,__roomTypeOut,false,0,true);
			}
		}
		
		private function __keyDown():void
		{
			__okClick(null);
		}
		
		private function __cancelDown():void
		{
			__cancelClick(null);
		}
		
		private function __checkChange(evt:Event):void
		{
			SoundManager.instance.play("008");
			if(evt.type == "click" )
			{
				_pass_txt.enabled = _pass_txt.enabled  ? false : true ;
				_pass_check.selected = _pass_check.selected ? false : true;
			}
			_pass_txt.enabled = _pass_check.selected;
			if(_pass_check.selected)
			{
				addChild(_pass_txt);
				if(tbx_password.parent)tbx_password.parent.removeChild(tbx_password);
				_pass_txt.setFocus();
			}
			else
			{
				_pass_txt.text = "";
				if(_pass_txt.parent)_pass_txt.parent.removeChild(_pass_txt);
				addChild(tbx_password);
			}
		}
		/**
		 * 房间类型， 0撮合 1自由，2夺宝，3 BOSS战，4探险
		 */		
		private function __roomTypeClick(evt:MouseEvent):void
		{
			var index:int = Number(evt.currentTarget.name.slice(5,6));
			var i:uint
			switch (index)
			{
				case 1:
		    		type_1.gotoAndStop(2);
	    			type_2.gotoAndStop(1);
	    			RoomExplain_mc.gotoAndStop(1);
					_roomType = 2;
					_secondType = 2;
					break;
				case 2:
		    		type_1.gotoAndStop(1);
	    			type_2.gotoAndStop(2);
	    			RoomExplain_mc.gotoAndStop(2);
		    		_secondType = 3;
					_roomType = 0;
					break;
			}
			SoundManager.instance.play("008");
		}
		
		private var descriptionTip:RoomIIPropTip;
		private var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
		
		private function __roomTypeOver(evt:MouseEvent):void
		{
			var index:int = Number(evt.currentTarget.name.slice(5,6));
			itemTemplateInfo.Description = DESCRIPTION[index];
			itemTemplateInfo.Property4   = "";
			itemTemplateInfo.Name        = "";
			if(!descriptionTip)descriptionTip = new RoomIIPropTip(false,false,false);
			descriptionTip.changeStyle(itemTemplateInfo,evt.target.width);
		
			var description_pos:Point = this.localToGlobal(new Point(evt.target.x,evt.target.y));
			descriptionTip.x = description_pos.x;
			descriptionTip.y = description_pos.y + evt.target.height;
			TipManager.AddTippanel(descriptionTip);
		}
		
		private function __roomTypeOut(evt:MouseEvent):void
		{
			if(descriptionTip && descriptionTip.parent)TipManager.RemoveTippanel(descriptionTip);
		}	
		private function __secondClick(evt:MouseEvent):void
		{
			var index:int = Number(evt.currentTarget.name.slice(5,6));
			if ( _roomType == 0 )
			{
				if(index != 2)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.time"));
		    		//MessageTipManager.getInstance().show("撮合房间固定回合时间：10秒");
		    		SoundManager.instance.play("008");
			    	return;
				}
			}
			this["time_" + 0].gotoAndStop(1);
			this["time_" + 1].gotoAndStop(1);
			this["time_" + 2].gotoAndStop(1);
			this["time_" + index].gotoAndStop(2);
			
			_secondType = index;
			SoundManager.instance.play("008");
		}
		
		private function __okClick(evt:Event):void
		{
			if(FilterWordManager.IsNullorEmpty(_name_txt.text))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.name"));
				//MessageTipManager.getInstance().show("房间名不能为空格");
			}
			else if(FilterWordManager.isGotForbiddenWords(_name_txt.text,"name"))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.string"));
				//MessageTipManager.getInstance().show("房间名存在非法字符");
			}
			else if(_pass_check.selected && FilterWordManager.IsNullorEmpty(_pass_txt.text))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.set"));
				//MessageTipManager.getInstance().show("请设置你的房间密码");
			}
			else if(checkOKBtnEnable())
			{
				WaitingView.instance.show();
				GameInSocketOut.sendCreateRoom(_name_txt.text,_roomType,_secondType,_pass_txt.text);
				hide();
			}
			SoundManager.instance.play("008");
		}
		
		private function __cancelClick(evt:MouseEvent):void
		{
//			_pass_check.setFocus();
			hide();
			SoundManager.instance.play("008");
		}
		
		public function hide():void
		{
			KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_ENTER,__keyDown);
			KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_ESCAPE,__cancelDown);
			if(parent)
				parent.removeChild(this);
		}
		
		public function dispose():void
		{
			if(_name_txt)
			{
				_name_txt.removeEventListener(ComponentEvent.ENTER,__okClick);
			}
			if(_pass_txt)
			{
				_pass_txt.removeEventListener(ComponentEvent.ENTER,__okClick);
			}
			for(var i:int = 1; i <= 2; i++)
			{
				this["type_" + i].removeEventListener(MouseEvent.CLICK,__roomTypeClick);
				this["type_" + i].removeEventListener(MouseEvent.MOUSE_OUT,__roomTypeOut);
				this["type_" + i]=null;
			}
			if(_pass_check)
			{
				_pass_check.removeEventListener(Event.CHANGE,__checkChange);
				if(_pass_check.parent) _pass_check.parent.removeChild(_pass_check);
			}
			if(pass_mc)
			{
				pass_mc.removeEventListener(MouseEvent.CLICK,__checkChange);
				if(pass_mc.parent)pass_mc.parent.removeChild(pass_mc);
			}
			_pass_check = null;
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			btnOk.removeEventListener(MouseEvent.CLICK,__okClick);
			btnCancel.removeEventListener(MouseEvent.CLICK,__cancelClick);
				
			if(btnOk)
			{
				btnOk.dispose();
			}
			if(btnCancel)
			{
				btnCancel.dispose();
			}
			if(_bg)
			{
				_bg.dispose();
			}
			btnOk = null;
			btnCancel = null;
			_controller = null;
			_bg = null;
			hide();
		}
		
		private function checkOKBtnEnable():Boolean
		{
			if(_roomType == -1)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreateRoomView.set2"));
				//MessageTipManager.getInstance().show("请选择房间模式！");
				return false;
			}
			return true;
		}
	}
}