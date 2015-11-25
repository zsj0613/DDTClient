package ddt.game.actions
{
	import ddt.actions.BaseAction;
	import ddt.game.map.MapView;
	import ddt.manager.GameManager;
	
	public class ViewEachPlayerAction extends BaseAction
	{
		private var _map:MapView;
		private var _players:Array;
		private var _interval:Number;
		private var _index:int;
		private var _count:int;
		public function ViewEachPlayerAction(map:MapView,players:Array,interval:Number = 1500)
		{
			_players = players.sortOn("x",Array.NUMERIC);
			_map = map;
			_interval = interval / 40;
			_index = 0;
			_count = 0;
		}
		
		override public function execute():void
		{
			if(GameManager.Instance.Current == null)
			{
				return;
			}
			if(_count <= 0)
			{
				if(_index < _players.length)
				{	
//					trace("==============viewEachPlayerAction"+new Date().toTimeString());
					_map.setCenter(_players[_index].x,_players[_index].y - 150,true);
					_count = _interval;
					_index ++;
				}
				else
				{
					_isFinished = true;
					/**
					 * 动画完毕可以开始开炮
					 * 把开始游戏的事件设置为已执行 避免事件阻塞
					*/					
					GameManager.Instance.Current.startEvent.executed = true;
				}
			}
			_count --;
		}
	}
}