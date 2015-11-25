package ddt.view
{
	import fl.events.ComponentEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import tank.commonII.asset.reworkNameAsset;
	import ddt.loader.LoadCheckName;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	public class ReworkNameView extends HConfirmFrame
	{
		private var _asset:reworkNameAsset;
		private var _newName:String;
		private var _nameBtn:HBaseButton;
		private var _isCanRework:Boolean;
		private var _place:int;
		private var _bagType:int;
		public function ReworkNameView( bagType:int,place:int)
		{
			/**
			*PVE_release版本
			*/			
			super();
			_place = place;
			_bagType = bagType;
			init();
			initEvent();
		}
		
		private function init():void
		{
			setSize(411,200);
			blackGound = false;
			alphaGound = false;
			titleText = LanguageMgr.GetTranslation("ddt.view.ReworkNameView.reworkName");
//			titleText = "名字更改";
			okLabel =	LanguageMgr.GetTranslation("ddt.view.ReworkNameView.okLabel");
//			okLabel =	"确认修改";
			okBtnEnable = false;
			showCancel = false;
			okFunction = __okClick;
			cancelFunction = __cancelClick;
			
			_asset = new reworkNameAsset();
			_asset.nameInput_txt.maxChars = 14;
			_asset.nameInput_txt.textColor = 0x000000;
			_asset.nameInput_txt.multiline = false;
			_nameBtn = new HBaseButton(_asset.nameCheckAccect);
			_nameBtn.useBackgoundPos = true;
			_nameBtn.y = _asset.nameCheckAccect.y + 81;
			_asset.clew_txt.text = LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.check_txt");
			//_asset.clew_txt = "可输入中英文或数字，长度不得超过14个字符";
			_asset.y = 30;
			_asset.x = 10;
			addChild(_asset);
			addChild(_nameBtn);
			_isCanRework = false;
		}
		
		private function initEvent():void
		{
			_asset.nameInput_txt.addEventListener(ComponentEvent.ENTER , __textInput);
			_asset.nameInput_txt.addEventListener(TextEvent.TEXT_INPUT , __input);
			_nameBtn.addEventListener(MouseEvent.CLICK ,__nameBtnClick);
			addEventListener(Event.ADDED_TO_STAGE , __addStage);
			addEventListener(MouseEvent.CLICK     , __addStage);
		}
		private function __addStage(evt:Event):void
		{
			if(_asset && _asset.nameInput_txt && _asset.nameInput_txt.stage)
			{
				_asset.nameInput_txt.stage.focus = _asset.nameInput_txt;
			}
		}
		private function __input(evt:Event):void
		{
			okBtnEnable = true;
		}
		
		private function __textInput(evt:Event):void
		{
			SoundManager.instance.play("008");
			if(nameInputCheck())
		    {
			    new LoadCheckName(_asset.nameInput_txt.text,setCheckTxt).loadSync();
		    }else{
		       	visibleCheckText();
		   	}
		}
		
		private function __nameBtnClick(evt:Event):void
		{
			SoundManager.instance.play("008");
			_isCanRework = false;
			if(nameInputCheck())
			{
				new LoadCheckName(_asset.nameInput_txt.text,setCheckTxt).loadSync();
			}else{
				visibleCheckText();
			}
			_asset.nameInput_txt.stage.focus = _asset.nameInput_txt;
		}
		
		private function __okClick():void
		{
			SoundManager.instance.play("008");
			_isCanRework = false;
			if(_asset.nameInput_txt.text == "")
			{
				setCheckTxt(LanguageMgr.GetTranslation("ddt.view.ReworkNameView.inputName"));
//				setCheckTxt("请输入昵称");
				return;
			}
			if(nameInputCheck())
			{
				new LoadCheckName(_asset.nameInput_txt.text,setCheckTxt).loadSync(reworkNameCallBack);
			}else{
				visibleCheckText();
				return;
			}
		}
		
		private function reworkNameCallBack(action : LoadCheckName):void
		{
			if(nameInputCheck() && _isCanRework)
			{
				_newName = _asset.nameInput_txt.text;
				SocketManager.Instance.out.sendUseReworkName(_bagType ,_place , _newName)
				reworkNameComplete();
				hide();
				dispose();
			}
		}
		
		private function reworkNameComplete():void
		{
			SoundManager.instance.play("047");
			HAlertDialog.show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("ddt.view.ReworkNameView.reworkNameComplete"));
//			HConfirmDialog.show("提示","改名成功，新名字将在24小时内启用。");
		}
		
		private function __cancelClick():void
		{
			SoundManager.instance.play("008");
			dispose();
		}
		
		public function nameInputCheck():Boolean
		{
			if(_asset.nameInput_txt.text != "")
			{
				if(FilterWordManager.isGotForbiddenWords(_asset.nameInput_txt.text,"name"))
				{
					HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.name"));
					//AlertDialog.show("提示","昵称中包含非法词汇");
					return false;
				}
				if(FilterWordManager.IsNullorEmpty(_asset.nameInput_txt.text))
				{
					LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.space")
					HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.space"));
					//AlertDialog.show("提示","昵称不能全为空格");
					
					return false;
					
				}
				if(FilterWordManager.containUnableChar(_asset.nameInput_txt.text))
				{
					HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.string"));
					//AlertDialog.show("提示","昵称中包含非法字符");

					return false;
				}
				return true;
			}
			HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.input"));
			//AlertDialog.show("提示","请输入昵称");
			return false;
		}
		
		private function setCheckTxt(m:String):void
		{
			if(m == LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.setCheckTxt"))
			//if(m == "恭喜.角色名可以使用.")
			{
				_asset.clew_txt.textColor = 0x339900;
				_isCanRework = true;
			}else
			{
				_asset.clew_txt.textColor = 0xff0000;
			}
			
			_asset.clew_txt.text = m;
		}
		
		private function visibleCheckText():void
		{
//			check_txt.text = ""; 
			_asset.clew_txt.textColor =0xffffff;
			_asset.clew_txt.text = LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.check_txt");
			//check_txt.text = "可输入中英文或数字，长度不超过14个字符";
		}
		
		override public function show():void
		{
			alphaGound = false;
			TipManager.AddTippanel(this,true);
			alphaGound = true;
		}
		
		override public function dispose():void
	 	{
		 	super.dispose();
		 	removeEventListener(Event.ADDED_TO_STAGE , __addStage);
		 	removeEventListener(MouseEvent.CLICK     , __addStage);
		 	if(_asset.nameInput_txt.stage)
		 	{
		 		_asset.nameInput_txt.stage.focus = null;
		 	}
		 	if(_asset)
		 	{
			 	_asset.nameInput_txt.removeEventListener(ComponentEvent.ENTER , __textInput);
			 	this.removeChild(_asset);
		 	}
		 	_asset = null;
		 	if(_nameBtn)
		 	{
		 		_nameBtn.removeEventListener(MouseEvent.CLICK ,__nameBtnClick);
		 		_nameBtn.dispose();
		 	}
		 	if(this.parent)
		 	{
		 		parent.removeChild(this);
		 	}
	 	}
		
	}
}