
package ddt.game.map
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import road.loader.DisplayLoader;
	
	import ddt.manager.PathManager;
	import ddt.room.MapIconLib;

	public class MapSmallMinIcon extends MapBigIcon
	{
		public function MapSmallMinIcon(id:int = 9999999)
		{
			super(id);
		}
		
		override protected function loadIcon():void
		{
//			if(id == 0) return;
			if(id == 9999999) return;
			
			if(MapIconLib.hasSmallMinIcon(_mapID))
			{
				addIcon(MapIconLib.getSmallMinIcon(_mapID));
			}else
			{
				loader = new DisplayLoader(0,PathManager.solveMapIconPath(_mapID,3));
				loader.loadSync(__iconLoaded);
			}
		}
		override protected function addIcon(b:Bitmap):void
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
			
			addChild(_icon);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		override protected function __iconLoaded(l:DisplayLoader):void
		{
			if(l.isSuccess)
			{
				if(!MapIconLib.hasSmallMinIcon(_mapID))
				{
					MapIconLib.addSmallMinIcon(_mapID,l.content as Bitmap);
				}
				addIcon(MapIconLib.getSmallMinIcon(_mapID) as Bitmap);
				
			}
		}
		
	}
}