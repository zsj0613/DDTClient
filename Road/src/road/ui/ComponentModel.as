package road.ui
{
	import road.loader.BaseLoader;
	import road.loader.LoaderEvent;
	import road.loader.LoaderManager;
	import road.loader.QueueLoader;
	import road.utils.ClassUtils;
	import road.utils.ObjectUtils;
	
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.ShaderFilter;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	[Event(name="complete",type="flash.events.Event")]
	public final class ComponentModel extends EventDispatcher
	{
		public function ComponentModel()
		{
			_componentStyle = new Dictionary();
			_styleSets = new Dictionary();
			_allTipStyles = new Vector.<String>();
			_shaderData = new Dictionary();
			_bitmapSets = new Dictionary();
		}
		
		private var _allTipStyles:Vector.<String>;
		private var _bitmapSets:Dictionary;
		private var _componentStyle:Dictionary;
		private var _currentComponentSet:XML;
		private var _shaderData:Dictionary;
		private var _styleSets:Dictionary;
		
		public function addBitmapSet(classpath:String,tagData:XML):void
		{
			_bitmapSets[classpath] = tagData;
		}

		public function addComponentSet(conponentSet:XML):void
		{
			_currentComponentSet = conponentSet;
			paras();
		}
		/**
		 * 
		 * @return 包含所有tip的样式
		 * 
		 */		
		public function get allTipStyles():Vector.<String>
		{
			return _allTipStyles;
		}
		/**
		 * 
		 * @param classpath 位图的路径
		 * @return 位图配置 
		 * 
		 */		
		public function getBitmapSet(classpath:String):XML
		{
			return _bitmapSets[classpath];
		}
		/**
		 * 
		 * @param stylename Component配置的样式名称
		 * @return Component配置
		 * 
		 */		
		public function getComonentStyle(stylename:String):XML
		{
			return _componentStyle[stylename];
		}
		/**
		 * 
		 * @param key 公用的配置的样式名称
		 * @return 公用的配置
		 * 
		 */		
		public function getSet(key:String):*
		{
			return _styleSets[key];
		}
		
		private function __onShaderLoadComplete(event:LoaderEvent):void
		{
			var shaderDataObject:Object = findShaderDataByLoader(event.loader);
			var shader:Shader = new Shader(shaderDataObject.loader.content);
			var shaderFilter:ShaderFilter = new ShaderFilter(shader);
			var shaderParas:Array = ComponentFactory.parasArgs(shaderDataObject.xml.@paras);
			for(var i:int = 0;i<shaderParas.length;i++)
			{
				var para:Array = String(shaderParas[i]).split(":");
				if(shaderFilter.shader.data.hasOwnProperty(para[0]))
				{
					shaderFilter.shader.data[para[0]].value = [int(para[1])];
				}
			}
			_styleSets[String(shaderDataObject.xml.@shadername)] = shaderFilter;
		}
		
		private function findShaderDataByLoader(loader:BaseLoader):Object
		{
			for each(var shaderDataObject:Object in _shaderData)
			{
				if(shaderDataObject.loader == loader)
				return shaderDataObject;
			}
			return null;
		}
		
		private function paras():void
		{
			parasSets(_currentComponentSet..set);
			parasComponent(_currentComponentSet..component);
			if(_currentComponentSet.hasOwnProperty("tips"))
			{
				parasTipStyle(_currentComponentSet.tips);
			}
			if(_currentComponentSet.shaderFilters.length() > 0) 
			{
//				parasShader(_currentComponentSet.shaderFilters[0]);
			}
			parasBitmapDataSets(_currentComponentSet..bitmapData);
			parasBitmapSets(_currentComponentSet..bitmap);
		}
		
		private function parasBitmapDataSets(list:XMLList):void
		{
			for(var i:int = 0;i<list.length();i++)
			{
				_bitmapSets[String(list[i].@resourceLink)] = list[i];
			}
		}
		
		private function parasBitmapSets(list:XMLList):void
		{
			for(var i:int = 0;i<list.length();i++)
			{
				_bitmapSets[String(list[i].@resourceLink)] = list[i];
			}
		}
		
		private function parasComponent(list:XMLList):void
		{
			for(var i:int = 0;i<list.length();i++)
			{
				_componentStyle[String(list[i].@stylename)] = list[i];
			}
		}
		
		private function parasSets(list:XMLList):void
		{
			for(var i:int = 0;i<list.length();i++)
			{
				if(String(list[i].@type) == ClassUtils.COLOR_MATIX_FILTER)
				{
					_styleSets[String(list[i].@stylename)] = ClassUtils.CreatInstance(list[i].@type,[ComponentFactory.parasArgs(list[i].@args)]);
				}else
				{
					_styleSets[String(list[i].@stylename)] = ClassUtils.CreatInstance(list[i].@type,ComponentFactory.parasArgs(list[i].@args));
				}
				ObjectUtils.copyPorpertiesByXML(_styleSets[String(list[i].@stylename)],list[i]);
			}
		}
		
//		private function parasShader(shaderXML:XML):void
//		{
//			var shaderPathTitle:String = shaderXML.@mainpath;
//			var shaderPerRate:String = shaderXML.@perRate;
//			var list:XMLList = shaderXML..shaderFilter;
//			for(var i:int = 0;i<list.length();i++)
//			{
//				var loader:BaseLoader = LoaderManager.Instance.creatLoader(shaderPathTitle+list[i].@path,BaseLoader.BYTE_LOADER);
//				loader.addEventListener(LoaderEvent.COMPLETE,__onShaderLoadComplete);
//				_queueLoader.addLoader(loader);
//				_shaderData[list[i].@shadername] = {xml:list[i],loader:loader};
//			}
//		}
		
		private function parasTipStyle(styles:XMLList):void
		{
			var allStyles:Array = String(styles[0].@alltips).split(",");
			for(var i:int = 0;i<allStyles.length;i++)
			{
				if(_allTipStyles.indexOf(allStyles[i])  == -1)
				{
					_allTipStyles.push(allStyles[i]);
				}
			}
		}
	}
}