package phy.object
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import road.utils.MathUtils;
	
	public class PhysicalObj extends Physics
	{
		protected var _id:int;
		
	 	protected var _testRect:Rectangle;
	 	
		protected var _canCollided:Boolean;
		
		protected var _isLiving:Boolean;
		
	 	protected var _layerType:int;
	 	public function PhysicalObj(id:int,layerType:int = 1,mass:Number = 1,gravityFactor:Number = 1,windFactor:Number = 1,airResitFactor:Number = 1)
	 	{
	 		super(mass,gravityFactor,windFactor,airResitFactor);
	 		_id = id;
	 		_layerType = layerType;
	 		_canCollided = false;
	 		_testRect = new Rectangle(-5,-5,10,10); 
	 		_isLiving = true;
	 	}
	 	
	 	public function get Id():int
	 	{
	 		return _id;
	 	}
	 	
	 	public function get layerType():int
	 	{
	 		return _layerType;
	 	}

	 	public function setCollideRect(left:int,top:int,right:int,buttom:int):void
	 	{
	 		_testRect.top = top;
	 		_testRect.left = left;
	 		_testRect.right = right;
	 		_testRect.bottom = buttom;
	 	}
	 	
	 	public function getCollideRect():Rectangle
	 	{
	 		return _testRect.clone();
	 	}
	 	
	 	public function get canCollided():Boolean
	 	{
	 		return _canCollided;
	 	}
	 	
	 	public function set canCollided(value:Boolean):void
	 	{
	 		_canCollided = value;
	 	}
	 	
	 	public function get smallView():Sprite
	 	{
	 		return null;
	 	}
	 	
	 	public function get isLiving():Boolean
	 	{
	 		return _isLiving;
	 	}

	 	override public function moveTo(p:Point):void
	 	{
	 		if(Point.distance(p,pos) >= 3)
	 		{
		 		var dx:Number = Math.abs(int(p.x) - int(x));
		 		var dy:Number = Math.abs(int(p.y) - int(y));
		 		var count:int = dx > dy ? dx : dy;
		 		var dt:Number = 1 / Number(count);
		 		var cur:Point = pos;
		 		var dest:Point;
		 		for(var t:int = Math.abs(count); t > 0; t -= 3)
		 		{
		 			dest = Point.interpolate(cur,p,dt*t);
		 			//trace("move to>>>>>:",dest);
		 			
		 			var rect:Rectangle = getCollideRect();
		 			rect.offset(dest.x,dest.y);
		 			var list:Array = _map.getPhysicalObjects(rect,this);
		 			if(list.length > 0)
		 			{
		 				pos = dest;
		 				collideObject(list);
		 			}
		 			else if( !_map.IsRectangleEmpty(rect))
		 			{
		 				pos = dest;
		 				collideGround();
		 			}
		 			else if(_map.IsOutMap(dest.x,dest.y))
		 			{
		 				pos = dest;
		 				flyOutMap();
		 			}
		 			if(!_isMoving)
		 			{
		 				return;
		 			}
		 		}
		 		pos = p;
	 		}
	 	}
	 	
		/**
		 * 计算物体的角度,取前后间隔为2像素的8个点，计算其平均角度。 
		 * @return 
		 * 
		 */	 	     
		public function calcObjectAngle(bounds:Number = 16):Number
		{
			if(_map)
			{
				var pre_array:Array = new Array();
				var next_array:Array = new Array();
				var pre:Point = new Point();
				var next:Point = new Point();
				var bound:Number = bounds;
				for(var m:Number = 1;m <= bound;m += 2)
				{
					//由下往上查找空的点
					for(var i:int = -10 ; i <= 10; i ++)
					{
						if(_map.IsEmpty(x+m,y-i))
						{
							if(i == -10)break;
							pre_array.push(new Point(x+m,y-i));
							break;
						}
					}
					for(var j:int = -10 ;  j<= 10; j ++)
					{
						if(_map.IsEmpty(x - m,y - j))
						{
							if(j == -10)break;
							next_array.push(new Point(x-m,y-j));
							break;
						}
					}
				}
				pre = new Point(x,y);	
				next = new Point(x,y);	
				for(var n:Number = 0;n < pre_array.length; n ++)
				{
					pre = pre.add(pre_array[n]);
				}
				for(var nn:Number = 0;nn < next_array.length; nn ++)
				{
					next = next.add(next_array[nn]);
				}
				pre.x = pre.x / (pre_array.length +1);
				pre.y = pre.y / (pre_array.length +1);
	
				next.x = next.x / (next_array.length+1);
				next.y = next.y / (next_array.length+1);
				return  MathUtils.GetAngleTwoPoint(pre,next);
			}
			else
			{
				return 0;
			}
		}
		
		public function calcObjectAngleDebug(bounds:Number = 16):Number
		{
			if(_map)
			{
				var pre_array:Array = new Array();
				var next_array:Array = new Array();
				var pre:Point = new Point();
				var next:Point = new Point();
				var bound:Number = bounds;
				for(var m:Number = 1;m <= bound;m += 2)
				{
					//由下往上查找空的点
					for(var i:int = -10 ; i <= 10; i ++)
					{
						if(_map.IsEmpty(x+m,y-i))
						{
							if(i == -10)break;
							pre_array.push(new Point(x+m,y-i));
							break;
						}
					}
					for(var j:int = -10 ;  j<= 10; j ++)
					{
						if(_map.IsEmpty(x - m,y - j))
						{
							if(j == -10)break;
							next_array.push(new Point(x-m,y-j));
							break;
						}
					}
				}
				pre = new Point(x,y);	
				next = new Point(x,y);	
				for(var n:Number = 0;n < pre_array.length; n ++)
				{
					pre = pre.add(pre_array[n]);
				}
				drawPoint(pre_array,true);
				for(var nn:Number = 0;nn < next_array.length; nn ++)
				{
					next = next.add(next_array[nn]);
				}
				drawPoint(next_array,false);
				
				pre.x = pre.x / (pre_array.length +1);
				pre.y = pre.y / (pre_array.length +1);
	
				next.x = next.x / (next_array.length+1);
				next.y = next.y / (next_array.length+1);
				return  MathUtils.GetAngleTwoPoint(pre,next);
			}
			else
			{
				return 0;
			}
		}
		
		private var _drawPointContainer:Sprite;
		private function drawPoint(data:Array,clear:Boolean):void
		{
			if(_drawPointContainer == null)_drawPointContainer = new Sprite();
			if(clear)_drawPointContainer.graphics.clear();
			for(var i:int = 0;i<data.length;i++)
			{
				_drawPointContainer.graphics.beginFill(0xFF0000);
				_drawPointContainer.graphics.drawCircle(data[i].x,data[i].y,2);
				_drawPointContainer.graphics.endFill();
			}
			_map.addChild(_drawPointContainer);
		}
	 	
	 	protected function flyOutMap():void
	 	{
	 		if(_isLiving)
	 		{
	 			die();
	 		}
	 	}
	 	
	 	protected function collideObject(list:Array):void
	 	{
	 		for each(var obj:PhysicalObj in list)
	 		{
	 			obj.collidedByObject(this);
	 		}
	 	}

	 	protected function collideGround():void
	 	{
	 		if(_isMoving)
	 		{
	 			stopMoving();
	 		}
	 	}
	 	
	 	public function collidedByObject(obj:PhysicalObj):void {}
	 	
	 	public function die():void
	 	{
	 		_isLiving = false;
	 		if(_isMoving)
	 		{
	 			stopMoving();
	 		}
	 	}
	 	
	 	public function getTestRect():Rectangle
	 	{
	 		return _testRect.clone();
	 	}
	 	
	 	public function isBox():Boolean
	 	{
	 		return false;
	 	}
	 	
	}
}