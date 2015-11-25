package par.renderer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import par.particals.Particle;	

	public class BitmapRenderer extends Sprite implements IParticleRenderer
	{
		protected static var ZERO_POINT:Point = new Point( 0, 0 );
		
		protected var _bitmap:Bitmap;

		protected var _smoothing:Boolean;
		
		protected var _canvas:Rectangle;

		public function BitmapRenderer( canvas:Rectangle, smoothing:Boolean = false )
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			_smoothing = smoothing;
			_canvas = canvas;
			createBitmap();
		}
		
		/**
		 * Create the Bitmap and BitmapData objects
		 */
		protected function createBitmap():void
		{
			if( _bitmap && _bitmap.bitmapData )
			{
				_bitmap.bitmapData.dispose();
			}
			if( _bitmap )
			{
				removeChild( _bitmap );
			}
			_bitmap = new Bitmap( null, "auto", _smoothing);
			_bitmap.bitmapData = new BitmapData( _canvas.width, _canvas.height, true, 0 );
			addChild( _bitmap );
			_bitmap.x = _canvas.x;
			_bitmap.y = _canvas.y;
		}
		
		/**
		 * The canvas is the area within the renderer on which particles can be drawn.
		 * Particles outside this area will not be drawn.
		 */
		public function get canvas():Rectangle
		{
			return _canvas;
		}
		public function set canvas( value:Rectangle ):void
		{
			_canvas = value;
			createBitmap();
		}
		
		/**
		 * When the renderer is no longer required, this method must be called by the 
		 * user to free up memory used by the renderer. If you don't call this method
		 * then the renderer's bitmap data will remain in memory.
		 */
		public function dispose():void
		{
			if( _bitmap && _bitmap.bitmapData )
			{
				_bitmap.bitmapData.dispose();
			}
		}

		public function renderParticles( particles:Array ):void
		{
			_bitmap.bitmapData.fillRect( _bitmap.bitmapData.rect, 0 );
			_bitmap.bitmapData.lock();	
			for( var i:int = particles.length; i --;) 
			{
				drawParticle( particles[i] );
			}
			_bitmap.bitmapData.unlock();
		}
		
		/**
		 * Used internally here and in derived classes to alter the manner of 
		 * the particle rendering.
		 * 
		 * @param particle The particle to draw on the bitmap.
		 */
		protected function drawParticle( particle:Particle ):void
		{
			var matrix:Matrix = particle.matrixTransform;
			matrix.translate( -_canvas.x, -_canvas.y );
			_bitmap.bitmapData.draw( particle.image, matrix, particle.colorTransform, particle.image.blendMode, null, false );
		}
		
		/**
		 * @inheritDoc
		 */
		public function addParticle( particle:Particle ):void
		{
			// do nothing
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeParticle( particle:Particle ):void
		{
			// do nothing
		}
		
		public function reset():void
		{
		}
	}
}