package ddt.game.actions
{
	import ddt.actions.BaseAction;
	import ddt.data.game.Player;

	public class ChangeBallAction extends BaseAction
	{
		private var _player:Player;
		private var _currentBomb:int;
		private var _isSpecialSkill:Boolean;
		public function ChangeBallAction(player:Player,isSpecialSkill:Boolean,currentBomb:int)
		{
			_player = player;
			_currentBomb = currentBomb;
			_isSpecialSkill = isSpecialSkill
		}
		override public function executeAtOnce():void
		{
			super.executeAtOnce();
			_player.isSpecialSkill = _isSpecialSkill;
			_player.currentBomb = _currentBomb;
			if(_player.isSpecialSkill)
			{
				_player.addState(-1);
			}
		}
	}
}