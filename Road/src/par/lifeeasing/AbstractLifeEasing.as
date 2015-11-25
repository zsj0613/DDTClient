package par.lifeeasing
{
	import road.math.ColorLine;
	import road.math.XLine;
	
	public class AbstractLifeEasing
	{
		public var vLine:XLine = new XLine();
		
		public var rvLine:XLine = new XLine();
		
		public var spLine:XLine = new XLine();
		
		public var sizeLine:XLine = new XLine();
		
		public var weightLine:XLine = new XLine();
		
		public var alphaLine:XLine = new XLine();
		
		public var colorLine:ColorLine;
			
		public function easingVelocity(orient:Number,energy:Number):Number
		{
			return orient * vLine.interpolate(energy);
		}
		public function easingRandomVelocity(orient:Number,energy:Number):Number
		{
			return orient * rvLine.interpolate(energy);;
		}
		public function easingSize(orient:Number,energy:Number):Number
		{
			return orient * sizeLine.interpolate(energy);
		}
		public function easingSpinVelocity(orient:Number,energy:Number):Number
		{
			return orient * spLine.interpolate(energy);
		}
		public function easingWeight(orient:Number,energy:Number):Number
		{
			return orient * weightLine.interpolate(energy);
		}
		public function easingColor(orient:uint,energy:Number):uint
		{
			if(colorLine)
			{
				return colorLine.interpolate(energy);
			}
			else
			{
				return orient;
			}
		}
        public function easingApha(orient:Number,energy:Number):Number
        {
			return orient * alphaLine.interpolate(energy);;
		}
		
//		public function easingVelocity(orient:Number,energy:Number):Number
//		{
//			return orient;
//		}
//		public function easingRandomVelocity(orient:Number,energy:Number):Number
//		{
//			return orient;
//		}
//		public function easingSize(orient:Number,energy:Number):Number
//		{
//			return orient;
//		}
//		public function easingSpinVelocity(orient:Number,energy:Number):Number
//		{
//			return orient;
//		}
//		public function easingWeight(orient:Number,energy:Number):Number
//		{
//			return orient;
//		}
//		public function easingColor(orient:uint,energy:Number):uint
//		{
//			return orient;
//		}
//        public function easingApha(orient:Number,energy:Number):Number
//        {
//			return orient;
//		}

		
	}
	
}