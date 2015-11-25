package
{
	import flash.external.ExternalInterface; 
	public class global{ 
		
		
		public static function traceStr(str:String):void { 
			//trace(str);//在flash环境下输出调试信息; 
			if(ExternalInterface.available){ 
				ExternalInterface.call("trace", str);//在网页下输出调试信息; 
			} 
		} 
	} 
}
