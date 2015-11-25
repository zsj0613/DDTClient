package ddt.actions
{
	import flash.utils.getQualifiedClassName;
	
	import ddt.utils.DebugUtil;
	
	public class ActionManager
	{
		private var _queue:Array;
		
		public function ActionManager()
		{
			_queue = new Array();
		}
		
		public function act(action:BaseAction):void
		{
			for(var i:int = 0; i < _queue.length; i ++)
			{
				var c:BaseAction = _queue[i];
				if(c.connect(action))
				{
					return;
				}
				else if(c.canReplace(action))
				{
					action.prepare();
					_queue[i] = action;
					return;
				}
			}
			_queue.push(action);
			if(_queue.length == 1)
			{
				action.prepare();
			}
		}
		
		public function execute():void
		{
			if(_queue.length > 0)
			{
				var c:BaseAction = _queue[0];
				if(!c.isFinished)
				{
					c.execute();
				}else
				{
					_queue.shift();
					if(_queue.length > 0)
						_queue[0].prepare();
				}
			}
		}
		
		public function traceAllRemainAction():void
		{
			for each(var action:BaseAction in _queue)
			{
				var actionClassName:String = getQualifiedClassName(action);
//				DebugUtil.debugText(actionClassName);
			}
		}
		
		public function get actionCount():int
		{
			return _queue.length;
		}
		
		public function executeAtOnce():void
		{
			for each(var action:BaseAction in _queue)
			{
				action.executeAtOnce();
			}
		}
		
		public function clear():void
		{
			for each(var action:BaseAction in _queue)
			{
				action.cancel();
			}
			_queue = [];
		}
		

	}
}