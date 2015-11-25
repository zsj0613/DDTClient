package ddt.view.characterII
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import road.loader.*;
	import road.utils.ClassUtils;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.PathManager;

	public class BaseWingLayer extends Sprite implements ILayer
	{
		public static const SHOW_WING:int = 0;
		public static const GAME_WING:int = 1;
		
		protected var _info:ItemTemplateInfo;
		protected var _callBack:Function;
		protected var _loader:ModuleLoader;
		protected var _showType:int = 0;
		
		protected var _wing:MovieClip;
		public function BaseWingLayer(info:ItemTemplateInfo,showType:int = SHOW_WING)
		{
			_info = info;
			_showType = showType;
			super();
//			initLoader();
		}
		
		protected function initLoader():void
		{
			if(!ClassUtils.hasDefinition("wing_"+getshowTypeString()+"_"+info.TemplateID))
			{
				_loader =  LoaderManager.Instance.createLoader(getUrl(),BaseLoader.MODULE_LOADER);
				LoaderManager.Instance.startLoad(this._loader);
				_loader.addEventListener(LoaderEvent.COMPLETE,__sourceComplete);
			}else
			{
				__sourceComplete();
			}
		}
		
		protected function __sourceComplete(event:Event = null):void
		{
			if(info == null) return;
			var WingClass:Object = ClassUtils.getDefinition("wing_"+getshowTypeString()+"_"+info.TemplateID) as Class;
			if(WingClass == null)
			{
				_wing = null;
			}else
			{
				_wing = new WingClass() as MovieClip;
			}
			if(_callBack != null)
			{
				_callBack(this);
			}
		}
		
		public function setColor(color:*):Boolean
		{
			return false;
		}
		
		public function get info():ItemTemplateInfo
		{
			return _info;
		}
		
		public function set info(value:ItemTemplateInfo):void
		{
			_info = value;
//			initLoader();
		}
		
		public function getContent():DisplayObject
		{
			return _wing;
		}
		
		public function dispose():void
		{
			if(_loader)
			{
				_loader.removeEventListener(Event.COMPLETE,__sourceComplete);
				_loader = null;
			}
			_wing = null;
			_callBack = null;
			_info = null;
			if(parent)
				parent.removeChild(this);
		}
		
		public function load(callBack:Function):void
		{
			_callBack = callBack;
			initLoader();
		}
		
		private function loadLayerComplete():void
		{
			
		}
		
		public function set currentEdit(n:int):void
		{
		}
		
		public function get currentEdit():int
		{
			return 0;
		}
		
		override public function get width():Number
		{
			return 0;
		}
		
		override public function get height():Number
		{
			return 0;
		}
		
		protected function getUrl():String
		{
			return PathManager.soloveWingPath(info.Pic);
		}
		
		public function getshowTypeString():String
		{
			if(_showType == 0)
			{
				return "show";
			}else
			{
				return "game";
			}
		}
	}
}