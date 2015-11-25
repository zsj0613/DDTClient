package ddt.view.characterII
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.PathManager;
	
	import road.loader.*;
	import road.utils.ClassUtils;
	import road.loader.ModuleLoader;
	
	public class SinpleLightLayer extends Sprite implements ILayer
	{
		private   var _light    : MovieClip;
		private   var _info     : PlayerInfo;
		private   var _type     : int;
		private   var _callBack : Function;
		private   var _loader   : ModuleLoader;
		public function SinpleLightLayer($info:PlayerInfo,showType:int = 0)
		{
			super();
			_info = $info;
			_type = showType;
			
		}
		public function load(callBack:Function):void
		{
			_callBack = callBack;
			initLoader();
		}
		protected function initLoader():void
		{
			if(_info == null || _info.Nimbus < 100)return ;
			if(!ClassUtils.hasDefinition("game.crazyTank.view.light.SinpleLightAsset_"+getId()))
			{
				_loader =  LoaderManager.Instance.createLoader(getUrl(),BaseLoader.MODULE_LOADER);
				LoaderManager.Instance.startLoad(this._loader);
				_loader.addEventListener(LoaderEvent.COMPLETE,__sourceComplete);
			}else
			{
				__sourceComplete();
			}
		}
		private function getId() : String
		{
			var i : int = int(_info.Nimbus / 100);
			return i.toString();
			
		}
		
		protected function __sourceComplete(event:Event = null):void
		{
//			if(info == null) return;
			var LightClass:Object = ClassUtils.getDefinition("game.crazyTank.view.light.SinpleLightAsset_"+getId()) as Class;
			if(LightClass == null)
			{
				_light = null;
			}else
			{
				_light = new LightClass() as MovieClip;
			}
			if(_callBack != null)
			{
				_callBack(this);
			}
		}
		
		protected function getUrl():String
		{
			return PathManager.soloveSinpleLightPath(getId());
		}
		public function getshowTypeString():String
		{
			if(_type == 0)
			{
				return "show";
			}else
			{
				return "game";
			}
		}
		
		public function get info(): ItemTemplateInfo
		{
			return null;
//			return _info;
		}
		public function set info(value:ItemTemplateInfo):void
		{
//			this._info = value;
		}
		public function getContent():DisplayObject
		{
		return this._light;	
		}
		public function dispose():void
		{
			if(_light && _light.parent)_light.parent.removeChild(_light);
			_light = null;
			_callBack = null;
			_info = null;
			if(_loader)_loader.removeEventListener(LoaderEvent.COMPLETE,__sourceComplete);
			_loader = null;
			if(this.parent)this.parent.removeChild(this);
		}
		public function set currentEdit(n:int):void
		{
			
		}
		public function get currentEdit():int
		{
			return 0;
		}
		public function setColor(color:*):Boolean
		{
		return false;	
		}

	}
}