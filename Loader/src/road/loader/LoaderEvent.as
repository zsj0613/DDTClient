package road.loader
{
	import flash.events.Event;
	public class LoaderEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const LOAD_ERROR:String = "loadError";
		public static const PROGRESS:String = "progress";

		public function LoaderEvent(type:String,loader:BaseLoader)
		{
			this.loader = loader;
			super(type);
		}
		
		public var loader:BaseLoader;
	}
}