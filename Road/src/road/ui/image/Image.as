package road.ui.image
{
	import road.ui.Component;
	import road.ui.ComponentFactory;
	import road.ui.Disposeable;
	import road.utils.ClassUtils;
	import road.utils.ObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	/**
	 * 
	 * @author Herman
	 * 普通的图片
	 */	
	public class Image extends Component
	{
		public static const BITMAP_IMAGE:int = 1;
		public static const COMPONENT_IMAGE:int = 0;
		public static const P_frameFilters:String = "frameFilters";
		public static const P_reourceLink:String = "resourceLink";
		public static const P_scale9Grid:String = "scale9Grid";

		public function Image()
		{
			mouseChildren = false;
			mouseEnabled = false;
		}

		protected var _display:DisplayObject;
		protected var _filterString:String;
		protected var _frameFilter:Array;
		protected var _resourceLink:String;
		protected var _scaleGridArgs:Array;
		protected var _scaleGridString:String;
		
		override public function dispose():void
		{
			ObjectUtils.disposeObject(_display);
			_display = null;
			_frameFilter = null;
			super.dispose();
		}
		/**
		 * 
		 * @param value 设置每一帧的滤镜的字符串
		 * 具体看ComponentFactory.Instance.creatFilters
		 * 
		 */		
		public function set filterString(value:String):void
		{
			if(_filterString == value)return;
			_filterString = value;
			frameFilters = ComponentFactory.Instance.creatFilters(_filterString);
		}
		/**
		 * 
		 * @param filter 设置每一帧的滤镜
		 * 
		 */		
		public function set frameFilters(filter:Array):void
		{
			if(_frameFilter == filter) return;
			_frameFilter = filter;
			onPropertiesChanged(P_frameFilters);
		}
		/**
		 * 
		 * 资源路径
		 * 
		 */		
		public function get resourceLink ():String
		{
			return _resourceLink;
		}
		
		public function set resourceLink (value:String):void
		{
			if(value == _resourceLink) return;
			_resourceLink = value;
			onPropertiesChanged(P_reourceLink);
		}
		/**
		 * 
		 * 设置9宫格的字符串
		 * 
		 */		
		public function get scaleGridString():String
		{
			return _scaleGridString;
		}
		
		public function set scaleGridString(args:String):void
		{
			if(args == _scaleGridString)return;
			_scaleGridString = args;
			_scaleGridArgs = ComponentFactory.parasArgs(_scaleGridString);
			onPropertiesChanged(P_scale9Grid);
		}
		/**
		 * 
		 * @param frameIndex 帧的序号
		 * 设置图片跳到某一帧
		 * 
		 */		
		public function setFrame(frameIndex:int):void
		{
			
		}
		
		override protected function addChildren():void
		{
			if(_display) addChild(_display);
		}

		protected function get display():DisplayObject
		{
			return _display;
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			if(_changedPropeties[P_reourceLink])
			{
				resetDisplay();
			}
			
			updateSize();
			if(_changedPropeties[P_scale9Grid])updateScale9Grid();
			
			if(_changedPropeties[P_frameFilters] || _changedPropeties[P_reourceLink])
			{
				setFilters();
			}
		}
		
		protected function resetDisplay():void 
		{
			if(_display)removeChild(_display);
			_display = ComponentFactory.Instance.creat(_resourceLink);
			_width = _display.width;
			_height = _display.height;
			_changedPropeties[Component.P_height] = true;
			_changedPropeties[Component.P_width] = true;
		}
		
		protected function setFilters():void
		{
			if(_frameFilter && _display)_display.filters = _frameFilter[0];
		}
		
		protected function updateScale9Grid():void
		{
			var rect:Rectangle = new Rectangle(0,0,_display.width,_display.height);
			rect.left = _scaleGridArgs[0];
			rect.top = _scaleGridArgs[1];
			rect.right = _scaleGridArgs[2];
			rect.bottom = _scaleGridArgs[3];
			_display.scale9Grid = rect;
		}
		
		protected function updateSize():void
		{
			if(_changedPropeties[Component.P_width])_display.width = _width;
			if(_changedPropeties[Component.P_height])_display.height = _height;
		}
	}
}