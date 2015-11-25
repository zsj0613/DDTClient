package ddt.game.objects
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import game.crazyTank.view.SmallMapPlayer2Asset;
	
	import phy.object.PhysicalObj;
	
	import road.utils.ClassUtils;
	
	import ddt.utils.DisposeUtils;

	public class SimpleObject extends PhysicalObj
	{
		protected var m_model:String;
		protected var m_action:String;
		protected var m_moive:MovieClip;
		
		private var _smallMapView:MovieClip;
		
		public function SimpleObject(id:int,type:int,model:String,action:String)
		{
			super(id,type);
			mouseChildren = false;
			mouseEnabled = false;
			scrollRect = null;
			m_model = model;
			m_action = action;
			creatMovie(m_model);
			playAction(m_action);
			initSmallMapView();
		}
		
		protected function creatMovie(model:String):void
		{
			var moive_class:Class = ClassUtils.getDefinition(m_model) as Class;
			if(moive_class)
			{
				m_moive = new moive_class();
				addChild(m_moive);
	//			trace("=======added mapThing:"+m_model);
			}
		}
		
		protected function initSmallMapView():void
		{
			if(layerType == 0) _smallMapView = new SmallMapPlayer2Asset();
			if(_smallMapView != null) 
			{
				_smallMapView.visible = false;
				_smallMapView["attrack_mc"].visible = false;
				_smallMapView["player_mc"].gotoAndStop(1);
			}
		}
		
		public override function get smallView():Sprite
		{
			return _smallMapView;
		}
		
		public function playAction(action:String):void
		{
			if(m_moive)
			{
				m_moive.gotoAndPlay(action);
			}
			if(_smallMapView != null) _smallMapView.visible = (action == "2");
		}
		
		override public function dispose ():void
		{
			super.dispose();
			if(m_moive && m_moive.parent)
				removeChild(m_moive);
			m_moive = null;
		}
	}
}