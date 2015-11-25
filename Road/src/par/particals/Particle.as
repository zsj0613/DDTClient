package par.particals
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import par.lifeeasing.AbstractLifeEasing;
	import par.manager.ShapeManager;
	
	import road.math.randRange;
	
	public class Particle
	{	
		public var x:Number;
		
		public var y:Number;
		
		public var alpha:Number;
		
		public var color:Number;
		
		public var scale:Number;
		
		public var rotation:Number;
		
		public var life:Number;
		
		public var age:Number;
		
		public var size:Number;
		
		public var v:Number;
		
		public var angle:Number;
		
		public var gv:Number;
		
		public var motionV:Number;
		
		public var weight:Number;
		
		public var spin:Number;
		
		public var image:DisplayObject;
		
		public var info:ParticleInfo;
		
		public function Particle(info:ParticleInfo)
		{
			image = ShapeManager.create(info.displayCreator);
			this.info = info;
			initialize();
		}
		
		public function initialize():void
		{
			x = 0;
			y = 0;
			color = 0;
			scale = 1;
			rotation = 0;
			age = 0;
			life = 1;
			alpha = 1;
			v = 0;
			angle = 0;
			gv = 0;
			image.blendMode = info.blendMode;
		}
		
		public function update(time:Number):void
		{
			var ol:Number = age / life;
			var easing:AbstractLifeEasing = info.lifeEasing;
			
			v = easing.easingVelocity(v,ol);
			motionV = easing.easingRandomVelocity(motionV,ol);
			weight = easing.easingWeight(weight,ol);
			gv += weight;
			
			var pv:Point = Point.polar(v,angle);
			var rv:Point = Point.polar(motionV,randRange(0,2 * Math.PI));
			
			x += (pv.x + rv.x) * time;
			y += (pv.y + rv.y + gv) * time;

			scale = easing.easingSize(size,ol);
			rotation += easing.easingSpinVelocity(spin,ol) * time;
			color = easing.easingColor(color,ol);
			alpha = easing.easingApha(1,ol);
		}

		public function get matrixTransform():Matrix
		{
			var cos:Number = scale * Math.cos( rotation );
			var sin:Number = scale * Math.sin( rotation );
			return new Matrix( cos, sin, -sin, cos, x, y);
		}
		
		public function get colorTransform():ColorTransform
		{
			if(info.keepColor)
			{
				return new ColorTransform(1,1,1,alpha,
										 (( color >> 16 ) & 255),
			                           ((color >> 8 ) & 255),
			                           (color& 255),
			                           0);
			}
			else
			{
				return new ColorTransform(0,0,0,alpha,
									 (( color >> 16 ) & 255),
		                           ((color >> 8 ) & 255),
		                           (color& 255),
		                           0);
			
			}
		}
	}
}