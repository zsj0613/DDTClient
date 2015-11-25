package road.ui
{
	import road.loader.BaseLoader;
	import road.loader.DisplayLoader;
	import road.loader.TextLoader;
	import road.utils.ClassUtils;
	import road.utils.ObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	[Event(name="complete",type="flash.events.Event")]
	/**
	 * 创建Component的工厂 
	 * @author Herman
	 * 
	 */	
	public final class ComponentFactory extends EventDispatcher
	{
		private static var _instance:ComponentFactory;
		private static var COMPONENT_COUNTER:int = 1;
		private var _allComponents:Dictionary;
		public static function get Instance():ComponentFactory
		{
			if(_instance == null)
			{
				_instance = new ComponentFactory(new ComponentFactoryEnforcer());
			}
			return _instance;
		}
		/**
		 * 分隔参数信息字符串
		 * @param args 参数信息字符串
		 * @return 参数数组
		 * 
		 */		
		public static function parasArgs(args:String):Array
		{
			return args.split(",");
		}

		public function ComponentFactory(enforcer:ComponentFactoryEnforcer)
		{
			_model = new ComponentModel();
			ClassUtils.uiSourceDomain = ApplicationDomain.currentDomain;
		}

		private var _model:ComponentModel;
		/**
		 * 创建组件
		 * @param stylename Component的样式名称
		 * @return 
		 * 
		 */		
		public function creat(stylename:String,args:Array = null):*
		{
			var com:*;
			if(_model.getComonentStyle(stylename))
			{
				com = creatComponentByStylename(stylename);
			}else if(_model.getBitmapSet(stylename) || ClassUtils.classIsBitmapData(stylename))
			{
				com = creatBitmap(stylename);
			}else
			{
				com = ClassUtils.CreatInstance(stylename,args);
			}
			return com;
		}
		/**
		 * 创建bitmap 支持通过bitmapData 或者bitmap 的xml标签创建
		 * @param classname 类名
		 * @return bitmap
		 * 
		 */		
		public function creatBitmap(classname:String):Bitmap
		{
			var bitmapSet:XML = _model.getBitmapSet(classname);
			var bitmapData:BitmapData;
			var bitmap:Bitmap;
			if(bitmapSet == null)
			{
				if(ClassUtils.uiSourceDomain.hasDefinition(classname))
				{
					bitmapData = ClassUtils.CreatInstance(classname,[0,0]);
					bitmap = new Bitmap(bitmapData);
					_model.addBitmapSet(classname,new XML("<bitmapData resourceLink='"+classname+"' width='0' height='0' />"));
				}
			}else
			{
				if(bitmapSet.name() == ComponentSetting.BITMAPDATA_TAG_NAME)
				{
					bitmapData = creatBitmapData(classname);
					bitmap = new Bitmap(bitmapData,"auto",String(bitmapSet.@smoothing)=="true");
				}else
				{
					bitmap = ClassUtils.CreatInstance(classname);
				}
				if(bitmapSet.hasOwnProperty("@x"))bitmap.x = bitmapSet.@x;
				if(bitmapSet.hasOwnProperty("@y"))bitmap.y = bitmapSet.@y;
			}
			return bitmap
		}
		/**
		 * 创建bitmapData 支持通过bitmapData 或者bitmap 的xml标签创建
		 * @param classname 类名
		 * @return bitmapData
		 * 
		 */		
		public function creatBitmapData(classname:String):BitmapData
		{
			var bitmapSet:XML = _model.getBitmapSet(classname);
			if(bitmapSet == null)return null;
			var bitmapData:BitmapData
			if(bitmapSet.name() == ComponentSetting.BITMAPDATA_TAG_NAME)
			{
				bitmapData = ClassUtils.CreatInstance(classname,[int(bitmapSet.@width),int(bitmapSet.@height)]);
			}else
			{
				bitmapData = ClassUtils.CreatInstance(classname)["btimapData"];
			}
			return bitmapData;
		}
		/**
		 * 通过样式名称创建Component
		 * @param 样式名称
		 * @return Component
		 * 
		 */		
		public function creatComponentByStylename(stylename:String):*
		{
			var style:XML = _model.getComonentStyle(stylename);
			var classname:String = style.@classname;
			var component:Component = ClassUtils.CreatInstance(classname);
			component.beginChanges();
			component.id = componentID;
			_allComponents[component.id] = component;
			ObjectUtils.copyPorpertiesByXML(component,style);
			component.commitChanges();
			return component;
		}
		/**
		 * 通过Component::id获取Component
		 * @param componentid Component::id
		 * @return Component
		 * 
		 */		
		public function getComponentByID(componentid:int):*
		{
			return _allComponents[componentid];
		}
		/**
		 * 通过Component::id移除ComponentFactory中对Component的引用
		 * @param componentid Component::id
		 * 
		 */
		public function removeComponent(componentid:int):void
		{
			delete _allComponents[componentid];
		}
		
		/**
		 * 
		 * @param filterString : 代表滤镜的字符串  "null,f1|f2,f3,f4|f5"
		 * @return 包含滤镜的数组
		 * 
		 */		
		public function creatFilters(filterString:String):Array
		{
			var filterStyles:Array = parasArgs(filterString);
			var resultFilters:Array = [];
			for(var i:int = 0;i<filterStyles.length;i++)
			{
				if(filterStyles[i] == "null")
				{
					resultFilters.push(null);
				}else
				{
					var frameFilterStyle:Array = String(filterStyles[i]).split("|");
					var frameFilter:Array = [];
					for(var j:int = 0;j<frameFilterStyle.length;j++)
					{
						frameFilter.push(ComponentFactory.Instance.model.getSet(frameFilterStyle[j]));
					}
					resultFilters.push(frameFilter);
				}
			}
			return resultFilters;
		}
		
		public function get model():ComponentModel
		{
			return _model;
		}
		/**
		 * 
		 * @param url 配置Component的XML地址
		 * @param configRate 加载XML所占用的加载比率
		 * 
		 */		
		public function setup(config:XML):void
		{
			_allComponents = new Dictionary();
			_model.addComponentSet(config);
		}
		
		public function get componentID():int
		{
			return COMPONENT_COUNTER++;
		}
	}
}

class ComponentFactoryEnforcer {
};