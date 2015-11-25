package ddt.gameover.settlement.item
{
	import game.crazyTank.view.gameOverSettle.item.PlayerSettleItemAsset;
	
	import road.data.DictionaryData;
	
	import ddt.data.BuffInfo;
	import ddt.data.Experience;
	import ddt.data.gameover.BaseSettleInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.manager.RoomManager;
	
	/**
	 * 结算信息Item
	 * 
	 * @author JSION
	 * 
	 */	
	public class PlayerSettleItem extends PlayerSettleItemAsset
	{
		private var _gk:BaseSettleInfo;
		
		public function get info():BaseSettleInfo
		{
			return _gk;
		}
		
		public function set info(value:BaseSettleInfo):void
		{
			if(_gk == value) return;
			
			_gk = value;
			if(value == null)
			{
				noPlayer();
			}
			else
			{
				createSettleInfo();
			}
		}
		
		public function PlayerSettleItem(gk:BaseSettleInfo = null)
		{
			super();
			_gk = gk;
			init();
		}
		
		private function init():void
		{
			if(_gk != null && _gk.playerid > 0)
			{
				createSettleInfo();
			}
			else
			{
				noPlayer();
			}
			
			clearMC();
		}
		
		/**
		 * 创建关卡结算数据
		 * 
		 */		
		private function createSettleInfo():void
		{
			var roomplayerinfo:RoomPlayerInfo = RoomManager.Instance.current.players[_gk.playerid] as RoomPlayerInfo;
			nickname_txt.text = roomplayerinfo.info.NickName;
			killhert_txt.text = _gk.hert.toString();
//			killhert_txt.visible = true;
			treatment_txt.text = _gk.treatment.toString();
//			treatment_txt.visible = true;
			made_txt.text = _gk.made.toString()+"%";
//			made_txt.visible = true;
			exp_mc.exp_txt.text = "(+"+_gk.exp.toString()+")";
			exp_mc.strip_mc.width = Experience.getExpPercent(roomplayerinfo.info.Grade,roomplayerinfo.info.GP);
			if(exp_mc.strip_mc.width >= 98) exp_mc.strip_mc.width=98;
			exp_mc.visible = true;
			graded_txt.text = getGradedStr(_gk.graded);
//			graded_txt.visible = true;
			showBuff(roomplayerinfo);
		}
		
		public static function getGradedStr(grade:int):String
		{
			if(grade >= 3)
			{
				return "S";
			}
			else if(grade >= 2)
			{
				return "A";
			}
			else if(grade == 0)
			{
				return "C";
			}
			else if(grade < 2)
			{
				return "B";
			}
			
			return "C";
		}
		
		private function showBuff($roomplayerinfo:RoomPlayerInfo):void
		{
			var buff:DictionaryData=$roomplayerinfo.info.buffInfo;
			
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
		
		/**
		 * 清除用于定位的MovieClip
		 * 
		 */		
		private function clearMC():void
		{
		}
		
		/**
		 * 无玩家信息时调用
		 * 
		 */		
		private function noPlayer():void
		{
			nickname_txt.text = "";
			killhert_txt.text = "";
			treatment_txt.text = "";
			made_txt.text = "";
			exp_mc.visible = false;
			EXPx2.visible = false;
			graded_txt.text = "";
//			nickname_txt.visible = false;
//			killhert_txt.visible = false;
//			treatment_txt.visible = false;
//			made_txt.visible = false;
//			exp_mc.visible = false;
//			graded_txt.visible = false;
		}
		
		/**
		 * 析构函数
		 * 
		 */		
		public function dispose():void
		{
			_gk = null;
		}
	}
}