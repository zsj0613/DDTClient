package par.manager
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import road.utils.ClassUtils;
	
	//import road.model.ModelManager;
	
	public class ShapeManager
	{
		public static var list:Array = [];
		
		private static var _ready:Boolean;
		
		public static function get ready():Boolean
		{
			return _ready;
		}
		
		public static function setup():void
		{
			try
			{
				var cls:Object = ClassUtils.getDefinition("ParticalShapLib");
				if(cls["data"])
				{
					list = cls["data"];
					_ready = true;
				}
			}
			catch(err:Error){trace(err.message)}
		}
								
		public static function create(id:uint):DisplayObject
		{
			if(id < 0 || id >= list.length)
			{
				var sprit:Sprite = new Sprite();
				sprit.graphics.beginFill(0);
				sprit.graphics.drawCircle(0,0,10);
				sprit.graphics.endFill();
				return sprit;
			}
			else
			{
				var ator:Class = list[id]["data"];
				return new ator() as DisplayObject;
			} 
		}

	}
}