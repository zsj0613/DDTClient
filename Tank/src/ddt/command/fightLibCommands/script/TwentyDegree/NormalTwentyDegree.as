package ddt.command.fightLibCommands.script.TwentyDegree
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.CreateMonsterCommand;
	import ddt.command.fightLibCommands.PopUpFrameWaitCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	
	public class NormalTwentyDegree extends BaseScript
	{
		public function NormalTwentyDegree(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.NormalTwentyDegree.command1"),null,_host.showPowerTable2 as Function);
			command1.undoFunArr.push(_host.hidePowerTable as Function);
//			var command1:BaseFightLibCommand = new PopupFrameCommand("欢迎来到20度打法中级场，在这里我们要训练的课程是一屏幕以外用20度打法要用多少力度。我们来看一下1屏外的力度表。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.NormalTwentyDegree.command2"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),startTrain);
//			var command2:BaseFightLibCommand = new PopupFrameCommand("这里不仅要求掌握各种屏距力度，对距离的测算也有了一定要要求。如果准备好了，请点击开始训练按钮。","开始训练");		
			
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