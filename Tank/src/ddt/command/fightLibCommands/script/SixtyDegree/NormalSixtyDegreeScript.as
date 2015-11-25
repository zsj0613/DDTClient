package ddt.command.fightLibCommands.script.SixtyDegree
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	
	public class NormalSixtyDegreeScript extends BaseScript
	{
		public function NormalSixtyDegreeScript(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.SixtyDegree.NormalSixtyDegreeScript.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("欢迎来到65度打法中级场，在这里我们要训练的课程有风的情况下，要如何计算。在计算好力度的基础上，我们还要根据风速计算发炮角度。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.SixtyDegree.NormalSixtyDegreeScript.command2"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"));
//			var command2:BaseFightLibCommand = new PopupFrameCommand("具体的计算方法为：如果您与对方中间为顺风，角度调整为65+（风力*2），如果您与对方中间为逆风，角度调整为65-（风力*2）。如果您理解了，可以点击开始训练按钮。");
			command2.completeFunArr.push(startTrain);
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