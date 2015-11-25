package ddt.view.characterII
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.crazyTank.view.common.FigureBGAsset;
	
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;

	public class ShowCharacter extends BaseCharacter
	{
		public static const STAND:String = "stand";
		public static const WIN:String = "win";
		public static const LOST:String = "lost";
		
		private var _showLight:Boolean;
		private var _lightPos:Point;
		private var _light1: MovieClip;
		private var _light2 : MovieClip;
		private var _light01 : BaseLightLayer;
		private var _light02 : SinpleLightLayer;
		private var _loading:FigureBGAsset;
		private var _showGun:Boolean;
		private var _characterWithWeapon:BitmapData;
		private var _characterWithoutWeapon:BitmapData;
		private var _wing:MovieClip;
		
		private var _currentAction:String;
		private var _recordNimbus:int;
		public function ShowCharacter(info:PlayerInfo)
		{
			super(info,false);
			_showGun = true;
			_loading = new FigureBGAsset();
			_container.addChild(_loading);
			_currentAction = STAND;
		}
		private function __propertyChangeII(evt:PlayerPropertyEvent):void
		{
			if(evt.changedProperties[PlayerInfo.NIMBUS])
			{
				updateLight();
			}
		}
		
		override public function set showGun(value:Boolean):void
		{
			if(value == _showGun) return; 
			_showGun = value;
			updateCharacter();
		}
		
		override protected function initLoader():void
		{
			_loader = _factory.createLoader(_info,CharacterLoaderFactory.SHOW);
		}
		
		override public function set scaleX(value:Number):void
		{
			super.scaleX = _dir = value;
			if(!_loadCompleted)
			{
				if(value == 1)_loading.loading1.visible = true;
				else _loading.loading1.visible = false;
				_loading.loading2.visible = !_loading.loading1.visible;
			}
			_container.x = value < 0 ? -_characterWidth : 0;
		}
		
		override public function setShowLight(b:Boolean,p:Point = null):void
		{
			if(_showLight == b && _lightPos == p)return;
			_showLight = b;
			if(b)
			{
				if(p == null)
				{
					p = new Point(0,0);
				}
				_lightPos = p;
			}
			updateLight();
		}
		
		private function stopMovieClip(mc:MovieClip):void
		{
			if(mc)
			{
				mc.gotoAndStop(1);
				if(mc.numChildren>0)
				{
					for(var i:int=0; i< mc.numChildren; i++)
					{
						stopMovieClip(mc.getChildAt(i) as MovieClip);
					}
				}
			}
		}
		
		private function playMovieClip(mc:MovieClip):void
		{
			if(mc)
			{
				mc.gotoAndPlay(1);
				if(mc.numChildren>0)
				{
					for(var i:int=0; i< mc.numChildren; i++)
					{
						playMovieClip(mc.getChildAt(i) as MovieClip);
					}
				}
			}
		}
		
		private function stopWing():void
		{
			stopMovieClip(_wing);
		}
		
		private var _playAnimation:Boolean = true;;
		public function stopAnimation():void
		{
			_playAnimation = false;
			stopAllMoiveClip();
		}
		
		public function playAnimation():void
		{
			_playAnimation = true;
			playAllMoiveClip();
		}
		
		private function stopAllMoiveClip():void
		{
			stopMovieClip(_light1);
			stopMovieClip(_light2);
			stopWing();
		}
		
		private function playAllMoiveClip():void
		{
			playMovieClip(_light1);
			playMovieClip(_light2);
			playMovieClip(_wing);
		}
		
		private function restoreAnimationState():void
		{
			if(_playAnimation)
			{
				playAllMoiveClip();
			}else
			{
				stopAllMoiveClip();
			}
		}
		
		public function drawBitmapWithWingAndLight():void
		{
			if(_container == null || !_loadCompleted)return;
			
			stopAllMoiveClip();
			
			var _originalX:int = _container.x;
			var _originalY:int = _container.y;
			
			var pContainer:DisplayObjectContainer = _container.parent;
			var pIndex:int = pContainer.getChildIndex(_container);
			var clipRect:Rectangle = _container.getBounds(_container);
			
			var tmpContainer:Sprite = new Sprite();
			
			pContainer.removeChild(_container);
			
			_container.x = -clipRect.x * _container.scaleX;
			_container.y = -clipRect.y * _container.scaleX;
			
			tmpContainer.addChild(_container);
			
			var bitmapdata:BitmapData = new BitmapData(tmpContainer.width,tmpContainer.height,true,0);
			bitmapdata.draw(tmpContainer);
			
			var bitmap:Bitmap = new Bitmap(bitmapdata,"auto",true);
			
			tmpContainer.removeChild(_container);
			tmpContainer.addChild(bitmap);
			_container.x = _originalX;
			_container.y = _originalY;
			
			pContainer.addChildAt(_container, pIndex);
			
			if(tmpContainer.width > 140)
			{
				tmpContainer.x = tmpContainer.width - 17;
			}
			else
			{
				tmpContainer.x = tmpContainer.width;
			}
			
			_staticBmp = tmpContainer;
			
			restoreAnimationState();
		}
		
		public function getShowBitmapBig():DisplayObject
		{
			if(_staticBmp == null)
			{
				drawBitmapWithWingAndLight();
			}
			
			return _staticBmp;
		}
		
		public function resetShowBitmapBig():void
		{
			if(_staticBmp && _staticBmp.parent)
				_staticBmp.parent.removeChild(_staticBmp);
			_staticBmp = null;
		}
		
		private var _light2Update:Boolean = false;
		private var _light1Update:Boolean = false;
		private function updateLight():void
		{
			if(_info == null)return;
			if(_showLight && currentAction == STAND)
			{
				_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChangeII);
				if(_recordNimbus != _info.Nimbus)
				{
					_recordNimbus = _info.Nimbus;
					if(_info.getHaveLight())
					{
						_light2Update = true;
						deleteMC([_light2]);
						_light2 = null;
						if(_light02) _light02.dispose();
						_light02 = new SinpleLightLayer(_info);
						_light02.load(callBack02);
					}
					else
					{
						deleteMC([_light2]);
						_light2 = null;
					}
					if(_info.getHaveCircle())
					{
						_light1Update = true;
						deleteMC([_light1]);
						_light1 = null;
						if(_light01) _light01.dispose();
						_light01 = new BaseLightLayer(_info);
						_light01.load(callBack01);
					}else
					{
						deleteMC([_light1]);
						_light1 = null;
					}
				}
			}else
			{
				_recordNimbus = 0;
				deleteMC([_light1,_light2]);
				_light1 = null;
				_light2 = null;
			}
		}
		
		private function callBack01($load : BaseLightLayer) : void
		{
			_light1 = $load.getContent() as MovieClip;
			
			_container.addChildAt(_light1,0);
			_light1.x = _lightPos.x + 48;
			_light1.y = _lightPos.y + 64;
			
			drawBitmapWithWingAndLight();
			_light1Update = false;
			restoreAnimationState();
		}
		private function callBack02($load : SinpleLightLayer) : void
		{
			_light2 = $load.getContent() as MovieClip;
			
			_container.addChild(_light2);
			_light2.x = _lightPos.x + 50;
			_light2.y = _lightPos.y + 127;
			
			drawBitmapWithWingAndLight();
			_light2Update = false;
			restoreAnimationState();
		}

		private function deleteMC(mcs:Array):void
		{
			for(var i:int = 0; i < mcs.length; i++)
			{
				var mc:MovieClip = mcs[i] as MovieClip;
				if(mc != null)
					if(mc.parent)mc.parent.removeChild(mc);
			}
		}
		
		private function updateCharacter():void
		{
			if(_loader != null && _loader.getContent()[0] != null)
			{
				__loadComplete(_loader);
			}else
			{
				setContent();
			}
		}
		
		override protected function setContent():void
		{
			if(_loader != null)
			{
				var t:Array = _loader.getContent();
				if(_characterWithWeapon && _characterWithWeapon != t[0])
					_characterWithWeapon.dispose();
				if(_characterWithoutWeapon && _characterWithoutWeapon != t[1])
					_characterWithWeapon.dispose();
				_characterWithWeapon = t[0];
				_characterWithoutWeapon = t[1];
				if(_wing && _wing.parent)
				{
					_wing.parent.removeChild(_wing);
				}
				_wing = t[2];
			}
			if(_showGun) 
			{
				characterBitmapdata = _characterWithWeapon;
			}else
			{
				characterBitmapdata = _characterWithoutWeapon;
			}
			doAction(_currentAction);
			drawBitmapWithWingAndLight();
		}
		
		private function addWing():void
		{
			if(_wing == null) return;
			if(_wing.parent) return;
			var bodyIndex:int = _container.getChildIndex(_body);
			if(_info.getSuitsType() == 1)
			{
				_wing.y = -48;
			}else
			{
				_wing.y = 0;
			}
			
			_container.addChildAt(_wing,bodyIndex);
		}
		
		public function removeWing():void
		{
			if(_wing && _wing.parent)
			{
				_wing.parent.removeChild(_wing);
			}
		}
		
		override protected function __loadComplete(loader:ICharacterLoader):void
		{
			if(_loading != null)
			{
				if(_loading.parent)_loading.parent.removeChild(_loading);
			}
			super.__loadComplete(loader);
			updateLight();
		}
		
		override public function doAction(actionType:*):void
		{
			_currentAction = actionType;
			if(_info.getSuitsType() == 1)
			{
				_body.y = -13;
			}else
			{
				_body.y = 0;
			}
			
			
			switch(_currentAction)
			{
				case ShowCharacter.STAND:
					drawFrame(0);
					addWing();
					break;
				case ShowCharacter.WIN:
					drawFrame(1);
					removeWing();
					break;
				case ShowCharacter.LOST:
					drawFrame(2);
					removeWing();
					break;
				default:
					break;
			}
		}
		
		override public function get currentAction():*
		{
			return _currentAction;
		}
		
		override public function dispose():void
		{
			if(_info)_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChangeII);
			
			if(_light01)_light01.dispose();
			_light01 = null;
			
			if(_light02)_light02.dispose();
			_light02 = null;
			
			if(_light2 && _light2.parent) _light2.parent.removeChild(_light2);
			_light2 = null;
			
			if(_light1 && _light1.parent) _light1.parent.removeChild(_light1);
			_light1 = null;
			
			super.dispose();
			if(_characterWithoutWeapon)
			{
				_characterWithoutWeapon.dispose();
			}
			_characterWithoutWeapon = null;
			
			if(_characterWithWeapon)
			{
				_characterWithWeapon.dispose();
			}
			_characterWithWeapon = null;
			
			if(_wing && _wing.parent)
			{
				_wing.parent.removeChild(_wing);
			}
			_wing = null;
			
			if(_loading && _loading.parent) _loading.parent.removeChild(_loading);
			_loading = null;
			
			_lightPos = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}