package ddt.game.objects
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import game.crazyTank.view.SmallBoxAsset;
	import phy.object.PhysicalObj;
	import road.display.MovieClipWrapper;
	import road.manager.SoundManager;
	import ddt.game.map.MapView;
	import tank.game.objects.*;
	
	/**
	 * 1、黄色宝箱，2、红色宝箱，3、粽子，4、月饼、5、南瓜
	 * */

	public class SimpleBox extends SimpleObject
	{
		private var _box:MovieClipWrapper;
		private var _smallBox:Sprite;
		private var _boxClasses:Array = [BoxAsset01,BoxAsset02,BoxAsset03,BoxAsset04,BoxAsset05];
		override public function get smallView():Sprite
		{
			return _smallBox;
		}
		
		public function SimpleBox(id:int,model:String)
		{
			super(id,1,model,"");
			_canCollided = true;
			_smallBox = new SmallBoxAsset();
			_box.addEventListener(Event.COMPLETE,__complete);
			setCollideRect(-10,-10,20,20);
		}
		
		override protected function creatMovie(model:String):void
		{
			_box = createBoxView(model);
			addChild(_box);
		}
		
		public override function collidedByObject(obj:PhysicalObj):void
		{
			if(obj is SimpleBomb)
			{
				SimpleBomb(obj).owner.pick(Id);
				die();
			}
		}
		
		override public function die():void
		{
			_canCollided = false;
			_box.gotoAndPlay("finish");
			SoundManager.instance.play("018");
			super.die();
		}
		
		private function __complete(event:Event):void
		{
			if(_map)
			{
				MapView(_map).removePhysical(this);
			}
		}
		
		private function createBoxView(model:String):MovieClipWrapper
		{
			var asset:MovieClip = new  _boxClasses[int(model)-1] as MovieClip;
//			asset.mc_box.gotoAndStop(int(model));
			return new MovieClipWrapper(asset,true,true);
		}
		
		override public function isBox():Boolean
		{
			return true;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_box.removeEventListener(Event.COMPLETE,__complete);
			if(_map)
			{
				_map.removePhysical(this);
			}
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
	}
}