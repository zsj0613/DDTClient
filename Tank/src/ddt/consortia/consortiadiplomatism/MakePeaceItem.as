package ddt.consortia.consortiadiplomatism
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import road.ui.controls.HButton.HBaseButton;
	
	import tank.consortia.accect.ApplyInfoItemAsset;
	import ddt.consortia.data.ConsortiaDiplomatismInfo;
	import ddt.data.ConsortiaDutyType;
	import ddt.manager.ConsortiaDutyManager;
	import ddt.manager.PlayerManager;
	import road.manager.SoundManager;

	public class MakePeaceItem extends ApplyInfoItemAsset
	{
		private var _acceptBtns : HBaseButton;
		private var _rejectBtns : HBaseButton;
		private var _okFn:Function;
		private var _canFun:Function;
		public function MakePeaceItem(okFn:Function,canFun:Function)
		{
			_okFn = okFn;
			_canFun = canFun;
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			setTextField(this.nameTxt);
			setTextField(this.timeTxt);
			_acceptBtns = new HBaseButton(this.acceptBtns);
			_rejectBtns = new HBaseButton(this.rejectBtns);
			_acceptBtns.useBackgoundPos = true;
			_rejectBtns.useBackgoundPos = true;
			addChild(_rejectBtns);
			addChild(_acceptBtns);
			this.gotoAndStop(1);
		}
		private function addEvent() : void
		{
			_acceptBtns.addEventListener(MouseEvent.CLICK, __acceptClick);
			_rejectBtns.addEventListener(MouseEvent.CLICK, __rejectClick);
		}
		private function __acceptClick(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			_okFn(_info.ID)
		}
		private function __rejectClick(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			_canFun(_info.ID)
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
			if(_info is ConsortiaDiplomatismInfo)
			{
				this.nameTxt.text = _info.ConsortiaName;
				this.timeTxt.text = _info.ChairmanName;
				var b : Boolean = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._7_Diplomatism);
				this._rejectBtns.enable = this._acceptBtns.enable = b;
			}else
			{
				this.nameTxt.text = _info.UserName;
				this.timeTxt.text = _info.ApplyDate;
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
			_acceptBtns.removeEventListener(MouseEvent.CLICK, __acceptClick);
			_rejectBtns.removeEventListener(MouseEvent.CLICK, __rejectClick);
			if(_acceptBtns)
			{
				_acceptBtns.dispose();
				if(_acceptBtns.parent)this.removeChild(_acceptBtns);
			}
			_acceptBtns = null;
			if(_rejectBtns)
			{
				_rejectBtns.dispose();
				if(_rejectBtns.parent)this.removeChild(_rejectBtns);
			}
			_rejectBtns = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
	}
}