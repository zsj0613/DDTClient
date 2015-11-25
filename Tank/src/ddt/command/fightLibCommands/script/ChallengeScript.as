package ddt.command.fightLibCommands.script
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.manager.LanguageMgr;

	public class ChallengeScript extends BaseScript
	{
		public function ChallengeScript(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.ChallengeScript"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("能到达这里的都是万中选一的勇士，在这里你将接受最严酷的挑战。准备好了吗？那就惦记开始挑战吧！");
			command1.completeFunArr.push(startTrain);
			_commonds.push(command1);
			//			_commonds.push(command2);
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
			_host.blockExist();
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