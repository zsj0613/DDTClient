package ddt.view.common
{
	import game.crazyTank.view.common.BattleAsset;
	
	/**
	 * @author WickiLA
	 * @time 01/11/2010
	 * @description 等级tip上的战斗力图标
	 * */
	public class Battle extends BattleAsset
	{
		public function Battle(battle:int)
		{
			BattleNum = battle;
		}
		
		public function set BattleNum(battleNum:int):void
		{
			battle_txt.text = battleNum.toString();
		}

	}
}