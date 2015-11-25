package phy.object
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import phy.maps.Map;
	import phy.math.EulerVector;

	public class Physics extends Sprite
	{
		protected var _mass:Number; 
  		
  		protected var _gravityFactor:Number; //重力因素 g = 
  		
  		protected var _windFactor:Number;
  		
  		protected var _airResitFactor:Number;
		
		protected var _vx:EulerVector;  //x方向 x0 位置 x1 速度 x2 加速度
		
		protected var _vy:EulerVector; //y方向
		
		protected var _ef:Point; //外表的持久力
		
		protected var _isMoving:Boolean;
		
		protected var _map:Map;
		
		public function Physics(mass:Number = 1,gravityFactor:Number = 1,windFactor:Number = 1,airResitFactor:Number = 1)
		{
			super();
			
			_mass = mass;
			_gravityFactor = gravityFactor;
			_windFactor = windFactor;
			_airResitFactor = airResitFactor;
			
			_vx = new EulerVector(0,0,0);
			_vy = new EulerVector(0,0,0);
			_ef = new Point(0,0);
		}
		
		public function addExternForce(force:Point):void
		{
			_ef.x += force.x;
			_ef.y += force.y;
			if(!_isMoving && _map)
				startMoving();
		}
		
		public function addSpeedXY(vector:Point):void
		{
			_vx.x1 += vector.x;
			_vy.x1 += vector.y;
			
			if(!_isMoving && _map)
				startMoving();
		}
		
		public function setSpeedXY(vector:Point):void
		{
			_vx.x1 = vector.x;
			_vy.x1 = vector.y;
			
			if(!_isMoving && _map)
				startMoving();
		}
		
		public function get Vx():Number
		{
			return _vx.x1;
		}
		
		public function get Vy():Number
		{
			return _vy.x2;
		}
		
		public function get motionAngle():Number
		{
			return Math.atan2(_vy.x1,_vx.x1);
		}
		
		public function isMoving():Boolean
		{
			return _isMoving;
		}
		
		public function startMoving():void
		{
			_isMoving = true;
		}
		
		public function stopMoving():void
		{
			_vx.clearMotion();
			_vy.clearMotion();
			_isMoving = false;
		}
		
		protected var _arf:Number = 0;
		protected var _gf:Number = 0;
		protected var _wf:Number = 0;
		public function setMap(map:Map):void
	 	{
	 		_map = map;
	 		if(_map)
	 		{
		 		_arf = _map.airResistance * _airResitFactor ;
		 		_gf  = _map.gravity * _gravityFactor * _mass;
		 		_wf =  _map.wind * _windFactor ;
	 		}
	 	}
		
		protected function computeFallNextXY(dt:Number):Point
		{
		  //trace("------------------------------------------------");
		  //trace(_vx,_vy);
		  _vx.ComputeOneEulerStep(_mass, _arf, _wf + _ef.x, dt);
		  _vy.ComputeOneEulerStep(_mass, _arf, _gf + _ef.y, dt);
		  //trace(_vx,_vy);
		  return new Point(_vx.x0,_vy.x0);		 
		}
		
		public function get pos():Point
		{
			return new Point(x,y);
		}
		
		public function set pos(value:Point):void
		{
			x = value.x;
			y = value.y;
		}
		
		public function update(dt:Number):void
		{
			if(_isMoving && _map)
			{
				updatePosition(dt);
			}
		}
		
		protected function updatePosition(dt:Number):void
		{
		    moveTo(computeFallNextXY(dt));    
		}
		
		public function moveTo(p:Point):void
		{
			if(p.x != x || p.y != y)
			{
				pos = p;
			}
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			_vx.x0 = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			_vy.x0 = value;
		}
		
		public function dispose():void
		{
			if(_map)
				_map.removePhysical(this);
		}
	}
}