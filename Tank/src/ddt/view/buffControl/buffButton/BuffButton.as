package ddt.view.buffControl.buffButton
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.hasBuffTipAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.SimpleButtonFormat;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.BuffInfo;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.manager.TimeManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	public class BuffButton extends HBaseButton
	{
		protected var _info:BuffInfo;
		protected var _format:SimpleButtonFormat;
		
		private var _canClick:Boolean;
		private var _showTip:Boolean;
		public function BuffButton(bg:Sprite)
		{
			super(bg);
		}
		
		public static function createBuffButton(buffID:int):BuffButton
		{
			switch(buffID)
			{
			    case 1:
			        var free:BuffButton =  new FreeBuffButton();
			        return free;
			    case 2:
			        var doubleExp:BuffButton = new DoubExpBuffButton();
			        return doubleExp;
			    case 3:
			        var doubleGeste:BuffButton = new DoubGesteBuffButton();
			        return doubleGeste;
			    case 4:
			        var pvtKick:BuffButton = new PreventKickBuffButton();
			        return pvtKick;
			    default:
			        break;
			}
			return null;    
		}
		
		override protected function init():void
		{
			super.init();
			_canClick = true;
			_showTip = true;
            buttonMode = _canClick;
            _format = new SimpleButtonFormat;
            _format.setNotEnable(this);
		}
		
		override protected function overHandler(evt:MouseEvent):void
		{
			if(_canClick&&_info&&_info.IsExist)
	    	{
    			_format.setOverFormat(this);
	    	}
			if(_showTip)
			{
				TipManager.setCurrentTarget(_bg,createTipRender());
			}
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			if(_canClick&&_info&&_info.IsExist)
	    	{
	    		_format.setOutFormat(this);
	    	}
			TipManager.setCurrentTarget(null,null);
		}
		
		override protected function downHandler(evt:MouseEvent):void
		{
			if(_canClick&&_info&&_info.IsExist)
			{
				_format.setDownFormat(this);
			}
		}
		
		override protected function upHandler(evt:MouseEvent):void
		{
			if(_canClick&&_info&&_info.IsExist)
			{
				_format.setUpFormat(this);
			}
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			if(!CanClick) return;
			SoundManager.Instance.play("008");
		}
		
		protected function checkBagLocked() : Boolean
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return false;
			}
			return true;
		}
		
		protected function buyBuff():void
		{
			SocketManager.Instance.out.sendUseCard(-1,-1,ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).GoodsID,1);
		}
		
		protected function createTipRender():Sprite
		{
			if(_info!=null&&_info.IsExist)
			{
				var hasBuffTip:hasBuffTipAsset = new hasBuffTipAsset();
				hasBuffTip.name_tex.text = _info.buffName;
		    	hasBuffTip.day_txt.text  = getLeftTimeTxt(TimeManager.DAY_TICKS);
		    	hasBuffTip.hour_txt.text = getLeftTimeTxt(TimeManager.HOUR_TICKS);
		    	hasBuffTip.min_txt.text  = getLeftTimeTxt(TimeManager.Minute_TICKS);
				ComponentHelper.replaceChild(hasBuffTip,hasBuffTip.bg,new GoodsTipBgAsset());
		    	return hasBuffTip;
			}
			var noBuffTip:NoBuffTip = new NoBuffTip();
			noBuffTip.description = _info.description;
			return noBuffTip;
		}
		
		private function getLeftTimeTxt(unit:Number):String
		{
			if(getLeftTime()>0) 
			{
				switch(unit)
				{
					case TimeManager.DAY_TICKS:
					     return Math.floor(getLeftTime()/TimeManager.DAY_TICKS).toString();
				    case TimeManager.HOUR_TICKS:
				         return Math.floor((getLeftTime()%TimeManager.DAY_TICKS)/TimeManager.HOUR_TICKS).toString();
				    case TimeManager.Minute_TICKS:
				    	 return Math.floor((getLeftTime()%TimeManager.HOUR_TICKS)/TimeManager.Minute_TICKS).toString();
			    	default:
			    		 break;
				}
			}
			return "0";
		}
		
		private function getLeftTime():Number
		{
			var leftTime:Number;
			if(_info!=null&&_info.IsExist)
			{
				leftTime = _info.ValidDate-Math.floor((TimeManager.Instance.Now().time - _info.BeginData.time)/TimeManager.Minute_TICKS);
			}else
			{
				leftTime = -1;
			}
			return leftTime*TimeManager.Minute_TICKS;
		}
		
		public function setSize(width:Number, height:Number):void
		{
			_bg.width = width;
			_bg.height = height;
		}
		
		private function updateView():void
		{
			if(_info!=null&&_info.IsExist)
			{
				_format.setEnable(this);
			}else
			{
				_format.setNotEnable(this);
			}
		}
		
		public function set CanClick(value:Boolean):void
		{
			_canClick = value;
			this.buttonMode = _canClick;
		}
		
		public function get CanClick():Boolean
		{
			return _canClick;
		}
		
		public function set ShowTip(value:Boolean):void
		{
			_showTip = value;
		}
		
		public function get ShowTip():Boolean
		{
			return _showTip;
		}
		
		public function set info(value:BuffInfo):void
		{
			_info = value;
			updateView();
		}
		
		override public function dispose():void
		{
			if(_info)
				_info.dispose();
			_info = null;
			
			if(_format)
			{
				_format.dispose();
			}
			_format = null;
			
			super.dispose();
		}
	}
}