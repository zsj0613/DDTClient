package ddt.tofflist.view
{
	import flash.text.TextField;
	
	import game.crazytank.view.tofflist.TofflistLeftInfoAsset;
	
	import road.utils.ComponentHelper;
	
	import ddt.data.ConsortiaInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.tofflist.TofflistEvent;
	import ddt.tofflist.TofflistModel;
	import ddt.view.common.LevelIcon;
	public class TofflistLeftInfo extends TofflistLeftInfoAsset
	{
		private var _initStype     : Array = new Array();
		private var _levelIcon     : LevelIcon;
		public function TofflistLeftInfo()
		{
			super();
			init();
			addEvent();
		}
		private function init() :  void
		{
			_initStype[0] = Txt2.width;
			_initStype[1] = new Array(Txt3.x,Txt3.width);
			this.gotoAndStop("individual1");
			
			_levelIcon = new LevelIcon("s",1,0,0,0,0);
			_levelIcon.visible = false;
			levelPos.visible = false;
			ComponentHelper.replaceChild(this,levelPos,_levelIcon);
			initTextField(Txt2);
			initTextField(Txt3);
			initTextField(Txt4);
		}
		private function addEvent() : void
		{
			TofflistModel.addEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,   __tofflistTypeHandler);
		}
		private function removeEvent() : void
		{
			TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,   __tofflistTypeHandler);
		}
		/**多种不同的类型显示**/
		private function __tofflistTypeHandler(evt : TofflistEvent) : void
		{
			var self : SelfInfo = PlayerManager.Instance.Self;
			var consortia : ConsortiaInfo = PlayerManager.Instance.SelfConsortia;
			this.Txt4.text = "";
			if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL || TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
			{
				switch(TofflistModel.secondMenuType)
				{
					case TofflistTwoGradeMenu.LEVEL:
						gotoAndStop("individualLevel");
						reStype();
						this.Txt2.text = String(self.Repute);
						this.Txt3.text = String(self.GP);
						displayLevelIcon();
						break;
					case TofflistTwoGradeMenu.GESTE:
						gotoAndStop("individualGeste");
						upStype();
						this.Txt2.text = String(self.Repute);
						this.Txt3.text = String(self.Offer);
						break;
					case TofflistTwoGradeMenu.BATTLE:
						gotoAndStop("individualBattle");
						upStype();
						this.Txt2.text = String(self.Repute);
						this.Txt3.text = String(self.FightPower);
						break;
					case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
						gotoAndStop("individuaAchievementPoint");
						upStype();
						this.Txt2.text = String(self.Repute);
						this.Txt3.text = String(self.AchievementPoint);
						break;
				}
			}else
			{
				switch(TofflistModel.secondMenuType)
				{
					case TofflistTwoGradeMenu.LEVEL:
						gotoAndStop("consortiaLevel");
						reStype();
						_levelIcon.visible = false;
						if(!consortia || consortia.ConsortiaID == 0)
						{
							consortiaEmpty();
						}
						else
						{
							this.Txt2.text = String(self.ConsortiaRepute);
						    this.Txt3.text = String(consortia.Riches);
						    this.Txt4.text = String(consortia.Level);
						}
						break;
					case TofflistTwoGradeMenu.ASSETS:
						gotoAndStop("consortiaAssets");
						upStype();
						if(!consortia || consortia.ConsortiaID == 0)
						{
							consortiaEmpty();
						}
						else
						{
							this.Txt2.text = String(self.ConsortiaRepute);
						    this.Txt3.text = String(self.ConsortiaRiches);
						}
						break;
					case TofflistTwoGradeMenu.GESTE:
						gotoAndStop("consortiaGeste");
						upStype();
						if(!consortia || consortia.ConsortiaID == 0)
						{
							consortiaEmpty();
						}
						else
						{
							this.Txt2.text = String(self.ConsortiaRepute);
						    this.Txt3.text = String(self.ConsortiaHonor);
						}
						break;
					case TofflistTwoGradeMenu.BATTLE:
						gotoAndStop("consortiaBattle");
						upStype();
						this.Txt2.text = String(self.ConsortiaRepute);
						this.Txt3.text = String(consortia.FightPower);
						break;
				}
			}
		}
		private function consortiaEmpty() : void
		{
			Txt2.text = Txt3.text = LanguageMgr.GetTranslation("ddt.tofflist.view.TofflistLeftInfo.no");
			//Txt2.text = Txt3.text = "无公会";
		}
		/*显示等级图标*/
		private function displayLevelIcon() : void
		{
			var self : SelfInfo = PlayerManager.Instance.Self;
			this.addChild(levelPos);
			if(_levelIcon.parent)_levelIcon.parent.removeChild(_levelIcon);
			_levelIcon.dispose();
			_levelIcon = new LevelIcon("s",1,0,0,0,0);
			ComponentHelper.replaceChild(this,levelPos,_levelIcon);
			_levelIcon.level = self.Grade;
			_levelIcon.setRepute(PlayerManager.Instance.Self.Repute);
			_levelIcon.setRate(self.WinCount,self.TotalCount);
			_levelIcon.Battle = self.FightPower;
			_levelIcon.visible = true;
		}
		/***修改样式**/
		private function upStype() : void
		{
			Txt2.width = 115;
			//Txt3.x     = 238;
			Txt3.width  = 160;
			this._levelIcon.visible  = false;
			levelPos.visible = false;
			
		}
		private function reStype() : void
		{
			Txt2.width = int(_initStype[0]);
			Txt3.x     = int(_initStype[1][0]);
			Txt3.width = int(_initStype[1][1]);
			this._levelIcon.visible  = true;
			levelPos.visible = false;
			
		}
		public function dispose() : void
		{
			this.removeEvent();
			if(_levelIcon.parent)_levelIcon.parent.removeChild(_levelIcon);
			if(_levelIcon)_levelIcon.dispose();
			if(this.parent)this.parent.removeChild(this);
		}
		private function initTextField(txt : TextField) : void
		{
			txt.mouseEnabled = false;
			txt.selectable   = false;	
		}
	}
}