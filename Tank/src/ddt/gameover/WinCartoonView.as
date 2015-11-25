package ddt.gameover
{
	import flash.display.DisplayObject;
	
	import game.crazyTank.view.LevelUpFaileMC;
	import game.crazyTank.view.LevelUpStandMC;
	
	import ddt.data.game.Player;
	import tank.game.over.winCartoonAsset;
	import ddt.view.characterII.ICharacter;
	import ddt.view.characterII.ShowCharacter;
	
	public class WinCartoonView extends CartoonView
	{
		
		public function WinCartoonView()
		{
			super(new winCartoonAsset());
			mouseChildren = mouseEnabled = false;
		}
		
		override public function addShowCharactor(players:Array):void
		{
			_actionType = ShowCharacter.WIN;
			super.addShowCharactor(players);
			for each(var info:Player in players)
			{
				var direction:int = 1;
				if(info.team == 1)
				{
					direction = -1;
				}
				_centerY = -175;
				_centerX = -70;
				setupPlayerPos(direction,45);
			}
//			setLvUpPos();
		}
		
		public function addShowNPC(dis:DisplayObject):void
		{
			_actionType = ShowCharacter.WIN;
			if(_npc == null)
			{
				_npc = new Array();
			}
			_asset.addChild(dis);
			_npc.push(dis);
			_centerX = 5 ;
			_centerY = -30;
			setupNPCPos();
		}
		
		public function showLvUp():void
		{
			setLvUpPos();
		}
	
		private function setLvUpPos():void
		{
			for(var i:int = 0;i<_players.length;i++)
			{
				if(_players[i]["isUpGrade"])
				{
					var player:ICharacter = _players[i].character;
					var lvmc:LevelUpStandMC = new LevelUpStandMC();
					_lvUpMcs.push(lvmc);
					_asset.addChild(lvmc);
					var d:int = 1;
					if(_players[i]["team"] == 1)
					{
						d = -1;
					}
					if(d == -1)
					{
						lvmc.x = player.x + 32;
					}else
					{
						lvmc.x  = player.x+33;
					}
					lvmc.y = player.y;
				}	
			}
		}
	}
}