package ddt.gameover
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import road.data.DictionaryData;
	import road.ui.manager.TipManager;
	
	import ddt.data.BuffInfo;
	import ddt.data.Experience;
	import ddt.data.GameInfo;
	import ddt.data.game.Living;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import tank.view.ExperienceStripAsset;
	import ddt.view.common.LevelIcon;
	import tank.view.experience.ClientAdditionAsset;
	import tank.view.experience.DoubleExpAsset;
	import tank.view.experience.MarryIconAsset;
	
	import webgame.crazyTank.view.ExperienceAsset;
	/**
	 * 经验显示面板 
	 * @author SYC
	 * 
	 */
	public class ExperienceView extends ExperienceAsset
	{
		private var _self:LocalPlayer;
		private var _gamePlayers:DictionaryData;
		public function ExperienceView($game:GameInfo = null)
		{
			_red = 0;
			_blue = 0;
			_self = $game.selfGamePlayer;
			_gamePlayers = $game.livings;
			initView();
			initDate($game);
			initEvent();
		}
		private function initDate(_game:GameInfo):void
		{
			if(_game == null) return;
			var totalPerson:int = _game.PlayerCount;
			var gainRiches:int = _game.GainRiches;
			for each(var l:Living in _game.livings)
			{
				if(!(l is Player)) continue;
				var player:Player = l as Player;
				player.playerInfo.Grade = player.CurrentLevel;
				player.playerInfo.GP = player.CurrentGP;
				setInfo(player,totalPerson);
			}
			
//			if(gainRiches == 0)
//			{
//				ConsortiaRichesRed_txt.text = "——";
//				ConsortiaRichesBlue_txt.text = "——";
//			}
//			else 
//			{	
//				var redWin:Boolean = (_self.isWin && _self.team == 1) || ( _self.isWin == false && _self.team == 2);
//				ConsortiaRichesRed_txt.text = (redWin ? ("+" + gainRiches) : "——");
//				ConsortiaRichesBlue_txt.text = (redWin ? "——" : ("+" + gainRiches));
////				ConsortiaRichesRed_txt.text = "+" + gainRiches;
////				ConsortiaRichesBlue_txt.text = "+" + gainRiches;
//			}
		}
		private function initView():void
		{
			for(var i:uint = 1; i <= 2 ; i ++)
			{
				for(var j:uint = 1 ; j <= 4; j ++)
				{
					this["info" + i + j].visible = false;
					this["info" + i + j].upCartoon_mc.visible = false;
					this["info" + i + j].GESTEx2.visible = false;
					this["info" + i + j].gotoAndStop(1);
//					this["info" + i + j].EXPx2.visible = false;
				}
			}
			teamExp.visible = false;
			serverExp.visible = false;
			winCite1.visible = winCite2.visible = false;
			winCite1.gotoAndStop(2);
			winCite2.gotoAndStop(1);
		}
		private function initEvent():void
		{
			setTimeout(_timeOut,6000);
		}
		
		private function _timeOut():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private var _red:uint = 0;
		private var _blue:uint = 0;
		public function setInfo(info:Player,totalPlayer:int):void
		{
			var temp:uint;
			if(info.team == 1)
			{
				_red ++;
				temp = _red;
			}
			else
			{
				_blue ++;
				temp = _blue;
			}
			var mc:MovieClip = this["info" + info.team.toString() + temp.toString()];
			if(mc)
			{			
				mc.visible = true;
				mc.damageAndKill_txt.text = info.TotalHurt.toString() + " / "+info.TotalKill.toString();
				mc.nickName_txt.text = info.playerInfo.NickName;
				mc.offer_txt.text = info.GainOffer;
				
				if(info.TotalShootCount == 0)
					mc.hitRate_txt.text = "0%";
				else		
					mc.hitRate_txt.text = (Math.floor((info.TotalHitTargetCount /  info.TotalShootCount) * 10000) / 100).toString() + "%";		
				
				if(info.GainGP == 0)
				{
	                mc.value_mc.value_txt.htmlText = "(+0)";
				}
				else
				{
					if(info.GainGP > 0)
					{
						if(totalPlayer > 1)
						{
							teamExp.gotoAndStop(totalPlayer -1);
							teamExp.visible = true;
						}
						else
						{
							teamExp.visible = false;
						}
						mc.value_mc.value_txt.htmlText = "(+" + Math.ceil(info.GainGP).toString() +")";
					}
					else
					{
						mc.value_mc.value_txt.text = "(-" + Math.abs(info.GainGP).toString() + ")";
					}
					mc.value_mc.value_txt.visible = true;
				}
				if(info.MarryGP>0)
				{
					mc.exp200.visible=true;
				}else
				{
					mc.exp200.visible=false;
				}
				
				var percent:int = Experience.getExpPercent(Experience.getGrade(info.playerInfo.GP),info.playerInfo.GP);
				mc.value_mc.strip.width = percent / 100 * 91;
				var grade_mc:LevelIcon = new LevelIcon("s",info.playerInfo.Grade,info.playerInfo.Repute,info.playerInfo.WinCount,info.playerInfo.TotalCount,info.playerInfo.FightPower);
				grade_mc.x = mc.gradePos_mc.x;
				grade_mc.y = mc.gradePos_mc.y;
				mc.gradePos_mc.visible = false;
				mc.addChild(grade_mc);
				if(info.isUpGrade)
				{
					mc.value_mc.strip.width = 91;
					mc.value_mc.value_txt.visible = false;
					mc.upCartoon_mc.visible = true;
				} 
				if(info.isSelf)
				{
					mc.gotoAndStop(2);
					var winTeam:int;
					if(info.isWin)
					{
						winTeam = info.team;
					}
					else
					{
						winTeam = (info.team == 1 ? 2 : 1);
					}
					this["winCite" + winTeam.toString()].visible = true;
				}
				else
				{
					mc.gotoAndStop(1);
				}
				(mc as ExperienceStripAsset).icon_pos.gotoAndStop(1);
				showBuffAddition(mc,info);//双倍经验卡（Buffer）
				showAuncherExperienceAddition(mc,info);//客户端加成
				showSpouseAddition(mc,info);//结婚加成
				updateIconPos(mc,info);//重新排列加成图标的位置
			}
		}
		
		private var _singlePlayerIconList:Array = [];
		
		private function showBuffAddition(mc:MovieClip,info:Player):void
		{
			var buff:DictionaryData = info.playerInfo.buffInfo;
			for(var i:String in buff)
			{
				if(buff[i].Type == BuffInfo.DOUBEL_EXP)
				{
//					(mc as ExperienceStripAsset).EXPx2.visible = true;
//					mc.value_mc.value_txt.autoSize = TextFieldAutoSize.LEFT;
					var _mc:MovieClip = new DoubleExpAsset();
					_mc.gotoAndStop(1);
					_mc["tipText"] = LanguageMgr.GetTranslation("ddt.gameover.gainDoubleEXP");
					_mc.addEventListener(MouseEvent.MOUSE_OVER, __iconOverHandler);
					_mc.addEventListener(MouseEvent.MOUSE_OUT, __iconOutHandler);
					_singlePlayerIconList.push(_mc);
					(mc as ExperienceStripAsset).icon_pos.addChild(_mc);
				}
				if(buff[i].Type == BuffInfo.DOUBLE_GESTE)
				{
					(mc as ExperienceStripAsset).GESTEx2.visible = true;
				}
			}
		}
		
		private function showAuncherExperienceAddition(mc:MovieClip,info:Player):void
		{
			var roomPlayerInfo:RoomPlayerInfo = GameManager.Instance.Current.findRoomPlayer(info.playerInfo.ID,info.playerInfo.ZoneID)
			
			if(roomPlayerInfo == null)
				return;
			
			var _mc:MovieClip;
			
			if(roomPlayerInfo.AdditionInfo.AuncherExperienceAddition > 1)
			{
				_mc = new ClientAdditionAsset();
				_mc.gotoAndStop(1);
				_mc["tipText"] = LanguageMgr.GetTranslation("ddt.gameover.clientGainEXP")+roomPlayerInfo.AdditionInfo.AuncherExperienceAddition.toString()+LanguageMgr.GetTranslation("ddt.gameover.times");
				_mc.addEventListener(MouseEvent.MOUSE_OVER, __iconOverHandler);
					_mc.addEventListener(MouseEvent.MOUSE_OUT, __iconOutHandler);
				_singlePlayerIconList.push(_mc);
				(mc as ExperienceStripAsset).icon_pos.addChild(_mc);
			}
			
			if(info.isSelf && roomPlayerInfo.AdditionInfo.GMExperienceAdditionType > 1)
			{
				serverExp.gotoAndStop(roomPlayerInfo.AdditionInfo.GMExperienceAdditionType - 1);
				serverExp.visible = true;
			}
		}
		
		private function showSpouseAddition(mc:MovieClip,info:Player):void
		{
			for each(var l:Living in _gamePlayers)
			{
				if(l.playerInfo.SpouseID != 0 && 
				l.team == info.team && 
				info.playerInfo.ID != l.playerInfo.ID && 
				(l.playerInfo.SpouseID == info.playerInfo.ID || 
				l.playerInfo.ID == info.playerInfo.SpouseID))
				{
					var _mc:MovieClip = new MarryIconAsset();
					_mc.gotoAndStop(1);
					_mc["tipText"] = LanguageMgr.GetTranslation("ddt.gameover.ExperienceView");
//					_mc["tipText"] = "夫妻组队经验获得1.2倍";
					_mc.addEventListener(MouseEvent.MOUSE_OVER, __iconOverHandler);
					_mc.addEventListener(MouseEvent.MOUSE_OUT, __iconOutHandler);
					_singlePlayerIconList.push(_mc);
					(mc as ExperienceStripAsset).icon_pos.addChild(_mc);
				}
			}
		}
		private function __iconOverHandler(e:MouseEvent):void
		{
			TipManager.clearTipLayer();
			
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			var _iconTip:AdditionIconTipPanel = new AdditionIconTipPanel(mc["tipText"]);
			
			var globalPoint:Point = mc.localToGlobal(new Point());
			
			globalPoint.x += 32;
			globalPoint.y += 33;
			
			if(globalPoint.x > stage.stageWidth)
			{
				globalPoint.x = globalPoint.x - _iconTip.width - mc.width;
			}
			
			_iconTip.x = globalPoint.x - 7;
			_iconTip.y = globalPoint.y;
			
			TipManager.AddTippanel(_iconTip);
		}
		
		private function __iconOutHandler(e:MouseEvent):void
		{
			TipManager.clearTipLayer();
		}
		
		private var playerIconLst:DictionaryData = new DictionaryData();
		
		private function updateIconPos(mc:MovieClip,info:Player):void
		{
			for (var i:uint = 1; i < _singlePlayerIconList.length; i++)
			{
				if(_singlePlayerIconList[i] is MovieClip && _singlePlayerIconList[i - 1] is MovieClip)
					_singlePlayerIconList[i].x = _singlePlayerIconList[i - 1].x + _singlePlayerIconList[i - 1].width + 2;
			}
			
			//计算显示居中
//			var _expAsset:ExperienceStripAsset = mc as ExperienceStripAsset;
//			
//			var _x:Number = _expAsset.icon_pos.x;
//			var _y:Number = _expAsset.icon_pos.y;
//			
//			_expAsset.icon_pos.x = _x - _expAsset.icon_pos.width / 2;
//			_expAsset.icon_pos.y = _y - _expAsset.icon_pos.height / 2;
			
			playerIconLst.add(info.playerInfo.ID, _singlePlayerIconList);
			
			_singlePlayerIconList = [];
		}
		
		public function dispose():void
		{
			TipManager.clearTipLayer();
			if(playerIconLst)
			{
				for each(var array:Array in playerIconLst)
				{
					for each(var mc:MovieClip in array)
					{
						mc.removeEventListener(MouseEvent.MOUSE_OVER, __iconOverHandler);
						mc.removeEventListener(MouseEvent.MOUSE_OUT, __iconOutHandler);
						mc.stop();
						if(mc.parent)
							mc.parent.removeChild(mc);
					}
				}
				playerIconLst.clear();
			}
			playerIconLst = null;
			
			_singlePlayerIconList = null;
			_gamePlayers = null;
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}