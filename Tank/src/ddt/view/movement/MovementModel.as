package ddt.view.movement
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import ddt.data.MovementInfo;
	import ddt.request.LoadActiveInfoAction;

	public class MovementModel extends EventDispatcher
	{
		private var _actives:Array;
		
		public static var newMovement : Dictionary = new Dictionary();   //bret 09.8.20
		
		public function get actives():Array
		{
			if(_actives)
			{
				return _actives.slice(0);
			}
			return null;
		}
		public function MovementModel()
		{
//			_actives = new Array();
		}
		
		private var _currentInfo:MovementInfo;
		internal function set currentInfo(value:MovementInfo):void
		{
			//if(_currentInfo == value) return;
			_currentInfo = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		internal function get currentInfo():MovementInfo
		{
			return _currentInfo;
		}
		
		public function getActiveInfo():void
		{
//			var action:LoadActiveInfoAction = new LoadActiveInfoAction();
//			action.loadSync(__loadComplete);
			new LoadActiveInfoAction().loadSync(__loadComplete);
		}
				
		private function __loadComplete(loader:LoadActiveInfoAction):void
		{
			_actives = loader.list;
			filtTime();
			_actives = sortActives();
			MovementLeftView.Instance.setup();
			dispatchEvent(new Event(Event.COMPLETE));
			
			checkNewMovement();    //bret 09.8.20 是否有新活动
		}
		
		private function filtTime():void
		{
			for(var i:int = _actives.length - 1; i >= 0; i --)
			{
				var info:MovementInfo = _actives[i];
				if(info.overdue())
				{
					_actives.splice(i,1);
				}
			}
		}
		
		private function sortActives():Array
		{
			var first:Array = new Array();
			var second:Array = new Array();
			var third:Array = new Array();
			for(var i:int = 0 ; i < _actives.length ; i ++)
			{
				var info:MovementInfo = _actives[i];
				if(info.Type == 0)
				{
					third.push(info);
				}
				else if(info.Type == 2)
				{
					second.push(info);
					if(newMovement[info.ActiveID] == null)newMovement[info.ActiveID] = false; //bret 09.8.20
				}
				else if(info.Type == 1)
				{
					first.push(info);
				}
			}
			return first.concat(second,third);
		}
		
		/* bret 是否有新活动 */
		public static function checkNewMovement() :void
		{
//			for(var i:String in newMovement)
//			{
//				if(!newMovement[i])
//				{
//					BellowStripViewII.Instance.showmovementHightLight();
//					break;
//				}
//			}
		}
		
		
		private static var _instance:MovementModel;
		public static function get Instance():MovementModel
		{
			if(_instance == null)
			{
				_instance = new MovementModel();
			}
			return _instance;
		}
//		internal function dispose():void
//		{
//			_actives = new Array();
//			_currentInfo = null;
//		}
		
	}
}