package ddt.game.map
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import game.crazyTank.view.common.LoadingAsset;
	
	import road.loader.DisplayLoader;
	
	import ddt.manager.PathManager;
	import ddt.room.MapIconLib;

	public class MapShowIcon extends MapBigIcon
	{
//		private var _needLoad:Boolean;
		private var _missionPic:String;
		
		public function MapShowIcon(mapID:int = 9999999,missionPic:String="show1.jpg")
		{
			_missionPic = missionPic;
			super(mapID);
		}
		
		public function load():void{
//			_needLoad = true;
			loadIcon();
		}
		override protected function loadIcon():void
		{
//			if(!_needLoad) return;
			if(id == 9999999) return;
			
			if(MapIconLib.hasShowIcon(_mapID+_missionPic))
			{
				addIcon(MapIconLib.getShowIcon(_mapID+_missionPic));
			}else
			{
				removeLoading();
				_loadingasset = new LoadingAsset();
				_loadingasset.width= 120;
				_loadingasset.height= 120;
				_loadingasset.x =92;
				_loadingasset.y =103;
				_loadingasset.graphics.beginFill(0x000000,.5);
				_loadingasset.graphics.drawRect(-17,-20,60,77);
				_loadingasset.graphics.endFill();
				addChild(_loadingasset);
				loader = new DisplayLoader(0,PathManager.solveMapIconPath(_mapID,2,_missionPic));
				loader.loadSync(__iconLoaded,3);
			}
		}
		
		override protected function __iconLoaded(l:DisplayLoader):void
		{
			removeLoading();
			if(l.isSuccess)
			{
				if(!MapIconLib.hasShowIcon(_mapID+_missionPic))
				{
					MapIconLib.addShowIcon(_mapID+_missionPic,l.content as Bitmap);
				}
				addIcon(MapIconLib.getShowIcon(_mapID+_missionPic));
			}
			else
			{
				if(_icon)
				{
					removeChild(_icon);
					if(_icon.bitmapData)_icon.bitmapData.dispose();
				}
				_icon = null;
				
			}
		}
		
		private function removeLoading():void
		{
			if(_loadingasset)
			{
				_loadingasset.graphics.clear()
				if(_loadingasset && _loadingasset.parent) _loadingasset.parent.removeChild(_loadingasset);
			}
		}
		
		override public function dispose():void
		{
//			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,__error);
			super.dispose();
		}
		
	}
}