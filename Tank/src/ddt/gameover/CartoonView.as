package ddt.gameover
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	
	import ddt.data.game.Player;
	import ddt.view.characterII.ICharacter;
	import ddt.view.characterII.ShowCharacter;

	public class CartoonView extends Sprite
	{
		protected var _asset:Sprite;
		
		protected var _players:Array;
		
		protected var _centerX:Number;
		
		protected var _centerY:Number;
		
		protected var _actionType:String;
		
		protected var _lvUpMcs:Array = [];
		
		protected var _npc:Array;
		public function CartoonView(bg:Sprite)
		{
			_asset = bg;
			_asset.mouseEnabled = false;
			_asset.mouseChildren = false;
			if(_asset is MovieClip)
				(_asset as MovieClip).gotoAndStop(1);
			addChild(_asset);
			_players = new Array();
		}
		
		
		private function clearAsset():void
		{
			while(_asset.numChildren >0)
			{
				_asset.removeChildAt(0);
			}
		}
		
		public function addShowCharactor(players:Array):void
		{
			for each(var info:Player in players)
			{
				var charactor:ICharacter = info.character;
				charactor.y = - 173;
				charactor.showGun = false;
				_asset.addChild(charactor as DisplayObject);
				_players.push(info);
			}
		}
		
		
		protected function setupPlayerPos(direction:int,itemWidth:Number):void
		{
			var lenth:int = _players.length;
			var itemTotalWidth:Number = itemWidth*(lenth);
			for(var i:int = 0;i<lenth;i++)
			{
				var player:ShowCharacter = _players[i].character;
				player.scaleX = direction;
				player.setShowLight(false);
				player.doAction(_actionType);
				player.y = _centerY;
				var xPos:Number = itemWidth*(i+1) - itemTotalWidth/2;
				player.x = xPos + _centerX;
			}
		}
		
		private var _tempNpcWidths:Array = [];
		
		protected function setupNPCPos():void
		{
			var totalWidth:Number = 0;
			for(var i:int = 0;i<_npc.length;i++)
			{
				_npc[i].gotoAndStop(_actionType);
				_tempNpcWidths[i] = _npc[i].width;
				totalWidth += _npc[i].width;
				_npc[i].addEventListener(Event.ENTER_FRAME,__checkRealWidth);
			}
			var currentX:Number = 0;
			
			for(var j:int = 0;j < _npc.length;j++)
			{
				var disobj:MovieClip = _npc[j] as MovieClip;
				closeSound(disobj);
				disobj.scaleX = 1;
				var xPos:Number = _centerX - totalWidth / 2 + currentX + disobj.width / 2;
				disobj.x = xPos;
//				currentX += (_npc[j].width * 1.3);// 资源内Boss怪物为水平剧中,右移1/3宽度
				currentX += (_npc[j].width);// 资源内Boss怪物为水平剧中,右移1/3宽度
				disobj.y = _centerY;
			}
		}
		
		private function __checkRealWidth(event:Event):void
		{
			if(_npc == null) return;
			var index:int = _npc.indexOf(event.currentTarget);
			var child:DisplayObject = _npc[index].getChildAt(0);
			if(child)
			{
				setupNPCPos();
				_npc[index].removeEventListener(Event.ENTER_FRAME,__checkRealWidth);
			}
		}
		
		
		private function closeSound(mc : MovieClip) : void
		{
			var sound : SoundTransform = new SoundTransform();
			sound.volume = 0;
			mc.soundTransform = sound;
		} 
		
		public function doPosTrace():void
		{
			for(var i:int = 0;i<_asset.numChildren;i++)
			{
				var ani:DisplayObject =  _asset.getChildAt(i);
			}
		}
		
		
		public function dispose():void
		{
			if(_npc)
			{
				for(var j:int = 0; j < _npc.length; j++)
				{
					if(_npc[j] && _npc[j].parent)
					{
						_npc[j].removeEventListener(Event.ENTER_FRAME,__checkRealWidth);
						_npc[j].parent.removeChild(_npc[j]);
					}
					_npc[j] = null;
				}
			}
			if(_lvUpMcs)
			{
				for(var i:int = 0;i<_lvUpMcs.length;i++)
				{
					_lvUpMcs[i]["lv_mc"]["lv_mc_init"]["video"].clear();
				}
			}
			clearAsset();
			_players = null;
			_npc = null;
			_lvUpMcs = null;
			if(parent)parent.removeChild(this);
			_asset = null;
		}
	}
}