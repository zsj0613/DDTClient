package ddt.game.player
{
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.NickNameAsset;
	
	import ddt.data.game.Living;

	public class NickNameView extends NickNameAsset
	{
		private static var color_arr:Array = new Array(0x0057FF,0xEA0000,0xFF9900,0x84AF01,0x9662CA,0x996633,0xb96f6f,0x2c8585);
		public function NickNameView(info:Living)
		{
			nickName.autoSize = "left";
			if(info.playerInfo != null){
				nickName.text = info.playerInfo.NickName;
			}else{
				nickName.text = info.name;
			}
			var glow:GlowFilter = new GlowFilter();
			glow.blurX = 2;
			glow.blurY = 2;
			glow.strength = 100;
			glow.quality = 1;
			glow.color = 0x000000
			nickName.filters = [glow];
			setTxt(info.team);
		}
		
		private function setTxt(team:int):void
		{
			var format:TextFormat = new TextFormat();
			format.color = NickNameView.color_arr[team - 1];
			format.size = 12;
			format.font = "Arial";
			nickName.setTextFormat(format);
		}
		
	}
}