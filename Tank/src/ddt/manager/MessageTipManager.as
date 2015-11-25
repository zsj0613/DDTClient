package ddt.manager
{
	import flash.display.Sprite;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.Config;
	import tank.view.NoEnergyAsset;

	/**
	 * 简单游戏中的提示 
	 * @author SYC
	 * 
	 */
	public class MessageTipManager extends Sprite
	{
		private static var instance:MessageTipManager;
		
		private var _cartoon:NoEnergyAsset;
		
//		private var _isPlaying:Boolean;
		
		public function MessageTipManager()
		{
			//init();
			addEvent();
		}
		
		public static function getInstance():MessageTipManager
		{
			if(instance == null )
			{
				instance = new MessageTipManager();
			}
			return instance;
		}
		
		private function init():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			_cartoon = new NoEnergyAsset();
			_cartoon.mouseEnabled = false;
			_cartoon.mouseChildren = false;
			addChild(_cartoon);
			_cartoon.addFrameScript(_cartoon.totalFrames - 1,end);
			setCenter();
		}
		
		private function addEvent():void
		{
			
		}
		
		private function removeEvent():void
		{
			
		}
		
		private function dispose():void
		{
			removeEvent();
			if(_cartoon.parent)removeChild(_cartoon);
			_cartoon = null;
		}
		
		private function end():void
		{
			_cartoon.gotoAndStop(_cartoon.totalFrames);
			hide();
		}
		
		
		private function setCenter():void
		{
			x = (Config.GAME_WIDTH) / 2;
			y = (Config.GAME_HEIGHT) / 2;
		}
		
		private function setContent(t:String):void
		{
			_cartoon.tip_mc.tip_txt.text = t;
		}
		
		public function show(t:String,isReplace:Boolean = true):void
		{
			if(isReplace)
			{
				if(_cartoon == null)
				{
					init();
				}
				_cartoon.gotoAndPlay(1);
				setContent(t);
				TipManager.AddTippanel(this);
			}
			else
			{
				if(_cartoon == null)
				{
					init();
					_cartoon.gotoAndPlay(1);
					setContent(t);
					TipManager.AddTippanel(this);
				}
			}
			
			if(parent)
			{
				parent.mouseEnabled = false;
			}
		}
		
		public function hide():void
		{
			dispose();
			instance = null;
			if(parent)
			{
				parent.mouseEnabled = true;
			}
			if(parent)
			{
				TipManager.RemoveTippanel(this);
			}
		}
		
	}
}