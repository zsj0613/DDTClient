package ddt.game.player
{
	import flash.display.Sprite;
	
	import game.crazyTank.view.SmallBloodAsset;
	
	import ddt.data.game.Living;
	/**
	 *  
	 * @author SYC
	 * 人物上方小血条
	 */
	public class SmallBloodView extends SmallBloodAsset
	{
		private var _currentBlood:Sprite;
		private var _bloodWidth:int;
		private var _isLeader:Boolean;
		private var _totalBlood:int;
		
		public function SmallBloodView(maxBlood:int,team:int)
		{
		}
		
		public function init(info:Living):void
		{
			for(var i:int = 1; i <= 8; i ++)
			{
				var temp:Sprite = this["team" + i];
				temp.visible = false;
			}
			_currentBlood = this["team" + info.team];
			_currentBlood.visible = true;
			_bloodWidth = _currentBlood.width;
			_totalBlood = info.maxBlood;
		}
		
		public function updateBlood(blood:Number):void
		{
			if(blood < 0)
			{
				_currentBlood.width = 0;
			}
			else
			{
				_currentBlood.width = Math.floor(_bloodWidth / _totalBlood * blood);
			}
		}

		public function dispose():void
		{
			if(parent) parent.removeChild(this);
		}
		
	}
}