package ddt.consortia.myconsortia
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HCheckBox;
	import road.utils.ComponentHelper;
	
	import tank.consortia.accect.AuditingApplyItemAsset;
	import ddt.consortia.data.ConsortiaDiplomatismInfo;
	import ddt.data.ConsortiaDutyType;
	import ddt.manager.ConsortiaDutyManager;
	import ddt.manager.PlayerManager;
	import ddt.view.common.LevelIcon;

	public class MyConsortiaAuditingApplyItem extends AuditingApplyItemAsset
	{
		private var _seeBtns:HBaseButton;
		private var _acceptBtns : HBaseButton;
		private var _rejectBtns : HBaseButton;
		private var _seeFn:Function;
		private var _okFn:Function;
		private var _canFun:Function;
		private var _levelIcon:LevelIcon;
		private var _checkBox :HCheckBox;
		private var _isChoice :Boolean;
		/**
		 * 排序字段
		 */		
		public var FightPower:int;
		public var Level:int;
		
		public function MyConsortiaAuditingApplyItem(okFn:Function,canFun:Function,seeFn:Function=null)
		{
			_seeFn = seeFn;
			_okFn = okFn;
			_canFun = canFun;
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			setTextField(this.nameTxt);
//			setTextField(this.timeTxt);     bret 09.8.15 不显示申请时间
			_seeBtns = new HBaseButton(this.seeBtns);//查看功能 bret 09.6.12
			_acceptBtns = new HBaseButton(this.acceptBtns);
			_rejectBtns = new HBaseButton(this.rejectBtns);
			_seeBtns.useBackgoundPos = true;
			_acceptBtns.useBackgoundPos = true;
			_rejectBtns.useBackgoundPos = true;
			addChild(_seeBtns);
			addChild(_rejectBtns);
			addChild(_acceptBtns);
			
			_levelIcon = new LevelIcon("s",1,0,0,0,0);
			ComponentHelper.replaceChild(this,levelPos,_levelIcon);
			levelPos.visible = false;
			
			_isChoice = false;
			var checkBoxArea : MovieClip = new MovieClip();
			checkBoxArea.graphics.beginFill(0,0);
			checkBoxArea.graphics.drawRect(-5,-8,120,22);
			checkBoxArea.graphics.endFill();
			_checkBox = new HCheckBox("",checkBoxArea);
			_checkBox.x  = boxPos.x;
			_checkBox.y  = boxPos.y;
			addChild(_checkBox);
		}
		private function addEvent() : void
		{
			_seeBtns.addEventListener(MouseEvent.CLICK,__seeClick);
			_acceptBtns.addEventListener(MouseEvent.CLICK, __acceptClick);
			_rejectBtns.addEventListener(MouseEvent.CLICK, __rejectClick);
			_checkBox.addEventListener(MouseEvent.CLICK		 , __checkBoxCancel);
		}
		
		private function __checkBoxCancel(evt:Event):void
		{
			_checkBox.fireAuto = false;
			_checkBox.selected = !_checkBox.selected;
			_isChoice = _checkBox.selected;
		}
		
		public function boxCancel(value:Boolean):void
		{
			_checkBox.fireAuto = false;
			_checkBox.selected = value;
			_isChoice = _checkBox.selected;
		}
		
		public function get isChoice():Boolean
		{
			return _isChoice;
		}
		
		private function __seeClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_seeFn(_info.UserID);
		}
		private function __acceptClick(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			_okFn(_info.ID);
		}
		private function __rejectClick(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			_canFun(_info.ID);
//			if(this.parent)this.parent.removeChild(this); //bret 09.5.25
		}
		private var _info : Object;
		public function set info(o : Object) : void
		{
			this._info = o;
			upView();
		}
		public function get info() : Object
		{
			return this._info;
		}
		private function upView() : void
		{
			_levelIcon.level = _info.UserLevel;
			_levelIcon.setRepute(_info.Repute);
			_levelIcon.setRate(_info.Win,_info.Total);
			_levelIcon.Battle = _info.FightPower;
			FightPower = _info.FightPower;
			Level      = _info.UserLevel;
			fightPowerTxt.text = _info.FightPower;
			if(_info is ConsortiaDiplomatismInfo)
			{
				this.nameTxt.text = _info.ConsortiaName;
//				this.timeTxt.text = _info.ChairmanName;   bret 09.8.15 不显示申请时间
				var b : Boolean = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._7_Diplomatism);
				this._rejectBtns.enable = this._acceptBtns.enable = b;
			}else
			{
				this.nameTxt.text = _info.UserName;
//				this.timeTxt.text = _info.ApplyDate;      bret 09.8.15 不显示申请时间
			}
			
		}
		private function setTextField(txt : TextField) : void
		{
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.text = "";
		}
		public function dispose() : void
		{
			_seeBtns.removeEventListener(MouseEvent.CLICK,__seeClick);
			_acceptBtns.removeEventListener(MouseEvent.CLICK, __acceptClick);
			_rejectBtns.removeEventListener(MouseEvent.CLICK, __rejectClick);
			if(_seeBtns)
			{
				if(_seeBtns.parent)_seeBtns.parent.removeChild(_seeBtns);
				_seeBtns.dispose();
			}
			_seeBtns = null;
			if(_acceptBtns)
			{
				if(_acceptBtns.parent)this.removeChild(_acceptBtns);
				_acceptBtns.dispose();
			}
			_acceptBtns = null;
			if(_rejectBtns)
			{
				if(_rejectBtns.parent)this.removeChild(_rejectBtns);
				_rejectBtns.dispose();
			}
			_rejectBtns = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
	}
}