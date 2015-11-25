package ddt.command.fightLibCommands.script
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.ImmediateCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.PopupHFrameCommand;
	import ddt.command.fightLibCommands.WaittingCommand;
	import ddt.manager.LanguageMgr;

	public class FightLibGuideScripit extends BaseScript
	{
		public function FightLibGuideScripit(host:Object)
		{
			super(host);
		}
		
		override protected function initializeScript():void
		{
			var command1:PopupHFrameCommand = new PopupHFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.FightLibGuideScripit.welcome"),LanguageMgr.GetTranslation("ok"));
			var command2:WaittingCommand = new WaittingCommand(null);
			command2.excuteFunArr.push(_host.showGuide1 as Function);
			var command3:WaittingCommand = new WaittingCommand(null);
			command3.excuteFunArr.push(_host.showGuide2 as Function);
			var command4:ImmediateCommand = new ImmediateCommand();
			command4.excuteFunArr.push(_host.hideGuide as Function);
			_commonds.push(command1);
			_commonds.push(command2);
			_commonds.push(command3);
			_commonds.push(command4);
			super.initializeScript();
		}
	}
}