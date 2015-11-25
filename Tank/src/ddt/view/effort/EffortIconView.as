package ddt.view.effort
{
	
	import tank.view.effort.LoadingAsset;
	
	import road.loader.DisplayLoader;
	
	import ddt.loader.BitmapLoader;
	import ddt.manager.PathManager;
    import tank.view.effort.RightItemIconAsset;
	
	public class EffortIconView extends RightItemIconAsset
	{
		private var _photoloading:LoadingAsset;
		private var _iconUrl     :String;
		private var _icon        :BitmapLoader;
		public function EffortIconView(iconUrl:String)
		{
			super();
			_iconUrl = iconUrl;
			init();
		}
		
		private function init():void
		{
			_photoloading = new LoadingAsset();
			_photoloading.x = 23;
			_photoloading.y = 11;
			addChild(_photoloading);
			var path:String = PathManager.solveEffortIconPath(_iconUrl);
			_icon = new BitmapLoader(path);
			_icon._displayLoader.x = icon_mc.x;
			_icon._displayLoader.y = icon_mc.y;
			addChild(_icon._displayLoader);
			_icon.visible = true;
			_icon.loadSync(loadLayerComplete);
		}
		
		private function loadLayerComplete(loader:DisplayLoader):void
		{
			if(_photoloading)_photoloading.parent.removeChild(_photoloading);
			_photoloading = null;
			_icon._displayLoader.scaleX = 50/_icon._displayLoader.width;
			_icon._displayLoader.scaleY = 50/_icon._displayLoader.height;
		}
		
		public function dispose():void
		{
			if(_photoloading)_photoloading.parent.removeChild(_photoloading);
			_photoloading = null;
			if(icon_mc)
			{
				icon_mc.parent.removeChild(icon_mc);
			}
			if(_icon)
			{
				_icon.dispose();
			}
			_icon = null;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}