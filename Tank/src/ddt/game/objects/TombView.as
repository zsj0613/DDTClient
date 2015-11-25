package ddt.game.objects
{
	import flash.geom.Rectangle;
	
	import game.crazyTank.view.TombAsset;
	
	import phy.object.PhysicalObj;

	/**
	 * 坟墓 
	 * @author SYC
	 * 
	 */
	public class TombView extends PhysicalObj
	{
		private var _asset:TombAsset;
		
		public function TombView()
		{
			super(-1,1,5,50);
			_testRect = new Rectangle(-3,3,6,3);
			_canCollided = true;
			initView();
		}
		
		private function initView():void
		{
			mouseChildren = mouseEnabled = false;
			_asset = new TombAsset();
			_asset.y = 3;
			addChild(_asset);
		}
		
		override public function die():void
		{
			super.die();
			_map.removePhysical(this);
		}
		
		override public function stopMoving():void
		{
			super.stopMoving();
			_asset.rotation = calcObjectAngle();
		}
		override public function dispose():void
		{
			if(_map)
			{
				_map.removePhysical(this);
			}
			if(parent)
			{
				parent.removeChild(this);
			}
			removeChild(_asset);
			_testRect=null;
			super.dispose();
		}
	}
}