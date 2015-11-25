package phy.maps
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import par.enginees.ParticleEnginee;
	import par.renderer.DisplayObjectRenderer;
	
	import phy.object.PhysicalObj;
	import phy.object.Physics;
	
	public class Map extends Sprite
	{
		public var wind:Number = 3;
		
		public var gravity:Number = 9.8;
		
		public var airResistance:Number = 2;
	
		private var _phyicals:Dictionary;
		
		private var _objects:Dictionary;
		
		protected var _ground:Ground;
		
		protected var _stone:Ground;
		
		protected var _sky:DisplayObject;
		
		private var _bound:Rectangle;
		
		private var _partical:ParticleEnginee;
		
		private var _blood:Sprite;
		
		private var _bombLayer:Sprite;
		
		private var _layer:Sprite;
		
		private var _mapThing : Sprite;
		
		public function Map(sky:DisplayObject,ground:Ground = null,stone:Ground = null)
		{
			_layer = new Sprite();
			addChild(_layer);
			
			_objects = new Dictionary();
			_phyicals = new Dictionary();
			
			_sky = sky;
			_layer.addChild(_sky);
			
			_stone = stone;
			if(_stone) _layer.addChild(_stone);
			
			_ground = ground;
			if(_ground) _layer.addChild(_ground);
			
			_mapThing = new Sprite();
			_layer.addChild(_mapThing);
			
			var rd:DisplayObjectRenderer = new DisplayObjectRenderer();
			_layer.addChild(rd);
			_partical = new ParticleEnginee(rd);
			
			if(_ground)
			{
				_bound = new Rectangle(0,0,_ground.width,_ground.height);
			}
			else
			{
				_bound = new Rectangle(0,0,_stone.width,_stone.height);
			}
			
			_bombLayer = new Sprite();
			addChild(_bombLayer);
			
			_blood = new Sprite();
			addChild(_blood);
			
			addEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		public function get bound():Rectangle
		{
			return _bound;
		}
		
		public function get sky():DisplayObject
		{
			return _sky;
		}
		
		public function get ground():Ground
		{
			return _ground;
		}
		
		public function get stone():Ground
		{
			return _stone;
		}
		
		public function get particleEnginee():ParticleEnginee
		{
			return _partical;
		}
		
		protected var _mapChanged:Boolean = false;
		public function Dig(center:Point, surface:Sprite, border:Sprite=null):void
		{
			_mapChanged = true;
			if(_ground) 
				_ground.Dig(center,surface,border);
			if(_stone)
				_stone.Dig(center,surface,border);
		}
		
		public function get mapChanged():Boolean
		{
			return _mapChanged;
		}
		
		public function resetMapChanged():void
		{
			_mapChanged = false;
		}
		
		public function IsEmpty(x:int,y:int):Boolean
		{
			return (_ground == null || _ground.IsEmpty(x,y)) && (_stone == null || _stone.IsEmpty(x,y)) ;
		}
		
		public function IsRectangleEmpty(rect:Rectangle):Boolean
		{
			return (_ground == null || _ground.IsRectangeEmptyQuick(rect)) && (_stone == null || _stone.IsRectangeEmptyQuick(rect));
		}
		
		public function findYLineNotEmptyPointDown(x:int,y:int,h:int):Point
		{
			x = x < 0 ? 0 : (x >= _bound.width) ? _bound.width -1 : x;
			y = y < 0 ? 0 : y;
			h = y + h >= _bound.height ? _bound.height - y -1 : h;
			for(var i:int =0; i < h; i++)
			{
				if(!IsEmpty(x -1,y) || !IsEmpty(x + 1,y))
				{
					return new Point(x,y);
				}
				y ++;
			}
			return null;
		}
		
		public function findYLineNotEmptyPointUp(x:int,y:int,h:int):Point
		{
			x = x < 0? 0 : (x > _bound.width) ? _bound.width : x;
			y = y < 0 ? 0 : y;
			h = y + h > _bound.height ? _bound.height - y : h;
			for(var i:int =0; i < h; i++)
			{
				if(!IsEmpty(x -1,y) || !IsEmpty(x + 1,y))
					return new Point(x,y);
				y --;
			}
			return null;
		}
		
		public function findNextWalkPoint(posX:int,posY:int,direction:int,stepX:int,stepY:int):Point
		{
			if(direction != 1 && direction != -1) return null;
			var tx:int = posX + direction * stepX;
			if(tx < 0 || tx > _bound.width) return null;
			var p:Point = findYLineNotEmptyPointDown(tx,posY-stepY-1,_bound.height);
			if(p)
			{
				if(Math.abs(p.y - posY) > stepY)
					p = null;
			}
			return p;
		}
		
		public function canMove(x:int,y:int):Boolean
		{
			return IsEmpty(x,y) && !IsOutMap(x,y) 
		}
		
		public function IsOutMap(x:int,y:int):Boolean
		{
			if(x < _bound.x || x > _bound.width || y > _bound.height)
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		public function addBomb(sprite:Sprite):void
		{
			_bombLayer.addChild(sprite);
		}
		
		public function addPhysical(phy:Physics):void
		{
			if(phy is PhysicalObj)
			{
				_objects[phy] = phy;
				if(PhysicalObj(phy).layerType == 0 )
					_mapThing.addChild(phy);
				else
					_layer.addChild(phy);
			}
			else
			{
				_phyicals[phy] = phy;
				_layer.addChild(phy);
			}
			phy.setMap(this);
		}
		
		public function addMapThing(phy : Physics) : void
		{
			_mapThing.addChild(phy);
			phy.setMap(this);
			if(phy is PhysicalObj)
			{
				_objects[phy] = phy;
			}
			else
			{
				_phyicals[phy] = phy;
			}
		}
		
		public function removeMapThing(phy:Physics):void
		{
			_mapThing.removeChild(phy);
			phy.setMap(null);
			if(phy is PhysicalObj)
			{
				delete _objects[phy];
			}
			else
			{
				delete _phyicals[phy];
			}
		}
		public function setTopPhysical(phy:Physics):void
		{
			_layer.setChildIndex(phy,_layer.numChildren - 1);
		}
		
		public function hasSomethingMoving():Boolean
		{
			for each(var p:PhysicalObj in _objects)
			{
				if(p.isMoving())
				{
					return true;
				}
			}
			return false;
		}
		
		public function removePhysical(phy:Physics):void
		{
			phy.parent.removeChild(phy);
			phy.setMap(null);
			if(phy is PhysicalObj)
			{
				delete _objects[phy];
			}
			else
			{
				delete _phyicals[phy];
			}
		}
		
		public function hidePhysical(except:PhysicalObj):void
		{
			for each(var p:PhysicalObj in _objects)
			{
				if( p != except)
				{
					p.visible = false;
				}
			}
		}
		
		public function showPhysical():void
		{
			for each(var p:PhysicalObj in _objects)
			{
				p.visible = true;
			}
		}
		
		public function getPhysicalObjects(rect:Rectangle,except:PhysicalObj):Array
		{
			var temp:Array = new Array();
			for each(var phy:PhysicalObj in _objects)
			{
				if(phy != except && phy.isLiving && phy.canCollided)
				{
					var t:Rectangle = phy.getCollideRect();
					t.offset(phy.x,phy.y);
					if(t.intersects(rect))
					{
						temp.push(phy);
					}
				}
			}
			return temp;
		}
		
		public function getPhysicalObjectByPoint(point:Point,radius:Number,except:PhysicalObj = null):Array
		{
			var temp:Array = new Array();
			for each(var t:PhysicalObj in _objects)
			{
				if(t != except && t.isLiving && Point.distance(point,t.pos) <= radius)
				{
					temp.push(t);
				}
			}
			return temp;
		}
		
//		public function getLivingPlayersByPoint(point:Point,radius:Number):Array
//		{
//			var temp:Array = new Array();
//			for each(var t:PhysicalObj in _objects)
//			{
//				if(t.isPlayer() && t.isLiving && Point.distance(point,t.pos) <= radius)
//				{
//					temp.push(t);
//				}
//			}
//			return temp;
//		}
		
//		public function getBoxByPoint(point:Point,radius:Number):Array
//		{
//			var temp:Array = new Array();
//			for each(var t:PhysicalObj in _objects)
//			{
//				if(t.isBox() && t.isLiving && Point.distance(point,t.pos) <= radius)
//				{
//					temp.push(t);
//				}
//			}
//			return temp;
//		}
		
		public function getBoxesByRect(rect:Rectangle):Array
		{
			var temp:Array = new Array();
			for each(var obj:PhysicalObj in _objects)
			{
				if(obj.isBox() && obj.isLiving )
				{
					var t:Rectangle = obj.getTestRect();
					t.offset(obj.x,obj.y);
					if(t.intersects(rect))
					{
						temp.push(obj);
					}
				}
			}
			return temp;
		}
		
		public function addBlood(sprite:Sprite):void
		{
			_blood.addChild(sprite);
		}
		
		
		private function __enterFrame(event:Event):void
		{
			update();
		}
		
		protected function update():void
		{
			var num:Number = _layer.numChildren;
			for(var i:int = num -1; i >= 0; i --)
			{
				var obj:DisplayObject = _layer.getChildAt(i);
				if(obj is Physics)
				{
					Physics(obj).update(0.04);
				}
			}
			
			_partical.update();
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			var num:Number = _layer.numChildren;
			for(var i:int = num -1; i >= 0; i --)
			{
				var obj:DisplayObject = _layer.getChildAt(i);
				if(obj is Physics)
				{
					Physics(obj).dispose();
				}
			}
			_partical.dispose();
			if(_ground)
				_ground.dispose();
			if(_stone)
				_stone.dispose();
			if(_mapThing && _mapThing.parent)
			_mapThing.parent.removeChild(_mapThing);
			_objects = null;
			_phyicals = null;
		}

	}
}