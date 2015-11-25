package ddt.view.effort
{
	import crazytank.view.effort.AchievementPointAsset;

	public class AchievementPointView extends AchievementPointAsset
	{
		private var num_e0:int;
		private var num_e1:int
		public function AchievementPointView(value:int)
		{
			
			if(value >= 10)
			{
				num_e1 = (value/10) % 10;
				this.numMc_e1.gotoAndStop(num_e1);
				num_e0 = (value - num_e1*10);
				(num_e0 == 0) ?  this.numMc_e0.gotoAndStop(10) : this.numMc_e0.gotoAndStop(num_e0);
			}else
			{
				this.numMc_e1.visible = false;
				num_e0 = value;
				(num_e0 == 0) ?  this.numMc_e0.gotoAndStop(10) : this.numMc_e0.gotoAndStop(num_e0);
				numMc_e0.x = 28
			}
		}
		
		public function dispose():void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}