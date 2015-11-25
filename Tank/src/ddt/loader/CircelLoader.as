package ddt.loader
{
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import road.loader.DisplayLoader;

	public class CircelLoader extends Sprite
	{
		private var _loader:DisplayLoader;
		private var _asset:MovieClip;
		public var data:Object;
		
		private var _width:Number;
		private var _height:Number;
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		function CircelLoader()
		{
			addBackAsset();
		}
		
		public function load(path:String):void
		{
			if(_loader)
			{
				_loader._displayLoader.parent?removeChild(_loader._displayLoader):null;
			}
			
			_loader = new DisplayLoader(0,path);
			addBackAsset();
			_loader.loadSync(__complete);
		}
		
		private function addBackAsset():void
		{
			if(_asset == null)
			{
				_asset = new MovieClip();
				_asset.x = 50;
				_asset.y = 50;
				_asset.gotoAndStop(1);
			}
			addChild(_asset);
		}
		
		private function __complete(loader:DisplayLoader):void
		{
			if(loader.isSuccess)
			{
				_asset.parent?removeChild(_asset):null;
				_asset = null;
				
				addChild(_loader._displayLoader);
				_loader._displayLoader.x = width/2-_loader._displayLoader.width/2;
				_loader._displayLoader.y = height/2-_loader._displayLoader.height/2;
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				_asset.gotoAndStop(2);
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			}

		}
		
		public function setSize(w:Number, h:Number):void
		{
			width = w;
			height = h;
			drawLayout();
		}
		
		protected function drawLayout():void
		{
			_asset.x = this.width /2;
			_asset.y = this.height /2;
		}
		
		public function get content():DisplayObject
		{
			return _loader.content;
		}
		
		public function get loader():Loader
		{
			return _loader._displayLoader;
		}
				
		public function close():void
		{
			_loader._displayLoader.close();
		}
		
		public function get contentLoaderInfo():LoaderInfo
		{
			return _loader._displayLoader.contentLoaderInfo;
		}
	}
}