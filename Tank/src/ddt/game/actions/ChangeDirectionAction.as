package ddt.game.actions
{
	import ddt.actions.BaseAction;
	import ddt.game.objects.GameLiving;

	public class ChangeDirectionAction extends BaseAction
	{
		private var _living:GameLiving;
		private var _dir:int;
		public function ChangeDirectionAction(living:GameLiving,$dir:int)
		{
			super();
			_living = living;
			_dir = $dir;
		}
		
		override public function canReplace(action:BaseAction):Boolean
		{
			var act:ChangeDirectionAction = action as ChangeDirectionAction;
			if(act && _dir == act.dir) return true;
			return false;
		}
		
		override public function connect(action:BaseAction):Boolean
		{
			var act:ChangeDirectionAction = action as ChangeDirectionAction;
			if(act && _dir == act.dir) return true;
			return false;
		}
		
		public function get dir():int
		{
			return _dir;
		}
		
		override public function prepare():void
		{
			if(_isPrepare) return;
			_isPrepare = true;
			if(!_living.isLiving) _isFinished = true;
		}
		
		override public function execute():void
		{
			_living.actionMovie.scaleX = -_dir;
			_isFinished = true;
		}
		
		override public function executeAtOnce():void
		{
			super.executeAtOnce();
			_living.actionMovie.scaleX = -_dir;
		}
		
	}
}