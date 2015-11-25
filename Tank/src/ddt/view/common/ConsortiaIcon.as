package ddt.view.common
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.CLevelTipAsset;
	import game.crazyTank.view.common.ConsortiaIcon_Big;
	import game.crazyTank.view.common.ConsortiaIcon_Small;
	
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.ConsortiaInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.utils.Helpers;
	
	public class ConsortiaIcon extends Sprite
	{
		public static const BIG:String = "big";
		public static const SMALL:String = "small";
		private var _icon:MovieClip;
		private var _size:String;
		private var _cid:int;
		
		private var _cName:String = "";
		private var _level:int = 0;
		private var _repute:int = 0;
		
		private var _tip:CLevelTipAsset;
		private var _tipConatiner:Sprite;
		
		private var _isBattle:Boolean;
		
		public function ConsortiaIcon(cid:int,size:String = "big",isBattle:Boolean=false)
		{
			super();
			_size = size;
			_cid = cid;
			_isBattle = isBattle;
			if(cid == 0) return;
			
			creatIcon();
		}
		
		private function creatIcon():void
		{	
			if(_icon == null)
			{
				if(_size == BIG)
				{
					_icon = new ConsortiaIcon_Big();
				}else if(_size == SMALL)
				{
					_icon = new ConsortiaIcon_Small();
				}
			}
			addChild(_icon);
			
			_tip = new CLevelTipAsset();
			Helpers.hidePosMc(_tip);
			ComponentHelper.replaceChild(_tip,_tip.bg_pos,new GoodsTipBgAsset);
			_tip.stop();
			_tipConatiner = new Sprite();
			_tipConatiner.addChild(_tip);
			
			var myCInfo:SelfInfo = PlayerManager.Instance.Self;
//			var cInfo:ConsortiaInfo = PlayerManager.Instance.Self.ConsortiaAllyList[_cid];
			var isMyConsortia:Boolean = Boolean(myCInfo.ConsortiaID == _cid);
			
			
			isMyConsortia ? _icon.gotoAndStop(1) : _icon.gotoAndStop(2); 
			if(myCInfo.ConsortiaID == 0)_icon.gotoAndStop(1);
//			if(cInfo && PlayerManager.Instance.Self.ConsortiaID != 0)
//			{
//				if(cInfo.State == 2)
//				{
//					_icon.gotoAndStop(2);
//				}else
//				{
//					_icon.gotoAndStop(1);
//				}
//			}else
//			{
//				_icon.gotoAndStop(1);
//			}
//			
			//如果是自己
			if(isMyConsortia)
			{
//				_tip.name_txt.text = myCInfo.ConsortiaName;
				
				if(_tip.totalFrames>=myCInfo.ConsortiaLevel&&myCInfo.ConsortiaLevel>0)
				{
					_tip.gotoAndStop(myCInfo.ConsortiaLevel);
				}else{
					_tip.gotoAndStop(1);
				}
				
				_tip.states_txt.text = LanguageMgr.GetTranslation("ddt.view.common.ConsortiaIcon.self");
				//_tip.states_txt.text = "公会成员";
				_tip.states_txt.textColor = 0x00EEFF;
				_tip.repute_txt.text = String(myCInfo.ConsortiaRepute);
			}else
			{
//				_tip.name_txt.text = _cName;
				if(_tip.totalFrames>=_level&&_level>0)
				{
					_tip.gotoAndStop(_level);
				}else{
					_tip.gotoAndStop(1);
				}
				if(_cid != 0 && myCInfo.ConsortiaID != 0)
				{
					_tip.states_txt.text = LanguageMgr.GetTranslation("ddt.view.common.ConsortiaIcon.enemy");
					//_tip.states_txt.text = "敌对";
					_tip.states_txt.textColor = 0xFF1C0F;
				}
				else
				{
					_tip.states_txt.text = LanguageMgr.GetTranslation("ddt.view.common.ConsortiaIcon.middle");
					//_tip.states_txt.text = "中立";
					_tip.states_txt.textColor = 0x59FF11;
				}
				
//				if(cInfo)
//				{
//					_tip.states_txt.text = LanguageMgr.GetTranslation("ddt.view.common.ConsortiaIcon.enemy");
//						//_tip.states_txt.text = "敌对";
//					_tip.states_txt.textColor = 0xFF1C0F;
////					if(cInfo.State == 2)
////					{
////						_tip.states_txt.text = LanguageMgr.GetTranslation("ddt.view.common.ConsortiaIcon.enemy");
////						//_tip.states_txt.text = "敌对";
////						_tip.states_txt.textColor = 0xFF1C0F;
////					}else
////					{
////						_tip.states_txt.text = LanguageMgr.GetTranslation("ddt.view.common.ConsortiaIcon.middle");
////						//_tip.states_txt.text = "中立";
////						_tip.states_txt.textColor = 0x59FF11;
////					}
//				}else
//				{
//					_tip.states_txt.text = LanguageMgr.GetTranslation("ddt.view.common.ConsortiaIcon.middle");
//					//_tip.states_txt.text = "中立";
//					_tip.states_txt.textColor = 0x59FF11;
//				}
				
				_tip.repute_txt.text = String(_repute);
			}
			if(!_isBattle)
			{
				addListener();
			}			
		}
		
		public function set consortiaName (cName:String):void
		{
			_cName = cName;
//			if(_tip){
//				_tip.name_txt.text = cName;
//			}
		}
		
		public function set consortiaLevel (level:int):void
		{
			_level = level;
			
			if(_tip){
				if(_tip.totalFrames >=level && level > 0)
				{
					_tip.gotoAndStop(level);
				}
			}
		}
		
		public function set consortiaRepute(repute:int):void
		{
			_repute = repute;
			if(_tip)
			{
				_tip.repute_txt.text = String(repute);
			}
		}
		
		public function set consortiaID (id:int):void
		{
			_cid = id;
			if(_cid == 0)
			{
				if(_icon)
				_icon.visible = false;
			}else
			{
				if(_icon)
				_icon.visible = true;
				creatIcon();
			}
			
		}
		
		public function get consortiaID():int
		{
			return _cid;
		}
	
		private function showTipListener(event:MouseEvent):void
		{
			TipManager.setCurrentTarget(_icon,_tipConatiner);
		}
		
		private function hideTipListener(event:MouseEvent):void
		{
			TipManager.setCurrentTarget(null,_tipConatiner);
		}
		
		public function dispose():void
		{
			removeListener();
			if(_tip && _tip.parent)_tip.parent.removeChild(_tip);
			_tip = null;
			
			if(_tipConatiner && _tipConatiner.parent)_tipConatiner.parent.removeChild(_tipConatiner);
			_tipConatiner = null;
			
			if(_icon && _icon.parent)_icon.parent.removeChild(_icon);
			_icon = null;
			
			if(parent)
				parent.removeChild(this);
		}
		
		private function addListener():void
		{
			_icon.addEventListener(MouseEvent.MOUSE_OVER,showTipListener);
			_icon.addEventListener(MouseEvent.MOUSE_OUT,hideTipListener);
		}
		
		private function removeListener():void
		{
			if(_icon)
			{
				_icon.removeEventListener(MouseEvent.MOUSE_OVER,showTipListener);
				_icon.removeEventListener(MouseEvent.MOUSE_OUT,hideTipListener);
			}
			
		}
	}
}