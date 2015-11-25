package ddt.manager
{
	import flash.utils.Dictionary;
	
	
	public class LanguageMgr
	{
		private static var _dic:Dictionary;
		private static var _reg:RegExp = new RegExp("\\{(\\d+)\\}");
		
		public static function setup(dic:Dictionary):void
		{
			_dic = dic ? dic :new Dictionary();			
		}
		
		public static function GetTranslation(translationId:String,...args):String
		{
			var input:String = _dic[translationId] ? _dic[translationId] : "";
			
			var obj:Object = _reg.exec(input);
			while(obj && args.length > 0)
			{
				var id:int = int(obj[1]);
				if(id >= 0 && id < args.length)
				{
					input =input.replace(_reg,args[id]);
				}
				else
				{
					input = input.replace(_reg,"{}");
				}
				obj = _reg.exec(input);
			}
			return input;
		}
	}
}