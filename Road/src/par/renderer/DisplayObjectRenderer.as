package par.renderer
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import par.particals.Particle;	

	public class DisplayObjectRenderer extends Sprite implements IParticleRenderer
	{
		private var layers:Dictionary;
		
		public function DisplayObjectRenderer()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			layers = new Dictionary();
		}
		
		/**
		 * @inheritDoc
		 */
		public function renderParticles( particles:Array ):void
		{
			for each(var p:Particle in particles)
			{
				p.image.transform.colorTransform = p.colorTransform;
				p.image.transform.matrix = p.matrixTransform;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addParticle( particle:Particle ):void
		{
			var ly:Sprite = layers[particle.info];
			if( ly == null)
			{
				layers[particle.info] = ly = new Sprite();
				ly.blendMode = BlendMode.LAYER;
				addChild(ly);
			}
			if(particle.info.keepOldFirst)
			{
				ly.addChild(particle.image);
			}
			else
			{
				ly.addChildAt(particle.image,0 );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeParticle( particle:Particle ):void
		{
			var ly:Sprite = layers[particle.info];
			if(ly)
			{
				ly.removeChild( particle.image );
			}
		}
		
		public function reset():void
		{
			layers = new Dictionary();
			var len:Number = numChildren;
			for(var i:int = 0; i < len; i++)
			{
				this.removeChildAt(0);
			}
		}
		
		public function dispose():void
		{
		}
	}
}