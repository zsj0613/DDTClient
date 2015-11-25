package ddt.hotSpring.player
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.player.PlayerInfo;
	import tank.hotSpring.HeadMaskAsset;
	import ddt.view.sceneCharacter.SceneCharacterActionItem;
	import ddt.view.sceneCharacter.SceneCharacterActionSet;
	import ddt.view.sceneCharacter.SceneCharacterItem;
	import ddt.view.sceneCharacter.SceneCharacterLoaderBody;
	import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
	import ddt.view.sceneCharacter.SceneCharacterLoaderPath;
	import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
	import ddt.view.sceneCharacter.SceneCharacterSet;
	import ddt.view.sceneCharacter.SceneCharacterStateItem;
	import ddt.view.sceneCharacter.SceneCharacterStateSet;
	
	public class HotSpringPlayerBase extends SceneCharacterPlayerBase
	{
		private var _playerInfo:PlayerInfo;
		private var _sceneCharacterStateSet:SceneCharacterStateSet;
		private var _sceneCharacterSetNatural:SceneCharacterSet;//正常人物状态形象图源集
		private var _sceneCharacterSetWater:SceneCharacterSet;//水中人物状态形象图源集
		private var _sceneCharacterLoaderPath:SceneCharacterLoaderPath;
		private var _sceneCharacterActionSetNatural:SceneCharacterActionSet;//正常状态下动作集
		private var _sceneCharacterActionSetWater:SceneCharacterActionSet;//水中状态下动作集
		private var _sceneCharacterLoaderHead:SceneCharacterLoaderHead;//头部加载
		private var _sceneCharacterLoaderBody:SceneCharacterLoaderBody;//身体加载
		private var _headBitmapData:BitmapData;
		private var _bodyBitmapData:BitmapData;
		private var _rectangle:Rectangle=new Rectangle();
		private var _headMaskAsset:HeadMaskAsset;
		public var playerWitdh:Number = 120;//人物宽
		public var playerHeight:Number = 175;//人物高
		private var _callBack:Function;
		
		public function HotSpringPlayerBase(playerInfo:PlayerInfo, callBack:Function=null)
		{
			_playerInfo=playerInfo;
			_callBack=callBack;
			initialize();
			super(callBack);
		}
		
		private function initialize():void
		{
			_sceneCharacterStateSet=new SceneCharacterStateSet();
			_sceneCharacterActionSetNatural=new SceneCharacterActionSet();
			_sceneCharacterActionSetWater=new SceneCharacterActionSet();			
			
			sceneCharacterLoadHead();//加载头部形象
		}
		
		/**
		 * 加载头部形象
		 */		
		private function sceneCharacterLoadHead():void
		{
			_sceneCharacterLoaderHead = new SceneCharacterLoaderHead(_playerInfo);
			_sceneCharacterLoaderHead.load(sceneCharacterLoaderHeadCallBack);
		}
		
		/**
		 *加载头部形象完成
		 */		
		private function sceneCharacterLoaderHeadCallBack(sceneCharacterLoaderHead:SceneCharacterLoaderHead, isAllLoadSucceed:Boolean=true):void
		{
			_headBitmapData = sceneCharacterLoaderHead.getContent()[0] as BitmapData;//取得头部形象(横排3个图)
			if(sceneCharacterLoaderHead) sceneCharacterLoaderHead.dispose();
			sceneCharacterLoaderHead = null;
			
			if(!isAllLoadSucceed || !_headBitmapData)
			{//如果加载到的图像资源为空，则标识当前人物形象加载失败(会在加载人物队列时，再次对失败队列进行重新加载)
				if(_callBack!=null) _callBack(this, false);
				return;
			}
			
			sceneCharacterStateNatural();//加入正常人物状态
		}
		
		/**
		 * 加入正常人物状态
		 */		
		private function sceneCharacterStateNatural():void
		{
			_sceneCharacterSetNatural=new SceneCharacterSet();
			
			var actionBmp:BitmapData;
			
			//正面与背面头部上下抖头坐标控制，每子项对应一个单元源图
			var points:Vector.<Point>=new Vector.<Point>();
			points.push(new Point(0, 0));
			points.push(new Point(0, 0));
			points.push(new Point(0, -1));
			points.push(new Point(0, 2));
			points.push(new Point(0, 0));
			points.push(new Point(0, -1));
			points.push(new Point(0, 2));
			
			//设置正面睁眼头部截取区域
			_rectangle.x=0;
			_rectangle.y=0;
			_rectangle.width=playerWitdh;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_headBitmapData, _rectangle, new Point(0,0));
			_sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead", "NaturalFrontAction", actionBmp, 1, 1, playerWitdh, playerHeight, 1, points, true, 7));//加入正面行为的睁眼头部形象项
			
			//设置正面闭眼截取区域
			_rectangle.x=playerWitdh;
			_rectangle.y=0;
			_rectangle.width=playerWitdh;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_headBitmapData, _rectangle, new Point(0,0));
			_sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseHead", "NaturalFrontEyesCloseAction", actionBmp, 1, 1, playerWitdh, playerHeight, 2));//加入正面行为的闭眼头部形象项
			
			//设置背面头部截取区域
			_rectangle.x=playerWitdh*2;
			_rectangle.y=0;
			_rectangle.width=playerWitdh;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(playerWitdh, playerHeight*2, true, 0x000000);
			actionBmp.copyPixels(_headBitmapData, _rectangle, new Point(0, 0));
			_sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackHead", "NaturalBackAction", actionBmp, 1, 1, playerWitdh, playerHeight, 6, points, true, 7));//加入背面行为的头部形象项
			
			sceneCharacterLoadBodyNatural()//加载正常状态身体形象
		}
		
		/**
		 * 加载正常状态身体形象
		 */		
		private function sceneCharacterLoadBodyNatural():void
		{
			_sceneCharacterLoaderPath=new SceneCharacterLoaderPath();
			_sceneCharacterLoaderPath.clothPath="cloth2";//指定服装路径为正常状态下的路径
			_sceneCharacterLoaderBody = new SceneCharacterLoaderBody(_playerInfo, _sceneCharacterLoaderPath);
			_sceneCharacterLoaderBody.load(sceneCharacterLoaderBodyNaturalCallBack);
		}
		
		/**
		 * 加载正常状态身体形象完成
		 */		
		private function sceneCharacterLoaderBodyNaturalCallBack(sceneCharacterLoaderBody:SceneCharacterLoaderBody, isAllLoadSucceed:Boolean=true):void
		{
			_bodyBitmapData = sceneCharacterLoaderBody.getContent()[0] as BitmapData;//取得身体形象(横排7个图)
			_sceneCharacterLoaderPath=null;
			if(sceneCharacterLoaderBody) sceneCharacterLoaderBody.dispose();
			sceneCharacterLoaderBody = null;
			
			if(!isAllLoadSucceed || !_bodyBitmapData)
			{//如果加载到的图像资源为空，则标识当前人物形象加载失败(会在加载人物队列时，再次对失败队列进行重新加载)
				if(_callBack!=null) _callBack(this, false);
				return;
			}
			
			var actionBmp:BitmapData;
			
			//加入正面行为身体形象项
			_rectangle.x=0;
			_rectangle.y=0;
			_rectangle.width=_bodyBitmapData.width;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(_bodyBitmapData.width, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_bodyBitmapData, _rectangle, new Point(0, 0));
			_sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody", "NaturalFrontAction", actionBmp, 1, 7, playerWitdh, playerHeight, 3));
			
			//设置正面闭眼身体截取区域
			_rectangle.x=0;
			_rectangle.y=0;
			_rectangle.width=playerWitdh;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_bodyBitmapData, _rectangle, new Point(0,0));
			_sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody", "NaturalFrontEyesCloseAction", actionBmp, 1, 1, playerWitdh, playerHeight, 4));
			
			//加入背面行为身体形象项
			_rectangle.x=0;
			_rectangle.y=playerHeight;
			_rectangle.width=_bodyBitmapData.width;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(_bodyBitmapData.width, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_bodyBitmapData, _rectangle, new Point(0, 0));
			_sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackBody", "NaturalBackAction", actionBmp, 1, 7, playerWitdh, playerHeight, 5));
			
			//加入动作-正面站立并眨眼
			var sceneCharacterActionItem1:SceneCharacterActionItem=new SceneCharacterActionItem("naturalStandFront", 
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					7,7,7], true);
			_sceneCharacterActionSetNatural.push(sceneCharacterActionItem1);
			
			//加入动作-背面站立 
			var sceneCharacterActionItem2:SceneCharacterActionItem=new SceneCharacterActionItem("naturalStandBack", 
				[8], false);
			_sceneCharacterActionSetNatural.push(sceneCharacterActionItem2);
			
			//加入动作-正面行走
			var sceneCharacterActionItem3:SceneCharacterActionItem=new SceneCharacterActionItem("naturalWalkFront", 
				[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6], true);
			_sceneCharacterActionSetNatural.push(sceneCharacterActionItem3);
			
			//加入动作-背面行走
			var sceneCharacterActionItem4:SceneCharacterActionItem=new SceneCharacterActionItem("naturalWalkBack", 
				[9,9,9,10,10,10,11,11,11,12,12,12,13,13,13,14,14,14], true);
			_sceneCharacterActionSetNatural.push(sceneCharacterActionItem4);
			
			//加入正常人物状态至状态集
			var _sceneCharacterStateItemNatural:SceneCharacterStateItem=new SceneCharacterStateItem("natural", _sceneCharacterSetNatural, _sceneCharacterActionSetNatural);
			_sceneCharacterStateSet.push(_sceneCharacterStateItemNatural);
			
			//加入水中人物状态
			sceneCharacterStateWater();
		}
		
		/**
		 * 加入水中人物状态
		 */		
		private function sceneCharacterStateWater():void
		{
			_sceneCharacterSetWater=new SceneCharacterSet();
			
			_headMaskAsset=new HeadMaskAsset();
			_headMaskAsset.cacheAsBitmap=true;
			
			var actionBmp:BitmapData;
			var actionBmpMask:Bitmap;
			var actionMaskBox:Sprite;
			
			//设置正面睁眼头部截取区域
			_rectangle.x=0;
			_rectangle.y=0;
			_rectangle.width=playerWitdh;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_headBitmapData, _rectangle, new Point(0,0));
			
			//头部遮照
			actionBmpMask=new Bitmap(actionBmp);
			actionBmpMask.cacheAsBitmap=true;
			actionBmpMask.mask=_headMaskAsset;
			actionMaskBox=new Sprite();
			actionMaskBox.addChild(actionBmpMask);
			actionMaskBox.addChild(_headMaskAsset);
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.draw(actionMaskBox);
			
			if(actionBmpMask) actionBmpMask.bitmapData.dispose();
			actionBmpMask=null;
			if(actionMaskBox && actionMaskBox.parent) actionMaskBox.parent.removeChild(actionMaskBox);
			actionMaskBox=null;
			
			_sceneCharacterSetWater.push(new SceneCharacterItem("WaterFrontHead", "WaterFrontAction", actionBmp, 1, 1, playerWitdh, playerHeight, 1));
			
			//设置正面闭眼截取区域
			_rectangle.x=playerWitdh;
			_rectangle.y=0;
			_rectangle.width=playerWitdh;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_headBitmapData, _rectangle, new Point(0,0));
			
			actionBmpMask=new Bitmap(actionBmp);
			actionBmpMask.cacheAsBitmap=true;
			actionBmpMask.mask=_headMaskAsset;
			actionMaskBox=new Sprite();
			actionMaskBox.addChild(actionBmpMask);
			actionMaskBox.addChild(_headMaskAsset);
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.draw(actionMaskBox);
			
			if(actionBmpMask) actionBmpMask.bitmapData.dispose();
			actionBmpMask=null;
			if(actionMaskBox && actionMaskBox.parent) actionMaskBox.parent.removeChild(actionMaskBox);
			actionMaskBox=null;
			
			_sceneCharacterSetWater.push(new SceneCharacterItem("WaterFrontEyesCloseHead", "WaterFrontEyesCloseAction", actionBmp, 1, 1, playerWitdh, playerHeight, 2));
			
			//设置背面头部截取区域
			_rectangle.x=playerWitdh*2;
			_rectangle.y=0;
			_rectangle.width=playerWitdh;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_headBitmapData, _rectangle, new Point(0,0));
			
			actionBmpMask=new Bitmap(actionBmp);
			actionBmpMask.cacheAsBitmap=true;
			actionBmpMask.mask=_headMaskAsset;
			actionMaskBox=new Sprite();
			actionMaskBox.addChild(actionBmpMask);
			actionMaskBox.addChild(_headMaskAsset);
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.draw(actionMaskBox);
			
			if(actionBmpMask) actionBmpMask.bitmapData.dispose();
			actionBmpMask=null;
			if(actionMaskBox && actionMaskBox.parent) actionMaskBox.parent.removeChild(actionMaskBox);
			actionMaskBox=null;
			
			if(_headMaskAsset && _headMaskAsset.parent) _headMaskAsset.parent.removeChild(_headMaskAsset);
			_headMaskAsset=null;
			
			_sceneCharacterSetWater.push(new SceneCharacterItem("WaterBackHead", "WaterBackAction", actionBmp, 1, 1, playerWitdh, playerHeight, 6));
			
			sceneCharacterLoadBodyWater();//加载身体形象
		}
		
		/**
		 * 加载水中身体形象
		 */		
		private function sceneCharacterLoadBodyWater():void
		{
			//加载身体形象
			_sceneCharacterLoaderPath=new SceneCharacterLoaderPath();
			_sceneCharacterLoaderPath.clothPath="cloth3";//指定服装路径为正常状态下的路径
			_sceneCharacterLoaderBody = new SceneCharacterLoaderBody(_playerInfo, _sceneCharacterLoaderPath);
			_sceneCharacterLoaderBody.load(sceneCharacterLoaderBodyWaterCallBack);
		}
		
		/**
		 * 加载水中状态身体形象完成
		 */		
		private function sceneCharacterLoaderBodyWaterCallBack(sceneCharacterLoaderBody:SceneCharacterLoaderBody, isAllLoadSucceed:Boolean=true):void
		{
			_bodyBitmapData = sceneCharacterLoaderBody.getContent()[0] as BitmapData;//取得身体形象(横排1个图)
			_sceneCharacterLoaderPath=null;
			if(sceneCharacterLoaderBody) sceneCharacterLoaderBody.dispose();
			sceneCharacterLoaderBody = null;
			
			if(!isAllLoadSucceed || !_bodyBitmapData)
			{//如果加载到的图像资源为空，则标识当前人物形象加载失败(会在加载人物队列时，再次对失败队列进行重新加载)
				if(_callBack!=null) _callBack(this, false);
				return;
			}
			
			var actionBmp:BitmapData;
			
			//加入正面行为身体形象项
			_rectangle.x=0;
			_rectangle.y=0;
			_rectangle.width=_bodyBitmapData.width;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(_bodyBitmapData.width, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_bodyBitmapData, _rectangle, new Point(0, 0));
			_sceneCharacterSetWater.push(new SceneCharacterItem("WaterFrontBody", "WaterFrontAction", actionBmp, 1, 1, playerWitdh, playerHeight, 3));
			
			//设置正面闭眼身体截取区域
			_rectangle.x=0;
			_rectangle.y=0;
			_rectangle.width=playerWitdh;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(playerWitdh, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_bodyBitmapData, _rectangle, new Point(0,0));
			_sceneCharacterSetWater.push(new SceneCharacterItem("WaterFrontEyesCloseBody", "WaterFrontEyesCloseAction", actionBmp, 1, 1, playerWitdh, playerHeight, 4));
			
			//加入背面行为身体形象项
			_rectangle.x=0;
			_rectangle.y=playerHeight;
			_rectangle.width=_bodyBitmapData.width;
			_rectangle.height=playerHeight;
			actionBmp=new BitmapData(_bodyBitmapData.width, playerHeight, true, 0x000000);
			actionBmp.copyPixels(_bodyBitmapData, _rectangle, new Point(0, 0));
			_sceneCharacterSetWater.push(new SceneCharacterItem("WaterBackBody", "WaterBackAction", actionBmp, 1, 0, playerWitdh, playerHeight, 5));
			
			//加入动作-正面停止并眨眼
			var sceneCharacterActionItem1:SceneCharacterActionItem=new SceneCharacterActionItem("waterFrontEyes", 
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					1,1,1], true);
			_sceneCharacterActionSetWater.push(sceneCharacterActionItem1);
			
			//加入动作-背面停止
			var sceneCharacterActionItem2:SceneCharacterActionItem=new SceneCharacterActionItem("waterStandBack", 
				[2], false);
			_sceneCharacterActionSetWater.push(sceneCharacterActionItem2);
			
			//加入动作-背面
			var sceneCharacterActionItem3:SceneCharacterActionItem=new SceneCharacterActionItem("waterBack", 
				[2], false);
			_sceneCharacterActionSetWater.push(sceneCharacterActionItem3);
			
			//加入动作-正面
			var sceneCharacterActionItem4:SceneCharacterActionItem=new SceneCharacterActionItem("waterFront", 
				[0], false);
			_sceneCharacterActionSetWater.push(sceneCharacterActionItem4);
			
			//加入水中人物状态至状态集
			var _sceneCharacterStateItemWater:SceneCharacterStateItem=new SceneCharacterStateItem("water", _sceneCharacterSetWater, _sceneCharacterActionSetWater);
			_sceneCharacterStateSet.push(_sceneCharacterStateItemWater);
			
			super.sceneCharacterStateSet=_sceneCharacterStateSet;//设置最终状态集
		}
		
		override public function dispose():void
		{
			_playerInfo=null;
			
			if(_sceneCharacterSetNatural) _sceneCharacterSetNatural.dispose();
			_sceneCharacterSetNatural=null;
			
			if(_sceneCharacterSetWater) _sceneCharacterSetWater.dispose();
			_sceneCharacterSetWater=null;			
			
			if(_sceneCharacterLoaderHead) _sceneCharacterLoaderHead.dispose();
			_sceneCharacterLoaderHead=null;
			
			if(_sceneCharacterLoaderBody) _sceneCharacterLoaderBody.dispose();
			_sceneCharacterLoaderBody=null;
			
			if(_sceneCharacterActionSetNatural) _sceneCharacterActionSetNatural.dispose();
			_sceneCharacterActionSetNatural=null;
			
			if(_sceneCharacterActionSetWater) _sceneCharacterActionSetWater.dispose();
			_sceneCharacterActionSetWater=null;			
			
			if(_sceneCharacterStateSet) _sceneCharacterStateSet.dispose();
			_sceneCharacterStateSet=null;			
			
			if(_headBitmapData) _headBitmapData.dispose();
			_headBitmapData=null;
			
			if(_bodyBitmapData) _bodyBitmapData.dispose();
			_bodyBitmapData=null;
			
			if(_headMaskAsset && _headMaskAsset.parent) _headMaskAsset.parent.removeChild(_headMaskAsset);
			_headMaskAsset=null;
			
			_sceneCharacterLoaderPath=null;
			_rectangle=null;
			
			super.dispose();
		}
	}
}