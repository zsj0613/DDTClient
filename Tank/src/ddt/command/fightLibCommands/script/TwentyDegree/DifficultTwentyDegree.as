package ddt.command.fightLibCommands.script.TwentyDegree
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.script.BaseScript;

	public class DifficultTwentyDegree extends BaseScript
	{
		public function DifficultTwentyDegree(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand("欢迎来到20度打法高级场，在之前的训练中，我们给出的都是整数的屏距，如果遇到非整数的屏距，怎么办呢？");
			var command2:BaseFightLibCommand = new PopupFrameCommand("我们可以对屏距先进行估算，并算出所需近似力度，然后对力度进行一些微调。如果您理解了，可以点击开始训练按钮。","开始训练");
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