package ddt.view.common
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ddt.data.player.PlayerInfo;
	import ddt.events.UIModuleEvent;
	import ddt.loader.UIModuleLoader;
	import ddt.manager.LanguageMgr;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.ui.controls.hframe.bitmap.BlackTipBG;
	import road.ui.manager.TipManager;
	import road.utils.ClassUtils;
	
	
	public class VIPLiteIcon extends Sprite
	{
		private var _info:PlayerInfo;
		private var _icon:MovieClip;
		private var _loader:UIModuleLoader;

		
		public function VIPLiteIcon(info:PlayerInfo)
		{
			this._info = info;
			
			
			init();
			
		}
		
		private function init():void
		{
			if(!ClassUtils.hasDefinition("ddt.view.common.VIPLiteIconAsset"))
			{
				_loader = new UIModuleLoader(UIModuleLoader.VIP);
				_loader.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__OnLoaded);
			}
			else
			{
				_icon = ClassUtils.CreatInstance("ddt.view.common.VIPLiteIconAsset"); 
				var a:int =_info.VIPLevel+1;
				_icon.gotoAndStop(a);
				addChild(_icon);
			}
			
		}
		
		private function __OnLoaded(event:UIModuleEvent):void
		{
			_loader.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__OnLoaded);
			{
				_icon = ClassUtils.CreatInstance("ddt.view.common.VIPLiteIconAsset"); 
				var a:int =_info.VIPLevel+1;
				_icon.gotoAndStop(a);
				addChild(_icon);
			}
		}

		public function dispose ():void

		{
			_info = null;
			if(parent) parent.removeChild(this);
			
		}
		
	}
}