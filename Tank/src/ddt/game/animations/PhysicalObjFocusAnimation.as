package ddt.game.animations
{
	import phy.object.PhysicalObj;
	
	import ddt.game.objects.SimpleBomb;

	public class PhysicalObjFocusAnimation extends BaseSetCenterAnimation
	{
		private var _phy:PhysicalObj;
		public function PhysicalObjFocusAnimation(phy:PhysicalObj,life:int = 100,offsetY:int = 0)
		{
			super(phy.x,phy.y +offsetY,life);
			_phy = phy;
			_level = AnimationLevel.MIDDLE;
		}
		
		override public function canReplace(anit:IAnimate):Boolean
		{
			var at:PhysicalObjFocusAnimation = anit as PhysicalObjFocusAnimation;
			//同为跟踪炸弹的动作，判断是否相同的炸弹
			if(at && at._phy != _phy)
			{
				if(_phy is SimpleBomb && at._phy is SimpleBomb)
				{
					if(!_phy.isLiving || SimpleBomb(_phy).info.Id > SimpleBomb(at._phy).info.Id)
					{
						return true;
					}else
					{
						return false;
					}
				}
			}
			return true;
		}
	}
}