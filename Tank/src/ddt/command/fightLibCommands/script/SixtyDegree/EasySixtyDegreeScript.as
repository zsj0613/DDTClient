package ddt.command.fightLibCommands.script.SixtyDegree
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.CreateMonsterCommand;
	import ddt.command.fightLibCommands.ImmediateCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.WaittingCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	
	public class EasySixtyDegreeScript extends BaseScript
	{
		public function EasySixtyDegreeScript(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.SixtyDegree.EasySixtyDegreeScript.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("首先我来说一下65度打法适合的武器：轰天、司马砸缸、黑白讲点、雷霆。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.SixtyDegree.EasySixtyDegreeScript.command2"));
//			var command2:BaseFightLibCommand = new PopupFrameCommand("现在我们来说一下65度打法的优缺点。优点就是受地形、高差影响比较小，缺点就是受风力影响比较大，而且对力度要求比较精确。");
			var command3:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.SixtyDegree.EasySixtyDegreeScript.command3"),null,_host.showPowerTable3);
//			var command3:BaseFightLibCommand = new PopupFrameCommand("下面我们来详细讲解一下打法。先看一下65度打法的力度表。");
			command3.undoFunArr.push(_host.hidePowerTable as Function);
			var command4:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.SixtyDegree.EasySixtyDegreeScript.command4"),null);
//			var command4:BaseFightLibCommand = new PopupFrameCommand("结合我们之前学习的课程，我来说明一下，在无风状态下，角度为65度，相隔为1距时，发射力度为13，相隔为2距时，发射力度为21，以此类推，相隔为20距时，发射力度为85");
			var command5:PopupFrameCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.SixtyDegree.EasySixtyDegreeScript.command6"));
//			var command6:PopUpFrameWaitCommand = new PopUpFrameWaitCommand("我们首先将角度调整到20度，然后来按照这个力度表实际操作一下。",(_host.waitAttack as Function));
			var commmand6:ImmediateCommand = new ImmediateCommand();
			command5.completeFunArr.push(_host.openShowTurn as Function);
			command5.completeFunArr.push(_host.skip as Function);
			var command6:CreateMonsterCommand = new CreateMonsterCommand();
			command6.excuteFunArr.push((_host.waitAttack as Function));
			var command7:WaittingCommand = new WaittingCommand(null);
			var command8:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.SixtyDegree.EasySixtyDegreeScript.command7"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),startTrain,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
			command8.excuteFunArr.push(_host.closeShowTurn as Function);
//			var command7:BaseFightLibCommand = new PopupFrameCommand("恭喜你打中了，现在您可以选择开始测试，或再看一遍讲解。",null,null,"再看一次",restart,true,true);S
			_commonds.push(command1);
			_commonds.push(command2);
			_commonds.push(command3);
			_commonds.push(command4);
			_commonds.push(command5);
			_commonds.push(command6);
			_commonds.push(command7);
			_commonds.push(command8);		
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