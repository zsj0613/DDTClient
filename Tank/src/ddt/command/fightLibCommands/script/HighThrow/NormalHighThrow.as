package ddt.command.fightLibCommands.script.HighThrow
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	
	public class NormalHighThrow extends BaseScript
	{
		public function NormalHighThrow(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.NormalHighThrow.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("在这里我们要训练的课程是在有风的情况下，要如何计算角度，在计算好力度的基础上，我们还要根据风速计算发炮角度。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.NormalHighThrow.command2"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),startTrain,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
//			var command2:BaseFightLibCommand = new PopupFrameCommand("如果您与对方中间为顺风，角度为90-屏距+（风力*2），如果您与对方中间为逆风，角度调整为90-屏距-（风力*2）。如果准备好了，请点击开始训练按钮。");
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