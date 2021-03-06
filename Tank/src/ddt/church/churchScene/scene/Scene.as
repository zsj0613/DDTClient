package ddt.church.churchScene.scene
{
	import ddt.church.churchScene.path.IHitTester;
	import ddt.church.churchScene.path.IPathSearcher;
	import ddt.church.churchScene.path.RoboSearcher;
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;


	public class Scene extends EventDispatcher
	{
		private var _info :SceneMapInfo;
		
		private var _hitTester:IHitTester;
		private var _pathSearcher:IPathSearcher;
		
		private var _x:Number;
		private var _y:Number;
		
		public function Scene()
		{
			this._pathSearcher = new RoboSearcher(18,1000,8);
			this._x = 0;
			this._y = 0;
		}
		
		public function get HitTester():IHitTester
		{
			return  _hitTester;
		}
		
		public function set info(value:SceneMapInfo):void
		{
			this._info = value;
		}
		
		
		public function get info():SceneMapInfo
		{
			return this._info;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}

		public function set position(value:Point):void
		{
			if(value.x != _x || value.y != _y)
			{
				this._x = value.x;
				this._y = value.y;
//				this.dispatchEvent(new SceneEvent(SceneEvent.POSITION_CHANGED,value));
			}
		}
		
		public function get position():Point
		{
			return new Point(_x,_y);
		}
		
		public function setPathSearcher(path:IPathSearcher):void
		{
			_pathSearcher = path;
		}
		
		public function setHitTester(tester:IHitTester):void
		{
			_hitTester = tester;
		}
		
		public function hit(local:Point):Boolean
		{
			return _hitTester.isHit(local);
		}
		
		public function searchPath(from:Point,to:Point):Array
		{
			return _pathSearcher.search(from,to,_hitTester);
		}
		
		public function localToGlobal(point:Point):Point
		{
			return new Point(point.x + _x,point.y + _y);
		}
		
		public function globalToLocal(point:Point):Point
		{
			return new Point(point.x - _x,point.y - _y);
		}
		
		public function dispose():void
		{
			//
			_info = null;
			_hitTester = null;
			_pathSearcher = null;
		}
	}
}
