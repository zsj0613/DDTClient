package road.utils
{
	import road.ui.Disposeable;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.sampler.getMemberNames;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 
	 * @author Herman
	 * 
	 */	
	public final class ObjectUtils
	{
		
		private static var _copyAbleTypes:Vector.<String>;
		private static var _descriptOjbXMLs:Dictionary;

		/**
		 * 
		 * @param obj 用于复制的源对象
		 * @return obj 的副本
		 * 
		 */		
		public static function cloneSimpleObject(obj:Object):Object
		{
			var temp:ByteArray = new ByteArray();
			temp.writeObject(obj);
			temp.position = 0;
			return temp.readObject();
		}
		
		/**
		 * 
		 * 通过XML对目标对象进行赋值
		 * @param object: 赋值的目标对象
		 * @param data : 保存属性的XML对象
		 * 
		 */		
		public static function copyPorpertiesByXML(object:Object,data:XML):void
		{
			var attr:XMLList =data.attributes();
			for each(var item:XML in attr)
			{
				var propname:String = item.name().toString();
				if(object.hasOwnProperty(propname))
				{
					var value:String = item.toString();
					if(value == "false")
					{
						object[propname] = false;
					}else
					{
						object[propname] = value;
					}
				}
			}
		}
		
		/**
		 * 
		 * @param dest 接受赋值的对象
		 * @param orig 赋值的源对象
		 * @param descriXML 该源对象的描述XML
		 * 
		 */		
		public static function copyProperties(dest:Object,orig:Object):void
		{
			if(_descriptOjbXMLs == null)_descriptOjbXMLs = new Dictionary();
			var copyAbleTypes:Vector.<String> = getCopyAbleType();
			var properties:XMLList;
			var descriXML:XML = describeTypeSave(orig);
			properties = descriXML.variable;
			for each(var propertyInfo:XML in properties){
				var propertyType:String = propertyInfo.@type;
				if (copyAbleTypes.indexOf(propertyType) != -1)
				{
					var propertyName:String = propertyInfo.@name;
					if (dest.hasOwnProperty(propertyName))
					{
						dest[propertyName] = orig[propertyName];
					}
				}
			}
		}
		/**
		 * 
		 * 对所有在container容器的对象执行dispose操作
		 * @param container 存放需要dispose对象的容器
		 * 
		 */		
		public static function disposeAllChildren(container:DisplayObjectContainer):void
		{
			while(container.numChildren > 0)
			{
				var child:DisplayObject=container.getChildAt(0);
				ObjectUtils.disposeObject(child);
			}
		}
		/**
		 * 
		 * 清除container下的所有显示对象
		 * @param container 被清除子对象的容器
		 * 
		 */		
		public static function removeChildAllChildren(container:DisplayObjectContainer):void
		{
			while(container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
		}
		
		/**
		 * 清除对象的引用以便垃圾回收
		 * @param target : 目标对象
		 * 
		 * 支持几种对象 ：
		 * Disposeable 只执行dispose方法。
		 * Bitmap 会把bitmapData dispose 然后removeChild
		 * BitmapData 会调用dispose
		 * DisplayObject 会removeChild
		 */		
		public static function disposeObject(target:Object):void
		{
			if(target == null) return;
			if(target is Disposeable)
			{
				Disposeable(target).dispose();
			}else if(target is Bitmap) 
			{
				var targetBitmap:Bitmap = Bitmap(target);
				if(targetBitmap.parent)targetBitmap.parent.removeChild(targetBitmap);
				targetBitmap.bitmapData.dispose();
			}else if(target is BitmapData) 
			{
				var targetBitmapData:BitmapData = BitmapData(target);
				targetBitmapData.dispose();
			}
			else if(target is DisplayObject) 
			{
				var targetDisplay:DisplayObject = DisplayObject(target);
				if(targetDisplay.parent)targetDisplay.parent.removeChild(targetDisplay);
			}
		}
		
		private static function getCopyAbleType():Vector.<String>
		{
			if(_copyAbleTypes == null)
			{
				_copyAbleTypes = new Vector.<String>();
				_copyAbleTypes.push("int");
				_copyAbleTypes.push("uint");
				_copyAbleTypes.push("String");
				_copyAbleTypes.push("Boolean");
				_copyAbleTypes.push("Number");
			}
			return _copyAbleTypes;
		}
		/**
		 * 
		 * 安全的获取类的信息
		 * @param obj 目标对象
		 * @return 类的描述信息
		 * 
		 */		
		public static function describeTypeSave(obj:Object):XML
		{
			var result:XML
			var classname:String = getQualifiedClassName(obj);
			if(_descriptOjbXMLs[classname] != null)
			{
				result = _descriptOjbXMLs[classname];
			}else
			{
				result = describeType(obj);
				_descriptOjbXMLs[classname] = result;
			}
			return result;
		}
	}
}