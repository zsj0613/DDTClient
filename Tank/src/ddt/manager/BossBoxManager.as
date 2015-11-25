package ddt.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import road.comm.PackageIn;
	import road.data.DictionaryData;
	import road.ui.manager.TipManager;
	
	import ddt.data.bossBoxInfo.GradeBoxInfo;
	import ddt.data.bossBoxInfo.TimeBoxInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.events.CrazyTankSocketEvent;
	import tank.fightLibChooseFightLibTypeView.BookShine;
	import tank.game.movement.SmallBoxButtonAsset;
	import ddt.request.LoadBoxTempInfo;
	import ddt.request.LoadUserBoxInfo;
	import ddt.states.StateType;
	import ddt.view.bossbox.BossBoxView;
	import ddt.view.bossbox.SmallBoxButton;
	import ddt.view.bossbox.TimeCountDown;

	public class BossBoxManager extends EventDispatcher
	{
		private static var _instance:BossBoxManager;
		private var _box:BossBoxView;
		private var _time:TimeCountDown;
		private var _smallBoxButton:SmallBoxButton;
		private var _receiedBox:int = 0;
		private var _delayBox:int = 1;
		private var _startDelayTime:Boolean = true;
		private var _isShowTimeBox:Boolean;
		private var _isShowGradeBox:Boolean;
		private var _isBoxShowedNow:Boolean = false;
		private var _boxShowArray:Array;
		private var _delaySumTime:int = 0;
		private var _isTimeBoxOver:Boolean = false;
		private var _boxButtonShowType:int = SmallBoxButton.showTypeWait;
		private var _currentGrade:int;

		public var timeBoxList:DictionaryData;
		public var gradeBoxList:DictionaryData;
		public var boxTemplateID:Dictionary;
		public var inventoryItemList:DictionaryData;
		
		public static const LOADUSERBOXINFO_COMPLETE:String = "loadUserBoxInfo_complete";
		public static const SHOWBOXINHALLVIEW:String = "showBoxInHallView";
		public static var DataLoaded:Boolean = false;
		
		public function BossBoxManager()
		{
		}
		
		private function init():void
		{
			_time = new TimeCountDown(1000);
			_boxShowArray = new Array();
		}
		
		private function initEvent():void
		{
			_time.addEventListener(TimeCountDown.COUNTDOWN_COMPLETE,_timeOver);
			_time.addEventListener(TimeCountDown.COUNTDOWN_ONE, _timeOne);
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_TIME_BOX,_getTimeBox);
		}
		
		private function _loadGoodsInfo():void
		{
			var loader:LoadUserBoxInfo = new LoadUserBoxInfo();
			loader.loadSync(__sortInfo,3);
		}
		
		private function __sortInfo(loader:LoadUserBoxInfo):void
		{
			if(loader.isSuccess)
			{
				timeBoxList = loader.timeBoxList;
				gradeBoxList = loader.gradeBoxList;
				boxTemplateID = loader.boxTemplateID;
				DataLoaded = true;
				dispatchEvent(new Event(BossBoxManager.LOADUSERBOXINFO_COMPLETE));
				startDelayTime();
			}
		}
		
		private function _loadBoxTempInfo():void
		{
			var loader:LoadBoxTempInfo = new LoadBoxTempInfo(boxTemplateID);
			loader.loadSync(__sortInfoII,3);
		}
		
		private function __sortInfoII(loader:LoadBoxTempInfo):void
		{
			inventoryItemList = loader.inventoryItemList;
		}
		
		public function setup():void
		{
			init();
			initEvent();
			_loadGoodsInfo();
			
			addEventListener(BossBoxManager.LOADUSERBOXINFO_COMPLETE , _loadUserBoxInfo_complete);
		}
		
		private function _loadUserBoxInfo_complete(e:Event):void
		{
			removeEventListener(BossBoxManager.LOADUSERBOXINFO_COMPLETE , _loadUserBoxInfo_complete);
			_loadBoxTempInfo();
		}
		
		public function startDelayTime():void
		{
			resetTime();
		}
		
		private function resetTime():void
		{
			if(timeBoxList == null)return;
			if(timeBoxList[_delayBox] && _startDelayTime && timeBoxList[_delayBox].Level >= currentGrade)
			{
				_time.setTimeOnMinute(timeBoxList[_delayBox].time);
				_delaySumTime = timeBoxList[_delayBox].time * 60;
				_boxButtonShowType = SmallBoxButton.showTypeCountDown;
				if(_smallBoxButton)
				{
					_smallBoxButton.showType(_boxButtonShowType);
					_smallBoxButton.updateTime(_delaySumTime);
				}
			}
		}
		
		public function startGradeChangeEvent():void
		{
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE , _updateGradeII);
		}
		
		private function _updateGradeII(e:PlayerPropertyEvent):void
		{
			if(PlayerManager.Instance.Self.Grade > currentGrade)
			{
				if(_checkeGradeForBox(currentGrade,PlayerManager.Instance.Self.Grade))
					showBoxOfGrade();
			}
		}
		
		private function _checkeGradeForBox(prevGrade:int , NowGrade:int):Boolean
		{
			var bool:Boolean = false;
			currentGrade = PlayerManager.Instance.Self.Grade;
			
			for each(var info:GradeBoxInfo in gradeBoxList)
			{
				if(PlayerManager.Instance.Self.Sex)
				{
					if(info.Level > prevGrade && info.Level <= NowGrade && info.sex)
					{
						_boxShowArray.push(info.boxID +",grade");
						bool = true;
					}
				}
				else
				{
					if(info.Level > prevGrade && info.Level <= NowGrade && !info.sex)
					{
						_boxShowArray.push(info.boxID +",grade");
						bool = true;
					}
				}
			}
			
			return bool;
		}
		
		public function showBoxOfGrade():void
		{
			if(StateManager.currentStateType != StateType.FIGHTING_RESULT && StateManager.currentStateType != StateType.FIGHTING)
			{
				isShowGradeBox = false;
				showGradeBox();
			}
			else
			{
				isShowGradeBox = true;
			}
		}
		
		private function removeEvent():void
		{
			_time.removeEventListener(TimeCountDown.COUNTDOWN_COMPLETE,_timeOver);
			_time.removeEventListener(TimeCountDown.COUNTDOWN_ONE, _timeOne);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_TIME_BOX,_getTimeBox);
		}
		
		private function _getTimeBox(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var isGet:Boolean = pkg.readBoolean();
			var nextBoxTime:int = pkg.readInt();
			
			if(isGet)
			{
				if(_box)
				{
					_box.dispose();
					_box.removeEventListener(BossBoxView.CLOSEBOX , _closeBox);
					_box = null;
				}
				
				_isBoxShowedNow = false;
				_findBoxIdByTime(nextBoxTime);
				resetTime();
				_showOtherBox();
			}
		}
		
		private function _findBoxIdByTime(time:int):void
		{
			if(timeBoxList == null)return;
			for each(var info:TimeBoxInfo in timeBoxList)
			{
				if(time == info.time)
				{
					_receiedBox = info.boxID;
					_delayBox = _receiedBox + 1;
					if(timeBoxList[_delayBox])
						_startDelayTime = true;
					else
					{
						_startDelayTime = false;
						_isTimeBoxOver = true;
						if(_smallBoxButton)
						{
							_smallBoxButton.visible = false;
						}
					}
					return;
				}
			}
			if(time == 0)
			{
				_receiedBox = 0;
				_delayBox = _receiedBox + 1;
				if(timeBoxList[_delayBox])
					_startDelayTime = true;
				else
					_startDelayTime = false;
			}
			else
			{
				_startDelayTime = false;
			}
		}
		
		private function _findBoxIdByTime_II(time:int):void
		{
			var minBoxInfo:TimeBoxInfo;
			for each(var info:TimeBoxInfo in timeBoxList)
			{
				if(info.time > time)
				{
					if(minBoxInfo == null)
						minBoxInfo = info;
					if(info.time < minBoxInfo.time)
						minBoxInfo = info;
				}
			}
			
			if(minBoxInfo)
			{
				_delayBox = minBoxInfo.boxID;
				_startDelayTime = true;
			}
			else
			{
				_startDelayTime = false;
				_isTimeBoxOver = true;
				if(_smallBoxButton)
				{
					_smallBoxButton.visible = false;
				}
			}
		}
		
		private function _findGetedBoxByTime(time:int):void
		{
			for each(var info:TimeBoxInfo in timeBoxList)
			{
				if(time == info.time)
				{
					_receiedBox = info.boxID - 1;
					_delayBox = info.boxID;
					if(timeBoxList[_delayBox])
						_startDelayTime = true;
					else
						_startDelayTime = false;
					return;
				}
			}
		}
		
		private function _findGetedBoxGrade(prevGrade:int , NowGrade:int):Boolean
		{
			var bool:Boolean = false;
			
			for each(var info:GradeBoxInfo in gradeBoxList)
			{
				if(PlayerManager.Instance.Self.Sex)
				{
					if(info.Level > prevGrade && info.Level <= NowGrade && info.sex)
					{
						_boxShowArray.push(info.boxID +",grade");
						bool = true;
					}
				}
				else
				{
					if(info.Level > prevGrade && info.Level <= NowGrade && !info.sex)
					{
						_boxShowArray.push(info.boxID +",grade");
						bool = true;
					}
				}
			}
			
			return bool;
		}
		
		private function _showOtherBox():void
		{
			for(var i:int = 0 ; i < _boxShowArray.length ; i++)
			{
				if(String(_boxShowArray[i]).indexOf("grade") > 0)
				{
					showGradeBox();
					return;
				}
			}
		}
		
		private function _timeOver(e:Event):void
		{
			if(timeBoxList[_delayBox])
			{
				isShowTimeBox = true;
				_boxShowArray.push(_delayBox + ",time");
				_boxButtonShowType = SmallBoxButton.showTypeOpenbox;
				if(_smallBoxButton)
					_smallBoxButton.gotoOpenBox();
				
				SocketManager.Instance.out.sendGetTimeBox(0, timeBoxList[_delayBox].time);
			}
		}
		
		private function _timeOne(e:Event):void
		{
			_delaySumTime--;
			if(_smallBoxButton != null)
			{
				_smallBoxButton.updateTime(_delaySumTime);
			}
		}
		
		private function _getShowBoxID(boxType:String):int
		{
			for(var i:int = 0 ; i < _boxShowArray.length ; i++)
			{
				if(String(_boxShowArray[i]).indexOf(boxType) > 0)
				{
					var id:int = String(_boxShowArray[i]).split(",")[0];
					_boxShowArray.splice(i,1);
					return id;
				}
			}
			return 0;
		}
		
		public function showTimeBox():void
		{
			if(!_isBoxShowedNow)
			{
				var id:int = _getShowBoxID("time");
				if(id != 0)
				{
					_showBox(0, id ,inventoryItemList[timeBoxList[id].TemplateIDList]);
				}
			}
		}
		
		public function showGradeBox():void
		{
			if(!_isBoxShowedNow)
			{
				var id:int = _getShowBoxID("grade");
				if(id != 0)
				{
					_showBox(1, id ,inventoryItemList[gradeBoxList[id].TemplateIDList]);
				}
			}
		}
		
		public function _showBox(boxType:int , _id:int, goodsIDs:Array):void
		{
			_isBoxShowedNow = true;
			_box = new BossBoxView(boxType ,_id , goodsIDs);
			//_box = new BossBoxView(boxType,"2120,15005,7014,5147,1169,8004");//13142,3143,6126,4126,11431,11435");
			TipManager.AddTippanel(_box,false);
			_box.addEventListener(BossBoxView.CLOSEBOX , _closeBox);
		}
		
		private function _closeBox(e:Event):void
		{
			var type:int = (e.target as BossBoxView).boxType;
			if(type == 0)
				SocketManager.Instance.out.sendGetTimeBox(1, type);
			if(type == 1)
			{
				SocketManager.Instance.out.sendGetTimeBox(1, type);
				_closeGradeBox();
			}
		}
		
		private function _closeGradeBox():void
		{
			_box.dispose();
			
			if(_box)
			{
				_box.removeEventListener(BossBoxView.CLOSEBOX , _closeBox);
				_box = null;
			}
			
			_isBoxShowedNow = false;
			_showOtherBox();
		}
		
		private function _smallBoxButton_click(e:Event):void
		{
			if(_isShowTimeBox)
				showTimeBox();
		}
		
		public function isShowBoxButton():Boolean
		{
			if(timeBoxList == null) return false;
			if(PlayerManager.Instance.Self.Grade > timeBoxList[1].Level || _isTimeBoxOver)
			{
				return false;
			}
			else
				return true;
		}
		
		public function deleteBoxButton():void
		{
			_smallBoxButton.removeEventListener(SmallBoxButton.SMALLBOXBUTTON_CLICK, _smallBoxButton_click);
			_smallBoxButton = null;
			
			stopShowTimeBox();
		}
		
		public function stopShowTimeBox():void
		{
			if(_isBoxShowedNow)
			{
				if(_box)
				{
					if(_box.boxType == 0)
					{
						_boxShowArray.push(_box.boxID + ",time");
					}
					
					_box.dispose();
					_box.removeEventListener(BossBoxView.CLOSEBOX , _closeBox);
					_box = null;
				}
				
				_isBoxShowedNow = false;
			}
		}
		
		public var _receieGrade:int;
		public var _needGetBoxTime:int;
		
		public function set receieGrade(value:int):void
		{
			_receieGrade = value;
			
			if(_findGetedBoxGrade(_receieGrade, PlayerManager.Instance.Self.Grade))
			{
				isShowGradeBox = true;
			}
		}
		
		public function set needGetBoxTime(value:int):void
		{
			_needGetBoxTime = value;
			if(_needGetBoxTime > 0)
			{
				_findGetedBoxByTime(_needGetBoxTime);
				if(_startDelayTime)
				{
					isShowTimeBox = true;
					_startDelayTime = false;
					_boxShowArray.push(_delayBox + ",time");
					_boxButtonShowType = SmallBoxButton.showTypeOpenbox;
					if(_smallBoxButton)
						_smallBoxButton.gotoOpenBox();
				}
			}
		}
		
		public function set receiebox(value:int):void
		{
			_findBoxIdByTime(value);
		}
		
		public function set isShowTimeBox(value:Boolean):void
		{
			_isShowTimeBox = value;
		}
		
		public function get isShowTimeBox():Boolean
		{
			return _isShowTimeBox;
		}
		
		public function set isShowGradeBox(value:Boolean):void
		{
			_isShowGradeBox = value;
		}
		
		public function get isShowGradeBox():Boolean
		{
			return _isShowGradeBox;
		}
		
		public function set smallBoxButton(button:SmallBoxButton):void
		{
			_smallBoxButton = button;
			_smallBoxButton.addEventListener(SmallBoxButton.SMALLBOXBUTTON_CLICK, _smallBoxButton_click);
			_smallBoxButton.showType(_boxButtonShowType);
			_smallBoxButton.updateTime(_delaySumTime);
		}
		
		public function set currentGrade(value:int):void
		{
			_currentGrade = value;
			
			for each(var info:TimeBoxInfo in timeBoxList)
			{
				if(_currentGrade > info.Level)
				{
					_startDelayTime = false;
					_isTimeBoxOver = true;
					if(_smallBoxButton)
						_smallBoxButton.visible = false;
					break;
				}
			}
		}
		
		public function get currentGrade():int
		{
			return _currentGrade;
		}
		
		public static function get instance():BossBoxManager
		{
			if(_instance == null)
			{
				_instance = new BossBoxManager();
			}
			
			return _instance;
		}
		
	}
}