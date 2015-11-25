package ddt.view.effort
{
	import flash.events.Event;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.Config;
	import ddt.data.effort.EffortInfo;
	import tank.view.effort.EffortMovieClipAsset

	public class EffortMovieClipView extends EffortMovieClipAsset
	{
		private var _info:EffortInfo;
		private var alphaArray:Array = [ 0 , 0 , 0.2 , 0.3 , 0.35 , 0.4  ,0.45  ,0.5  ,0.55  ,0.6  ,0.66 ,
										 0.7 ,0.7 ,0.7 ,0.65 ,0.5 ,0.4 ,0.3 ,0.4 ,0.5 ,0.6 ,0.8 ,1 ];
		public static const MOVIE_END:String = "MovieEnd";
		private var _achievementPointView:AchievementPointView;
		public function EffortMovieClipView(info:EffortInfo)
		{
			super();
			_info = info;
			init();
			initEvent();
		}
		
		private function init():void
		{
			content_txt.text = _info.Title;
			_achievementPointView   = new AchievementPointView(_info.AchievementPoint)
			_achievementPointView.x = achievementPoint_pos.x;
			_achievementPointView.y = achievementPoint_pos.y;
			this.addChild(_achievementPointView);
			x = (Config.GAME_WIDTH) / 2 - this.width/2 + 65;
			y = (Config.GAME_HEIGHT) / 2 - this.height/2;
			TipManager.AddTippanel(this);
			this.play();
			SoundManager.instance.play("121");
		}
		
		private function initEvent():void
		{
			addEventListener(Event.ENTER_FRAME , __cartoonFrameHandler);
		}
		
		private function setAlpha():void
		{
			content_txt.alpha    = alphaArray[this.currentFrame];
			_achievementPointView.alpha = alphaArray[this.currentFrame];
		}
		
		private function __cartoonFrameHandler(evt:Event):void
		{
			if(this.currentFrame <= 22)
			{
				setAlpha();
			}
			if(this.currentFrame == this.totalFrames)
			{
				end();
				dispatchEvent(new Event(MOVIE_END));
			}
		}
		
		private function end():void
		{
			gotoAndStop(this.totalFrames);
			dispose();
		}
		
		public function dispose():void
		{
			TipManager.RemoveTippanel(this);
			if(_achievementPointView)
			{
				_achievementPointView.parent.removeChild(_achievementPointView);
				_achievementPointView.dispose();
			}
			_achievementPointView = null;
		}
	}
}