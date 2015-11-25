package ddt.command.fightLibCommands
{
	import flash.events.Event;
	
	import ddt.events.FightLibCommandEvent;
	import ddt.manager.SocketManager;
	
	public class CreateMonsterCommand extends BaseFightLibCommand
	{
		public function CreateMonsterCommand()
		{
		}
		
		override public function excute():void
		{
			SocketManager.Instance.out.createMonster();
			super.excute();
			finish();
		}
		
		override public function undo():void
		{
			SocketManager.Instance.out.deleteMonster();
			super.undo();
		}
	}
}