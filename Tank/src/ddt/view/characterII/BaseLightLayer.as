package ddt.view.characterII
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import road.loader.*;
	import road.utils.*;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.PathManager;
	
	public class BaseLightLayer extends Sprite implements ILayer
	{
		private    var _light    : MovieClip;
		private   var _info     : PlayerInfo;
		private   var _type     : int;
		private   var _callBack : Function;
		private   var _loader   : ModuleLoader;
		public function BaseLightLayer(info: PlayerInfo,showType:int = 0)
		{
			super();
			_info = info;
			_type = showType;
			
		}
		public function load(callBack:Function):void
		{
			_callBack = callBack;
			initLoader();
		}
		protected function initLoader():void
		{
			if(_info == null || getId() == "00")return ;
			if(!ClassUtils.hasDefinition("game.crazyTank.view.light.CircleLightAsset_" + getId()))
			{
				_loader =  LoaderManager.Instance.createLoader(getUrl(),BaseLoader.MODULE_LOADER);
				this._loader.addEventListener(LoaderEvent.COMPLETE, this.__sourceComplete);
				LoaderManager.Instance.startLoad(this._loader);
			}else
			{
				__sourceComplete();
			}
		}
		
		private function getId() : String
		{
			if(_info.Nimbus == 0)return "00";
			var nimbus : String = _info.Nimbus.toString();
			nimbus = nimbus.substr((nimbus.length-2),nimbus.length);
			nimbus = (Number(nimbus)).toString();
			return nimbus;
		}
		protected function __sourceComplete(event:Event = null):void
		{
			var LightClass:Object = ClassUtils.getDefinition("game.crazyTank.view.light.CircleLightAsset_"+getId()) as Class;
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
			return PathManager.soloveCircleLightPath(getId());
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
			if(_loader)
			{
				_loader.removeEventListener(LoaderEvent.COMPLETE,__sourceComplete);
			}
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
//		override public function get width():Number
//		{
//			
//		}
//		public function get height():Number
//		{
//			
//		}

	}
}