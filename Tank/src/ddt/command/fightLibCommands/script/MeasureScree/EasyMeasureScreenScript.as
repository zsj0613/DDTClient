package ddt.command.fightLibCommands.script.MeasureScree
{
	import road.ui.manager.TipManager;
	
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.CreateMonsterCommand;
	import ddt.command.fightLibCommands.IFightLibCommand;
	import ddt.command.fightLibCommands.ImmediateCommand;
	import ddt.command.fightLibCommands.PopUpFrameWaitCommand;
	import ddt.command.fightLibCommands.PopupFrameCommand;
	import ddt.command.fightLibCommands.TimeCommand;
	import ddt.command.fightLibCommands.script.BaseScript;
	import ddt.manager.LanguageMgr;
	import ddt.view.GreenArrow;

	/**
	 * 
	 * @author WickiLA
	 * @time 0602/2010
	 * @description 简单目测屏距的脚本
	 */
	public class EasyMeasureScreenScript extends BaseScript
	{
		private var _arrow:GreenArrow;
		
		public function EasyMeasureScreenScript(fightView:Object)
		{
			super(fightView);
		}
		
		override protected function initializeScript():void
		{
			var command1:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command1"));
//			var command1:BaseFightLibCommand = new PopupFrameCommand("欢迎来到测量屏距初级课程，在这里您将学习到最基础的屏距测量。");
			var command2:BaseFightLibCommand = new PopUpFrameWaitCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command2"),clearMaskAndArrow,null,null,null,null,false,false);
//			var command2:BaseFightLibCommand = new PopUpFrameWaitCommand("在小地图中有一个可拖动的白框，您可以尝试拖动一下。",(_host.clearMask as Function));
			command2.excuteFunArr.push(drawMaskAndWait);
			var command3:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command3"));
//			var command3:BaseFightLibCommand = new PopupFrameCommand("对了，就是这样。白框最左到最右是大地图中一个屏幕的宽度。我们称为1屏。");
			var command4:BaseFightLibCommand = new ImmediateCommand();
			command4.excuteFunArr.push(_host.splitSmallMapDrager as Function);
			var command5:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command5"));
//			var command5:BaseFightLibCommand = new PopupFrameCommand("将这一屏分为10等份，每份称为1距。鼠标拖动白框放在人物点的中间，测量自己与敌方的距离。下面我们来实际演示一下~");
			var command6:CreateMonsterCommand = new CreateMonsterCommand();
			command6.excuteFunArr.push(_host.blockSmallMap as Function);
			var command7:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command7"));
//			var command7:BaseFightLibCommand = new PopupFrameCommand("现在我们来看一下，对方的位置是多少呢？我们来看一下");
			var command8:BaseFightLibCommand = new TimeCommand(13500);
			command8.excuteFunArr.push(_host.shineText as Function);
			var command9:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command9"),LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.startTrain"),null,LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
//			var command9:BaseFightLibCommand = new PopupFrameCommand("屏距是5距。怎么样，看明白了吗？","开始训练",null,"再看一次",restart,true,true);
			command9.excuteFunArr.push(_host.restoreSmallMap as Function);
			command9.completeFunArr.push(_host.restoreText as Function);
			command9.completeFunArr.push(_host.hideSmallMapSplit as Function);
			command9.completeFunArr.push(_host.activeSmallMap as Function);
			command9.undoFunArr.push(_host.restoreText as Function);
			command9.undoFunArr.push(_host.hideSmallMapSplit as Function);
			command9.undoFunArr.push(_host.activeSmallMap as Function);
			var command10:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("ddt.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command10"));
//			var command10:BaseFightLibCommand = new PopupFrameCommand("下面我们来开始初级场的训练");
			command10.completeFunArr.push(_host.enableReanswerBtn as Function);
			_commonds.push(command1);
			_commonds.push(command2);
			_commonds.push(command3);
			_commonds.push(command4);
			_commonds.push(command5);
			_commonds.push(command6);
			_commonds.push(command7);
			_commonds.push(command8);
			_commonds.push(command9);
			_commonds.push(command10);
//			_commonds.push(command11);
			super.initializeScript();
		}
		
		override public function start():void
		{
			_host.sendClientScriptStart();
			super.start();
		}
		
		public function drawMaskAndWait():void
		{
			_host.drawMasks();
			_arrow = new GreenArrow();
			_arrow.rotation = -135;
			_arrow.x = 910;
			_arrow.y = 120;
			TipManager.AddTippanel(_arrow);
			_host.screanAddEvent();
		}
		
		public function clearMaskAndArrow():void
		{
			_host.clearMask();
			_arrow.stop();
			TipManager.RemoveTippanel(_arrow);
		}
		
		public function splitSmallMapDrager():void
		{
			_host.splitSmallMapDrager();
		}
		
		override public function finish():void
		{
			super.finish();
			_host.sendClientScriptEnd();
			_host.enableExist();
		}
	}
}