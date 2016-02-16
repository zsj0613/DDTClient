package ddt.consortia.myconsortia
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.consortia.ConsortiaControl;
	import ddt.consortia.ConsortiaModel;
	import tank.consortia.accect.AuditingApplyPaneAsset;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.consortia.myconsortia.frame.RecruitMemberFrame;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;

	public class MyConsortiaAuditingApplyList extends HFrame
	{
		private var _list   : SimpleGrid;
		private var _items  : Array;
		private var _current: MyConsortiaAuditingApplyItem;
		private var _model  : ConsortiaModel;
		private var _bg     : AuditingApplyPaneAsset;
		private var _control:ConsortiaControl;
		private var _recruitMemberFrame:RecruitMemberFrame;
		private var _prePageBtn : HBaseButton;
		private var _nextPageBtn : HBaseButton;
		private var _okBtn  : HLabelButton;
		private var _cannelBtn : HLabelButton;
		private var _checkBox  : HCheckBox;
		private var _levenSortBtn :HBaseButton;
		private var _fightPowerSortBtn :HBaseButton;
		private var _isSelected:Boolean;
		private var _lastSort:String = "";
		
		public function MyConsortiaAuditingApplyList($model : ConsortiaModel,control:ConsortiaControl)
		{
			super();
			
			showBottom = true;
			blackGound = true;
			alphaGound = false;
			fireEvent = false;
			moveEnable = false;
			
			this._control = control;
			this._model = $model;
			init();
			addEvent();
			
		}
		private function init() : void
		{
			this.setSize(510,460);
			_bg   = new AuditingApplyPaneAsset();
			this.addContent(_bg,false);
			_bg.listPos.visible = false;
			_bg.x = -8;
			_bg.y = -6;

			_list = new SimpleGrid(409,28,1);
			_list.setSize(480,300);
			_list.verticalScrollPolicy = "off";
			_list.horizontalScrollPolicy = "off";
			addContent(_list,false);
			_list.x = _bg.x + _bg.listPos.x;
			_list.y = _bg.y + _bg.listPos.y;
			
			this.setContentSize(_bg.width-12,_bg.height-6);
			_items = new Array();
			
			_prePageBtn = new HBaseButton(_bg.prePageBtnAsset);
			_prePageBtn.useBackgoundPos = true;
			_bg.addChild(_prePageBtn);
			
			_nextPageBtn = new HBaseButton(_bg.nextPageBtnAsset);
			_nextPageBtn.useBackgoundPos = true;
			_bg.addChild(_nextPageBtn);
			
			_levenSortBtn = new HBaseButton(_bg.levenSort);
			_levenSortBtn.useBackgoundPos = true;
			_bg.addChild(_levenSortBtn);
			
			_fightPowerSortBtn = new HBaseButton(_bg.fightPowerSort);
			_fightPowerSortBtn.useBackgoundPos = true;
			_bg.addChild(_fightPowerSortBtn);
			_okBtn     = new HLabelButton();
			_cannelBtn = new HLabelButton();
			titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaAuditingApplyList.titleText");
			//titleText = "审核批准";
			_okBtn.label = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaAuditingApplyList.okLabel");
			//okLabel = "招收成员";
			_cannelBtn.label = LanguageMgr.GetTranslation("ddt.invite.InviteView.close");
			//cancelLabel = "关    闭";
			_okBtn.y = _cannelBtn.y = _bg.openFrameBtnPos.y;
			_okBtn.x = _bg.openFrameBtnPos.x - 30;
			_cannelBtn.x = _bg.closePos.x;
			_bg.closePos.visible = _bg.openFrameBtnPos.visible = false;
			_bg.addChild(_okBtn);
			_bg.addChild(_cannelBtn);
			
			/**拒捕申请**/
			_bg.checkBoxTxt.visible = false;
			var checkBoxArea : MovieClip = new MovieClip();
			checkBoxArea.graphics.beginFill(0,0);
			checkBoxArea.graphics.drawRect(-5,-8,70,22);
			checkBoxArea.graphics.endFill();
			_checkBox = new HCheckBox("",checkBoxArea);
			_checkBox.x = 235;//_bg.checkBoxPos.x;
			_checkBox.y = 355;//_bg.checkBoxPos.y;
//			_bg.checkBoxPos.visible = false;
			if(_model.myConsortiaData.ChairmanID == PlayerManager.Instance.Self.ID) _checkBox.visible = _bg.checkBoxTxt.visible = true;
			_bg.addChild(_checkBox);
			_isSelected = false;
			var right:int = PlayerManager.Instance.Self.Right;
			if(PlayerManager.Instance.Self.DutyLevel == 1)
			{
				_checkBox.fireAuto     = true;
			    _checkBox.buttonMode   = true;
				_checkBox.mouseEnabled = true;
				_checkBox.visible      = true;
				_bg.applyRightAsset.visible = false;
				if(_model && _model.myConsortiaData)_checkBox.selected = !_model.myConsortiaData.OpenApply;
			}
			else
			{
				if(_model && _model.myConsortiaData)_bg.applyRightAsset.visible = !_model.myConsortiaData.OpenApply;
				_checkBox.visible   = false;
//				_checkBox.fireAuto   = false;
//			    _checkBox.buttonMode = false;
//				_checkBox.selected = !_model.myConsortiaData.OpenApply;
//				_checkBox.mouseEnabled = false;
			}
			
		}
		private var _isAddEvent : Boolean = false;
		public function addEvent() : void
		{
			if(_isAddEvent)return;
			_okBtn.addEventListener(MouseEvent.CLICK,                                          __recruitHandler);
			_cannelBtn.addEventListener(MouseEvent.CLICK,                                      __closing);
			_model.addEventListener(ConsortiaDataEvent.MY_CONSORTIA_AUDITING_APPLY_DATA_CHAGE, __auditingApplyHandler);
			_model.addEventListener(ConsortiaDataEvent.DELETE_CONSORTIA_APPLY,                 __deleteRecordHandler);
			_prePageBtn.addEventListener(MouseEvent.CLICK,                                     __gotoPageHandler);
			_nextPageBtn.addEventListener(MouseEvent.CLICK,                                    __gotoPageHandler);
			_checkBox.addEventListener(Event.CHANGE,                                           __upConsortiaApplyStatus);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,__consortiaApplyStatusResult);
			addEventListener(KeyboardEvent.KEY_DOWN,                                      __onKeyDown);
			_fightPowerSortBtn.addEventListener(MouseEvent.CLICK,  							   __sortBtnClick)
			_levenSortBtn.addEventListener(MouseEvent.CLICK,								   __sortBtnClick)
			_bg.full_btn.addEventListener(MouseEvent.CLICK ,								   __btnClick);
			_bg.agree_btn.addEventListener(MouseEvent.CLICK ,								   __btnClick);
			_bg.reject_btn.addEventListener(MouseEvent.CLICK ,								   __btnClick);
			_isAddEvent = true;
		}
		public function removeEvent() : void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,                                          __recruitHandler);
			_cannelBtn.removeEventListener(MouseEvent.CLICK,                                      __closing);
			_model.removeEventListener(ConsortiaDataEvent.MY_CONSORTIA_AUDITING_APPLY_DATA_CHAGE, __auditingApplyHandler);
			_model.removeEventListener(ConsortiaDataEvent.DELETE_CONSORTIA_APPLY,                 __deleteRecordHandler);
			_prePageBtn.removeEventListener(MouseEvent.CLICK,                                     __gotoPageHandler);
			_nextPageBtn.removeEventListener(MouseEvent.CLICK,                                    __gotoPageHandler);
			_checkBox.removeEventListener(Event.CHANGE,                                           __upConsortiaApplyStatus);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,__consortiaApplyStatusResult);
			removeEventListener(KeyboardEvent.KEY_DOWN,                                     __onKeyDown);
			_fightPowerSortBtn.removeEventListener(MouseEvent.CLICK,  							   __sortBtnClick)
			_levenSortBtn.removeEventListener(MouseEvent.CLICK,									   __sortBtnClick)
			_isAddEvent = false;
		}
		
		private function __sortBtnClick(evt:Event):void
		{
			SoundManager.Instance.play("008");
			if(evt.target.name == "fightPowerSort")
			{
				_lastSort = "FightPower";
//				Sort("FightPower");
			}else if(evt.target.name == "levenSort")
			{
				_lastSort = "Level";
//				Sort("Level");
			}
			Sort(_lastSort);
		}
		
		private function __btnClick(evt:Event):void
		{
			switch(evt.currentTarget.name)
			{
				case "full_btn":
						full();
					break;
				case "agree_btn":
						agree();
					break;
				case "reject_btn":
						reject();
					break;
			}
		}
		
		private function full():void
		{
			_isSelected = !_isSelected;
			SoundManager.Instance.play("008");
			if(allHasSelected())
			{
				for(var i:int= 0;i<_items.length;i++)
				{
					if(!_items[i])continue;
					(_items[i] as MyConsortiaAuditingApplyItem).boxCancel(false);
				}
			}else
			{
				for(var j:int= 0;j<_items.length;j++)
				{
					if(!_items[j])continue;
					(_items[j] as MyConsortiaAuditingApplyItem).boxCancel(true);
				}
			}
		}
		
		private function allHasSelected():Boolean
		{
			for(var i:uint = 0;i<_items.length;i++)
			{
				if(!(_items[i]  as MyConsortiaAuditingApplyItem).isChoice)
				{
					return false;
				}
			}
			return true;
		}
		
		private function agree():void
		{
			SoundManager.Instance.play("008");
			var noChoice:Boolean = true;
			for(var i:int= 0;i<_items.length;i++)
			{
				if(!_items[i])continue;			
				if((_items[i] as MyConsortiaAuditingApplyItem).isChoice)
				{
					_control.sendTryinPass((_items[i] as MyConsortiaAuditingApplyItem).info.ID);
					_model.deleteMyConsortiaAuditingData((_items[i] as MyConsortiaAuditingApplyItem).info.ID);
					noChoice = false;
				}
			}
			items();
			if(noChoice)
			{
				MessageTipManager.getInstance().show("请您至少选择一个条目");
			}
		}
		
		private function reject():void
		{
			SoundManager.Instance.play("008");
			var noChoice:Boolean = true;
			for(var i:int= 0;i<_items.length;i++)
			{
				if(!_items[i])continue;
				if((_items[i] as MyConsortiaAuditingApplyItem).isChoice)
				{
					_control.sendDeleteTryinRecord((_items[i] as MyConsortiaAuditingApplyItem).info.ID);
					_model.deleteMyConsortiaAuditingData((_items[i] as MyConsortiaAuditingApplyItem).info.ID);
					noChoice = false;
					i = i - 1;
				}
			}
			items();
			if(noChoice)
			{
				MessageTipManager.getInstance().show("请您至少选择一个条目");
			}
		}
		
		/**是否容许其他人加入到公会**/
		private function __upConsortiaApplyStatus(evt : Event) : void
		{
			_checkBox.fireAuto = false;
			SocketManager.Instance.out.sendConsoritaApplyStatusOut(!_checkBox.selected);
		}
		/**操作返回**/
		private function __consortiaApplyStatusResult(evt : CrazyTankSocketEvent) : void
		{
			_checkBox.fireAuto = true;
			var status:Boolean = evt.pkg.readBoolean();
			var isSuccess : Boolean = evt.pkg.readBoolean();
			var msg:String = evt.pkg.readUTF();
			MessageTipManager.getInstance().show(msg);
			_checkBox.selected = Boolean(!status);
		}
		private var _totalPage   : int;
		private var _currentPage : int ;
		private function __auditingApplyHandler(evt : ConsortiaDataEvent) : void
		{
			_currentPage = 1;
			_bg.pageTxt.text = "1/1";
			_lastSort = "";
			items();
		}
		private function items() : void
		{
			clearList();
			var $list : Array = _model.myConsortiaAuditingApplyData;
		    _totalPage = Math.ceil($list.length/10);	
		    var lenth : int = (_currentPage * 10 > $list.length ? $list.length : _currentPage * 10);
			for(var i:int=(_currentPage-1)*10;i<lenth;i++)
			{
				if(!$list[i])continue;
				var item : MyConsortiaAuditingApplyItem = new MyConsortiaAuditingApplyItem(__okClick,__cancelClick,__seeClick);
				item.info = $list[i];
				_list.appendItem(item);
				_items.push(item);
			}
			if(_lastSort != "") {
				Sort(_lastSort);
			}
			_bg.pageTxt.text = String(_currentPage) + "/" + String(_totalPage = _totalPage == 0 ? 1:_totalPage);
			btnsStatus();
		}
		
		private function Sort(field : String):void
		{
			for(var i:int = 0 ; i<_items.length ; i++)
			{
				var item:MyConsortiaAuditingApplyItem = _items[i] as MyConsortiaAuditingApplyItem;
				_list.removeItem(item);
			}
			_items.sortOn(field,Array.DESCENDING|Array.NUMERIC);
			for(var j:int = 0 ; j<_items.length ; j++)
			{
				var item2:MyConsortiaAuditingApplyItem = _items[j] as MyConsortiaAuditingApplyItem;
				_list.appendItemAt(item2,j);
			}
		}
		
		private function __gotoPageHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			if(evt.target.name == "prePageBtnAsset")
			{
				if(_currentPage > 1)
				{
					_currentPage --;
				}
			}
			else if(evt.target.name == "nextPageBtnAsset")
			{
				
				if(_currentPage < _totalPage)
				{
					_currentPage ++;
				}
			}
			_bg.pageTxt.text = String(_currentPage) + "/" + String(_totalPage);
			items();
		}
		private function btnsStatus() : void
		{
			if(_currentPage < _totalPage)
			{
				_nextPageBtn.enable = true;
			}
			else
			{
				_nextPageBtn.enable = false;
			}
			if(_currentPage > 1)
			{
				_prePageBtn.enable = true;
			}
			else
			{
				_prePageBtn.enable = false;
			}
		}
		private function __deleteRecordHandler(evt : ConsortiaDataEvent) : void
		{
			var id : int = int(evt.data);
			removeItem(id);
		}
		private function removeItem(id : int) : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : MyConsortiaAuditingApplyItem = _items[i] as MyConsortiaAuditingApplyItem;
				if(item.info.ID == id)
				{
					_list.removeItem(item);
					item.dispose();
					_items.splice(i,1);
					break;
				}
				
			}
		}
		private function clearList() : void
		{
			for(var i:int=0;i<_items.length;i++)
			{
				var item : MyConsortiaAuditingApplyItem = _items[i] as MyConsortiaAuditingApplyItem;
				_list.removeItem(item);
				item.dispose();
			}
			_list.clearItems();
			_items = [];
		}
		
		private function  __recruitHandler(evt : MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_recruitMemberFrame = new RecruitMemberFrame(_model);
			TipManager.AddTippanel(_recruitMemberFrame,true);
		}
		
		private function __seeClick(id:int):void
		{
			SoundManager.Instance.play("008");
			PersonalInfoManager.instance.addPersonalInfo(id,PlayerManager.Instance.Self.ZoneID);
		}
		
		private function __okClick(id:int):void
		{
			SoundManager.Instance.play("008");
			_control.sendTryinPass(id);
			_model.deleteMyConsortiaAuditingData(id);
			items();
		}
		
		
		private function __cancelClick(id:int):void
		{
			SoundManager.Instance.play("008");
			_control.sendDeleteTryinRecord(id);
			_model.deleteMyConsortiaAuditingData(id);
			items();
//			MessageTipManager.getInstance().show("您已拒绝申请"); //bret 09.5.25
//			if(this.parent)this.parent.removeChild(this); //bret 09.5.25
		}
		private function __closing(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			this.removeEvent();
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function __onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				e.stopPropagation();
				removeEvent();
				if(this.parent)this.parent.removeChild(this);
			}
			
		}
		
		override public function show() : void
		{
			super.show();
		}
		override public function dispose() : void
		{
			removeEvent();
			super.dispose();
			clearList();
			if(_list)_list.clearItems();
			if(_list && _list.parent)_list.parent.removeChild(_list);
			_list = null;
			
			if(_prePageBtn)
			{
				if(_prePageBtn.parent)_prePageBtn.parent.removeChild(_prePageBtn);
				_prePageBtn.dispose();
			} 
			_prePageBtn = null;
			if(_fightPowerSortBtn)
			{
				if(_fightPowerSortBtn.parent)_fightPowerSortBtn.parent.removeChild(_fightPowerSortBtn);
				_fightPowerSortBtn.dispose();
			}
			_fightPowerSortBtn = null;
			if(_levenSortBtn)
			{
				if(_levenSortBtn.parent)_levenSortBtn.parent.removeChild(_levenSortBtn);
				_levenSortBtn.dispose();
			}
			_levenSortBtn = null;
			if(_nextPageBtn)
			{
				if(_nextPageBtn.parent)_nextPageBtn.parent.removeChild(_nextPageBtn);
				_nextPageBtn.dispose();
			}
			_nextPageBtn = null;
			if(_okBtn)
			{
				if(_okBtn.parent)_okBtn.parent.removeChild(_okBtn);
				_okBtn.dispose();
			}
			
			_okBtn = null;
			if(_cannelBtn)
			{
				if(_cannelBtn.parent)_cannelBtn.parent.removeChild(_cannelBtn);
				_cannelBtn.dispose();
			}
			_cannelBtn = null;
			if(_checkBox && _checkBox.parent)_checkBox.parent.removeChild(_checkBox);
			_checkBox = null;
			_items = null;
			_current = null;
			if(_bg && _bg.parent)_bg.parent.removeChild(_bg);
			if(_recruitMemberFrame && _recruitMemberFrame.parent)_recruitMemberFrame.parent.removeChild(_recruitMemberFrame);
			if(_recruitMemberFrame)_recruitMemberFrame.dispose();
			_recruitMemberFrame = null;
			if(this.parent)this.parent.removeChild(this);
		}
	}
}