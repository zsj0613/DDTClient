package flash.geom
{
	public final class GradientMatrix
	{
		public static function getGradientBox( width:Number, height:Number, rotation:Number, tx:Number, ty:Number ):Matrix
		{
			var m:Matrix = new Matrix();
			m.createGradientBox( 100, 100 );
			m.translate( -50, -50 );
			m.scale( width / 100, height / 100 );
			m.rotate( rotation );
			m.translate( tx, ty );
			return m;
		}
	}
}