package ddt.gameover.settlement.item
{
	import game.crazyTank.view.gameOverSettle.item.duplicateItemAsset;
	
	import road.data.DictionaryData;
	import road.utils.ComponentHelper;
	
	import ddt.data.BuffInfo;
	import ddt.data.Experience;
	import ddt.data.game.Player;
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.view.common.LevelIcon;

	public class DuplicateSettleItem extends duplicateItemAsset
	{
		private var _settleinfo:BaseSettleInfo;
		
		private var _player:Player;
		
		private var _level:LevelIcon;

		public function DuplicateSettleItem(settleinfo:BaseSettleInfo = null,player:Player = null)
		{
			super();
			gotoAndStop(1);
			_settleinfo = settleinfo;
			_player = player;   
			
			level_pos.visible = false;
			EXPx2.visible = false;
			upCartoon_mc.visible = false;
			
			if(settleinfo != null && _player != null)
			{
				init();
//				initEvent();
			}
			else
			{
				noPlayer();
			}
			
			clearMC();
		}
		
		private function init():void
		{
			setSettlementInfo();
			createLevelIcon();
		}
		
		/* private function initEvent():void
		{
			
		} */
		
		/**
		 * 设置结算信息
		 * 
		 */		
		private function setSettlementInfo():void
		{
			playername_txt.text = _player.playerInfo.NickName;
			allhert_txt.text = _settleinfo.hert.toString();
			alltreatment_txt.text = _settleinfo.treatment.toString();
			made_txt.text = _settleinfo.made.toString()+"%";
//			experience_txt.text = _settleinfo.exp.toString();
			if(_settleinfo.exp >= 0)
			{
				exp_mc.exp_txt.text = "(+"+_settleinfo.exp.toString()+")";
				exp_mc.strip_mc.width = Experience.getExpPercent(Experience.getGrade(_player.playerInfo.GP),_player.playerInfo.GP) * 0.95;
				if(exp_mc.strip_mc.width >= 98) exp_mc.strip_mc.width=98;
				exp_mc.visible = true;
			}
			else
			{
				exp_mc.exp_txt.text = "(-"+_settleinfo.exp.toString()+")";
				exp_mc.strip_mc.width = 0;
				exp_mc.visible = true;
			}
			
			graded_txt.text = PlayerSettleItem.getGradedStr(_settleinfo.graded);
			
			if(_player.isUpGrade)
			{
				exp_mc.exp_txt.visible = false;
//				exp_mc.strip_mc.width = 95;
				upCartoon_mc.visible = true;
			}
			
			showBuff();
		}
		
		private function showBuff():void
		{
			var buff:DictionaryData=_player.playerInfo.buffInfo;
			
			
			for (var i:String in buff)
			{
				if (buff[i].Type == BuffInfo.DOUBEL_EXP)
				{
					EXPx2.visible = true;
					break;
//					mc.value_mc.value_txt.autoSize=TextFieldAutoSize.LEFT;
				}
			}
		}
		
		private function createLevelIcon():void
		{
			_level = new LevelIcon("s",_player.playerInfo.Grade,_player.playerInfo.Repute,_player.playerInfo.WinCount,_player.playerInfo.TotalCount,_player.playerInfo.FightPower,false);
			_level.x = level_pos.x - 2;
			_level.y = level_pos.y;
			level_pos.parent.addChild(_level);
//			ComponentHelper.replaceChild(this,level_pos,_level);
		}
		
		/**
		 * 清除用于定位的MovieClip
		 * 
		 */		
		private function clearMC():void
		{
			if(level_pos && level_pos.parent)
			{
				level_pos.parent.removeChild(level_pos);
			}
			level_pos = null;
		}
		
		/**
		 * 无玩家时调用
		 * 
		 */		
		public function noPlayer():void
		{
			playername_txt.text = "";
			allhert_txt.text = "";
			alltreatment_txt.text = "";
//			experience_txt.text = "-";
			made_txt.text = "";
			exp_mc.exp_txt.text = "";
			exp_mc.strip_mc.width = 0;
			exp_mc.visible = false;
			graded_txt.text = "";
			
			upCartoon_mc.visible = false;
			EXPx2.visible = false;
		}
		
		public function dispose():void
		{
			if(_level)
			{
				_level.dispose();
			}
			_level = null;
			
			_settleinfo = null;
			_player = null;
		}
	}
}