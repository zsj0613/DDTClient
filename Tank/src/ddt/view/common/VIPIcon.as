package ddt.view.common
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.SelfInfo;
	import ddt.events.UIModuleEvent;
	import ddt.loader.UIModuleLoader;
	import ddt.manager.PlayerManager;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.ui.controls.hframe.bitmap.BlackTipBG;
	import road.ui.manager.TipManager;
	import road.utils.ClassUtils;
	
	
	public class VIPIcon extends Sprite
	{
		private var _info:PlayerInfo =PlayerManager.Instance.Self;
		private var _icon:MovieClip;
		private var _tip:Sprite;
		private var _IsShowMoney:Boolean;
		
		private var _bg:ScaleBitmap;
		private var _label:MovieClip;
		private var _loader:UIModuleLoader;
		
		public function VIPIcon(info:PlayerInfo,IsShowMoney:Boolean)
		{
			this._info = info;
			
			this._IsShowMoney = IsShowMoney;
			if(!ClassUtils.hasDefinition("ddt.view.common.VIPIconAsset"))
			{
				_loader = new UIModuleLoader(UIModuleLoader.VIP);
				_loader.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__OnLoaded);
			}
			else
			{
				init();
			}
			
			
		}
		private function __OnLoaded(event:UIModuleEvent):void
		{
			if(event.module==UIModuleLoader.VIP)
			{
				_loader.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__OnLoaded);
				init();
			}
		}
		
		private function init():void
		{
			if(_info==null)
			{
				return;
			}
			_icon = ClassUtils.CreatInstance("ddt.view.common.VIPIconAsset");
			var a:int =_info.VIPLevel+1;//见鬼了这玩意能出现null			
			_icon.gotoAndStop(a);
			addChild(_icon);
			
			if(_IsShowMoney)
			{
				_bg = new BlackTipBG();
				_bg.height = 25;
			
				_label = ClassUtils.CreatInstance("ddt.view.common.VIPIconTipAsset");
				_label.Text_txt.text = GetTip();
				_label.Text_txt.autoSize = TextFieldAutoSize.LEFT;


				_label.Text_txt.setTextFormat(new TextFormat("Arial",14,0xffffff,true));
			
				_tip = new Sprite();
				_tip.addChild(_bg);
				_tip.addChild(_label);			
				setCenter();
				addEvent();
			}
		}
		
		private function addEvent():void
		{
			_icon.addEventListener(MouseEvent.MOUSE_OVER,__showTip);
			_icon.addEventListener(MouseEvent.MOUSE_OUT,__hideTip);
		}
		
		private function removeEvent():void
		{
			if(_icon)
			{
				_icon.removeEventListener(MouseEvent.MOUSE_OVER,__showTip);
				_icon.removeEventListener(MouseEvent.MOUSE_OUT,__hideTip);
			}
		}
		
		private function setCenter():void
		{
			_bg.width = _label.width+10;
			_label.x = 5;
			_label.y = (_bg.height - _label.height)/2;
			
			_tip.x = _icon.x + 15;
			_tip.y = _icon.y + 15;
			addChild(_tip);
			
			_tip.visible = false;                    
			TipManager.setCurrentTarget(null,_tip);  //bret 09.8.21
		}
		
		public function dispose():void
		{
			removeEvent();
			_info = null;
			_tip = null;
			if(_bg != null)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(parent) parent.removeChild(this);
			
		}
		
		
		private function __showTip(event:MouseEvent):void
		{
			_tip.visible = true;                    
			TipManager.setCurrentTarget(_icon,_tip);//bret 09.8.21
		}
		
		private function __hideTip(event:MouseEvent):void			
		{
			_tip.visible = false;                  
			TipManager.setCurrentTarget(null,_tip);//bret 09.8.21
		}
		
		private function GetTip():String
		{
			if(PlayerManager.Instance.Self.VIPLevel==10)
			{
				return "已经是最高等级";
			}
			else
			{
				var x:int = PlayerManager.Instance.Self.VIPLevel;
				var moneys:Array = ClassUtils.getDefinition("ddt.Config")["VIP_Moneys"];
				var nextmoney:int = int(moneys[x+1]);
				var nowmoney:int =PlayerManager.Instance.Self.ChargedMoney;
				var a:int = nextmoney-nowmoney;
				var b:String = "还差"+a+ "元升级";
				return b;
			}
		}
	}
}