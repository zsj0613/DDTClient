package ddt.game.actions
{
	import game.crazyTank.view.LoseAsset;
	import game.crazyTank.view.WinAsset;
	
	import road.display.MovieClipWrapper;
	import road.manager.SoundManager;
	
	import ddt.actions.BaseAction;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.map.MapView;
	import ddt.manager.GameManager;
	
	public class GameOverAction extends BaseAction
	{
		private var _event:CrazyTankSocketEvent;
		private var _executed:Boolean;
		private var _count:int;
		private var _map:MapView;
		
		
		public function GameOverAction(map:MapView,event:CrazyTankSocketEvent,waitTime:Number = 3000)
		{
			_event = event;
			_map = map;
			_count = waitTime / 40;
			
		}
		
		override public function cancel():void
		{
			_event.executed = true;
		}
		
		override public function execute():void
		{
			if(!_executed)
			{
				if(_map.hasSomethingMoving() == false && (_map.currentPlayer == null || _map.currentPlayer.actionCount == 0 ))
				{
					_executed = true;
					_event.executed = true;
					if(_map.currentPlayer && _map.currentPlayer.isExist)_map.currentPlayer.beginNewTurn();//清除当前攻击人物的一些状态
					var movie:MovieClipWrapper;
					if(GameManager.Instance.Current.selfGamePlayer.isWin)
					{
						movie = new MovieClipWrapper(new WinAsset(),true,true);
					}
					else
					{
						movie = new MovieClipWrapper(new LoseAsset(),true,true);
					}
					SoundManager.Instance.play("040");
					movie.x = 500;
					movie.y = 360;
					_map.gameView.addChild(movie);
					_map.gameView.gameOver();
				}
			}
			else
			{
				_count --;
				if(_count <=0)
				{
					_isFinished = true;
					_map.gameView.gotoGameOverState();
				}
			}
		}
	}
}