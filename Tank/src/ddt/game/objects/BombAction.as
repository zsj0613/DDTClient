package ddt.game.objects
{
	import flash.geom.Point;
	
	import phy.object.PhysicalObj;
	
	import ddt.data.GameInfo;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	
	public class BombAction
	{
		private var _time:int;
		private var _type:int;
		private var _param1:int;
		public var _param2:int;
		public var _param3:int;
		public var _param4:int;
		
		public function get time():int
		{
			return _time;
		}
		
		public function BombAction(time:int,type:int,param1:int, param2:int,param3:int,param4:int)
		{
			_time = time;
			_type = type;
			_param1 = param1;
			_param2 = param2;
			_param3 = param3;
			_param4 = param4;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function execute(ball:SimpleBomb,game:GameInfo):void
		{
			switch(_type)
			{
				case ActionType.PICK:
					var obj:PhysicalObj = ball.map.getPhysical(_param1);
					if(obj)
					{
						obj.collidedByObject(ball);
					}
					break;
				case ActionType.BOMB:
					ball.x = _param1;
					ball.y = _param2;
					ball.bomb();
					break;
				case ActionType.START_MOVE:
					var info:Living = game.findLiving(_param1);
					if(info is Player)
					{
						(info as Player).playerMoveTo(1,new Point(_param2,_param3),info.direction,_param4 != 0);
					}else if(info != null)
					{
						info.fallTo(new Point(_param2,_param3),Player.FALL_SPEED);
					}
					break;
				case ActionType.FLY_OUT:
					ball.die();
					break;
				case ActionType.KILL_PLAYER:
					var player:Living = game.findLiving(_param1);
					if(player)
					{
						player.updateBload(_param4,_param3,0-_param2);
						player.isHidden = false;
						player.isFrozen = false;
					}
					break;
				case ActionType.TRANSLATE:
					ball.owner.transmit(new Point(_param1,_param2));
					break;
				case ActionType.FORZEN:
					var player1:Living = game.findLiving(_param1);
					if(player1)
					{
						player1.isFrozen = true;
						player1.isHidden = false;
					}
					break;
				case ActionType.CHANGE_SPEED:
					ball.setSpeedXY(new Point(_param1,_param2));
					ball.clearWG();
					break;	
				case ActionType.UNFORZEN:
					var player3:Living = game.findLiving(_param1);
					if(player3)
					{
						player3.isFrozen = false;
					}
					break;
				case ActionType.DANER:
					var player2:Player = game.findPlayer(_param1);
					if(player2)
					{
						player2.dander = _param2;
					}
					break;
				case ActionType.CURE:
					var player4:Living = game.findLiving(_param1);
					if(player4)
					{
						player4.showAttackEffect(2);
						player4.updateBload(_param2,0,_param3);
					}
					break;
				case ActionType.GEM_DEFENSE_CHANGED:
				    var player5 : Player = game.findPlayer(_param1);
				    if(player5)
				    {
				    	player5.gemDefense = true;
				    }
				    break;
			    case ActionType.CHANGE_STATE:
			    	var living:Living = game.findLiving(_param1);
			    	if(living)
			    	{
			    		living.State = _param2;
			    	}
			    	break;
			    case ActionType.DO_ACTION:
			    	var living1:Living = game.findLiving(_param1);
			    	if(living1)
			    	{
			    		living1.playMovie(ActionType.ACTION_TYPES[_param4]);
			    	}
			    	break;
			}
		}
		

	}
}