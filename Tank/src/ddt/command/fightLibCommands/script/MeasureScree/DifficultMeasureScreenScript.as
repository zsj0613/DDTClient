package ddt.command.fightLibCommands.script.MeasureScree
{
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.CreateMonsterCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.TimeCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;

	/**
	 * 
	 * @author WickiLA
	 * @time 0602/2010
	 * @description 高级的目测屏距脚本
	 */
	public class DifficultMeasureScreenScript extends BaseScript
	{
		public function DifficultMeasureScreenScript(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.DifficultMeasureScreenScript.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("之前我们学习了比较规则的屏距测量，那么遇见非整数距该怎么算？。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.DifficultMeasureScreenScript.command2"));
//			var command2:BaseFightLibCommand = new PopupFrameCommand("如果屏距不是整数距，我们可以按最近的整数屏距计算。看个实例吧~");
			var command3:CreateMonsterCommand = new CreateMonsterCommand();
			var command4:TimeCommand = new TimeCommand(2000);
			command4.completeFunArr.push(_host.leftJustifyWithPlayer);
			var command5:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.DifficultMeasureScreenScript.command4"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),null,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
//			var command4:BaseFightLibCommand = new PopupFrameCommand("现在我们来看一下，您与NPC之间的距离在10~11之间，并且离10距比较近，那我们就把他当做10距来计算","开始训练",null,"再看一次",restart,true,true);
			command5.excuteFunArr.push(_host.leftJustifyWithPlayer as Function);
			var command6:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.DifficultMeasureScreenScript.command5"));
//			var command5:BaseFightLibCommand = new PopupFrameCommand("下面我们来开始稿级场的训练");
			command6.completeFunArr.push(_host.enableReanswerBtn as Function);
			
			_commonds.push(command1);
			_commonds.push(command2);
			_commonds.push(command3);
			_commonds.push(command4);
			_commonds.push(command5);
			_commonds.push(command6);
			super.initializeScript();
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