package ddt.game.actions
{
	import ddt.actions.BaseAction;
	import ddt.data.game.Living;
	import ddt.game.animations.AnimationLevel;
	import ddt.game.animations.BaseSetCenterAnimation;
	import ddt.game.objects.GameLiving;
	import ddt.game.objects.GameSamllEnemy;

	public class LivingMoveAction extends BaseAction
	{
		private var _living:GameLiving;
		private var _path:Array;
		private var _currentPathIndex:int = 0;
		private var _dir:int;
		public function LivingMoveAction(living:GameLiving,path:Array,dir:int)
		{
			_isFinished = false;
			_living = living;
			_path = path;
			_dir = dir;
			_currentPathIndex = 0;
		}
		
		override public function prepare():void
		{
			if(_living.isLiving)
			{
				_living.startMoving();
				if(!(_living is GameSamllEnemy) || _living == _living.map.currentFocusedLiving)
				{
					_living.map.animateSet.addAnimation(new BaseSetCenterAnimation(_living.x,_living.y - 150,0,false,AnimationLevel.HIGHT));
				}
				if(_path[0].x < _path[_path.length-1].x)
				{
					_living.actionMovie.scaleX = -1;
				}else if(_path[0].x > _path[_path.length-1].x)
				{
					_living.actionMovie.scaleX = 1;
				}
           }else
			{
				finish();
			}
		}
		
		override public function execute():void
		{
            /**if(!(_living is GameSamllEnemy) || _living == _living.map.currentFocusedLiving)
					_living.map.animateSet.addAnimation(new BaseSetCenterAnimation(_living.x,_living.y - 150,0,false,AnimationLevel.LOW));*/
			if(_living is GameSamllEnemy){
				_living.map.requestForFocus(_living,AnimationLevel.LOW);
			}else{
				_living.map.animateSet.addAnimation(new BaseSetCenterAnimation(_living.x,_living.y - 150,0,false,AnimationLevel.LOW));
			}
            if(_path[_currentPathIndex]) _living.info.pos = _path[_currentPathIndex];
            _currentPathIndex++;
            if (_currentPathIndex >= _path.length)
            {
				finish();
                _living.info.doDefaultAction();
            }
		}
		
		private function finish():void
		{
			_living.stopMoving();
			//_living.map.cancelFocus(_living);
			_isFinished = true;
		}
		
		
	}
}