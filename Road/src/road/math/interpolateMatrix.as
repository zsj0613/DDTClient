package road.math
{
	import flash.geom.Matrix;
	public function interpolateMatrix(p1:Number,m1:Matrix,p2:Number,m2:Matrix,p:Number):Matrix
	{
		var result:Matrix = new Matrix();
		result.a = interpolateNumber(p1,m1.a,p2,m2.a,p);
		result.b = interpolateNumber(p1,m1.b,p2,m2.b,p);
		result.c = interpolateNumber(p1,m1.c,p2,m2.c,p);
		result.d = interpolateNumber(p1,m1.d,p2,m2.d,p);
		result.tx = interpolateNumber(p1,m1.tx,p2,m2.tx,p);
		result.ty = interpolateNumber(p1,m1.ty,p2,m2.ty,p);
		return result;
	}
}