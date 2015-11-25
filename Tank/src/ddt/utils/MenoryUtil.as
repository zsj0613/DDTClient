package ddt.utils
{
	import flash.net.LocalConnection;
	
	public class MenoryUtil
	{
		public function MenoryUtil()
		{
		}
		
		public static function clearMenory():void
		{
			try
			{
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch(error : Error){}         
		}
	}
}