package ddt.tofflist.view
{
	import flash.events.MouseEvent;
	
	import game.crazytank.view.tofflist.TofflistMenuBarAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	
	import ddt.tofflist.TofflistEvent;
	import ddt.utils.DisposeUtils;

	public class TofflistStairMenu extends TofflistMenuBarAsset
	{
		public static const PERSONAL:String = "personal";
		public static const CONSORTIA:String = "consortia";
		public static const CROSS_SERVER_PERSONAL:String = "crossServerPersonal";
		public static const CROSS_SERVER_CONSORTIA:String = "crossServerConsortia";
		
		private var _type      				   : String = PERSONAL;
		private var _currentBtn       		   : HFrameButton;
		private var _consortiaOrderBtn 		   : HFrameButton;
		private var _crossServerIndividualBtn  : HFrameButton;
		private var _crossServerConsortiaBtn   : HFrameButton;
		private var _individualOrderBtn  : HFrameButton;
		public function TofflistStairMenu()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			_consortiaOrderBtn = new HFrameButton(this.consortiaOrderBtnAsset);
			_consortiaOrderBtn.useBackgoundPos = true;
			addChild(_consortiaOrderBtn);
			
			_crossServerIndividualBtn = new HFrameButton(this.crossServerIndividualBtn);
			_crossServerIndividualBtn.useBackgoundPos = true;
//			_crossServerIndividualBtn.enable = false;
			addChild(_crossServerIndividualBtn);
			
			_crossServerConsortiaBtn = new HFrameButton(this.crossServerConsortiaBtn);
			_crossServerConsortiaBtn.useBackgoundPos = true;
//			_crossServerConsortiaBtn.enable = false;
			addChild(_crossServerConsortiaBtn);
			
			_individualOrderBtn = new HFrameButton(this.individualOrderBtnAsset);
			_individualOrderBtn.useBackgoundPos = true;
			addChild(_individualOrderBtn);
		}
		private function addEvent() : void
		{
			_consortiaOrderBtn.addEventListener(MouseEvent.CLICK,      			__selectToolBarHandler);
			_crossServerIndividualBtn.addEventListener(MouseEvent.CLICK,        __selectToolBarHandler);
			_crossServerConsortiaBtn.addEventListener(MouseEvent.CLICK,         __selectToolBarHandler);
			_individualOrderBtn.addEventListener(MouseEvent.CLICK,    			__selectToolBarHandler);
		}
		private function removeEvent() : void
		{
			_consortiaOrderBtn.removeEventListener(MouseEvent.CLICK,    		 __selectToolBarHandler);
			_crossServerIndividualBtn.removeEventListener(MouseEvent.CLICK,   	 __selectToolBarHandler);
			_crossServerConsortiaBtn.removeEventListener(MouseEvent.CLICK,       __selectToolBarHandler);
			_individualOrderBtn.removeEventListener(MouseEvent.CLICK,  			 __selectToolBarHandler);
		}
		public function dispose() : void
		{
			removeEvent();
			DisposeUtils.disposeHBaseButton(_currentBtn);
			DisposeUtils.disposeHBaseButton(_consortiaOrderBtn);
			DisposeUtils.disposeHBaseButton(_crossServerIndividualBtn);
			DisposeUtils.disposeHBaseButton(_crossServerConsortiaBtn);
			DisposeUtils.disposeHBaseButton(_individualOrderBtn);
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function __selectToolBarHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			if(_currentBtn)_currentBtn.selected = false;
			_currentBtn = evt.target.parent.parent as HFrameButton;
			_currentBtn.selected = true;
			switch(evt.target.name)
			{
				case "consortiaOrderBtnAsset":
					this._type = CONSORTIA;
					break;
				case "crossServerConsortiaBtn":
					this._type = CROSS_SERVER_CONSORTIA;
				break;
				case "crossServerIndividualBtn":
					this._type = CROSS_SERVER_PERSONAL;
				break;
				case "individualOrderBtnAsset":
					this._type = PERSONAL;
					break;
			}
			this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,_type));
		}
		public function get type() : String
		{
			return this._type;
		}
		public function set type(value : String) : void
		{
			_type = value;
			if(_currentBtn)_currentBtn.selected = false;
			if(_type == PERSONAL)
			{
				_currentBtn = _individualOrderBtn
			}
			else if(_type == CONSORTIA)
			{
				_currentBtn = _consortiaOrderBtn;
			}
			else if(_type == CROSS_SERVER_PERSONAL)
			{
				_currentBtn = _crossServerIndividualBtn;
			}
			else if(_type == CROSS_SERVER_CONSORTIA)
			{
				_currentBtn = _crossServerConsortiaBtn;
			}
			_currentBtn.selected = true;
			this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,_type));
		}
	}
}