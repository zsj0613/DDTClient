package ddt.game.player
{
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.ConsortiaNameAsset;
	
	import ddt.data.GameInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.GameManager;
	import ddt.manager.PlayerManager;

	public class ConsortiaNameView extends ConsortiaNameAsset
	{
		private static var color_arr:Array = new Array(0xEA0000,0x0057FF,0xFF9900,0x84AF01,0x9662CA,0x996633,0xb96f6f,0x2c8585);
		public var isShowIcon:Boolean;
		public function ConsortiaNameView(info:PlayerInfo)
		{
			consortiaName.autoSize = "left";
			consortiaName.text = info.ConsortiaName ? "<"+info.ConsortiaName+">" : "";

			var glow:GlowFilter = new GlowFilter();
			glow.blurX = 2;
			glow.blurY = 2;
			glow.strength = 100;
			glow.quality = 1;
			glow.color = 0x000000;
			consortiaName.filters = [glow];
			
			setTxt(info.ConsortiaID);
			
		}
		private function setTxt(consortiaID:int):void
		{
			var format:TextFormat = new TextFormat();
//			var cInfo:ConsortiaInfo = PlayerManager.Instance.Self.ConsortiaAllyList[consortiaID] as ConsortiaInfo;
//			if(cInfo)
			if(consortiaID != 0)
			{
				var game : GameInfo = GameManager.Instance.Current;
				var self : SelfInfo = PlayerManager.Instance.Self;
				if(self.ConsortiaID == 0 || self.ConsortiaID == consortiaID ||(game && game.gameType == 2))
				{
					format.color = 0x00FF00;
				}
				else
				{
					isShowIcon = true;
					format.color = 0xAD00FF;
				}
//				if(cInfo.State != 2)
//				{
//					format.color = 0x00FF00;
//				}else
//				{
//					isShowIcon = true;
//					format.color = 0xAD00FF;
//				}
			}else
			{
				format.color = 0x00FF00;
			}
			format.size = 12;
			format.font = "Arial";
			format.align = "left";
			consortiaName.setTextFormat(format);
		}
		
		override public function get width():Number
		{
			return consortiaName.width;
		}
	}
}