package ddt.data.player
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import ddt.data.Experience;
	
	/**
	 * 
	 * @author SYC
	 * 人物基本信息 
	 */	
	[Event (name="property_change",type="ddt.data.player.PlayerPropertyEvent")]
	public class BasePlayer extends EventDispatcher
	{
		/**
		 * 用户区ID,每个中心服务器一个独立的区ID
		 * 默认为0
		 * */
		private var _zoneID:int;
		
		public function set ZoneID(zoneID:int):void
		{
			_zoneID = zoneID;
		} 
		
		public function get ZoneID():int
		{
			return _zoneID;
		}
		
		/**
		 * 用户ＩＤ
		 */		
		public var ID:Number;
		
		/**
		 * 昵称 
		 */		
		public var NickName:String;
		
		/**
		 * 性别 true 为 男，false 为 女
		 */		
		public var Sex:Boolean;
		
		public function get SexByInt():int{
			if(Sex){
				return 1;
			}
			return 2;
		}
		public function set SexByInt(value:int):void{
			
		}
		/**
		 * 登陆时间　 
		 */		
		public var Date:String;
		
		/**
		 * 胜利场数 
		 */		
		public var WinCount:int;
		
		/**
		 * 总场数 
		 */		
		private var _totalCount:int = 0;
		public function get TotalCount():int
		{
			return _totalCount;
		}
		public function set TotalCount(value:int):void
		{
			if(_totalCount == value || value <= 0) return;
			if(_totalCount == value-1 || _totalCount == value - 2){
				onPropertiesChanged("TotalCount");
			}
			_totalCount = value;
		}
		
		
		
		private var _grade:int
		public function get Grade():int
		{
			return _grade;
		}
		public function set Grade(value:int):void
		{
			if(_grade == value || value <= 0) return;
			if(_grade!=0 && _grade < value) IsUpdate = true;
			_grade = value;
			onPropertiesChanged("Grade");
		}
		public var IsUpdate:Boolean;
		
		/**
		 * 积分 
		 */
		 public var _score:Number;	
		 public function get Score():Number
		 {
		 	return _score;
		 }
		 public function set Score(value:Number):void
		 {
		 	if(_score == value) return;
		 	_score = value;
		 	onPropertiesChanged("Score");
		 }
		 
		 /**
		  * 经验 
		  */		 
		 private var _gP:int;
		 public function get GP():int
		 {
		 	return _gP;
		 }
		 public function set GP(value:int):void
		 {
		 	_gP = value;
		 	Grade = Experience.getGrade(_gP);
		 	onPropertiesChanged("GP");
		 }
		 
		 //////////////////////////////////////////////////////工会信息////////////////////////////////////////////////
		 private var _consortiaID:int = 0;
		 public function get ConsortiaID():int
		 {
			return _consortiaID;
		 }
		 public function set ConsortiaID(value:int):void
		 {
			if(_consortiaID == value)	return;
			_consortiaID = value;
			onPropertiesChanged("ConsortiaID");
		 }
		 private var _consortiaName:String;
		 public function set ConsortiaName(value:String):void
		 {
		 	if(_consortiaName == value) return;
		 	_consortiaName = value;
		 	onPropertiesChanged("ConsortiaName");
		 }
		 
		 public function get ConsortiaName():String
		 {
		 	return _consortiaName;
		 }
		 
		 private var _offer:int;
		public function get Offer():int
		{
		 	return _offer;
		}
		public function set Offer(value:int):void
		{
		 	if(_offer == value)return;
		 	_offer = value;
		 	onPropertiesChanged("Offer");
		}
		
		////////////////////////////////////////////////////结婚系统/////////////////////////////////////////////
		/**
		 * 是否已结婚 
		 */		
		private var _isMarried:Boolean;
		/**
		 * 情侣ID 
		 */		
		public var SpouseID:int;
		/**
		 * 情侣昵称 
		 */
		private var _spouseName:String;
		
		public function set SpouseName(value:String):void
		{
			if(_spouseName == value)return;
			_spouseName = value;
			onPropertiesChanged("SpouseName");
		}
		
		public function get SpouseName():String
		{
			return _spouseName;
		}
		
		public function set IsMarried(value:Boolean):void{
			if(value && !_isMarried){
			}
			_isMarried = value;
			onPropertiesChanged("IsMarried");
		}
		public function get IsMarried():Boolean{
			return _isMarried
		}
		 /////////////////////////////////////////////////////BeginChanges / CommitChange ////////////////////////////
		 private var _changeCount:int = 0;
		 protected var _changedPropeties:Dictionary = new Dictionary();
		 public function beginChanges():void
		 {
		 	_changeCount ++;
		 }
		 
		 public function commitChanges():void
		 {
		 	_changeCount --;
		 	if(_changeCount <= 0)
		 	{
		 		_changeCount = 0;
		 		updateProperties();
		 	}
		 }
		 
		 protected function onPropertiesChanged(propName:String = null):void
		 {
		 	if(propName != null)
		 	{
		 		_changedPropeties[propName] = true;
		 	}
		 	if(_changeCount <= 0)
		 	{
		 		_changeCount = 0;
		 		updateProperties();
		 	}
		 }
		 
		 
		 
		 public function updateProperties():void
		 {
		 	var temp:Dictionary = _changedPropeties;
		 	_changedPropeties = new Dictionary();
		 	dispatchEvent(new PlayerPropertyEvent(PlayerPropertyEvent.PROPERTY_CHANGE,temp));
		 }
	}
}