package ddt.manager
{
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.system.IMEConversionMode;
	
	public class IMEManager
	{
		public static function enable():void
		{
			if(Capabilities.hasIME)
			{
				try{
					IME.enabled = true;
				}catch(e:Error)
				{
					trace(e.message);
				}
			}
		}
		
		public static function disable():void
		{
			if(Capabilities.hasIME)
			{
				try{
					IME.enabled = false;
				}catch(e:Error)
				{
					trace(e.message);
				}
			}
		}

	}
}