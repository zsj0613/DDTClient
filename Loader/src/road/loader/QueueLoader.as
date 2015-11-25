package road.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	[Event(name="complete",type="flash.events.Event")]
	public class QueueLoader extends EventDispatcher
	{
		private var _loaders:Vector.<BaseLoader>;
		
		public function QueueLoader()
		{
			_loaders = new Vector.<BaseLoader>();
		}
		
		public function addLoader(loader:BaseLoader):void
		{
			_loaders.push(loader);
		}
		
		public function start():void
		{
			tryLoadNext();
		}
		
		private function tryLoadNext():void
		{
			for(var i:int = 0;i < _loaders.length;i++)
			{
				if(!_loaders[i].isComplete)
				{
					LoaderManager.Instance.startLoad(_loaders[i]);
					_loaders[i].addEventListener(LoaderEvent.COMPLETE,__loadNext);
					return;
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function isAllComplete():Boolean
		{
			for(var i:int = 0;i<_loaders.length;i++)
			{
				if(!_loaders[i].isComplete)return false;
			}
			return true;
		}
		
		private function isLoading():Boolean
		{
			for(var i:int = 0;i<_loaders.length;i++)
			{
				if(_loaders[i].isLoading)return true;
			}
			return false;
		}
		
		private function __loadNext(event:LoaderEvent):void
		{
			event.loader.removeEventListener(LoaderEvent.COMPLETE,__loadNext);
			tryLoadNext();
		}
	}
}