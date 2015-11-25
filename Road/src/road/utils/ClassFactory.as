package road.utils
{
	import flash.utils.describeType;
	
	public class ClassFactory
	{
		public function ClassFactory(generator:Class = null)
	    {
	    	this.generator = generator;
	    }

   	 	public var generator:Class;
		public var properties:Object = null;
		public function newInstance():*
		{
			var instance:Object = new generator();
	
	        if (properties != null)
	        {
	        	for (var p:String in properties)
				{
	        		instance[p] = properties[p];
				}
	       	}
	       	return instance;
		}
		
		public static function copyProperties(source:Object,target:Object):Object
		{
			if(source && target)
			{
				var names:Array = ClassFactory.getObjectPropertyName(source);
				for(var i:int = 0; i<names.length;i++)
				{
					target[names[i]] = source[names[i]];
				}
			}
			return target;
		}
		
		public static function copyPropertiesByTarget(source:Object,target:Object):Object
		{
			if(source && target)
			{
				var names:Array = ClassFactory.getObjectPropertyName(target);
				for(var i:int = 0; i<names.length;i++)
				{
					target[names[i]] = source[names[i]];
				}
			}
			return target;
		}
		
		/**
		 * 输出公有属性和可写，可读写属性
		 * @param obj
		 * @return 
		 * 
		 */		
		public static function getObjectPropertyName(obj:Object):Array
		{
			var description:XML = describeType(obj);
			var xmllist:XMLList = description..accessor;
			var xmllist2:XMLList = description..variable;
			var tmp:Array = new Array();
			var i:int = 0;
			for(i = 0;i<xmllist.length();i++)
			{
				if(xmllist[i].@access == "writeonly"||xmllist[i].@access == "readwrite")tmp.push(xmllist[i].@name.toXMLString());
			}
			for(i = 0; i < xmllist2.length(); i++)
			{
				tmp.push(xmllist2[i].@name.toXMLString());
			}
			return tmp;
		}
	}
}