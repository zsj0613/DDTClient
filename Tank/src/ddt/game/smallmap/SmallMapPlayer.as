package ddt.game.smallmap
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import game.crazyTank.view.SmallMapPlayer1Asset;
	import game.crazyTank.view.SmallMapPlayer2Asset;
	import game.crazyTank.view.SmallMapPlayer3Asset;
	import game.crazyTank.view.SmallMapPlayer4Asset;
	import game.crazyTank.view.SmallMapPlayer5Asset;
	import game.crazyTank.view.SmallMapPlayer6Asset;
	import game.crazyTank.view.SmallMapPlayer7Asset;
	import game.crazyTank.view.SmallMapPlayer8Asset;
	import game.crazyTank.view.SmallMapPlayer9Asset;
	import game.crazyTank.view.SmallMapPlayer10Asset;
	import game.crazyTank.view.SmallMapPlayer11Asset;
	import game.crazyTank.view.SmallMapPlayer12Asset;
	import game.crazyTank.view.SmallMapPlayer13Asset;
	import game.crazyTank.view.SmallMapPlayer14Asset;
	import game.crazyTank.view.SmallMapPlayer15Asset;
	import game.crazyTank.view.SmallMapPlayer16Asset;

	
	import ddt.data.game.Living;
	import ddt.data.game.SimpleBoss;
	import ddt.data.game.SmallEnemy;
	import ddt.data.game.TurnedLiving;
	import ddt.events.LivingEvent;
	import ddt.manager.GameManager;

	public class SmallMapPlayer extends Sprite
	{
		private var _info:Living;
		
		private var _player:MovieClip;
		
		public function SmallMapPlayer(info:Living)
		{
			_info = info;
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			if(_info is SimpleBoss||_info is SmallEnemy){
				if(_info.team == 1){
					createPlayer(new SmallMapPlayer1Asset());
					return;
				}
			}
			if(_info.team == 1)
			{
				
				createPlayer(new SmallMapPlayer9Asset());
			}
			else if(_info.team == 2)
			{
				createPlayer(new SmallMapPlayer10Asset());
			}
			else if(_info.team == 3)
			{
				createPlayer(new SmallMapPlayer11Asset());
			}
			else if(_info.team == 4)
			{
				createPlayer(new SmallMapPlayer12Asset());
			}
			else if(_info.team == 5)
			{
				createPlayer(new SmallMapPlayer13Asset());
			}
			else if(_info.team == 6)
			{
				createPlayer(new SmallMapPlayer14Asset());
			}
			else if(_info.team == 7)
			{
				createPlayer(new SmallMapPlayer15Asset());
			}
			else if(_info.team == 8)
			{
				createPlayer(new SmallMapPlayer16Asset());
			}
		}
		
		private function initEvent():void
		{
			_info.addEventListener(LivingEvent.ATTACKING_CHANGED,__change);		
			_info.addEventListener(LivingEvent.HIDDEN_CHANGED,   __hide);
			_info.addEventListener(LivingEvent.DIE,              __die);
		}
		
		public function dispose():void
		{
			_info.removeEventListener(LivingEvent.ATTACKING_CHANGED,__change);
			_info.removeEventListener(LivingEvent.HIDDEN_CHANGED,   __hide);
			_info.removeEventListener(LivingEvent.DIE,              __die);
			_info = null;
			_player.stop();
			_player = null;
			if(parent) parent.removeChild(this);
		}
		
		private function createPlayer(player:MovieClip):void
		{
			_player = player;
			
			_player.scaleX = _player.scaleY = 1.2;
			
			player["attrack_mc"].visible = false;
			addChild(_player);
			if(_info.isSelf)
			{
				player["player_mc"].gotoAndPlay(1);
			}
			else
			{
				player["player_mc"].gotoAndStop(8);
			}
		}
		
		private function __change(event:LivingEvent):void
		{
			if((_info as TurnedLiving).isAttacking){
				_player["attrack_mc"].visible = true;
			}else{
				_player["attrack_mc"].visible = false;
			}
		}
		
		//10/6/28。修改适应16色玩家。
		private function __hide(event:LivingEvent):void
		{
			if(_info.isHidden)
			{
				if(_info.team != GameManager.Instance.Current.selfGamePlayer.team)
				{
					alpha = 0;
					visible = false;
				}
				else
				{
					alpha = 0.5;
				}
			}
			else
			{
				alpha = 1;
				visible = true;
			}
		}
		
		private function __die(evt : LivingEvent) : void
		{
			_player["attrack_mc"].visible = false;
		}
	}
}