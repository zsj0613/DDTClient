package ddt.tofflist
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import ddt.manager.PlayerManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.tofflist.requests.TofflistConsortiaAssetAccumulateList;
	import ddt.tofflist.requests.TofflistConsortiaAssetDayList;
	import ddt.tofflist.requests.TofflistConsortiaAssetWeekList;
	import ddt.tofflist.requests.TofflistConsortiaBattleList;
	import ddt.tofflist.requests.TofflistConsortiaExloitAccumulateList;
	import ddt.tofflist.requests.TofflistConsortiaExploitDayList;
	import ddt.tofflist.requests.TofflistConsortiaExploitWeekList;
	import ddt.tofflist.requests.TofflistConsortiaGradeList;
	import ddt.tofflist.requests.TofflistEffortValueAccumulateList;
	import ddt.tofflist.requests.TofflistEffortValueDayList;
	import ddt.tofflist.requests.TofflistEffortValueWeekList;
	import ddt.tofflist.requests.TofflistIndividaulBattleList;
	import ddt.tofflist.requests.TofflistIndividualExploitAccumulateList;
	import ddt.tofflist.requests.TofflistIndividualExploitDayList;
	import ddt.tofflist.requests.TofflistIndividualExploitWeekList;
	import ddt.tofflist.requests.TofflistIndividualGradeAccumulateList;
	import ddt.tofflist.requests.TofflistIndividualGradeDayList;
	import ddt.tofflist.requests.TofflistIndividualGradeWeekList;
	import ddt.tofflist.view.TofflistView;
	import ddt.view.common.BellowStripViewII;

	public class TofflistController extends BaseStateView
	{
		private var _container : Sprite;
		private var _view      : TofflistView;
		public function TofflistController()
		{
			super();
		}
		private function init() : void
		{
			_container = new Sprite();
			_view  = new TofflistView(this);
			_container.addChild(_view);
		}
		/********************************
		 *  EXTENDS
		 * ******************************/
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			super.enter(prev,data);
			init();
			_view.addEvent();
			PlayerManager.Instance.Self.sendGetMyConsortiaData();
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
		}
		
		override public function leaving(next:BaseStateView):void
		{
			dispose();
			_view.removeEvent();
			_view=null;
			BellowStripViewII.Instance.hide();
			super.leaving(next);
		}
		
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		override public function getType():String
		{
			return StateType.TOFFLIST;
		}
		
		
		/********************************
		 *  REQUEST
		 * *****************************/
		 
		 /**人个，功勋，日增**/
		 public function loadIndividualExploitDay() : void
		 {
		 	if(!TofflistModel.Instance.individualExploitDay)
		 	{
		 		new TofflistIndividualExploitDayList().loadSync(__individualExploitDayResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.individualExploitDay = TofflistModel.Instance.individualExploitDay;
		 	}
		 }
		 private function __individualExploitDayResult(action : TofflistIndividualExploitDayList) : void
		 {
		 	TofflistModel.Instance.individualExploitDay = action.list;
		 }	
		 
		 /**人个，功勋，周增**/
		 public function loadIndividualExploitWeek() : void
		 {
		 	if(!TofflistModel.Instance.individualExploitWeek)
		 	{
		 		new TofflistIndividualExploitWeekList().loadSync(__individualExploitWeekListResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.individualExploitWeek = TofflistModel.Instance.individualExploitWeek;
		 	}
		 }
		 private function __individualExploitWeekListResult(action : TofflistIndividualExploitWeekList) : void
		 {
		 	TofflistModel.Instance.individualExploitWeek = action.list;
		 }
		 
		 
		 /**人个，功勋，累积**/
		 public function loadIndividualExploitAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.individualExploitAccumulate)
		 	{
		 		new TofflistIndividualExploitAccumulateList().loadSync(__IndividualExploitAccumulateResut);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.individualExploitAccumulate = TofflistModel.Instance.individualExploitAccumulate;
		 	}
		 }
		 private function __IndividualExploitAccumulateResut(action : TofflistIndividualExploitAccumulateList) : void
		 {
		 	TofflistModel.Instance.individualExploitAccumulate = action.list;
		 }		
		  
		 /**个人，等级，日增**/
		 public function loadIndividualGradeDay() : void
		 {
		 	if(!TofflistModel.Instance.individualGradeDay)
		 	{
		 		new TofflistIndividualGradeDayList().loadSync(__individualGradeDayListResut);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.individualGradeDay = TofflistModel.Instance.individualGradeDay;
		 	}
		 }
		 private function __individualGradeDayListResut(action : TofflistIndividualGradeDayList) : void
		 {
		 	TofflistModel.Instance.individualGradeDay = action.list;
		 }	
		  
		 /**个人，等级，周增**/
		 public function loadIndividualGradeWeek() : void
		 {
		 	if(!TofflistModel.Instance.individualGradeWeek)
		 	{
		 		new TofflistIndividualGradeWeekList().loadSync(__individualGradeWeekListResut);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.individualGradeWeek = TofflistModel.Instance.individualGradeWeek;
		 	}
		 }
		 private function __individualGradeWeekListResut(action : TofflistIndividualGradeWeekList) : void
		 {
		 	TofflistModel.Instance.individualGradeWeek = action.list;
		 }
		 
		 /**个人，等级，累积**/
		 public function loadIndividualGradeAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.individualGradeAccumulate)
		 	{
		 		new TofflistIndividualGradeAccumulateList().loadSync(__individualGradeAccumulateListResut);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.individualGradeAccumulate = TofflistModel.Instance.individualGradeAccumulate;
		 	}
		 }
		 private function __individualGradeAccumulateListResut(action : TofflistIndividualGradeAccumulateList) : void
		 {
		 	TofflistModel.Instance.individualGradeAccumulate = action.list;
		 }
			 
		 /**公会，等级，累积**/
		 public function loadConsortiaAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.consortiaGradeAccumulate)
		 	{
		 		new TofflistConsortiaGradeList().loadSync(__consortiaRichesResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.consortiaGradeAccumulate = TofflistModel.Instance.consortiaGradeAccumulate;
		 	}
		 }
		 private function __consortiaRichesResult(action : TofflistConsortiaGradeList) : void
		 {
		 	TofflistModel.Instance.consortiaGradeAccumulate = action.list;
		 }
		 /**公会，资产，日增**/
		 public function loadConsortiaAssetDay() : void
		 {
		 	if(!TofflistModel.Instance.consortiaAssetDay)
		 	{
		 		new TofflistConsortiaAssetDayList().loadSync(__consortiaAssetDayResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.consortiaAssetDay = TofflistModel.Instance.consortiaAssetDay;
		 	}
		 }
		 private function __consortiaAssetDayResult(action : TofflistConsortiaAssetDayList) : void
		 {
		 	TofflistModel.Instance.consortiaAssetDay = action.list;
		 }
		 /**公会，资产，周增**/
		 public function loadConsoritaAssetWeek() : void
		 {
		 	if(!TofflistModel.Instance.consortiaAssetWeek)
		 	{
		 		new TofflistConsortiaAssetWeekList().loadSync(__consortiaAssetWeekResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.consortiaAssetWeek = TofflistModel.Instance.consortiaAssetWeek;
		 	}
		 }
		 private function __consortiaAssetWeekResult(action : TofflistConsortiaAssetWeekList) : void
		 {
		 	TofflistModel.Instance.consortiaAssetWeek = action.list;
		 }
		 /**公会，资产，累积**/
		 public function loadConsortiaAssetAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.consortiaAssetAccumulate)
		 	{
		 		new TofflistConsortiaAssetAccumulateList().loadSync(__consortiaAssetAccumulateResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.consortiaAssetAccumulate = TofflistModel.Instance.consortiaAssetAccumulate;
		 	}
		 }
		 private function __consortiaAssetAccumulateResult(action : TofflistConsortiaAssetAccumulateList) : void
		 {
		 	TofflistModel.Instance.consortiaAssetAccumulate = action.list;
		 }
		 /**公会，功勋，日增**/
		 public function loadConsortiaExploitDay() : void
		 {
		 	if(!TofflistModel.Instance.consortiaExploitDay)
		 	{
		 		new TofflistConsortiaExploitDayList().loadSync(__consortiaExploitDayResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.consortiaExploitDay = TofflistModel.Instance.consortiaExploitDay;
		 	}
		 }
		 private function __consortiaExploitDayResult(action : TofflistConsortiaExploitDayList) : void
		 {
		 	TofflistModel.Instance.consortiaExploitDay = action.list;
		 }
		 /**公会，功勋，周增**/
		 public function loadConsortiaExploitWeek() : void
		 {
		 	if(!TofflistModel.Instance.consortiaExploitWeek)
		 	{
		 		new TofflistConsortiaExploitWeekList().loadSync(__consortiaExploitWeekResult);	
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.consortiaExploitWeek = TofflistModel.Instance.consortiaExploitWeek;
		 	}
		 }
		 private function __consortiaExploitWeekResult(action : TofflistConsortiaExploitWeekList) : void
		 {
		 	TofflistModel.Instance.consortiaExploitWeek = action.list;
		 }
		 /**公会，功勋，累积**/
		 public function loadConsortiaExploitAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.consortiaExploitAccumulate)
		 	{
		 		new TofflistConsortiaExloitAccumulateList().loadSync(__consortiaExploitAccumulateResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.consortiaExploitAccumulate = TofflistModel.Instance.consortiaExploitAccumulate;
		 	}
		 }
		 private function __consortiaExploitAccumulateResult(action : TofflistConsortiaExloitAccumulateList) : void
		 {
		 	TofflistModel.Instance.consortiaExploitAccumulate = action.list;
		 }
		 
		 /**公会，战斗力，累积*/
		 public function loadConsortiaBattleAccumulate():void
		 {
		 	TofflistModel.Instance.consortiaBattleAccumulate = null;
		 	if(!TofflistModel.Instance.consortiaBattleAccumulate)
		 	{
		 		new TofflistConsortiaBattleList().loadSync(__consortiaBattleAccumulateResult);
		 	}else
		 	{
		 		TofflistModel.Instance.consortiaBattleAccumulate = TofflistModel.Instance.consortiaBattleAccumulate;
		 	}
		 }
		 
		 private function __consortiaBattleAccumulateResult(action:TofflistConsortiaBattleList):void
		 {
		 	TofflistModel.Instance.consortiaBattleAccumulate = action.list;
		 }
		 
		 /**
		 * 个人，战斗力，累积
		 * */
		 public function loadPersonalBattleAcuumulate():void
		 {
		 	TofflistModel.Instance.personalBattleAccumulate = null;
		 	if(!TofflistModel.Instance.personalBattleAccumulate)
		 	{
		 		new TofflistIndividaulBattleList().loadSync(__personalBattleAuccumulateResult);
		 	}else
		 	{
		 		TofflistModel.Instance.personalBattleAccumulate = TofflistModel.Instance.personalBattleAccumulate;
		 	}
		 }
		 private function __personalBattleAuccumulateResult(action :TofflistIndividaulBattleList):void
		 {
		 	TofflistModel.Instance.personalBattleAccumulate = action.list;
		 }
		 
		/**********************************
		 * 跨服数据加载
		 **********************************/
		/**跨服人个，功勋，日增**/
		public function loadCrossServerIndividualExploitDay() : void
		{
		 	if(!TofflistModel.Instance.crossServerIndividualExploitDay)
		 	{
		 		new TofflistIndividualExploitDayList("AreaCelebByDayOfferList.xml").loadSync(__crossServerIndividualExploitDayResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerIndividualExploitDay = TofflistModel.Instance.crossServerIndividualExploitDay;
		 	}
		 }
		 private function __crossServerIndividualExploitDayResult(action : TofflistIndividualExploitDayList) : void
		 {
		 	TofflistModel.Instance.crossServerIndividualExploitDay = action.list;
		 }
		 
 		/**跨服人个，功勋，周增**/
 		public function loadCrossServerIndividualExploitWeek() : void
		{
		 	if(!TofflistModel.Instance.crossServerIndividualExploitWeek)
		 	{
		 		new TofflistIndividualExploitWeekList("AreaCelebByWeekOfferList.xml").loadSync(__crossServerIndividualExploitWeekListResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerIndividualExploitWeek = TofflistModel.Instance.crossServerIndividualExploitWeek;
		 	}
		}
		private function __crossServerIndividualExploitWeekListResult(action : TofflistIndividualExploitWeekList) : void
		{
		 	TofflistModel.Instance.crossServerIndividualExploitWeek = action.list;
		}
		
 		/**跨服人个，功勋，累积**/
 		public function loadCrossServerIndividualExploitAccumulate() : void
		{
		 	if(!TofflistModel.Instance.crossServerIndividualExploitAccumulate)
		 	{
		 		new TofflistIndividualExploitAccumulateList("AreaCelebByOfferList.xml").loadSync(__crossServerIndividualExploitAccumulateResut);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerIndividualExploitAccumulate = TofflistModel.Instance.crossServerIndividualExploitAccumulate;
		 	}
		}
		private function __crossServerIndividualExploitAccumulateResut(action : TofflistIndividualExploitAccumulateList) : void
		{
		 	TofflistModel.Instance.crossServerIndividualExploitAccumulate = action.list;
		}
		
		/**跨服个人，等级，日增**/
		public function loadCrossServerIndividualGradeDay() : void
		{
		 	if(!TofflistModel.Instance.crossServerIndividualGradeDay)
		 	{
		 		new TofflistIndividualGradeDayList("AreaCelebByDayGPList.xml").loadSync(__crossServerIndividualGradeDayListResut);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerIndividualGradeDay = TofflistModel.Instance.crossServerIndividualGradeDay;
		 	}
		}
		private function __crossServerIndividualGradeDayListResut(action : TofflistIndividualGradeDayList) : void
		{
		 	TofflistModel.Instance.crossServerIndividualGradeDay = action.list;
		}
 		/**跨服个人，等级，周增**/
 		public function loadCrossServerIndividualGradeWeek() : void
		{
		 	if(!TofflistModel.Instance.crossServerIndividualGradeWeek)
		 	{
		 		new TofflistIndividualGradeWeekList("AreaCelebByWeekGPList.xml").loadSync(__crossServerIndividualGradeWeekListResut);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerIndividualGradeWeek = TofflistModel.Instance.crossServerIndividualGradeWeek;
		 	}
		}
		private function __crossServerIndividualGradeWeekListResut(action : TofflistIndividualGradeWeekList) : void
		{
		 	TofflistModel.Instance.crossServerIndividualGradeWeek = action.list;
		}
 		/**跨服个人，等级，累积**/
 		 public function loadCrossServerIndividualGradeAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.crossServerIndividualGradeAccumulate)
		 	{
		 		new TofflistIndividualGradeAccumulateList("AreaCelebByGPList.xml").loadSync(__crossServerIndividualGradeAccumulateListResut);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerIndividualGradeAccumulate = TofflistModel.Instance.crossServerIndividualGradeAccumulate;
		 	}
		 }
		 private function __crossServerIndividualGradeAccumulateListResut(action : TofflistIndividualGradeAccumulateList) : void
		 {
		 	TofflistModel.Instance.crossServerIndividualGradeAccumulate = action.list;
		 }
		/**跨服个人，战斗力，累积 **/		 
		 public function loadCrossServerPersonalBattleAcuumulate():void
		 {
		 	TofflistModel.Instance.crossServerPersonalBattleAccumulate = null;
		 	if(!TofflistModel.Instance.crossServerPersonalBattleAccumulate)
		 	{
		 		new TofflistIndividaulBattleList("AreaCelebByDayFightPowerList.xml").loadSync(__crossServerPersonalBattleAuccumulateResult);
		 	}else
		 	{
		 		TofflistModel.Instance.crossServerPersonalBattleAccumulate = TofflistModel.Instance.crossServerPersonalBattleAccumulate;
		 	}
		 }
		 private function __crossServerPersonalBattleAuccumulateResult(action :TofflistIndividaulBattleList):void
		 {
		 	TofflistModel.Instance.crossServerPersonalBattleAccumulate = action.list;
		 }
		 
		/**跨服公会，等级，累积**/
		 public function loadCrossServerConsortiaAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.crossServerConsortiaGradeAccumulate)
		 	{
		 		new TofflistConsortiaGradeList("AreaCelebByConsortiaLevel.xml").loadSync(__crossServerConsortiaRichesResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerConsortiaGradeAccumulate = TofflistModel.Instance.crossServerConsortiaGradeAccumulate;
		 	}
		 }
		 private function __crossServerConsortiaRichesResult(action : TofflistConsortiaGradeList) : void
		 {
		 	TofflistModel.Instance.crossServerConsortiaGradeAccumulate = action.list;
		 }
		/**跨服公会，资产，日增**/
		public function loadCrossServerConsortiaAssetDay() : void
		 {
		 	if(!TofflistModel.Instance.crossServerConsortiaAssetDay)
		 	{
		 		new TofflistConsortiaAssetDayList("AreaCelebByConsortiaDayRiches.xml").loadSync(__crossServerConsortiaAssetDayResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerConsortiaAssetDay = TofflistModel.Instance.crossServerConsortiaAssetDay;
		 	}
		 }
		 private function __crossServerConsortiaAssetDayResult(action : TofflistConsortiaAssetDayList) : void
		 {
		 	TofflistModel.Instance.crossServerConsortiaAssetDay = action.list;
		 }
		 
		/**跨服公会，资产，周增**/
		 public function loadCrossServerConsoritaAssetWeek() : void
		 {
		 	if(!TofflistModel.Instance.crossServerConsortiaAssetWeek)
		 	{
		 		new TofflistConsortiaAssetWeekList("AreaCelebByConsortiaWeekRiches.xml").loadSync(__crossServerConsortiaAssetWeekResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerConsortiaAssetWeek = TofflistModel.Instance.crossServerConsortiaAssetWeek;
		 	}
		 }
		 private function __crossServerConsortiaAssetWeekResult(action : TofflistConsortiaAssetWeekList) : void
		 {
		 	TofflistModel.Instance.crossServerConsortiaAssetWeek = action.list;
		 }
		 
		/**跨服公会，资产，累积**/ 
		public function loadCrossServerConsortiaAssetAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.crossServerConsortiaAssetAccumulate)
		 	{
		 		new TofflistConsortiaAssetAccumulateList("AreaCelebByConsortiaRiches.xml").loadSync(__crossServerConsortiaAssetAccumulateResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerConsortiaAssetAccumulate = TofflistModel.Instance.crossServerConsortiaAssetAccumulate;
		 	}
		 }
		 private function __crossServerConsortiaAssetAccumulateResult(action : TofflistConsortiaAssetAccumulateList) : void
		 {
		 	TofflistModel.Instance.crossServerConsortiaAssetAccumulate = action.list;
		 }
		 
 		/**跨服公会，功勋，日增**/
 		public function loadCrossServerConsortiaExploitDay() : void
		 {
		 	if(!TofflistModel.Instance.crossServerConsortiaExploitDay)
		 	{
		 		new TofflistConsortiaExploitDayList("AreaCelebByConsortiaDayHonor.xml").loadSync(__crossServerConsortiaExploitDayResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerConsortiaExploitDay = TofflistModel.Instance.crossServerConsortiaExploitDay;
		 	}
		 }
		 private function __crossServerConsortiaExploitDayResult(action : TofflistConsortiaExploitDayList) : void
		 {
		 	TofflistModel.Instance.crossServerConsortiaExploitDay = action.list;
		 }
 		/**跨服公会，功勋，周增**/
 		public function loadCrossServerConsortiaExploitWeek() : void
		 {
		 	if(!TofflistModel.Instance.crossServerConsortiaExploitWeek)
		 	{
		 		new TofflistConsortiaExploitWeekList("AreaCelebByConsortiaWeekHonor.xml").loadSync(__crossServerConsortiaExploitWeekResult);	
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.crossServerConsortiaExploitWeek = TofflistModel.Instance.crossServerConsortiaExploitWeek;
		 	}
		 }
		 private function __crossServerConsortiaExploitWeekResult(action : TofflistConsortiaExploitWeekList) : void
		 {
		 	TofflistModel.Instance.crossServerConsortiaExploitWeek = action.list;
		 }
 		/**跨服公会，功勋，累积**/
 		 public function loadCrossServerConsortiaExploitAccumulate() : void
		 {
		 	if(!TofflistModel.Instance.consortiaExploitAccumulate)
		 	{
		 		new TofflistConsortiaExloitAccumulateList("AreaCelebByConsortiaHonor.xml").loadSync(__CrossServerConsortiaExploitAccumulateResult);
		 	}
		 	else
		 	{
		 		TofflistModel.Instance.consortiaExploitAccumulate = TofflistModel.Instance.consortiaExploitAccumulate;
		 	}
		 }
		 private function __CrossServerConsortiaExploitAccumulateResult(action : TofflistConsortiaExloitAccumulateList) : void
		 {
		 	TofflistModel.Instance.consortiaExploitAccumulate = action.list;
		 }
 		/**跨服公会，战斗力，累积*/
		 public function loadCrossServerConsortiaBattleAccumulate():void
		 {
		 	TofflistModel.Instance.crossServerConsortiaBattleAccumulate= null;
		 	if(!TofflistModel.Instance.crossServerConsortiaBattleAccumulate)
		 	{
		 		new TofflistConsortiaBattleList("AreaCelebByConsortiaFightPower.xml").loadSync(__CrossServerConsortiaBattleAccumulateResult);
		 	}else
		 	{
		 		TofflistModel.Instance.crossServerConsortiaBattleAccumulate = TofflistModel.Instance.crossServerConsortiaBattleAccumulate;
		 	}
		 }
		 private function __CrossServerConsortiaBattleAccumulateResult(action:TofflistConsortiaBattleList):void
		 {
		 	TofflistModel.Instance.crossServerConsortiaBattleAccumulate = action.list;
		 }
		 
		 /**本区个人，成就点，累积*/
		 public function loadPersonalAchievementPoint():void
		 {
			 if(!TofflistModel.Instance.PersonalAchievementPoint)
			 {
				 new TofflistEffortValueAccumulateList().loadSync(__loadPersonalAchievementPointResult);
			 }else
			 {
				 TofflistModel.Instance.PersonalAchievementPoint = TofflistModel.Instance.PersonalAchievementPoint;
			 }
		 }
		 private function __loadPersonalAchievementPointResult(action:TofflistEffortValueAccumulateList):void
		 {
			 TofflistModel.Instance.PersonalAchievementPoint = action.list;
		 }
		 
		 /**本区个人，成就点，日增*/
		 public function loadPersonalAchievementPointDay():void
		 {
			 if(!TofflistModel.Instance.PersonalAchievementPointDay)
			 {
				 new TofflistEffortValueDayList().loadSync(__loadPersonalAchievementPointDayResult);
			 }else
			 {
				 TofflistModel.Instance.PersonalAchievementPointDay = TofflistModel.Instance.PersonalAchievementPointDay;
			 }
		 }
		 private function __loadPersonalAchievementPointDayResult(action:TofflistEffortValueDayList):void
		 {
			 TofflistModel.Instance.PersonalAchievementPointDay = action.list;
		 }
		 
		 /**本区个人，成就点，周增*/
		 public function loadPersonalAchievementPointWeek():void
		 {
			 if(!TofflistModel.Instance.PersonalAchievementPointWeek)
			 {
				 new TofflistEffortValueWeekList().loadSync(__loadPersonalAchievementPointWeekResult);
			 }else
			 {
				 TofflistModel.Instance.PersonalAchievementPointWeek = TofflistModel.Instance.PersonalAchievementPointWeek;
			 }
		 }
		 private function __loadPersonalAchievementPointWeekResult(action:TofflistEffortValueWeekList):void
		 {
			 TofflistModel.Instance.PersonalAchievementPointWeek = action.list;
		 }
		 
		 /**跨区个人，成就点，累积*/
		 public function loadCrossServerPersonalAchievementPoint():void
		 {
			 if(!TofflistModel.Instance.crossServerPersonalAchievementPoint)
			 {
				 new TofflistEffortValueAccumulateList("AreaCelebByAchievementPointList.xml").loadSync(__crossServerPersonalAchievementPointResult);
			 }else
			 {
				 TofflistModel.Instance.crossServerPersonalAchievementPoint = TofflistModel.Instance.crossServerPersonalAchievementPoint;
			 }
		 }
		 private function __crossServerPersonalAchievementPointResult(action:TofflistEffortValueAccumulateList):void
		 {
			 TofflistModel.Instance.crossServerPersonalAchievementPoint = action.list;
		 }
		 
		 /**跨区个人，成就点，日增*/
		 public function loadCrossServerPersonalAchievementPointDay():void
		 {
			 if(!TofflistModel.Instance.crossServerPersonalAchievementPointDay)
			 {
				 new TofflistEffortValueDayList("AreaCelebByAchievementPointDayList.xml").loadSync(__crossServerPersonalAchievementPointDayResult);
			 }else
			 {
				 TofflistModel.Instance.crossServerPersonalAchievementPointDay = TofflistModel.Instance.crossServerPersonalAchievementPointDay;
			 }
		 }
		 private function __crossServerPersonalAchievementPointDayResult(action:TofflistEffortValueDayList):void
		 {
			 TofflistModel.Instance.crossServerPersonalAchievementPointDay = action.list;
		 }
		 
		 /**跨区个人，成就点，周增*/
		 public function loadCrossServerPersonalAchievementPointWeek():void
		 {
			 if(!TofflistModel.Instance.crossServerPersonalAchievementPointWeek)
			 {
				 new TofflistEffortValueWeekList("AreaCelebByAchievementPointWeekList.xml").loadSync(__crossServerPersonalAchievementPointWeekResult);
			 }else
			 {
				 TofflistModel.Instance.crossServerPersonalAchievementPointWeek = TofflistModel.Instance.crossServerPersonalAchievementPointWeek;
			 }
		 }
		 private function __crossServerPersonalAchievementPointWeekResult(action:TofflistEffortValueWeekList):void
		 {
			 TofflistModel.Instance.crossServerPersonalAchievementPointWeek = action.list;
		 }
		 
		/*******************************
		 * 
		 * ****************************/
		public function loadList(type:int):void
		{
		}
		
		override public function getView():DisplayObject
		{
			return _container;
		}
		
		override public function dispose():void
		{
			_view.dispose();
		}
		
	}
}