package ddt.game.actions
{
	import ddt.actions.BaseAction;
	import ddt.game.map.MapView;
	import ddt.manager.GameManager;
	
	public class ViewEachObjectAction extends BaseAction
	{
		private var _map:MapView;
		private var _objects:Array;
		private var _interval:Number;
		private var _index:int;
		private var _count:int;
		private var _type:int;
		public function ViewEachObjectAction(map:MapView,objects:Array,type:int = 0,interval:Number = 1500){
			_objects = objects
			_map = map;
			_interval = interval / 40;
			_index = 0;
			_count = 0;
			_type = type;
		}
		
		override public function execute():void
		{
			if(_count <= 0)
			{
				if(_index < _objects.length)
				{	
					_map.scenarioSetCenter(_objects[_index].x,_objects[_index].y,_type);
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