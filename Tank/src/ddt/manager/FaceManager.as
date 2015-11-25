package ddt.manager
{
	public class FaceManager
	{
		/* 单例对象 */
		private static var _instance:FaceManager;
		
		/* 表情库 */
				
		public function FaceManager(singleton:SingletonEnfocer)
		{
			
		}
		
		public static function getInstance():FaceManager
		{
			if(_instance == null)
			{
				_instance = new FaceManager(new SingletonEnfocer());
			}	
			return _instance as FaceManager;
		}

	}
}
class SingletonEnfocer {}