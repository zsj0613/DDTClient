package ddt.roomlist
{
	import fl.controls.TextInput;
	import fl.events.ComponentEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
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
	
	import tank.roomlist.CreatePveRoomAsset;
	
	public class RoomListIICreatePveRoomView extends CreatePveRoomAsset
	{
		
		private static var PREWORD:Array = [LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreatePveRoomView.tank"),LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreatePveRoomView.go"),LanguageMgr.GetTranslation("ddt.roomlist.RoomListIICreatePveRoomView.fire")];

		
		private var _controller:IRoomListIIController;
		
		private var btnOk:HBaseButton;
		private var btnCancel:HBaseButton;
		
		private var _roomType:int;		  //房间类型1探险2夺宝3Boss战 默认2夺宝
		private var GameDifficuLevel:int; //难度等级 默认0简单
		
		private var _name_txt:TextInput;
		private var _pass_check:HCheckBox;//勾选的小方块
		private var _pass_txt:TextInput;
		private var _bg:HFrame;
		private var _bottomBMP1:ScaleBMP_2;
		private var _bottomBMP2:ScaleBMP_3;
		public static var myColorMatrix_filter:ColorMatrixFilter;
		
		public function RoomListIICreatePveRoomView(controller:IRoomListIIController)
		{
			_controller = controller;
			init();
			initEvent();
		}
		
		private function init():void
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
			
			_bg.setSize(310,405);
			_bg.y = -34;
			_bg.x = -7;
			addChildAt(_bg,0);
			_bottomBMP1 = new ScaleBMP_2();
			_bottomBMP1.x = ascertainPos_mc.x + 145;
			_bottomBMP1.y = ascertainPos_mc.y + 29;
			addChildAt(_bottomBMP1,1);
			_bottomBMP2 = new ScaleBMP_3();
			_bottomBMP2.x = ascertainPos_mc.x + 153;
			_bottomBMP2.y = ascertainPos_mc.y + 260;
			addChildAt(_bottomBMP2,2);
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
			
			pass_mc.buttonMode = true;
			

			addChild(_pass_check);
			_pass_check.x -= 2;
			_pass_check.y -= 1;
			_pass_check.buttonMode = true;
			
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
			
//			explore_mc.gotoAndStop(1);
//			explore_mc.buttonMode = true;
			
			dacoity_mc.gotoAndStop(2);
			dacoity_mc.buttonMode = true;
			challengeBOSS_mc.gotoAndStop(1);
			challengeBOSS_mc.buttonMode =true;
			//启用Boss战
			
			//if(!false)
			//{
			//	challengeBOSS_mc.filters = [myColorMatrix_filter];
			//	challengeBOSS_mc.mouseChildren = false;
			//	challengeBOSS_mc.mouseEnabled  =false;
			//}
			
			RoomExplain_mc.gotoAndStop(1);
			
			_roomType = 4;//默认为副本
			GameDifficuLevel =0;
			
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
			pass_mc.addEventListener(MouseEvent.CLICK,__checkChange,false,0,true);
			_pass_check.addEventListener(Event.CHANGE,__checkChange,false,0,true);
			btnOk.addEventListener(MouseEvent.CLICK,__okClick,false,0,true);
			btnCancel.addEventListener(MouseEvent.CLICK,__cancelClick,false,0,true);
			
//			explore_mc.addEventListener(MouseEvent.CLICK , __RoomModeClick ,false ,0,true);
//			explore_mc.addEventListener(MouseEvent.MOUSE_OUT, __RoomModeOut ,false ,0,true);
			
			dacoity_mc.addEventListener(MouseEvent.CLICK , __RoomModeClick ,false ,0,true);
			dacoity_mc.addEventListener(MouseEvent.MOUSE_OUT, __RoomModeOut ,false ,0,true);
			
			challengeBOSS_mc.addEventListener(MouseEvent.CLICK , __RoomModeClick ,false ,0,true);
			challengeBOSS_mc.addEventListener(MouseEvent.MOUSE_OUT , __RoomModeOut ,false ,0,true);
		}
		
		private function __keyDown():void
		{
			__okClick(null);
		}
		
		private function __cancelDown():void
		{
			__cancelClick(null);
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
			else
			{
				WaitingView.instance.show();
//				GameInSocketOut.sendCreateRoom(_name_txt.text,_roomType,/*mode*/5,/*_secondType*/0,_pass_txt.text);
				GameInSocketOut.sendCreateRoom(_name_txt.text,_roomType,2,_pass_txt.text);
				hide();
			}
			SoundManager.Instance.play("008");
		}
		
		private function __cancelClick(evt:Event):void
		{
			hide();
			SoundManager.Instance.play("008");
		}
		
		private function __checkChange(evt:Event):void
		{
			SoundManager.Instance.play("008");
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
		 * 房间类型，自由 1 撮合 0 ，2探险，3 BOSS战，4夺宝  
		 * 
		 */
		private function __RoomModeClick(evt:Event):void
		{
			var index:int = GetRoomMode(evt);
//			if(_roomType!= index)
//			{
				switch (index)
				{
					case 1:
//						explore_mc.gotoAndStop(2);
//			    		dacoity_mc.gotoAndStop(1);
//		    			challengeBOSS_mc.gotoAndStop(1);
//		    			RoomExplain_mc.gotoAndStop(1);
//		    			_roomType = 2;
						break;
					case 2:
//						explore_mc.gotoAndStop(1);
			    		dacoity_mc.gotoAndStop(2);
		    			challengeBOSS_mc.gotoAndStop(1);
		    			RoomExplain_mc.gotoAndStop(1);
		    			_roomType = 4;
						break;			
					case 3:
//						explore_mc.gotoAndStop(1);
			    		dacoity_mc.gotoAndStop(1);
		    			challengeBOSS_mc.gotoAndStop(2);
		    			RoomExplain_mc.gotoAndStop(2);
		    			_roomType = 3;
						break;
					default:
						_roomType=-1;
		    			break;
//				}
			}
			SoundManager.Instance.play("008");
		}
		
		private var descriptionTip:RoomIIPropTip;
		private var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
		
		private function __RoomModeOut(evt:Event):void
		{
			if(descriptionTip && descriptionTip.parent)TipManager.RemoveTippanel(descriptionTip);
		}
		
		private function GetRoomMode(evt:Event):int
		{
			var str:String = evt.currentTarget.name;
			if(str == "explore_mc")
			{
				return 1;
			}else if(str == "dacoity_mc")
			{
				return 2;
			}else
			{
				return 3;
			}
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
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
//			if(explore_mc)
//			{
//				explore_mc.removeEventListener(MouseEvent.CLICK , __RoomModeClick);
//				explore_mc.removeEventListener(MouseEvent.MOUSE_OUT, __RoomModeOut);
//				if(explore_mc.parent)explore_mc.parent.removeChild(explore_mc);
//			}
			
			if(dacoity_mc)
			{
				dacoity_mc.removeEventListener(MouseEvent.CLICK , __RoomModeClick );
				dacoity_mc.removeEventListener(MouseEvent.MOUSE_OUT, __RoomModeOut);
				if(dacoity_mc.parent)dacoity_mc.parent.removeChild(dacoity_mc);
			}
			if(challengeBOSS_mc)
			{
				challengeBOSS_mc.removeEventListener(MouseEvent.CLICK , __RoomModeClick);
				challengeBOSS_mc.removeEventListener(MouseEvent.MOUSE_OUT, __RoomModeOut);
				if(challengeBOSS_mc.parent)challengeBOSS_mc.parent.removeChild(challengeBOSS_mc);
			}
			
			if(_name_txt)
			{
				_name_txt.removeEventListener(ComponentEvent.ENTER,__okClick);
				if(_name_txt.parent)_name_txt.parent.removeChild(_name_txt);
			}
			if(_pass_txt)
			{
				if(_pass_txt.parent)_pass_txt.parent.removeChild(_pass_txt);
				_pass_txt.removeEventListener(ComponentEvent.ENTER,__okClick);
			}
			if(_pass_check)
			{
				_pass_check.removeEventListener(Event.CHANGE,__checkChange);
				if(_pass_check.parent)_pass_check.parent.removeChild(_pass_check);
			}
			if(btnOk)
			{
				btnOk.removeEventListener(MouseEvent.CLICK,__okClick);
				btnOk.dispose();
			}
			if(btnCancel)
			{
				btnCancel.addEventListener(MouseEvent.CLICK,__cancelClick);
				btnCancel.dispose();
			}
			if(_bg)
			{
				_bg.dispose();
			}
			_bg = null;
			btnCancel = null;
			btnOk = null;
			_pass_check = null;
//			explore_mc = null;
			dacoity_mc = null;
			challengeBOSS_mc = null;
			_name_txt = null;
			_pass_txt = null;
			_controller = null;
			
		}
	}
}