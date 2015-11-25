package ddt.game.other
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import phy.math.EulerVector;
	
	import ddt.data.BallInfo;
	import ddt.data.game.LocalPlayer;
	import ddt.game.map.MapView;
	import ddt.game.objects.GameLocalPlayer;
	import ddt.manager.BallManager;
	import ddt.socket.GameInSocketOut;
	
	public class CalcBallPathCreator
	{
		private var _vx:EulerVector;
		private var _vy:EulerVector;
		
		private var _dt:Number = 0.04;//变加速时间间隔
		
		private var _containts:Sprite;
		private var _local:LocalPlayer;
		private var _gamelocal:GameLocalPlayer;
		private var _map:MapView;
		
		private var _force:Number;
		
		public function get ForceValue():Number
		{
			return _force;
		}
		
		public function CalcBallPathCreator()
		{
			_vx = new EulerVector(0,0,0);
			_vy = new EulerVector(0,0,0);
		}
		
		public function setup(containts:Sprite, local:LocalPlayer, gamelocal:GameLocalPlayer, map:MapView):void
		{
			_containts = containts;
			_local = local;
			_gamelocal = gamelocal;
			_map = map;
		}
		
		public function shootBomb():void
		{
			var shootBeginPoint:Point = _gamelocal.shootPoint();
			var angle:Number = _local.calcBombAngle();
			var force:Number = _force;
			GameInSocketOut.sendGameCMDShoot(shootBeginPoint.x,shootBeginPoint.y,force,angle);
		}
		
		public function setForceAndDrawPath(val:Number):void
		{
			_force = val;
			if(_force > 0)
				drawPath();
		}
		
		private function drawPath():void
		{
			var shootBeginPoint:Point = _gamelocal.shootPoint();
			var angle:Number = _local.calcBombAngle();
			var force:Number = _force;
			
			_containts.graphics.clear();
			_map.smallMap.clearBallPath();
			
			_map.smallMap.setPathStyle(2,0xFF0000);
			_containts.graphics.lineStyle(2,0xFF0000);
			draw(shootBeginPoint,angle,force);
			
			var tmpAngle1:Number = angle + 5;
			var tmpForce1:Number = force * 1.1;
			_map.smallMap.setPathStyle(2,0xCCCCCC);
			_containts.graphics.lineStyle(2,0xCCCCCC);
			draw(shootBeginPoint,tmpAngle1,tmpForce1);
			
			var tmpAngle:Number = angle - 5;
			var tmpForce2:Number = force * 0.9;
			_map.smallMap.setPathStyle(2,0x336699);
			_containts.graphics.lineStyle(2,0x336699);
			draw(shootBeginPoint,tmpAngle,tmpForce2);
		}
		
		private function draw(shootBeginPoint:Point,angle:Number,force:Number):void
		{
			var ballID:int = _gamelocal.player.currentBomb;
			
			var ball:BallInfo = BallManager.findBall(ballID);
			
			var vx:Number = force * Math.cos((angle / 180 * Math.PI));
			var vy:Number = force * Math.sin((angle / 180 * Math.PI));
			
			var _mass:Number = ball.Mass;
			var _arf:Number = _map.airResistance * ball.DragIndex;
			var _wf:Number = _map.wind * ball.Wind;
			var _gf:Number = _map.gravity * ball.Weight * _mass;
			
			_vx.x0 = shootBeginPoint.x;//x0为位置
			_vy.x0 = shootBeginPoint.y;
			
			_containts.graphics.moveTo(_vx.x0,_vy.x0);
			_map.smallMap.resetPathPos(_vx.x0,_vy.x0);
			
			_vx.x1 = vx;//x1为速度
			_vy.x1 = vy;
			
			while(_vx.x0 < (_map.sky.width * 2) && _vy.x0 < (_map.sky.height * 2))
			{
				_vx.ComputeOneEulerStep(_mass,_arf,_wf,_dt);
				_vy.ComputeOneEulerStep(_mass,_arf,_gf,_dt);
				_containts.graphics.lineTo(_vx.x0,_vy.x0);
				_map.smallMap.updateBallPath(_vx.x0,_vy.x0);
			}
		}
		
		public function dispose():void
		{
			_containts = null;
			_local = null;
			_gamelocal = null;
			_map = null;
			_vx = null;
			_vy = null;
		}
	}
}