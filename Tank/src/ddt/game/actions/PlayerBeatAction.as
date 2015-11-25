package ddt.game.actions
{
	import flash.display.Sprite;
	
	import road.display.MovieClipWrapper;
	
	import ddt.actions.BaseAction;
	import ddt.game.objects.GameLocalPlayer;
	import ddt.game.objects.GamePlayer;
	import ddt.view.characterII.GameCharacter;
	
	public class PlayerBeatAction extends BaseAction
	{
		private var _player:GamePlayer;
		private var _count:int;
		
		public function PlayerBeatAction(player:GamePlayer)
		{
			_player = player;
			_count = 0;
		}
		
		override public function prepare():void
		{
			_player.body.doAction(GameCharacter.HIT);
			_player.map.setTopPhysical(_player);
			if(_player is GameLocalPlayer)
			{
				GameLocalPlayer(_player).aim.visible = false;
			}
			var t:MovieClipWrapper = new MovieClipWrapper(new HitAsset(),true,true);
			t.x = - _player.body.characterWidth / 2 - 8;
			t.y = - _player.body.characterHeight + 19;
			Sprite(_player.body).addChild(t);
		}
		
		override public function execute():void
		{
			_count ++;
			if(_count >= 50)
			{
				if(_player is GameLocalPlayer)
				{
					GameLocalPlayer(_player).aim.visible = true;
				}
				_isFinished = true;
			}
		}
		
	}
}