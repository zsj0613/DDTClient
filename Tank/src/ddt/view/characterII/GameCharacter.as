package ddt.view.characterII
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import ddt.command.PlayerAction;
	import ddt.data.player.PlayerInfo;

	public class GameCharacter extends BaseCharacter
	{
		public static const STAND:PlayerAction = new PlayerAction("stand",
															[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,
															 0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,7,7,8,8,9,9,9,9,8,8,7,7,6,6,0,0,0,0,0,0,0,0,
															 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0],
															false,true,false);
															
		public static const WALK:PlayerAction = new PlayerAction("walk",
															[1,1,2,2,3,3,4,4,5,5],
															false,false,false);
		public static const SHOT:PlayerAction = new PlayerAction("shot",
															[22,23,26,27],
															true,false,true);
		public static const STOPSHOT:PlayerAction = new PlayerAction("stopshot",
																[23],
																true,false,false);
		public static const SHOWGUN:PlayerAction = new PlayerAction("showgun",
																[19,20,21,21,21],
																true,false,true);
		public static const HIDEGUN:PlayerAction = new PlayerAction("hidegun",
																[27],
																true,false,false);
		public static const THROWS:PlayerAction = new PlayerAction("throws",
																[31,32,33,34,35],
																true,false,true);
		public static const STOPTHROWS:PlayerAction = new PlayerAction("stopthrows",
																	[34],
																	true,false,false);
		public static const SHOWTHROWS:PlayerAction = new PlayerAction("showthrows",
																	[28,29,30,30,30],
																	true,false,true);
		public static const HIDETHROWS:PlayerAction = new PlayerAction("hidethrows",
																	[35],
																	true,false,false);
		public static const SHAKE:PlayerAction = new PlayerAction("shake",
																[6,6,7,7,8,8,9,9,8,8,7,7,6,6],
																false,false,false);
		public static const HANDCLIP:PlayerAction = new PlayerAction("handclip",
																[13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13],																	
																true,false,false);
		public static const SOUL:PlayerAction = new PlayerAction("soul",
																[36],
																false,true,false);
		public static const CRY:PlayerAction = new PlayerAction("cry",
																[16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18],
																false,false,false);
		public static const HIT:PlayerAction = new PlayerAction("hit",
																[12,12,24,24,24,24,24,24,24,24,25,25,38,38,38,38,11,11,11,11],
																false,false,false);
		
		public static const GAME_WING_WAIT:int = 1;
		public static const GAME_WING_SHOT:int = 2;
													
		private var _currentAction:PlayerAction;
		private var _defaultAction:PlayerAction;
		private var _wing:MovieClip;
		private var _frameStartPoint:Point = new Point(0,0);
		private var _framePicCount:int = 39;
		private var _framePicContainer:Sprite;
		public function GameCharacter(info:PlayerInfo)
		{
			super(info,true);
			_framePicContainer = new Sprite();
			_framePicContainer.x = -_characterWidth / 2 - 10;
			_framePicContainer.y = -_characterHeight + 12;
			_container.removeChild(_body);
			_container.addChild(_framePicContainer);
			_currentAction = STAND;
			_defaultAction = STAND;
		}
		
		override protected function initSizeAndPics():void
		{
			setCharacterSize(114,95);
			setPicNum(3,13);
		}
		
		public function get weaponX():int
		{
			return _framePicContainer.x;
		}
		
		public function get weaponY():int
		{
			return _framePicContainer.y;
		}
		public function addWeaponMovie(movie:MovieClip):void
		{
			movie.x = -_characterWidth / 2 - 10;
			movie.y = -_characterHeight + 12;
			addChild(movie);
		}
		
		override protected function initLoader():void
		{
			_loader = _factory.createLoader(_info,CharacterLoaderFactory.GAME);
		}
		
		private var _index:int = 0;
		private var _isPlaying:Boolean = false;
		override public function update():void
		{
			if(_isPlaying)
			{
				if(_index < _currentAction.frames.length)
				{
					drawFrame(_currentAction.frames[_index++]);
				}
				else 
				{
					if(_currentAction.repeat)
					{
						_index = 0;
					}
					else
					{
						if(_currentAction.stopAtEnd)
						{
							_isPlaying = false;
						}
						else
						{
							doAction(_defaultAction);
						}
					}
				}
			}
		}
		
		override public function doAction(actionType:*):void
		{
			if(_currentAction.canReplace(actionType))
			{
				_currentAction = actionType;
				_index = 0;
			}
			if(_currentAction == STAND)
			{
				WingState = GAME_WING_WAIT;
				if(leftWing && rightWing)
				{
					leftWing["movie"].gotoAndStop(1);
					rightWing["movie"].gotoAndStop(1);
				}
			}
			else if(_currentAction == SOUL)
			{
				switchWingVisible(false);
			}
			else
			{
				if(leftWing && rightWing)
				{
					try
					{
						leftWing["movie"].play();
						rightWing["movie"].play();
					}
					catch(e:Error)
					{
					}					
				}
			}
			_isPlaying = true;
		}

		override public function actionPlaying():Boolean
		{
			return _isPlaying;
		}
		
		override public function get currentAction():*
		{
			return _currentAction;
		}
		
		override public function setDefaultAction(actionType:*):void
		{
			if(actionType is PlayerAction)
			{
				_currentAction = actionType;
			}
		}
		
		override protected function setContent():void
		{
			if(_loader != null)
			{
				if(_characterBitmapdata && _characterBitmapdata != _loader.getContent()[0])
					_characterBitmapdata.dispose();
				characterBitmapdata = _loader.getContent()[0];
			}
			if(_loader != null)
			{
				var t:Array = _loader.getContent();
				if(getQualifiedClassName(_wing) != getQualifiedClassName(t[1]))
				{
					removeWing();				
					_wing = t[1];
					WingState = GAME_WING_WAIT;
				}
				drawAllFrames();
			}
		}
		
		private function removeWing():void
		{
			if(_wing == null) return;
			if(rightWing && rightWing.parent)
			{
				rightWing.parent.removeChild(rightWing);
			}
			
			if(leftWing && leftWing.parent)
			{
				leftWing.parent.removeChild(leftWing);
			}
			_wing = null;
		}
		
		public function switchWingVisible(v:Boolean):void
		{
			if(leftWing && rightWing)
			{
				rightWing.visible = leftWing.visible = v;
			}
		}
		
		
		public function setWingPos(xPos:Number,yPos:Number):void
		{
			if(rightWing && leftWing)
			{
				rightWing.x = leftWing.x = xPos;
				rightWing.y = leftWing.y = yPos;
			}
		}
		
		public function setWingScale(xScale:Number,yScale:Number):void
		{
			if(rightWing && leftWing)
			{
				leftWing.scaleX = rightWing.scaleX = xScale;
				leftWing.scaleY = rightWing.scaleY = yScale;
			}
		}
		
		private var _wingState:int = 0;
		public function set WingState (wingState:int):void
		{
			if(leftWing && rightWing)
			{
				leftWing.gotoAndStop(wingState);
				rightWing.gotoAndStop(wingState);
				_wingState = wingState;
			}
		}
		
		public function get WingState():int
		{
			return _wingState
		}
		
		public function get wing ():MovieClip
		{
			return _wing;
		}
		
		public function get leftWing():MovieClip
		{
			if(_wing)
			{
				return _wing["leftWing"];
			}
			return null;
		}
		
		public function get rightWing():MovieClip
		{
			if(_wing)
			{
				return _wing["rightWing"];
			}
			return null;
		}
		
		override public function dispose():void
		{
			removeWing();
			super.dispose();
			removeAllFrame();
			_frameStartPoint = null;
		}
		
		private var _frameBitmaps:Array = [];
		
		private function drawAllFrames():void
		{
			removeAllFrame();
			_frameBitmaps = [];
			for(var i:int = 0;i < _framePicCount; i++)
			{
				var bmd:BitmapData = new BitmapData(_characterWidth,_characterHeight,true,0);
				bmd.copyPixels(_characterBitmapdata,_frames[i],_frameStartPoint);
				var bm:Bitmap = new Bitmap(bmd,"auto",true);
				_frameBitmaps.push(bm);
			}
		}
		
		private function removeAllFrame():void
		{
			if(_frameBitmaps == null || _frameBitmaps.length == 0) return;
			for(var i:int = 0;i < _framePicCount; i++)
			{
				_frameBitmaps[i].bitmapData.dispose();
			}
			_frameBitmaps = null;
		}
		
		
		override public function drawFrame(frame:int):void
		{
			if(_characterBitmapdata != null)
			{
				if(frame < 0 || frame >= _frames.length)frame = 0;
				if(frame != _currentframe || _bitmapChanged )
				{
					_bitmapChanged = false;
					_currentframe = frame;
					if(_framePicContainer.numChildren > 0)_framePicContainer.removeChildAt(0);
					_framePicContainer.addChild(_frameBitmaps[_currentframe]);
				}
			}
		}
		
	}
}