package ddt.register
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
//加载注册
		public function EnterRegister(root:Sprite,config:XML,user:String,pass:String):void
		{
			root.stage.frameRate = 25;
			root.stage.align = StageAlign.TOP_LEFT;
			root.stage.scaleMode = StageScaleMode.NO_SCALE;
			var registerState:RegisterState = new RegisterState(root,config,user,pass);
			root.addChild(registerState);
		}
	}