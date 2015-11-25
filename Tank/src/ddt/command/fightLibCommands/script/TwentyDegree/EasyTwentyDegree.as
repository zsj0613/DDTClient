package ddt.command.fightLibCommands.script.TwentyDegree
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.CreateMonsterCommand;
	import ddt.command.fightLibCommands.ImmediateCommand;
	import ddt.command.fightLibCommands.PopUpFrameWaitCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.WaittingCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	
	public class EasyTwentyDegree extends BaseScript
	{
		public function EasyTwentyDegree(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("首先我来说一下20度打法适合的武器：通畅利器、神风、医用工具箱、司马砸缸、烈火、牛顿水果篮。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command2"));
//			var command2:BaseFightLibCommand = new PopupFrameCommand("现在我们来说一下20度打法的优缺点。优点就是受风力影响很小。缺点就是受地形、高差影响比较大，有些位置会打不到。");
			var command3:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command3"));
			var command4:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command4"));
			command4.excuteFunArr.push(_host.showPowerTable1 as Function);
			command4.undoFunArr.push(_host.hidePowerTable as Function);
//			var command4:BaseFightLibCommand = new PopupFrameCommand("结合我们之前学习的课程，我来说明一下，角度为20度，相隔为1距时，发射力度为10，相隔为2距时，发射力度为19，以此类推，相隔为10距时，发射力度为54。");
			var command5:PopupFrameCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command6"),null);
//			var command5:PopUpFrameWaitCommand = new PopUpFrameWaitCommand("我们首先将角度调整到20度，然后来按照这个力度表实际操作一下。",(_host.waitAttack as Function));
			var command6:ImmediateCommand = new ImmediateCommand();
			command6.completeFunArr.push(_host.openShowTurn as Function);
			command6.completeFunArr.push(_host.skip as Function);
			var command7:CreateMonsterCommand = new CreateMonsterCommand();
			command7.excuteFunArr.push((_host.waitAttack as Function));
			var command8:WaittingCommand = new WaittingCommand(null);
			var command9:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command7"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),startTrain,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
			command9.excuteFunArr.push(_host.closeShowTurn as Function);
//			var command7:BaseFightLibCommand = new PopupFrameCommand("恭喜你打中了，现在您可以选择开始测试，或再看一遍讲解。",null,null,"再看一次",restart,true,true);
			
			_commonds.push(command1);
			_commonds.push(command2);
			_commonds.push(command3);
			_commonds.push(command4);
			_commonds.push(command5);
			_commonds.push(command6);
			_commonds.push(command7);
			_commonds.push(command8);
			_commonds.push(command9);
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