package ddt.hotSpring.vo
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import ddt.data.player.PlayerInfo;
	import ddt.hotSpring.events.HotSpringRoomPlayerEvent;
	import ddt.view.sceneCharacter.SceneCharacterDirection;

	/**
	 * 仅温泉系统中的玩家实体值对象
	 */
	public class PlayerVO extends EventDispatcher
	{
		private var _playerPos:Point=new Point(480, 560);
		private var _playerNickName:String;
		private var _playerSex:Boolean;
		private var _playerInfo:PlayerInfo;
		private var _walkPath:Array=[];
		private var _targetArea:int;//目标所在区域:1=陆地区；2=水区
		private var _currentlyArea:int;//当前所在区域:1=陆地区；2=水区
		private var _sceneCharacterDirection:SceneCharacterDirection;
		private var _playerDirection:int=3;//玩家方向：1=RT;2=LT;3=RB;4=LB
		private var _playerMoveSpeed:Number=0.15;//玩家移动速度
		public var currentWalkStartPoint:Point;
		
		/**
		 * 取得玩家当前位置 
		 */		
		public function get playerPos():Point
		{
			return _playerPos;
		}
		
		/**
		 * 设置玩家当前位置
		 */		
		public function set playerPos(value:Point):void
		{
			_playerPos=value;
			dispatchEvent(new HotSpringRoomPlayerEvent(HotSpringRoomPlayerEvent.PLAYER_POS_CHANGE,_playerInfo.ID));
		}

		/**
		 * 取得玩家基本信息
		 */		
		public function get playerInfo():PlayerInfo
		{
			return _playerInfo;
		}
		
		/**
		 * 设置玩家基本信息
		 */		
		public function set playerInfo(value:PlayerInfo):void
		{
			_playerInfo=value;
		}
		
		/**
		 *取得玩家行走路径
		 */		
		public function get walkPath():Array
		{
			return _walkPath;
		}
		
		/**
		 *设置玩家行走路径
		 */		
		public function set walkPath(value:Array):void
		{
			_walkPath = value;
		}
		
		/**
		 * 取得当前区域:1=陆地;2=水区
		 */		
		public function get currentlyArea():int
		{
			return _currentlyArea;
		}
		
		/**
		 * 设置当前区域:1=陆地;2=水区
		 */		
		public function set currentlyArea(value:int):void
		{
			if(_currentlyArea==value) return;
			_currentlyArea = value;
			_playerMoveSpeed=_currentlyArea==1 ? 0.15 : 0.075;//玩家移动速度
		}
		
		/**
		 * 取得玩家当前方向
		 */		
		public function get scenePlayerDirection():SceneCharacterDirection
		{
			return _sceneCharacterDirection;
		}
		
		/**
		 * 设置玩家当前方向
		 */		
		public function set scenePlayerDirection(value:SceneCharacterDirection):void
		{
			_sceneCharacterDirection = value;
			switch(_sceneCharacterDirection)
			{
				case SceneCharacterDirection.RT:
					_playerDirection=1;
					break;
				case SceneCharacterDirection.LT:
					_playerDirection=2;
					break;
				case SceneCharacterDirection.RB:
					_playerDirection=3;
					break;
				case SceneCharacterDirection.LB:
					_playerDirection=4;
					break;
			}
		}

		/**
		 * 取得玩家方向：1=RT;2=LT;3=RB;4=LB
		 */		
		public function get playerDirection():int
		{
			return _playerDirection;
		}

		/**
		 * 设置玩家方向：1=RT;2=LT;3=RB;4=LB
		 */
		public function set playerDirection(value:int):void
		{
			_playerDirection = value;
			switch(_playerDirection)
			{
				case 1:
					_sceneCharacterDirection=SceneCharacterDirection.RT;
					break;
				case 2:
					_sceneCharacterDirection=SceneCharacterDirection.LT;
					break;
				case 3:
					_sceneCharacterDirection=SceneCharacterDirection.RB;
					break;
				case 4:
					_sceneCharacterDirection=SceneCharacterDirection.LB;
					break;
			}
		}
		
		/**
		 * 取得玩家移动速度
		 */		
		public function get playerMoveSpeed():Number
		{
			return _playerMoveSpeed;
		}

		/**
		 * 设置玩家移动速度
		 */		
		public function set playerMoveSpeed(value:Number):void
		{
			if(_playerMoveSpeed==value) return;
			_playerMoveSpeed = value;
			dispatchEvent(new HotSpringRoomPlayerEvent(HotSpringRoomPlayerEvent.PLAYER_MOVE_SPEED_CHANGE,_playerInfo.ID));
		}
		
		/**
		 * 当前对象克隆
		 */		
		public function clone():PlayerVO
		{
			var playerVO:PlayerVO=new PlayerVO();
			playerVO.playerInfo=_playerInfo;
			playerVO.playerPos=_playerPos;
			playerVO.walkPath=_walkPath;
			playerVO.currentlyArea=_currentlyArea;
			playerVO.playerDirection=_playerDirection;
			playerVO.playerMoveSpeed=_playerMoveSpeed;
			return playerVO;
		}
		
		public function dispose():void
		{
			while(_walkPath && _walkPath.length>0)
			{
				_walkPath.shift();
			}
			_walkPath=null;
			_playerInfo=null;
			_sceneCharacterDirection=null;
		}
	}
}