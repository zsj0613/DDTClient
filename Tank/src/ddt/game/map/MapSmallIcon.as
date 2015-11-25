package ddt.game.map
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import road.loader.DisplayLoader;
	
	import ddt.manager.PathManager;
	import ddt.room.MapIconLib;

	public class MapSmallIcon extends MapBigIcon
	{
		public function MapSmallIcon(id:int = 9999999)
		{
			super(id);
		}
		
		override protected function loadIcon():void
		{
//			if(id == 0) return;
			if(id == 9999999) return;
			
			if(MapIconLib.hasSmallIcon(_mapID))
			{
				addIcon(MapIconLib.getSmallIcon(_mapID));
			}else
			{
				loader = new DisplayLoader(0,PathManager.solveMapIconPath(_mapID,0));
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
				if(!MapIconLib.hasSmallIcon(_mapID))
				{
					MapIconLib.addSmallIcon(_mapID,l.content as Bitmap);
				}
				addIcon(MapIconLib.getSmallIcon(_mapID) as Bitmap);
				
			}
		}
		
	}
}