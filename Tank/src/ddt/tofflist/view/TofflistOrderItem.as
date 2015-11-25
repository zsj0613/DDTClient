package ddt.tofflist.view
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.crazytank.view.tofflist.TofflistOrderItemAsset;
	
	import road.manager.SoundManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.tofflist.TofflistEvent;
	import ddt.tofflist.TofflistModel;
	import ddt.tofflist.data.TofflistConsortiaData;
	import ddt.tofflist.data.TofflistConsortiaInfo;
	import ddt.tofflist.data.TofflistPlayerInfo;
	import ddt.view.common.LevelIcon;

	public class TofflistOrderItem extends TofflistOrderItemAsset
	{
		private var _info          : TofflistPlayerInfo;
		private var _consortiaInfo : TofflistConsortiaInfo;
		private var _level         : LevelIcon;
		private var _index         : int;
		
		public function TofflistOrderItem()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			setText(Txt1);
			setText(Txt2);
			setText(Txt3);
			setText(Txt4);
			setText(Txt5);
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,495,22);
			this.graphics.endFill();
			_level = new LevelIcon("s",1,0,0,0,0);
			ComponentHelper.replaceChild(this,levelPos,_level);
			this.itemBgAsset.visible = false;
			this.buttonMode = true;
		}
		private function addEvent() : void
		{
			addEventListener(MouseEvent.CLICK,        __itemClickHandler);
			addEventListener(MouseEvent.MOUSE_OVER,   __itemMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT,    __itemMouseOutHandler);
		}
		private function removeEvent() : void
		{
			removeEventListener(MouseEvent.CLICK,        __itemClickHandler);
			removeEventListener(MouseEvent.MOUSE_OVER,   __itemMouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT,    __itemMouseOutHandler);
			
		}
		private var _isSelect : Boolean;
		private function __itemClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			if(!_isSelect)isSelect = true
		}
		private function __itemMouseOverHandler(evt : MouseEvent) : void
		{
			this.itemBgAsset.visible = true;
		}
		private function __itemMouseOutHandler(evt : MouseEvent) : void
		{
			if(_isSelect)return;
			this.itemBgAsset.visible = false;
		}
		public function set isSelect(b : Boolean) : void
		{
			this.itemBgAsset.visible = this._isSelect = b;
			if(b)this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_ITEM_SELECT,this));
		}
		/**传入数据对象**/
		public function set info($info : Object) : void
		{
			if($info is PlayerInfo)
			{
				this._info = $info as TofflistPlayerInfo;
			}
			else if($info is TofflistConsortiaData)
			{
				var $consortiaInfo : TofflistConsortiaData = $info as TofflistConsortiaData;
				if($consortiaInfo)
				{
					this._info = $consortiaInfo.playerInfo;
					this._consortiaInfo = $consortiaInfo.consortiaInfo;
				}
			}
			if(_info)upView();
		}
		public function get info() : Object
		{
			return this._info;
		}
		public function set index(i : int) : void
		{
			this._index = i;
		}
		public function get index() : int
		{
			return this._index;
		}
		/**排名显示**/
		private function get NO_ID() : String
		{
			var str : String = "";
			switch(_index)
			{
				case 1:
				str = 1 +"st";
				break;
				case 2:
				str = 2+ "nd";
				break;
				case 3:
				str = 3 + "rd";
				break;
				default :
				str = _index + "th";
				break;
			}
			return str;
		}
		/**数据显示**/
		private function upView() : void
		{
			if((TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL && TofflistModel.secondMenuType == TofflistTwoGradeMenu.GESTE)
			  || (TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA && (TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS || TofflistModel.secondMenuType == TofflistTwoGradeMenu.GESTE)))
			{
				upStyle();
			}
		   this.Txt3.text = "";
		   this.Txt1.text = NO_ID;
		   this.Txt2.width= 170;
//		   this.Txt2.x    = 65; 
		   this.Txt4.width= 235
//		   this.Txt4.x    = 245;
		   if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
		   {
			   switch(TofflistModel.secondMenuType)
			   {
					/**个人，等级**/
					case TofflistTwoGradeMenu.LEVEL:
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_info.AddDayGP);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_info.AddWeekGP);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_info.GP);
						}
						this.Txt1.width=64;
						this.Txt2.text = _info.NickName;
						this.Txt2.width= 205;
						this.Txt4.x    = 280;
						this.Txt2.x    = 70;
						_level.level = _info.Grade;
						_level.setRepute(_info.Repute);
						_level.setRate(_info.WinCount,_info.TotalCount);
						_level.Battle = _info.FightPower
						break;
					
					/**个人，功勋**/
					case TofflistTwoGradeMenu.GESTE:
						upStyle();
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_info.AddDayOffer);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_info.AddWeekOffer);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_info.Offer);
						}
						this.Txt1.width=58;
						this.Txt2.text = _info.NickName;
						this.Txt2.width= 170;
		   				this.Txt2.x    = 63; 
						this.Txt4.x    = 245;
						break;
					/**个人，战斗力**/
					case TofflistTwoGradeMenu.BATTLE:
						upStyle();
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_info.FightPower);
						}
						this.Txt1.width=58;
						this.Txt2.text = _info.NickName;
						this.Txt2.width= 170;
		   				this.Txt2.x    = 63; 
						this.Txt4.x    = 245;
						break;
					/**个人，成就点**/
					case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
						upStyle();
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_info.AddDayAchievementPoint);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_info.AddWeekAchievementPoint);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_info.AchievementPoint);
						}
						this.Txt1.width=58;
						this.Txt2.text = _info.NickName;
						this.Txt2.width= 170;
						this.Txt2.x    = 63; 
						this.Txt4.x    = 245;
						break;
					
				}
		   }else if(TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA)
		   {
		   	   if(!_consortiaInfo)return;
			   switch(TofflistModel.secondMenuType)
			   {
					/**公会，等级**/
					case TofflistTwoGradeMenu.LEVEL:
						_level.visible = false;
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt1.width=64;
							this.Txt2.text = this._consortiaInfo.ConsortiaName
							this.Txt4.text = String(_consortiaInfo.LastDayRiches);
							this.Txt3.text = String(_consortiaInfo.Level);
							this.Txt2.width= 205;
							this.Txt2.x    = 65;
							this.Txt3.x    = 265;
							this.Txt4.x    = 330;
							this.Txt4.width= 140;
						}
						break;
					
					/**公会，资产**/
					case TofflistTwoGradeMenu.ASSETS:
						upStyle();
						_level.visible = false;
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_consortiaInfo.AddDayRiches);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_consortiaInfo.AddWeekRiches);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_consortiaInfo.LastDayRiches);
						}
						this.Txt1.width=58;
						this.Txt2.x    = 52; 
						this.Txt4.x    = 245;
						this.Txt2.text = _consortiaInfo.ConsortiaName;
						break;
					
					/**公会，功勋**/
					case TofflistTwoGradeMenu.GESTE:
						upStyle();
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_consortiaInfo.AddDayHonor);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_consortiaInfo.AddWeekHonor);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_consortiaInfo.Honor);
						}
						this.Txt1.width=58;
						this.Txt2.x    = 52; 
						this.Txt4.x    = 245;
						this.Txt2.text = _consortiaInfo.ConsortiaName;
						break;
						/**公会 战斗力*/
					case TofflistTwoGradeMenu.BATTLE:
						upStyle();
						if(!_consortiaInfo)return;
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_consortiaInfo.FightPower);
						}
						this.Txt1.width=58;
						this.Txt2.x    = 52; 
						this.Txt4.x    = 245;
						this.Txt2.text = _consortiaInfo.ConsortiaName;
						break;
		   		}
		   }else
		   {
		   		upCrossServerView();
		   }
		}
		
		private function upCrossServerView():void
		{
			this.Txt3.text = "";
		    this.Txt1.text = NO_ID;
		    if(_info.AreaName)
		    {
		    	this.Txt5.text = _info.AreaName;
		    }else
		    {
			 	this.Txt5.text = "";
		    }
			if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
		    {
		       switch(TofflistModel.secondMenuType)
			   {
			   		/**跨服个人，等级**/
					case TofflistTwoGradeMenu.LEVEL:
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_info.AddDayGP);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_info.AddWeekGP);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_info.GP);
							this.Txt4.width= 137;
							this.Txt4.x    = 350;
							this.Txt5.x    = 240;
							this.Txt5.width= 115;
							if(_level)
							{
								_level.x = 205;
							}
						}
						this.Txt1.width=58;
						this.Txt2.text = _info.NickName;
						this.Txt2.x    = 40;
						this.Txt4.width= 137;
						this.Txt4.x    = 350;
						this.Txt5.x    = 240;
						this.Txt5.width= 115;
						if(_level)
						{
							_level.x = 205;
						}
						_level.level = _info.Grade;
						_level.setRepute(_info.Repute);
						_level.setRate(_info.WinCount,_info.TotalCount);
						_level.Battle = _info.FightPower
						break;
					
					/**跨服个人，功勋**/
					case TofflistTwoGradeMenu.GESTE:
						upStyle();
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_info.AddDayOffer);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_info.AddWeekOffer);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_info.Offer);
						}
						this.Txt1.width=58;
						this.Txt4.x    = 320;
						this.Txt5.x    = 250;
						this.Txt2.text = _info.NickName;
						this.Txt2.width= 170;
						this.Txt2.x    = 55;
						this.Txt5.width= 130;
						this.Txt5.x    = 230;
						break;
					/**跨服个人，战斗力**/
					case TofflistTwoGradeMenu.BATTLE:
						upStyle();
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_info.FightPower);
						}
						this.Txt1.width=58;
						this.Txt2.text = _info.NickName;
						this.Txt2.width= 170;
						this.Txt2.x    = 55;
						this.Txt4.x    = 320;
						this.Txt5.x    = 230;
						this.Txt5.width= 130;
						break;
					/**跨服个人，成就点**/
					case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
						upStyle();
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_info.AddDayAchievementPoint);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_info.AddWeekAchievementPoint);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_info.AchievementPoint);
						}
						this.Txt1.width=58;
						this.Txt4.x    = 320;
						this.Txt5.x    = 250;
						this.Txt2.text = _info.NickName;
						this.Txt2.width= 170;
						this.Txt2.x    = 55;
						this.Txt5.width= 130;
						this.Txt5.x    = 230;
						break;
			   }
		    }else
		    {
		       if(!_consortiaInfo)return;
		       switch(TofflistModel.secondMenuType)
			   {
					/**跨服公会，等级**/
					case TofflistTwoGradeMenu.LEVEL:
						_level.visible = false;
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt1.width=58;
							this.Txt2.text = this._consortiaInfo.ConsortiaName
							this.Txt4.text = String(_consortiaInfo.LastDayRiches);
							this.Txt3.text = String(_consortiaInfo.Level);
							this.Txt2.width= 135;
							this.Txt2.x    = 60;
							this.Txt4.x    = 360;
							this.Txt4.width= 105;
							this.Txt3.x    = 190;
							this.Txt5.width= 115;
							this.Txt5.x    = 249;
						}
						break;
					
					/**跨服公会，资产**/
					case TofflistTwoGradeMenu.ASSETS:
						upStyle();
						_level.visible = false;
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_consortiaInfo.AddDayRiches);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_consortiaInfo.AddWeekRiches);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_consortiaInfo.LastDayRiches);
						}
						this.Txt1.width=56;
						this.Txt2.text = _consortiaInfo.ConsortiaName;
						this.Txt2.width= 170;
						this.Txt2.x    = 55;
						this.Txt4.x    = 310;
						this.Txt5.x    = 230;
						this.Txt5.width= 130;
						break;
					
					/**跨服公会，功勋**/
					case TofflistTwoGradeMenu.GESTE:
						upStyle();
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.DAY)
						{
							this.Txt4.text = String(_consortiaInfo.AddDayHonor);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.WEEK)
						{
							this.Txt4.text = String(_consortiaInfo.AddWeekHonor);
						}
						else if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_consortiaInfo.Honor);
						}
						this.Txt1.width=56;
						this.Txt2.text = _consortiaInfo.ConsortiaName;
						this.Txt2.width= 170;
						this.Txt2.x    = 55;
						this.Txt4.x    = 310;
						this.Txt5.x    = 230;
						this.Txt5.width= 130;
						break;
						/**跨服公会 战斗力*/
					case TofflistTwoGradeMenu.BATTLE:
						upStyle();
						if(!_consortiaInfo)return;
						if(TofflistModel.thirdMenuType == TofflistThirdClassMenu.TOTAL)
						{
							this.Txt4.text = String(_consortiaInfo.FightPower);
						}
						this.Txt1.width=58;
						this.Txt2.text = _consortiaInfo.ConsortiaName;
						this.Txt2.width= 170;
						this.Txt2.x    = 55;
						this.Txt4.x    = 310;
						this.Txt5.x    = 230;
						this.Txt5.width= 130;	
						break;	
			   }
		    }
		}
		
		
		private function upStyle() : void
		{
			_level.visible = false;
			Txt1.width = 97;
			Txt2.x     = 101;
			Txt2.width = 195;
			Txt4.x     = 297;
			Txt4.width = 197;
		}
		private function setText(txt : TextField) : void
		{
			txt.selectable   = false;
			txt.mouseEnabled = false;
			txt.text         = "";
		}
		public function dispose() : void
		{
			removeEvent();
			if(parent)this.parent.removeChild(this);
		}
		
		public function get currentText() : String
		{
			return this.Txt4.text.toString();
		}
		
	}
}