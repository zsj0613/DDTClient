package ddt.command.fightLibCommands.script.HighThrow
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	
	public class DifficultHighThrow extends BaseScript
	{
		public function DifficultHighThrow(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.DifficultHighThrow.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("在之前的训练中，我们给出的都是整数的屏距和风力，如果遇到非整数的屏距和风力，怎么办呢？");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.DifficultHighThrow.command2"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),startTrain,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
//			var command2:BaseFightLibCommand = new PopupFrameCommand("我们可以对角度按照屏距、风力先进行四舍五入，算出所需近似角度，然后通过对力度进行一些微调，来校正角度带来的误差。如果您理解了，可以点击开始训练按钮。","开始训练");
			_commonds.push(command1);
			_commonds.push(command2);
			//			_commonds.push(command3);
			//			_commonds.push(command4);
			//			_commonds.push(command5);
			//			_commonds.push(command6);
			//			_commonds.push(command7);
			//			_commonds.push(command8);
			//			_commonds.push(command9);
			//			_commonds.push(command10);
			//			_commonds.push(command11);
			super.initializeScript();
		}
		
		private function startTrain():void
		{
			_host.continueGame();
		}
		
		override public function start():void
		{
			_host.sendClientScriptStart();
			super.start();
		}
		
		override public function finish():void
		{
			super.finish();
			_host.sendClientScriptEnd();
			_host.enableExist();
		}
	}
}