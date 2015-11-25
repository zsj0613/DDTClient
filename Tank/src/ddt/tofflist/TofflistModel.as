package ddt.tofflist
{
	import flash.events.EventDispatcher;
	
	import ddt.data.player.PlayerInfo;
	import ddt.tofflist.view.TofflistStairMenu;
	import ddt.tofflist.view.TofflistThirdClassMenu;
	import ddt.tofflist.view.TofflistTwoGradeMenu;
	
	public class TofflistModel
	{
		/*** 个人排行1,2,3,4* 公会排行5,6,7* */
		private static var _tofflistType       : int;
		/**1,日排。2，周排。3，累积.**/ 
		public static var childType            : int;
		private static var _currentPlayerInfo  : PlayerInfo;
		public  static var currentText         : String;
		public  static var currentIndex        : int;
		
		private static var _firstMenuType:String = TofflistStairMenu.PERSONAL;
		private static var _secondMenuType:String = TofflistTwoGradeMenu.BATTLE;
		private static var _thirdMenuType:String = TofflistThirdClassMenu.TOTAL;
		
		private var _lastUpdateTime:String = "";
		
		private static var _dispatcher         : EventDispatcher = new EventDispatcher();
		
		public static function addEventListener(type:String,listener:Function,useCapture:Boolean=false) : void
		{
			_dispatcher.addEventListener(type,listener,useCapture);
		}
		public static function removeEventListener(type:String,listener:Function,useCapture:Boolean=false) : void
		{
			_dispatcher.removeEventListener(type,listener,useCapture);
		}
		/**类型**/
		public static function set firstMenuType(type : String) : void
		{
			_firstMenuType = type;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TYPE_CHANGE,type));
			
		}
		public static function get firstMenuType() : String
		{
			return _firstMenuType;
		}
		
		public static function set secondMenuType(type:String):void
		{
			_secondMenuType = type;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TYPE_CHANGE,type));
		}
		
		public static function get secondMenuType():String
		{
			return _secondMenuType;
		}
		
		public static function set thirdMenuType(type:String):void
		{
			_thirdMenuType = type;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TYPE_CHANGE,type));
		}
		
		public static function get thirdMenuType():String
		{
			return _thirdMenuType;
		}
		
		/**在列表中选择的玩家，或选择公会时选中的会长**/
		public static function set currentPlayerInfo(info : PlayerInfo) : void
		{
			_currentPlayerInfo = info;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_CURRENT_PLAYER,info));	
		}
		public static function  get currentPlayerInfo() : PlayerInfo
		{
			return _currentPlayerInfo;
		}
		
		
		
		/**个人，等级，日增**/
		private var _individualGradeDay : Array;
		public function set individualGradeDay(arr : Array) : void
		{
			this._individualGradeDay = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY));
			
		}
		public function get individualGradeDay() : Array
		{
			return this._individualGradeDay;
		}
		
		/**个人，等级，周增**/
		private var _individualGradeWeek : Array;
		public function set individualGradeWeek(arr : Array) : void
		{
			this._individualGradeWeek = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK));
		}
		public function get individualGradeWeek() : Array
		{
			return this._individualGradeWeek;
		}
		
		/**个人，等级，累积**/
		private var _individualGradeAccumulate : Array;
		public function set individualGradeAccumulate(arr : Array) : void
		{
			this._individualGradeAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE));
		}
		public function get individualGradeAccumulate() : Array
		{
			return this._individualGradeAccumulate;
		}
		
		/**个人，功勋，日增**/
		private var _individualExploitDay : Array;
		public function set individualExploitDay(arr : Array) : void
		{
			this._individualExploitDay = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY));
		}
		public function get individualExploitDay() : Array
		{
			return this._individualExploitDay;
		}
		/**个人，功勋，周增**/
		private var _individualExploitWeek : Array;
		public function set individualExploitWeek(arr : Array) : void
		{
			this._individualExploitWeek = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK));
		} 
		public function get individualExploitWeek() : Array
		{
			return this._individualExploitWeek;
		}
		/**人个，功勋，累积**/
		private var _individualExploitAccumulate : Array;
		public function set individualExploitAccumulate(arr : Array) : void
		{
			this._individualExploitAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE));
		}
		public function get individualExploitAccumulate() : Array
		{
			return this._individualExploitAccumulate;
		}  
		
		/**公会，等级，日增**/
//		private var _consortiaGradeDay : Array;
//		public function set consortiaGradeDay(arr : Array) : void
//		{
//			this._consortiaGradeDay = arr;
//			
//		}
//		public function get consortiaGradeDay() : Array
//		{
//			return this._consortiaGradeDay;
//		}
//		/**公会，等级，周增**/
//		private var _consortiaGradeWeek : Array
//		public function set consortiaGradeWeek(arr : Array) : void
//		{
//			this._consortiaGradeWeek = arr;
//		}
//		public function get consortiaGradeWeek() : Array
//		{
//			return this._consortiaGradeWeek;
//		}
		/**公会，等级，累积**/
		private var _consortiaGradeAccumulate: Array;
		public function set consortiaGradeAccumulate(arr : Array) : void
		{
			this._consortiaGradeAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE));
		}
		public function get consortiaGradeAccumulate() : Array
		{
			return this._consortiaGradeAccumulate;
		}
		/**公会，资产，日增***/
		private var _consortiaAssetDay : Array;
		public function set consortiaAssetDay(arr : Array) : void
		{
			this._consortiaAssetDay = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY));
		}
		public function get consortiaAssetDay() : Array
		{
			return this._consortiaAssetDay;
		}
		/**公会，资产，周增***/
		private var _consortiaAssetWeek : Array;
		public function set consortiaAssetWeek($list : Array) : void
		{
			this._consortiaAssetWeek = $list;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK));
		}
		public function get consortiaAssetWeek() : Array
		{
			return this._consortiaAssetWeek;
		}
		/**公会，资产，累积**/
		private var _consortiaAssetAccumulate : Array;
		public function set consortiaAssetAccumulate(arr : Array) : void
		{
			this._consortiaAssetAccumulate = arr;
			
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE));
		}
		public function get consortiaAssetAccumulate() : Array
		{
			return this._consortiaAssetAccumulate;
		}
		/**公会，功勋，日增**/
		private var _consortiaExploitDay : Array;
		public function set consortiaExploitDay($list : Array) : void
		{
			this._consortiaExploitDay = $list;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY));
		}
		public function get consortiaExploitDay() : Array
		{
			return this._consortiaExploitDay;
		}
		/**公会，功勋，周增***/
		private var _consortiaExploitWeek : Array;
		public function set consortiaExploitWeek($list : Array) : void
		{
			this._consortiaExploitWeek = $list;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK));
		}
		public function get consortiaExploitWeek() : Array
		{
			return this._consortiaExploitWeek;
		}
		/**公会，功勋，累积**/
		private var _consortiaExploitAccumulate : Array;
		public function set consortiaExploitAccumulate(arr : Array) : void
		{
			this._consortiaExploitAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE));
			
		}
		public function get consortiaExploitAccumulate() : Array
		{
			return this._consortiaExploitAccumulate;
		}
		
		/**公会，战斗力，累积*/
		private var _consortiaBattleAccumulate:Array
		public function set consortiaBattleAccumulate(value:Array):void
		{
			_consortiaBattleAccumulate = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE));
		}
		
		public function get consortiaBattleAccumulate():Array
		{
			return _consortiaBattleAccumulate;
		}
		
		/**个人，战斗力，累积*/
		private var _personalBattleAccumulate : Array;
		public function set personalBattleAccumulate(arr:Array):void
		{
			_personalBattleAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE));
		}
		
		public function get personalBattleAccumulate():Array
		{
			return _personalBattleAccumulate;
		}
		
		public function get lastUpdateTime():String
		{
			return _lastUpdateTime;
		}
		
		public function set lastUpdateTime(value:String):void
		{
			_lastUpdateTime = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE));
		}
		
		/****************************************************
		 *跨服数据 
		 ***************************************************/
		 
		/**跨服个人，等级，日增**/
		private var _crossServerIndividualGradeDay : Array;
		public function set crossServerIndividualGradeDay(arr : Array) : void
		{
			this._crossServerIndividualGradeDay = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY));
			
		}
		public function get crossServerIndividualGradeDay() : Array
		{
			return this._crossServerIndividualGradeDay;
		}
		
		/**跨服个人，等级，周增**/
		private var _crossServerIndividualGradeWeek : Array;
		public function set crossServerIndividualGradeWeek(arr : Array) : void
		{
			this._crossServerIndividualGradeWeek = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK));
		}
		public function get crossServerIndividualGradeWeek() : Array
		{
			return this._crossServerIndividualGradeWeek;
		}
		
		/**跨服个人，等级，累积**/
		private var _crossServerIndividualGradeAccumulate : Array;
		public function set crossServerIndividualGradeAccumulate(arr : Array) : void
		{
			this._crossServerIndividualGradeAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE));
		}
		public function get crossServerIndividualGradeAccumulate() : Array
		{
			return this._crossServerIndividualGradeAccumulate;
		}
		
		/**跨服个人，功勋，日增**/
		private var _crossServerIndividualExploitDay : Array;
		public function set crossServerIndividualExploitDay(arr : Array) : void
		{
			this._crossServerIndividualExploitDay = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY));
		}
		public function get crossServerIndividualExploitDay() : Array
		{
			return this._crossServerIndividualExploitDay;
		}
		
		/**跨服个人，功勋，周增**/
		private var _crossServerIndividualExploitWeek : Array;
		public function set crossServerIndividualExploitWeek(arr : Array) : void
		{
			this._crossServerIndividualExploitWeek = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK));
		} 
		public function get crossServerIndividualExploitWeek() : Array
		{
			return this._crossServerIndividualExploitWeek;
		}
		
		/**跨服人个，功勋，累积**/
		/**人个，功勋，累积**/
		private var _crossServerIndividualExploitAccumulate : Array;
		public function set crossServerIndividualExploitAccumulate(arr : Array) : void
		{
			this._crossServerIndividualExploitAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE));
		}
		public function get crossServerIndividualExploitAccumulate() : Array
		{
			return this._crossServerIndividualExploitAccumulate;
		}
		
		/**跨服个人，战斗力，累积*/		
		private var _crossServerPersonalBattleAccumulate : Array;
		public function set crossServerPersonalBattleAccumulate(arr:Array):void
		{
			_crossServerPersonalBattleAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE));
		}
		public function get crossServerPersonalBattleAccumulate():Array
		{
			return _crossServerPersonalBattleAccumulate;
		}
		
		/**跨服公会，等级，累积**/
		private var _crossServerConsortiaGradeAccumulate: Array;
		public function set crossServerConsortiaGradeAccumulate(arr : Array) : void
		{
			this._crossServerConsortiaGradeAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE));
		}
		public function get crossServerConsortiaGradeAccumulate() : Array
		{
			return this._crossServerConsortiaGradeAccumulate;
		}
		
		/**跨服公会，资产，日增**/
		private var _crossServerConsortiaAssetDay : Array;
		public function set crossServerConsortiaAssetDay(arr : Array) : void
		{
			this._crossServerConsortiaAssetDay = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY));
		}
		public function get crossServerConsortiaAssetDay() : Array
		{
			return this._crossServerConsortiaAssetDay;
		}
		
		/**跨服公会，资产，周增**/
		private var _crossServerConsortiaAssetWeek : Array;
		public function set crossServerConsortiaAssetWeek($list : Array) : void
		{
			this._crossServerConsortiaAssetWeek = $list;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK));
		}
		public function get crossServerConsortiaAssetWeek() : Array
		{
			return this._crossServerConsortiaAssetWeek;
		}
		
		/**跨服公会，资产，累积**/
		private var _crossServerConsortiaAssetAccumulate : Array;
		public function set crossServerConsortiaAssetAccumulate(arr : Array) : void
		{
			this._crossServerConsortiaAssetAccumulate = arr;
			
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE));
		}
		public function get crossServerConsortiaAssetAccumulate() : Array
		{
			return this._crossServerConsortiaAssetAccumulate;
		}
		
		/**跨服公会，功勋，日增**/
		private var _crossServerConsortiaExploitDay : Array;
		public function set crossServerConsortiaExploitDay($list : Array) : void
		{
			this._crossServerConsortiaExploitDay = $list;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY));
		}
		public function get crossServerConsortiaExploitDay() : Array
		{
			return this._crossServerConsortiaExploitDay;
		}
		
		/**跨服公会，功勋，周增**/
		private var _crossServerConsortiaExploitWeek : Array;
		public function set crossServerConsortiaExploitWeek($list : Array) : void
		{
			this._crossServerConsortiaExploitWeek = $list;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK));
		}
		public function get crossServerConsortiaExploitWeek() : Array
		{
			return this._crossServerConsortiaExploitWeek;
		}
		
		/**跨服公会，功勋，累积**/
		private var _crossServerConsortiaExploitAccumulate : Array;
		public function set crossServerConsortiaExploitAccumulate(arr : Array) : void
		{
			this._crossServerConsortiaExploitAccumulate = arr;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE));
			
		}
		public function get crossServerConsortiaExploitAccumulate() : Array
		{
			return this._crossServerConsortiaExploitAccumulate;
		}
		
		/**跨服公会，战斗力，累积*/
		private var _crossServerConsortiaBattleAccumulate:Array
		public function set crossServerConsortiaBattleAccumulate(value:Array):void
		{
			_crossServerConsortiaBattleAccumulate = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE));
		}
		
		public function get crossServerConsortiaBattleAccumulate():Array
		{
			return _crossServerConsortiaBattleAccumulate;
		}
		
		/**本区个人，成就点，累积*/
		private var _personalAchievementPoint:Array
		public function set PersonalAchievementPoint(value:Array):void
		{
			_personalAchievementPoint = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE));
		}
		
		public function get PersonalAchievementPoint():Array
		{
			return _personalAchievementPoint;
		}
		
		/**本区个人，成就点，日增*/
		private var _personalAchievementPointDay:Array
		public function set PersonalAchievementPointDay(value:Array):void
		{
			_personalAchievementPointDay = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY));
		}
		
		public function get PersonalAchievementPointDay():Array
		{
			return _personalAchievementPointDay;
		}
		
		/**本区个人，成就点，周增*/
		private var _personalAchievementPointWeek:Array
		public function set PersonalAchievementPointWeek(value:Array):void
		{
			_personalAchievementPointWeek = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK));
		}
		public function get PersonalAchievementPointWeek():Array
		{
			return _personalAchievementPointWeek;
		}
		
		/**跨区个人，成就点，累积*/
		private var _crossServerPersonalAchievementPoint:Array
		public function set crossServerPersonalAchievementPoint(value:Array):void
		{
			_crossServerPersonalAchievementPoint = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE));
		}
		
		public function get crossServerPersonalAchievementPoint():Array
		{
			return _crossServerPersonalAchievementPoint;
		}
		
		/**跨区个人，成就点，日增*/
		private var _crossServerPersonalAchievementPointDay:Array
		public function set crossServerPersonalAchievementPointDay(value:Array):void
		{
			_crossServerPersonalAchievementPointDay = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY));
		}
		
		public function get crossServerPersonalAchievementPointDay():Array
		{
			return _crossServerPersonalAchievementPointDay;
		}
		
		/**跨区个人，成就点，周增*/
		private var _crossServerPersonalAchievementPointWeek:Array
		public function set crossServerPersonalAchievementPointWeek(value:Array):void
		{
			_crossServerPersonalAchievementPointWeek = value;
			_dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK));
		}
		
		public function get crossServerPersonalAchievementPointWeek():Array
		{
			return _crossServerPersonalAchievementPointWeek;
		}
		/*********************************************
		 *            单例模式
		 * ******************************************/
		private static var _instance : TofflistModel;
		public static function get Instance() : TofflistModel
		{
			if(_instance == null)
			{
				_instance = new TofflistModel();
			}
			return _instance;
		}
		
		
	}
}