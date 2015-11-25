package ddt.command.fightLibCommands.script.HighGap
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	
	public class EasyHighGap extends BaseScript
	{
		public function EasyHighGap(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighGap.EasyHighGap.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("之前我们学习都是如何打同一水平线的敌人，但是实战中，经常出现高度差，这时候就需要考虑到高差的影响。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighGap.EasyHighGap.command2"));
//			var command2:BaseFightLibCommand = new PopupFrameCommand("对于高差没有固定的公式来计算，但是可以通过对力度的调整来，一般来说，对方位置比你低，就需要在计算出力度的基础上减少一些力度。");
			var command3:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.HighGap.EasyHighGap.command3"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),startTrain,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
//			var command3:BaseFightLibCommand = new PopupFrameCommand("反过来，对方位置比你高，就需要在计算出力度的基础上减少一些力度。准备好后，请点击开始训练。","开始训练");
			_commonds.push(command1);
			_commonds.push(command2);
			_commonds.push(command3);
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