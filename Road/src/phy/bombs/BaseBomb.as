package phy.bombs
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import phy.object.PhysicalObj;
	
	public class BaseBomb extends PhysicalObj
	{
		protected var _movie:Sprite;
		
		private var _shape:Sprite;
		
		private var _border:Sprite;
    	
		public function BaseBomb(id:int,movie:Sprite,shape:Sprite,border:Sprite,mass:Number = 10,gfactor:Number = 100,windFactor:Number = 1,airResitFactor:Number = 1)
		{
			super(id,1,mass,gfactor,windFactor,airResitFactor);
			_testRect = new Rectangle(-3,-3,6,6);
			_movie = movie;
			if(_movie)
			{
				_movie.x = 0;
				_movie.y = 0;
				addChild(_movie);
			}
			
			_shape = shape;
			if(shape)
			{
				//爆炸的形状放在地图上，方便获取爆炸的区域
				_shape.x = 0;
				_shape.y = 0;
				_shape.visible = false;
				addChild(_shape);
			}
			
			_border = border;
		}	

		
		override public function update(dt:Number):void
		{
			super.update(dt);
		}
		public function get bombRectang():Rectangle
		{
			if(_map && _shape)
			{
				return _shape.getRect(_map);
			}
			else
			{
				return new Rectangle(x -200,y- 200,400,400);
			}
		}
		
		override protected function collideGround():void
		{
			this.bomb();
		}
		
		public function bomb():void
		{
			DigMap();
			this.die();
		}
		
		protected function DigMap():void
		{
			if(_shape && _shape.width > 0 && _shape.height > 0)
			{
				_map.Dig(pos,_shape,_border);
			}
		}
		
		override public function die():void
		{
			super.die();
			if(_map)
			{
				_map.removePhysical(this);
			}
		}
	}
}