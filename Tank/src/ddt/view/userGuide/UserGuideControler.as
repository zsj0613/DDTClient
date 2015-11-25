package ddt.view.userGuide
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import userGuide.accect.userGuideMC;
	public class UserGuideControler
	{
		private var secondGuidMC:MovieClip;
		
		private var _battleTip:MovieClip;
		private var _userGuide:Boolean;
		
		public function UserGuideControler()
		{
			secondGuidMC = new userGuideMC();
			secondGuidMC.gotoAndStop(1);
		}
		
		private var container:DisplayObjectContainer;
		
		public function setup(container:DisplayObjectContainer):void
		{
			this.container =  container;
		}

		private static var _instance:UserGuideControler;
		
		public static function get Instance():UserGuideControler
		{
			if(_instance == null)
			{
				_instance = new UserGuideControler();
			}
			return _instance;
		}
		
		private var tempContainer:DisplayObjectContainer;
		public function setTempContainer(container:DisplayObjectContainer):void
		{
			this.tempContainer =  container;
		}
		
		public static const SERVERLISTGUIDE : String = "serverListGuide";
		public static const HALLGUIDE       : String = "hallGuide";
		public static const CREATEROOM      : String = "createRoom";
		public static const CONFIRMROOM     : String = "confirmRoom";
		public static const CONFIRMROOMPVE     : String = "confirmRoomPVE";
		public static const STARTFIGHT      : String = "startFight";
		
		public var createRoom  : Boolean = false;
		public var confirmRoom : Boolean = false;
		public var startFight  : Boolean = false;
		
		public function showGuide(mask : String) : void
		{
			addGuideMC();
			//secondGuidMC.gotoAndStop(mask);
		}
		
		public function showServerListGuide():void
		{
			addGuideMC();
			//secondGuidMC.gotoAndStop("serverListGuide");
		}
		
		public function showHallGuide():void
		{
			addGuideMC();
			//secondGuidMC.gotoAndStop("hallGuide");
		}
		
		
		public function addGuideMC():void
		{
			if(tempContainer)
			{
				tempContainer.mouseEnabled = false;
				tempContainer.addChild(secondGuidMC);
			}else
			{
				container.mouseEnabled = false;
				container.addChild(secondGuidMC);
			}
			secondGuidMC.mouseEnabled = false;
			secondGuidMC.mouseChildren = false;
		}
		
		public function removeGuideMC():void
		{
			if(secondGuidMC.parent)
			{
				secondGuidMC.parent.removeChild(secondGuidMC);
			}
		}
		
		public function set userGuide(b:Boolean):void
		{
			_userGuide = b;
		}
		public function get userGuide():Boolean
		{
			return _userGuide;
		}
	}
}