package ddt.register.manager
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class RegisterAlertManager
	{
		public static const STAGE_WIDTH:int = 1000;
		public static const STAGE_HEIGHT:int = 600;
		public function RegisterAlertManager()
		{
		}
		
		private static var _instance:RegisterAlertManager;
		public static function get Instance ():RegisterAlertManager
		{
			if(_instance == null)
			{
				_instance = new RegisterAlertManager();
			}
			return _instance;
		}
		
		private var _showLayer:Sprite;
		public function setup(container:Sprite):void
		{
			_showLayer = container;
		}
		
		public function addToShowLayer(child:DisplayObject):void
		{
			child.x = (STAGE_WIDTH - child.width)/2;
			child.y = (STAGE_HEIGHT - child.height)/2;
			_showLayer.addChild(child);
		}
		
		public function clearnAll():void
		{
			while(_showLayer.numChildren > 0)
			{
				_showLayer.removeChildAt(0);
			}
		}

	}
}