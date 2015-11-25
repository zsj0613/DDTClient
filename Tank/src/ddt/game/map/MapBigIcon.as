package ddt.game.map
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.crazyTank.view.common.LoadingAsset;
	
	import road.loader.DisplayLoader;
	
	import ddt.manager.PathManager;
	import ddt.room.MapIconLib;
	public class MapBigIcon extends Sprite
	{
		protected var loader:DisplayLoader;
		protected var _icon:Bitmap;
		protected var _loadingasset:LoadingAsset;
		
		public function MapBigIcon(mapID:int = 0)
		{
			super();
			_mapID = mapID;
			loadIcon();
		}
		
		
		
		protected function loadIcon():void
		{
			if(loader)
			{
				loader.dispose();
				loader = null;
			}
			if(MapIconLib.hasBigIcon(_mapID))
			{
				addIcon(MapIconLib.getBigIcon(_mapID));
			}else
			{
				loader = new DisplayLoader(0,PathManager.solveMapIconPath(_mapID,1));
				loader.loadSync(__iconLoaded);
			}
		}
		
		protected function __iconLoaded(l:DisplayLoader):void
		{
			if(l.isSuccess)
			{
				if(!MapIconLib.hasBigIcon(_mapID))
				{
					MapIconLib.addBigIcon(_mapID,l.content as Bitmap);
				}
				addIcon(MapIconLib.getBigIcon(_mapID));
			}
		}
		
		protected function addIcon(b:Bitmap):void
		{
			if(_icon)
			{
				removeChild(_icon);
				if(_icon.bitmapData)
				{
					_icon.bitmapData.dispose();
				}
			}
			_icon = b;
			
		
			if(_icon)
			{
				if(_width != 0 || _height != 0)
				{
					_icon.width = _width;
					_icon.height = _height;
				}else{
					width = _icon.width;
					height = _icon.height;
				}
			}
			addChild(_icon);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		public function setSize($width:Number,$height:Number):void
		{
			_height = $height;
			_width = $width;
			if(_icon)
			{
				_icon.width = _width;
				_icon.height = _height;
			}
		}
		
		override public function set width ($width:Number):void
		{
			_width = $width;
			if(_icon)
			{
				_icon.width = _width;
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height ($height:Number):void
		{
			_height = $height;
			if(_icon)
			{
				_icon.height = _height;
			}
		}
		
		
		protected var _mapID:int = 0;
		public function set id (i:int):void
		{
			_mapID = i;
			loadIcon();
		}
		
		public function get id():int
		{
			return _mapID;
		}
		
		public function get icon ():Bitmap
		{
			return _icon;
		}
		
		public function dispose ():void
		{
			if(loader)
			{
				loader.dispose();
			}
			loader = null;
			
			if(_icon && _icon.parent)
			{
				_icon.parent.removeChild(_icon);
			}
			_icon = null;
			
			if(_loadingasset && _loadingasset.parent)
			{
				_loadingasset.parent.removeChild(_loadingasset);
				
			}
			_loadingasset=null;
			
			if(parent)
				parent.removeChild(this);
		}
		
	}
}