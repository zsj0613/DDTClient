package ddt.tofflist.view
{
	import flash.events.MouseEvent;
	
	import game.crazytank.view.tofflist.TofflistThirdClassMenuAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	
	import ddt.tofflist.TofflistEvent;
	import ddt.tofflist.TofflistModel;
	import ddt.utils.DisposeUtils;

	public class TofflistThirdClassMenu extends TofflistThirdClassMenuAsset
	{
		public static const DAY:String = "day";
		public static const WEEK:String = "week";
		public static const TOTAL:String = "total";
		
		private var _type : String;
		private var _accumulateBtn     : HFrameButton;
		private var _dayAddBtn         : HFrameButton;
		private var _weekAddBtn        : HFrameButton;
		private var _currentItem       : HFrameButton;
		public function TofflistThirdClassMenu()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			_accumulateBtn = new HFrameButton(accumulateBtnAsset);
			_accumulateBtn.useBackgoundPos = true;
			addChild(_accumulateBtn);
			
			_dayAddBtn = new HFrameButton(dayAddBtnAsset);
			_dayAddBtn.useBackgoundPos = true;
			addChild(_dayAddBtn);
			
			_weekAddBtn = new HFrameButton(weekAddBtnAsset);
			_weekAddBtn.useBackgoundPos = true;
			addChild(_weekAddBtn);
		}
		private function addEvent() : void
		{
			_dayAddBtn.addEventListener(MouseEvent.CLICK,      __selectMenuHandler);
			_weekAddBtn.addEventListener(MouseEvent.CLICK,     __selectMenuHandler);
			_accumulateBtn.addEventListener(MouseEvent.CLICK,  __selectMenuHandler);
		}
		private function removeEvent() : void
		{
			_dayAddBtn.removeEventListener(MouseEvent.CLICK,      __selectMenuHandler);
			_weekAddBtn.removeEventListener(MouseEvent.CLICK,     __selectMenuHandler);
			_accumulateBtn.removeEventListener(MouseEvent.CLICK,  __selectMenuHandler);
		}
		private function __selectMenuHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			if(_currentItem)_currentItem.selected = false;
			_currentItem = evt.target.parent.parent as HFrameButton;
			_currentItem.selected = true;
			if(evt.target.name == "dayAddBtnAsset")
			{
				TofflistModel.thirdMenuType = _type = DAY;
			}
			else if(evt.target.name == "weekAddBtnAsset")
			{
				TofflistModel.thirdMenuType = _type = WEEK;
			}
			else if(evt.target.name == "accumulateBtnAsset")
			{
				TofflistModel.thirdMenuType = _type = TOTAL;
			}
			this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,_type));
		}
		public function selectType(parentType : String,secondType : String) : void
		{
			if(_currentItem)_currentItem.selected = false;
			if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL || TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
			{
				if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
				{
					 _weekAddBtn.enable = _dayAddBtn.enable = false;
					 _currentItem = this._accumulateBtn;
				     _type = TOTAL;
				}else
				{
					_dayAddBtn.enable = _weekAddBtn.enable = true;
				    _currentItem = this._weekAddBtn;
			    	_type = WEEK;
				}
			}else if(TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA || TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_CONSORTIA)
			{
				if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL || TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
				{
					_weekAddBtn.enable = _dayAddBtn.enable = false;
			        _currentItem = this._accumulateBtn;
			        _type = TOTAL;
				}else
				{
					_dayAddBtn.enable = _weekAddBtn.enable = true;
				    _currentItem = this._weekAddBtn;
			    	_type = WEEK;
				}
			}
			_currentItem.selected = true;
			TofflistModel.thirdMenuType = _type;
			this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,_type));
		}
		
		public function get type() : String
		{
			return this._type;
		}
		public function dispose() : void
		{
			removeEvent();
			DisposeUtils.disposeHBaseButton(_accumulateBtn);
			DisposeUtils.disposeHBaseButton(_dayAddBtn);
			DisposeUtils.disposeHBaseButton(_weekAddBtn);
			DisposeUtils.disposeHBaseButton(_currentItem);
			if(this.parent)this.parent.removeChild(this);
		}
		
		public function set dayAddEnable(b : Boolean) : void
		{
			this._dayAddBtn.enable = b;
		}
		public function set weekAddEnable(b : Boolean) : void
		{
			this._weekAddBtn.enable = b;
		}
		public function set accumulate(b : Boolean) : void
		{
			this._accumulateBtn.enable = b;
		}
		
	}
}
