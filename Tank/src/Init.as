package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public function Init(root:Sprite,config:XML,user:String,pass:String,setupCall:Function = null):void
	{
		var _game:DDT = new DDT();
		root.stage.frameRate = 25;
		root.stage.align = StageAlign.TOP_LEFT;
		root.stage.scaleMode = StageScaleMode.NO_SCALE;
		root.addChild(_game);
		_game.start(config,user,pass,setupCall);
	}
}