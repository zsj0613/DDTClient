package ddt.gameLoad
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import game.crazyTank.view.roomloading.RoomLoadingItemAsset;
	
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.view.characterII.ShowCharacter;

	public class RoomLoadingItem extends RoomLoadingItemAsset
	{
		private static const COLORS:Array = ["blue","red"];
		
		private var _figure:Sprite;
		private var _id:int;
		private var _info:RoomPlayerInfo;
		
		public function RoomLoadingItem()
		{
			super();
			init();
		}
		
		private function init():void
		{
			color_mc.gotoAndStop(1);
			color_mc.visible = false;
			figure_pos.visible = true;
			name_txt.text = "";
			loading_mc.visible = false;
			ok_icon.visible = false;
			percent_txt.visible = false;
			figure_pos.scrollRect = new Rectangle(0,0,figure_pos.width,figure_pos.height);
		}
		
		public function set info(info:RoomPlayerInfo):void
		{
			if(_info)
			{
				_info.removeEventListener(RoomEvent.LOADING_PROGRESS,__progress);
				if(_info.character)
				{
					_info.character.playAnimation();
				}
				if(_figure != null)
				{
					if(_figure.parent)
						_figure.parent.removeChild(_figure);
					_figure = null;
				}
				init();
			}
			
			_info = info;
			
			if(_info)
			{
				_info.resetLoadingProgress();
				_info.character.showGun = false;
				_info.character.doAction(ShowCharacter.STAND);
				_info.character.x = 0;
				_info.character.y = 0;
				_info.character.scaleX = -1;
				_info.character.setShowLight(false,null);
				_info.character.stopAnimation();
				_figure = new Sprite();
				_figure.addChild(_info.character as Sprite);
				if(_info.info.getSuitsType() == 1)
				{
					_figure.x =  - 30;
					_figure.y =  5;
				}else
				{
					_figure.x =  - 30;
					_figure.y =  - 25;
				}
				figure_pos.addChild(_figure);
				
				name_txt.text = String(_info.info.NickName);
				
				loading_mc.visible = true;
				color_mc.visible = true;
				ok_icon.visible = false;
				color_mc.gotoAndStop(COLORS[_info.team - 1]);
				percent_txt.visible = true;
				
				_info.addEventListener(RoomEvent.LOADING_PROGRESS,__progress);
				__progress(null);
			}
		}
		
		public function get info():RoomPlayerInfo
		{
			return _info;
		}
		
		private function __progress(event:RoomEvent):void
		{
			if(!ok_icon.visible)
			{
				percent_txt.text = String(int(_info.loadingProgress)) + "%";
				if(_info.loadingProgress > 99)
				{
					ok_icon.visible = true;
					percent_txt.visible = false;
					loading_mc.visible = false;
				}
			}
		}
		
		
		public function dispose():void
		{
			if(_info)
			{
				_info.removeEventListener(RoomEvent.LOADING_PROGRESS,__progress);
				if(_info.character)_info.character.playAnimation();
			}
			info = null;
			
			if(_figure && _figure.parent)
				_figure.parent.removeChild(_figure);
			_figure = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}