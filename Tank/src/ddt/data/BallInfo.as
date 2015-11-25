package ddt.data
{
	import flash.geom.Point;
	
	/**
	 *  
	 * @author SYC
	 * 弹头信息
	 */	
	public class BallInfo
	{
		public var ID:int = 2;
		
		public var Name:String;
		/**
		 * 质量 
		 */		
		public var Mass:Number = 1;
		
		public var FlyingPartical:Array = [];
		
		public var BombPartical:Array = [];
		
		public var Power:Number;
		
		public var Radii:Number;
		
		public var SpinV:Number = 1000;
		
		public var SpinVA:Number = 1;
		
		public var Amount:Number = 1;
		
		public var Wind:int;
		public var Weight:int;
		public var DragIndex:int;
		 
		/**
		 * 上否振动 
		 */		
		public var Shake:Boolean;
		
		/**
		 * 发射声音id 
		 */		
		public var ShootSound:String;
		
		/**
		 * 爆炸声音 
		 */		
		public var BombSound:String;
		
		public var ActionType:int;
		
		
		/**
		 * 传送弹角度 
		 * @return 
		 * 
		 */		
		public function getCarrayBall():Point
		{
			return new Point(0,90);
		}		
	}
}