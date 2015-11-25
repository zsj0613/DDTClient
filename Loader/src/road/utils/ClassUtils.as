package road.utils
{
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * 
	 * @author Herman
	 * 
	 */	
	public final class ClassUtils
	{
		public static const INNERRECTANGLE:String = "road.geom.InnerRectangle";
		public static const OUTTERRECPOS:String = "road.geom.OuterRectPos";
		public static const RECTANGLE:String = "flash.geom.Rectangle";
		public static const COLOR_MATIX_FILTER:String = "flash.filters.ColorMatrixFilter";
		private static var _appDomain:ApplicationDomain;
		
		/**
		 * 
		 * @param className : 类名
		 * @param args : 类的构造函数所需的参数
		 * @return the 该类的实例
		 * 
		 */		
		public static function CreatInstance(className:String,args:Array = null):*
		{
			var instanceClass:Object = _appDomain.getDefinition(className);
			if(instanceClass == null)
			{
				throw new IllegalOperationError("can't find the class of\""+className+"\"in current domain");
			}
			var instance:Object;
			if(args == null || args.length == 0)
			{
				instance = new instanceClass();
			}else if(args.length == 1)
			{
				instance = new instanceClass(args[0]);
			}else if(args.length == 2)
			{
				instance = new instanceClass(args[0],args[1]);
			}else if(args.length == 3)
			{
				instance = new instanceClass(args[0],args[1],args[2]);
			}else if(args.length == 4)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3]);
			}else if(args.length == 5)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4]);
			}else if(args.length == 6)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4],args[5]);
			}else if(args.length == 7)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
			}else if(args.length == 8)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
			}else if(args.length == 9)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);
			}else if(args.length == 10)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);
			}else if(args.length == 11)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]);
			}else if(args.length == 12)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11]);
			}else if(args.length == 13)
			{
				instance = new instanceClass(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11],args[12]);
			}else
			{
				throw new IllegalOperationError("arguments too long");
			}
			return instance;
		}
		/**
		 * 
		 * 用于取得Component类的域
		 * 
		 */		
		public static function get uiSourceDomain():ApplicationDomain
		{
			return _appDomain;
		}

		public static function set uiSourceDomain(domain:ApplicationDomain):void
		{
			_appDomain = domain;
		}
		
		public static function classIsBitmapData(classname:String):Boolean
		{
			if(!_appDomain.hasDefinition(classname))return false;
			var c:* = _appDomain.getDefinition(classname);
			var superClassname:String = getQualifiedSuperclassName(c);
			return superClassname == "flash.display::BitmapData";
		}
		
		public static function getDefinition(classname:String):*
		{
			return _appDomain.getDefinition(classname);
		}
		public static function hasDefinition(classname:String):Boolean
		{
			return _appDomain.hasDefinition(classname);
		}
	}
}