package ddt.command.fightLibCommands.script.HighThrow
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.CreateMonsterCommand;
	import ddt.command.fightLibCommands.ImmediateCommand;
	import ddt.command.fightLibCommands.PopUpFrameWaitCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.TimeCommand;
	import ddt.command.fightLibCommands.WaittingCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	
	public class EasyHighThrow extends BaseScript
	{
		public function EasyHighThrow(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.EasyHighThrow.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("首先我来说一下高抛打法适合的武器：司马砸缸、黑白家电、雷霆。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.EasyHighThrow.command2"));
//			var command2:BaseFightLibCommand = new PopupFrameCommand("现在我们来说一下高抛打法的优缺点。优点就是受高地形影响较小，缺点就是受风力和高差影响比较大。");
			var command3:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.EasyHighThrow.command3"),null);
//			var command3:BaseFightLibCommand = new PopupFrameCommand("下面我们来详细讲解一下打法。高抛打法是一种力度相对不变，调整角度的打法。在无风状态下，发射力度95，调整角度。角度的度数为90-你与对方的距离。");			
			var command4:CreateMonsterCommand = new CreateMonsterCommand();
			command4.excuteFunArr.push((_host.waitAttack as Function));
			var command5:TimeCommand = new TimeCommand(2000);
			var command6:PopupFrameCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.EasyHighThrow.command5"),null);
			command6.completeFunArr.push(_host.openShowTurn as Function);
			command6.completeFunArr.push(_host.skip as Function);
			var command7:WaittingCommand = new WaittingCommand(null);
//			var command5:PopUpFrameWaitCommand = new PopUpFrameWaitCommand("我们首先将角度调整到90附近，然后来刚才的角度公式实际操作一下。",(_host.waitAttack as Function));
			var command8:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighThrow.EasyHighThrow.command6"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),startTrain,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
//			var command6:BaseFightLibCommand = new PopupFrameCommand("恭喜你打中了，现在您可以选择开始测试，或再看一遍讲解。",null,null,"再看一次",restart,true,true);
			command8.excuteFunArr.push(_host.closeShowTurn as Function);
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
//			_host.skip();
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