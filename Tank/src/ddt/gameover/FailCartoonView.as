package ddt.gameover
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.media.SoundTransform;
	
	import game.crazyTank.view.LevelUpFaileMC;
	
	import ddt.data.game.Player;
	import tank.game.over.failCartoonAsset;
	import ddt.view.characterII.ICharacter;
	import ddt.view.characterII.ShowCharacter;
	
	public class FailCartoonView extends CartoonView
	{
		public function FailCartoonView()
		{
			super(new failCartoonAsset());
		}
	
		override public function addShowCharactor(players:Array):void
		{
			_actionType = ShowCharacter.LOST;
			super.addShowCharactor(players);
			for each(var info:Player in players)
			{
				var direction:int = 1;
				if(info.team == 1)
				{
					direction = -1;
				}
				_centerY = -146;
				_centerX = -77;
				setupPlayerPos(direction,45);
			}
//			setLvUpPos();
		}
		private function closeSound(mc : MovieClip) : void
		{
			var sound : SoundTransform = new SoundTransform();
			sound.volume = 0;
			mc.soundTransform = sound;
		} 
		
		public function addShowNPC(dis:DisplayObject):void
		{
			_actionType = "lost";
			if(_npc == null)
			{
				_npc = new Array();
			}
			
			_asset.addChild(dis);
			_npc.push(dis);
			var len:int = _npc.length;
			var direction:int = 1;
			_centerX = -7;
			_centerY = -5;
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
					var lvmc:LevelUpFaileMC = new LevelUpFaileMC();
					_lvUpMcs.push(lvmc);
					_asset.addChild(lvmc);
					var d:int = 1;
					if(_players[i]["team"] == 1)
					{
						d = -1;
//						lvmc.scaleX = -1;
					}
					if(d == -1)
					{
						lvmc.x = player.x + 30;
					}else
					{
						lvmc.x  = player.x+24;
					}
					lvmc.y = player.y;
				}
			}
		}
	}
}