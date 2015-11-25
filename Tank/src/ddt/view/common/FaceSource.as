package ddt.view.common
{
	import flash.display.MovieClip;
	
	import road.utils.ClassUtils;
	
	public class FaceSource
	{
//		private static var _bounds:Dictionary;
//		private static var _names:Array = ["大笑","赞同","坏笑","轻松","灵感","自信","郁闷","生气","瀑布汗","困了","琢磨","流泪","叹号","无语","疑问","愤怒","汗","惊愕","感谢","道歉","正确","错误","亲吻","爱","求救","剪刀","石头","布"];
		
		private static function setBounds():void
		{
//			_bounds = new Dictionary();
//			_bounds[1] = new Point(27,24);
//			_bounds[2] = new Point(28,26);
//			_bounds[3] = new Point(28,27);
//			_bounds[4] = new Point(39,26);
//			_bounds[5] = new Point(28,29);
//			_bounds[6] = new Point(27,25);
//			_bounds[7] = new Point(17,18);
//			_bounds[8] = new Point(45,35);
//			_bounds[9] = new Point(54,49);
//			_bounds[10] = new Point(29,26);
//			_bounds[11] = new Point(28,24);
//			_bounds[12] = new Point(27,43);
//			_bounds[13] = new Point(27,33);
//			_bounds[14] = new Point(27,24);
//			_bounds[15] = new Point(27,28);
//			_bounds[16] = new Point(27,24);
//			_bounds[17] = new Point(27,33);
//			_bounds[18] = new Point(34,72);
//			_bounds[19] = new Point(43,43);
//			_bounds[20] = new Point(32,50);
//			_bounds[21] = new Point(18,39);
//			_bounds[22] = new Point(18,42);
//			_bounds[23] = new Point(35,44);
//			_bounds[24] = new Point(27,24);
//			_bounds[25] = new Point(69,49);
//			_bounds[26] = new Point(27,26);
//			_bounds[27] = new Point(27,24);
//			_bounds[28] = new Point(27,29);
		}
				
		public static function getFaceById(id:int):MovieClip
		{
//			if(id < 29 && id > 0)
//				return ModelManager.create("Expression" + id) as MovieClip;		
//			else return null;	
			if(id < 49 && id > 0)
				return ClassUtils.CreatInstance("road.expression.Expresion0" + (id < 10 ? "0" + String(id) : String(id))) as MovieClip;
			else return null;	
		}
		
		public static function getSFaceById(id:int):MovieClip
		{
			if(id < 49 && id > 0)
				return ClassUtils.CreatInstance("sFace_0" + (id < 10 ? "0" + String(id) : String(id))) as MovieClip;
			else return null;
		}
		
//		public static function getBoundById(id:int):Point
//		{
//			if(_bounds == null)
//				setBounds();
//			if(id < 29 && id > 0)
//				return _bounds[id];
//			return new Point();	
//		}
//		
//		public static function getNameById(id:int):String
//		{
//			return _names[id - 1];
//		}
		
		public static function stringIsFace(str:String):int
		{
			if((str.length != 3 && str.length != 2) || str.slice(0,1) != "/")return -1;
			var n:Number = Number(str.slice(1));
			if(n < 49 && n > 0)return n;
			return -1;
		}
	}
}