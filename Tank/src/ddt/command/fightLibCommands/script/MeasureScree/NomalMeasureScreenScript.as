package ddt.command.fightLibCommands.script.MeasureScree
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

	/**
	 * 
	 * @author WickiLA
	 * @time 0602/2010
	 * @description 普通目测屏距的脚本
	 */
	public class NomalMeasureScreenScript extends BaseScript
	{
		public function NomalMeasureScreenScript(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("上节课我们学习了1屏以内的屏距测量，那么超过一屏的怎么测呢？这节课我们来学习一下吧。");
			var command2:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript.command2"));
			command2.excuteFunArr.push(_host.blockSmallMap as Function);
//			var command2:BaseFightLibCommand = new PopupFrameCommand("如果超出10距，可以记住10距在地图上的点位，在拖动白框到那个点位来测量，两次测量距离相加之和为双方之间的距离。我们来实际演示一下~");
			var command3:CreateMonsterCommand = new CreateMonsterCommand();
			var command4:TimeCommand = new TimeCommand(2000);
			command4.completeFunArr.push(_host.leftJustifyWithPlayer);
			command4.completeFunArr.push(_host.addRedPointInSmallMap as Function);
			command4.undoFunArr.push(_host.removeRedPointInSmallMap as Function);
			var command5:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript.command4"));
//			var command4:BaseFightLibCommand = new PopupFrameCommand("现在我们来看一下，在白框的另一边，也就是1屏的距离。记住这个位置。");
			
			
			var command6:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript.command5"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),null,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
			command6.excuteFunArr.push(_host.leftJustifyWithRedPoint as Function);
//			var command5:BaseFightLibCommand = new PopupFrameCommand("记住后将白框左边对齐这里，再看一下，这次是3距，加在一起就是13距","开始训练",null,"再看一次",restart,true,true);
			command6.completeFunArr.push(_host.removeRedPointInSmallMap as Function);
			command6.completeFunArr.push(_host.activeSmallMap as Function);
			var command7:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript.command6"));
//			var command6:BaseFightLibCommand = new PopupFrameCommand("下面我们来开始中级场的训练");
			command7.completeFunArr.push(_host.enableReanswerBtn as Function);
			
			_commonds.push(command1);
			_commonds.push(command2);
			_commonds.push(command3);
			_commonds.push(command4);
			_commonds.push(command5);
			_commonds.push(command6);
			_commonds.push(command7);
//			_commonds.push(command8);
//			_commonds.push(command9);
//			_commonds.push(command10);
//			_commonds.push(command11);
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