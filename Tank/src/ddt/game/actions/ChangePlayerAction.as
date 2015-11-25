package ddt.game.actions
{
	import flash.geom.Point;
	
	import game.crazyTank.view.TurnAsset;
	
	import org.aswing.KeyboardManager;
	
	import road.comm.PackageIn;
	import road.display.MovieClipWrapper;
	import road.manager.SoundManager;
	
	import ddt.actions.BaseAction;
	import ddt.data.PathInfo;
	import ddt.data.game.Living;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.TurnedLiving;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.animations.AnimationLevel;
	import ddt.game.animations.BaseSetCenterAnimation;
	import ddt.game.map.MapView;
	import ddt.game.objects.SimpleBox;
	import ddt.manager.GameManager;
	import ddt.manager.MessageTipManager;
	
	public class ChangePlayerAction extends BaseAction
	{
		private var _map:MapView;
		private var _info:Living;
		private var _count:int;
		private var _changed:Boolean;
		private var _pkg:PackageIn;
		private var _event:CrazyTankSocketEvent;
		
		public function ChangePlayerAction(map:MapView,info:Living,event:CrazyTankSocketEvent,sysMap:PackageIn,waitTime:Number = 200)
		{
			_event = event;
			_event.executed = false;
			_pkg = sysMap;
			_map = map;
			_info = info;
			_count = waitTime / 40;
		}
		
		private function syncMap():void
		{
			if(_info is LocalPlayer)
			{
				_info.isFrozen = false;
				_info.gemDefense = false;
			}
			GameManager.Instance.Current.setWind(_pkg.readInt() / 10,_info.LivingID==GameManager.Instance.Current.selfGamePlayer.LivingID);
			_info.isHidden = _pkg.readBoolean();
			var count:int = _pkg.readInt();
			for(var i:uint = 0; i < count; i ++)
			{
				var bid:int = _pkg.readInt();
				var bx:int = _pkg.readInt();
				var by:int = _pkg.readInt();
				var box:SimpleBox = new SimpleBox(bid,String(PathInfo.GAME_BOXPIC));
				box.x = bx;
				box.y = by;
				_map.addPhysical(box);
				
				if(_pkg.readBoolean())
				{
					MessageTipManager.getInstance().show(_pkg.readUTF());
				}
			}
			var playerCount:int = _pkg.readInt();
			for(var j:int = 0; j < playerCount; j ++)
			{
				var livingID:int = _pkg.readInt();
				var isLiving:Boolean = _pkg.readBoolean();
				var tx:int = _pkg.readInt();
				var ty:int = _pkg.readInt();
				var blood:int = _pkg.readInt();
				var nonole : Boolean = _pkg.readBoolean();
				var maxEnergy:int = _pkg.readInt();
				var shootCount:int = _pkg.readInt();
				var player:Living = GameManager.Instance.Current.livings[livingID];
				if(player)
				{
					player.updateBload(blood,5);
					player.isNoNole = nonole;
					player.maxEnergy = maxEnergy;
					if(player.isSelf)
					{
						LocalPlayer(player).energy = player.maxEnergy;
						LocalPlayer(player).shootCount = shootCount;
					}
					if(!isLiving)
					{
						player.die();
					}
					else
					{
						player.pos = new Point(tx,ty);
					}
				}
			}
			
			_map.currentTurn = _pkg.readInt();
		}
		
		override public function execute():void
		{
			if(!_changed)
			{
				if(_map.hasSomethingMoving() == false && (_map.currentPlayer == null || _map.currentPlayer.actionCount == 0 ))
				{
					executeImp(false);
				}
			}
			else
			{
				_count --;
				if(_count <= 0)
				{
					changePlayer();
				}
			}
		}
		
		private function changePlayer():void
		{
			if(_info is TurnedLiving)
			{
				TurnedLiving(_info).isAttacking = true;
			}
			_map.gameView.updateControlBarState(_info);
			_isFinished = true;
		}
		
		override public function cancel():void
		{
			_event.executed = true;
		}
		
		private function executeImp(fastModel:Boolean):void
		{
			if(!_info.isExist)
			{
				_map.gameView.updateControlBarState(null);
				_isFinished = true;
				return;
			}
			if(!_changed)
			{
				_event.executed = true;
				_changed = true;
				if(_pkg)
				{
					syncMap();
				}
				
				for each(var p:Living in GameManager.Instance.Current.livings)
				{
					p.beginNewTurn();
				}
				
				_map.gameView.setCurrentPlayer(_info);
				_map.animateSet.addAnimation(new BaseSetCenterAnimation(_info.pos.x,_info.pos.y - 150,25,false,AnimationLevel.HIGHT));
				_info.isFrozen = false;
				_info.gemDefense = false;
				
				if(_info is LocalPlayer && !fastModel)
				{
					KeyboardManager.getInstance().reset();
					SoundManager.instance.play("016");
					var _turnMovie:MovieClipWrapper = new MovieClipWrapper(new TurnAsset(),true,true);
					_turnMovie.repeat = false;
					_turnMovie.x = 440;
					_turnMovie.y = 180;
					_map.gameView.addChild(_turnMovie);
				}
				else
				{
					SoundManager.instance.play("038");
					changePlayer();
				}
			}
		}
		
		override public function executeAtOnce():void
		{
			super.executeAtOnce();
			executeImp(true);
		}

	}
}