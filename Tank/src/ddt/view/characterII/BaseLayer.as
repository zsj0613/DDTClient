package ddt.view.characterII
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.loader.BitmapLoader;
	import ddt.manager.PathManager;
	
	import road.loader.DisplayLoader;
	import road.utils.StringHelper;

	public class BaseLayer extends Sprite implements ILayer
	{
		public static const ICON:String = "icon";
		public static const SHOW:String = "show";
		public static const GAME:String = "game";
		public static const CONSORTIA:String = "consortia";
		
		protected var _loaders:Array;
		protected var _info:ItemTemplateInfo;
		protected var _colors:Array;
		protected var _gunBack:Boolean;
		protected var _hairType:String;
		protected var _currentEdit:uint;
		private var _callBack:Function;
		private var _completeCount:int;
		private var _color:String;
		private var _loadCompleted:Boolean;
		protected var _defaultLayer:uint;
		private var _isAllLoadSucceed:Boolean=true;//是否全部加载成功
		
		public function BaseLayer(info:ItemTemplateInfo,color:String = "",gunback:Boolean = false,hairType:int = 1)
		{
			_info = info;
			_color = color == null ? "" : color;
			_gunBack = gunback;
			_hairType = hairType == 1 ? "B" : "A";
			super();
			init();
		}
		
		private function init():void
		{
			_loaders = [];
			_colors = [];
			_completeCount = 0;
			initLoaders();
			initColors(_color);
		}
		
		protected function initLoaders():void
		{
			if(_info != null)
			{
				//global.traceStr(_info.Property8);
				for(var i:int = 0; i < _info.Property8.length; i++)
				{
					if(i>=1)
					{
						break;
					}						
					var url:String = getUrl(int(_info.Property8.charAt(i)));
					var l:BitmapLoader = new BitmapLoader(url);
					_loaders.push(l);
				}
				_defaultLayer = 0;
				_currentEdit = _loaders.length;
			}
		}
		
		private function initColors(color:String):void
		{
			_colors = color.split("|");

			if(_colors.length == _loaders.length)
			{
				for(var i:int =0; i < _colors.length; i++)
				{
					if(!StringHelper.isNullOrEmpty(_colors[i]))
					{
						(_loaders[i] as BitmapLoader).color = Number(_colors[i]);
					}
					else
					{
						(_loaders[i] as BitmapLoader).color = NaN;
					}
				}
			}
			else
			{
				for(var j:int =0; j < _loaders.length; j++)
				{
					(_loaders[j] as BitmapLoader).color = NaN;
				}
			}
			(_loaders[_defaultLayer] as BitmapLoader).visible = true;
		}
		
		public function getContent():DisplayObject
		{
			return this;
		}
		
		public function setColor(color:*):Boolean
		{
			if(_info == null || color == null)
				return false;
			initColors(color);
			return true;
		}
		
		public function get info():ItemTemplateInfo
		{
			return _info;
		}
		
		public function set info(value:ItemTemplateInfo):void
		{
			if(info == value) return;
			clear();
			_info = value;
			if(_info)
			{
				initLoaders();
				load(_callBack);
			}
		}
		
		public function set currentEdit(n:int):void
		{
			_currentEdit = n;
			if(_currentEdit > _loaders.length)
				_currentEdit = _loaders.length;
			else if(_currentEdit < 1)
				_currentEdit = 1;
		}
		
		public function get currentEdit():int
		{
			return _currentEdit;
		}
		
		public function dispose():void
		{
			_info = null;
			_callBack = null
			clear();
			if(parent)
				parent.removeChild(this);
		}
		
		protected function clearChildren():void
		{
			var count:int = numChildren;
			for(var i:int = 0; i < count; i++)
			{
				removeChildAt(0);
			}
		}
		
		protected function clear():void
		{
			_completeCount = 0;
			for(var i:int = 0; i < _loaders.length; i++)
			{
				if(_loaders[i] is BitmapLoader)
				{
					_loaders[i].dispose();
				}
			}
			clearChildren();
			_loaders = [];
			_colors = [];
		}
		
		final public function load(callBack:Function):void
		{
			_callBack = callBack;
			if(_info == null)
			{
				loadComplete();
				return;
			}
			for(var i:int = 0; i < _loaders.length; i++)
			{
				addChild((_loaders[i] as BitmapLoader)._displayLoader);
				(_loaders[i] as BitmapLoader).loadSync(loadLayerComplete);
			}
		}
		
		protected function getUrl(layer:int):String
		{
			return PathManager.solveGoodsPath(_info.CategoryID,_info.Pic,_info.NeedSex == 1,SHOW,_hairType,String(layer),_info.Level,_gunBack,int(_info.Property1));
		}
		
		protected function loadComplete():void
		{
			if(_callBack != null)
				_callBack(this);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function loadLayerComplete(loader:DisplayLoader):void
		{
			if(!loader.isSuccess)
			{//只要其中有一项图片加载失败
				_isAllLoadSucceed=false;//全部是否加载成功设置为false
			}
			
			_completeCount ++;
			if(_completeCount == _loaders.length)
			{
				_loadCompleted;
				loadComplete();
			}
		}
		
		/**
		 *是否全部加载成功
		 */		
		public function get isAllLoadSucceed():Boolean
		{
			return _isAllLoadSucceed;
		}
	}
}