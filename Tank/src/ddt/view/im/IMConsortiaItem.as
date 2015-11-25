package ddt.view.im
{
	import game.crazyTank.view.common.SexIconAsset;
	
	import ddt.view.common.LevelIcon;
	public class IMConsortiaItem extends IMFriendItem
	{
		public function IMConsortiaItem(info:Object)
		{
			super(info);
		}
		
		override protected function init():void
		{
			super.init();
//			buttonMode = true;
			_info.State == 1 ? icon.gotoAndStop(1) : icon.gotoAndStop(2);
			name_txt.text = String(info.info.NickName);
			name_txt.mouseEnabled = false;
//			dutyName_txt.visible = true;
			if(info.info.DutyName.length  == 2)
			{
//				dutyName_txt.text = info.info.DutyName.substr(0,1)+"   "+info.info.DutyName.substr(1,1);
			}else
			{
//				dutyName_txt.text = String(info.info.DutyName);
			}
			_level_icon = new LevelIcon("s",_info.info.Grade,_info.info.Repute,_info.info.WinCount,_info.info.TotalCount,_info.info.FightPower);
			_sex_icon = new SexIconAsset();
			delete_btn.visible = false;
		}
	}
}