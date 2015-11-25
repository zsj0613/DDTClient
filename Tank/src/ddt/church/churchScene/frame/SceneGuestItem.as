package ddt.church.churchScene.frame
{
	import road.ui.controls.ISelectable;
	import road.utils.ComponentHelper;
	
	import tank.church.ChurchGuestItemAsset;
	import ddt.data.player.PlayerInfo;
	import ddt.view.common.LevelIcon;

	public class SceneGuestItem extends ChurchGuestItemAsset implements ISelectable
	{
		private var _info:PlayerInfo;
		
		public function SceneGuestItem(info:PlayerInfo)
		{
			_info = info;
			
			init();
		}
		
		private function init():void
		{
			var level:LevelIcon = new LevelIcon("s",_info.Grade,_info.Repute,_info.WinCount,_info.TotalCount,_info.FightPower);
			ComponentHelper.replaceChild(this,level_pos,level);
			name_txt.text = String(_info.NickName);
			name_txt.selectable = false;
			name_txt.mouseEnabled = false;
			sex_mc.gotoAndStop(_info.Sex ? 1 : 2);
			bg_mc.visible = false;
		}

		public function get id():int
		{
			return _info.ID;
		}
		
		public function get selected():Boolean
		{
			return bg_mc.visible;
		}
		public function set selected(value:Boolean):void
		{
			bg_mc.visible = value;
		}
		
		public function get info():PlayerInfo
		{
			return _info;
		}
		
		public function get Grade():int
		{
			return _info.Grade;
		}
		
		public function get BP():int
		{
			return _info.GP;
		}
		
		public function get Nick():String
		{
			return _info.NickName;
		}
		public function dispose() : void
		{
			_info = null;
			if(this.parent)this.parent.removeChild(this);
		}
	}
}