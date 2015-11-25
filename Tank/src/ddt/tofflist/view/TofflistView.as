package ddt.tofflist.view
{
	import flash.geom.Point;
	
	import game.crazytank.view.tofflist.TofflistBgAsset;
	
	import tank.assets.ScaleBMP_24;
	import ddt.manager.DownlandClientManager;
	import ddt.tofflist.TofflistController;
	import ddt.tofflist.TofflistEvent;
	import ddt.tofflist.TofflistModel;
	import ddt.view.ClientDownloading;

	public class TofflistView extends TofflistBgAsset
	{
		private var _contro     : TofflistController;
		private var _rightView  : TofflistRightView;
		private var _leftView   : TofflistLeftView;
		private var clientDownloading:ClientDownloading;
		private var _bg1        : ScaleBMP_24;
		public function TofflistView($contro : TofflistController)
		{
			this._contro = $contro;
			super();
			init();
		}
		private function init() : void
		{
			_bg1 = new ScaleBMP_24();
			_bg1.x = pos1.x;
			_bg1.y = pos1.y;
			addChildAt(_bg1,0);
			removeChild(pos1);
			
			removeChild(pos2);
			
			_rightView   = new TofflistRightView(_contro);
			addChild(_rightView);
			_leftView  = new TofflistLeftView();
			addChild(_leftView);
			
//			DownlandClientManager.Instance.show(this);
//			DownlandClientManager.Instance.setDownlandBtnPos(new Point(downBtnPos.x,downBtnPos.y));
//			removeChild(downBtnPos);
		}
		
		public function addEvent() : void
		{
			TofflistModel.addEventListener(TofflistEvent.TOFFLIST_DATA_CHANGER,          __tofflistDataChange);
			TofflistModel.addEventListener(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,      __crossServerTofflistDataChange);
		}
		public function removeEvent() : void
		{			
			TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_DATA_CHANGER,       __tofflistDataChange);
			TofflistModel.removeEventListener(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,   __crossServerTofflistDataChange);
		}
		private function __tofflistDataChange(evt : TofflistEvent) : void
		{
			_leftView.updateTime();
			switch(String(evt.data))
			{
				case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY:
				this._rightView.orderList(TofflistModel.Instance.individualGradeDay);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK:
				this._rightView.orderList(TofflistModel.Instance.individualGradeWeek);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.individualGradeAccumulate);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:
				this._rightView.orderList(TofflistModel.Instance.individualExploitDay);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:
				this._rightView.orderList(TofflistModel.Instance.individualExploitWeek);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.individualExploitAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.consortiaGradeAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY:
				this._rightView.orderList(TofflistModel.Instance.consortiaAssetDay);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK:
				this._rightView.orderList(TofflistModel.Instance.consortiaAssetWeek);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.consortiaAssetAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY:
				this._rightView.orderList(TofflistModel.Instance.consortiaExploitDay);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK:
				this._rightView.orderList(TofflistModel.Instance.consortiaExploitWeek);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.consortiaExploitAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.consortiaBattleAccumulate);
				break;
				case TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.personalBattleAccumulate);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY:
				this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPointDay);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK:
				this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPointWeek);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPoint);
				break;
			}
		}
		
		private function __crossServerTofflistDataChange(evt:TofflistEvent):void
		{
			_leftView.updateTime();
			switch(String(evt.data))
			{
				case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY:
				this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeDay);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK:
				this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeWeek);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeAccumulate);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:
				this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitDay);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:
				this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitWeek);
				break;
				case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaGradeAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY:
				this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetDay);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK:
				this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetWeek);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY:
				this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitDay);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK:
				this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitWeek);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaBattleAccumulate);
				break;
				case TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.crossServerPersonalBattleAccumulate);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY:
				this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPointDay);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK:
				this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPointWeek);
				break;
				case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE:
				this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPoint);
				break;
			}
		}
		
		public function dispose() : void
		{
			removeEvent();
			_rightView.dispose();
			_leftView.dispose();
			
			if(_bg1)
			{
				removeChild(_bg1);
			}
			_bg1 = null;
			DownlandClientManager.Instance.hide();
			
			if(this.parent)this.parent.removeChild(this);
		}
	}
}