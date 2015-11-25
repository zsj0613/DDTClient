package phy.math
{
	public class EulerVector
	{
		public var x0:Number;
		
		public var x1:Number;
		
		public var x2:Number;
		
		public function EulerVector(x0:Number,x1:Number,x2:Number)
		{
			this.x0 = x0;
			this.x1 = x1;
			this.x2 = x2;
		}
		
		public function clear():void
		{
			x0 = 0;
			x1 = 0;
			x2 = 0;
		}
		
		public function clearMotion():void
		{
			x1 = 0;
			x2 = 0;
		}
		
		/**
		 *  Solve a.x'' + b.x' + c.x = d equation using Euler method.
		 */
 		public function ComputeOneEulerStep(m:Number,af:Number,f:Number,dt:Number):void
 		{
		  x2 = (f - af * x1) / m;
		  x1 = x1 + x2 * dt;
		  x0 = x0 + x1 * dt;
		}
		
		public function toString():String
		{
			return "x:"+x0+",v:"+x1+",a"+x2;
		}
	}
}