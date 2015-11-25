package ddt.view.effort
{
	import crazytank.view.effort.EffortFullItemAsset;
	
	import ddt.data.effort.EffortInfo;
	import ddt.manager.EffortManager;
	import ddt.manager.PlayerManager;

	public class EffortFullItemView extends EffortFullItemAsset
	{
		private var _info:EffortInfo;
		private var _isSelect:Boolean;
		private var _effortIcon:EffortIconView;
		private var _achievementPointView:AchievementPointView;
		public function EffortFullItemView(info:EffortInfo)
		{
			super();
			_info = info;
			init();
		}
		
		private function init():void
		{
			_effortIcon = new EffortIconView(String(_info.picId));
			_effortIcon.x = 5;
			_effortIcon.y = 2;
			_effortIcon.scaleX = 38/50;
			_effortIcon.scaleY = 38/50;
			addChild(_effortIcon);
			_achievementPointView = new AchievementPointView(_info.AchievementPoint);
			_achievementPointView.x = achievementPoint_pos.x;
			_achievementPointView.y = achievementPoint_pos.y;
			_achievementPointView.scaleX = 40/50;
			_achievementPointView.scaleY = 40/50;
			addChild(_achievementPointView);
			updateItem();
		}
		
		private function updateItem():void
		{
			if(_info)
			{
				title_txt.htmlText = EffortRigthItemView.setText(splitTitle(),0);
				detail_txt.htmlText= EffortRigthItemView.setText(_info.Detail,1);
				var date:Date = new Date();
				if(_info.CompleteStateInfo)date = _info.CompleteStateInfo.CompletedDate;
				if(_info.CompleteStateInfo && EffortManager.Instance.isSelf)
				{
					date_txt.text = String(date.fullYearUTC) + "/" + String(date.monthUTC) + "/" + String(date.dateUTC);
				}else
				{
					date_txt.text = "";
				}
			}
		}
		
		
		private function splitTitle():String
		{
			var strArray:Array = [];
			if(_info)
			{
				strArray = _info.Title.split("/");
				if(strArray.length > 1 && strArray[1] != "")
				{
					if(PlayerManager.Instance.Self.Sex)
					{
						return strArray[0];
					}else
					{
						return strArray[1];
					}
				}else
				{
					return strArray[0];
				}
			}
			return "";
		}
		
		public function dispose():void
		{
			if(_effortIcon)
			{
				_effortIcon.parent.removeChild(_effortIcon);
				_effortIcon.dispose();
				_effortIcon = null;
			}
			if(_achievementPointView)
			{
				_achievementPointView.parent.removeChild(_achievementPointView);
				_achievementPointView.dispose();
			}
			_achievementPointView = null;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}