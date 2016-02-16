package ddt.game
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.crazyTank.view.ToolStripAsset;
	
	import org.aswing.KeyStroke;
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import ddt.data.RoomInfo;
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.events.LivingEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.RoomManager;
	import ddt.manager.SharedManager;
	import ddt.manager.StateManager;
	import ddt.manager.TimeManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.StateType;
	import ddt.view.SetPannelView;
	import ddt.view.common.DeadTipDialog;
	import ddt.view.common.RoomIIPropTip;
	import ddt.view.im.IMController;
	import ddt.view.scenechatII.SceneChatIIFacePanel;
	
	/**
	 * 
	 * @author SYC
	 * 工具条 
	 */
	public class ToolStripView extends ToolStripAsset
	{
		public var specialEnabled:Boolean = true;
		private var _totalBlood: Number;
		
		private var _im_btn : HTipButton;
		private var _face_btn : HTipButton;
		private var _fastChat_btn : HTipButton;
		private var _set_btn : HTipButton;
		private var _exit_btn : HTipButton;
		private var _bloodStrip:BloodStrip;
		private var _powerStrip:PowerStrip;
		private var _danderStrip:DanderStrip;
		private var skillTip:RoomIIPropTip;
		
		private var _self:LocalPlayer;
		
		private var _startDate:Date;
		
		private var _chat:Sprite;
		public function set chat(value:Sprite):void
		{
			_chat = value;
		}
		
		private var _currentBlood:MovieClip;
		
		public function ToolStripView()
		{
			specialEnabled = true;
			startInit();
			addEvent();
			
		}
		
		private function startInit() : void
		{
			skillTip = new RoomIIPropTip(false,false,false);
			
			_im_btn   = new HTipButton(im_btn,"",LanguageMgr.GetTranslation("ddt.game.ToolStripView.friend"));
			_im_btn.useBackgoundPos = true;
			addChild(_im_btn);
			
			_face_btn  = new HTipButton(face_btn,"",LanguageMgr.GetTranslation("ddt.game.ToolStripView.face"));
			_face_btn.useBackgoundPos = true;
			addChild(_face_btn);
			
			_fastChat_btn = new HTipButton(fastChat_btn,"",LanguageMgr.GetTranslation("ddt.game.ToolStripView.chat"));
			_fastChat_btn.useBackgoundPos = true;
			addChild(_fastChat_btn);
			
			_set_btn = new HTipButton(set_btn,"",LanguageMgr.GetTranslation("ddt.game.ToolStripView.set"));
			_set_btn.useBackgoundPos = true;
			addChild(_set_btn);
			
			_exit_btn = new HTipButton(exit_btn,"",LanguageMgr.GetTranslation("ddt.game.ToolStripView.exit"));
			_exit_btn.useBackgoundPos = true;
			addChild(_exit_btn);
		}
		
		public function init():void
		{
			_bloodStrip = new BloodStrip();
			_bloodStrip.x = blood_mc.x;
			_bloodStrip.y = blood_mc.y;
			blood_mc.visible = false;
			addChild(_bloodStrip);
			
			_powerStrip = new PowerStrip(GameManager.Instance.Current.selfGamePlayer);
			_powerStrip.gotoAndStop(1);
			_powerStrip.x = powerStrip_mc.x;
			_powerStrip.y = powerStrip_mc.y-1;
			powerStrip_mc.visible = false;
			addChild(_powerStrip);
			
			_danderStrip = new DanderStrip();
			_danderStrip.gotoAndStop(1);
			_danderStrip.x = strip_mc.x;
			_danderStrip.y = strip_mc.y;
			strip_mc.visible = false;
			addChildAt(_danderStrip,getChildIndex(strip_mc));
			
			alpha = 1;
			mouseChildren = true;
			_danderStrip.addFrameScript(_frame - 1,null);
			_danderStrip.gotoAndStop(1);
			skill_btn.mouseEnabled = false;
			cartoon_mc.gotoAndStop(1);
			cartoon_mc.mouseEnabled = false;
			cartoon_mc.mouseChildren = false;
			
			_facePannel = new SceneChatIIFacePanel(true);
			_facePannel.x = 674;
			_facePannel.y = 365;
			_facePannel.setVisible(false);
			TipManager.AddTippanel(_facePannel);
			
			KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,__keydown);
		}
		
		public function setLocalPlayer(value:LocalPlayer):void
		{
			if(_self)
			{
				_self.removeEventListener(LivingEvent.DANDER_CHANGED,__dander);
				_self.removeEventListener(LivingEvent.BLOOD_CHANGED,__blood);
				_self.removeEventListener(LivingEvent.ATTACKING_CHANGED,__changeAttack);
				_self.removeEventListener(LivingEvent.DIE,__die);
				_self.removeEventListener(LivingEvent.ENERGY_CHANGED,__energy);
			}
			
			_self = value;
			
			if(_self)
			{
				_startDate = TimeManager.Instance.Now();
				_exit_btn.visible = true;
				_danderStrip.setInfo(_self);
				
				
				_self.addEventListener(LivingEvent.DANDER_CHANGED,__dander);
				_self.addEventListener(LivingEvent.BLOOD_CHANGED,__blood);
				_self.addEventListener(LivingEvent.ATTACKING_CHANGED,__changeAttack);
				_self.addEventListener(LivingEvent.DIE,__die);
				_self.addEventListener(LivingEvent.ENERGY_CHANGED,__energy);
				
				_totalBlood = _self.blood;
				__blood(null);
			}			
		}
		
		private function addEvent():void
		{
			skill_btn.addEventListener(MouseEvent.CLICK,__spellKill);
			
			showTip.addEventListener(MouseEvent.MOUSE_OVER,skillOverListener);
			showTip.addEventListener(MouseEvent.MOUSE_OUT,skillOutListener);
			skill_btn.addEventListener(MouseEvent.MOUSE_OVER,skillOverListener);
			skill_btn.addEventListener(MouseEvent.MOUSE_OUT,skillOutListener);
			_im_btn.addEventListener(MouseEvent.CLICK,__im);
			_face_btn.addEventListener(MouseEvent.CLICK,__face);
			_exit_btn.addEventListener(MouseEvent.CLICK,__exit);
			_set_btn.addEventListener(MouseEvent.CLICK,__setBtn);
			_fastChat_btn.addEventListener(MouseEvent.CLICK,__fastChat);
		}
		
		private function removeEvent():void
		{
			skill_btn.removeEventListener(MouseEvent.CLICK,__spellKill);
			showTip.removeEventListener(MouseEvent.MOUSE_OVER,skillOverListener);
			showTip.removeEventListener(MouseEvent.MOUSE_OUT,skillOutListener);
			skill_btn.removeEventListener(MouseEvent.MOUSE_OVER,skillOverListener);
			skill_btn.removeEventListener(MouseEvent.MOUSE_OUT,skillOutListener);
			_im_btn.removeEventListener(MouseEvent.CLICK,__im);
			_face_btn.removeEventListener(MouseEvent.CLICK,__face);
			_exit_btn.removeEventListener(MouseEvent.CLICK,__exit);
			_set_btn.removeEventListener(MouseEvent.CLICK,__setBtn);
			_fastChat_btn.removeEventListener(MouseEvent.CLICK,__fastChat);
		}
		
		public function dispose():void
		{
			KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,__keydown);
			removeEvent();
			if(_self)
			{
				_self.removeEventListener(LivingEvent.DANDER_CHANGED,__dander);
				_self.removeEventListener(LivingEvent.BLOOD_CHANGED,__blood);
				_self.removeEventListener(LivingEvent.ATTACKING_CHANGED,__changeAttack);
				_self.removeEventListener(LivingEvent.DIE,__die);
				_self.removeEventListener(LivingEvent.ENERGY_CHANGED,__energy);
			}
			
			_self = null;
			
			if(skillTip)skillTip.dispose();
			skillTip = null;
			_self = null;
			if(_facePannel.parent)
			{
				_facePannel.parent.removeChild(_facePannel);
			}
			if(_facePannel)_facePannel.dispose();
			_facePannel = null;
			if(_bloodStrip)
			{
				if(_bloodStrip.parent)_bloodStrip.parent.removeChild(_bloodStrip);
				_bloodStrip.dispose();
			}
			_bloodStrip = null;
			if(_powerStrip)
			{
				if(_powerStrip.parent)_powerStrip.parent.removeChild(_powerStrip);
				_powerStrip.dispose();
			}
			_powerStrip = null;
			
			remove();
			if(_danderStrip)
			{
				if(_danderStrip.parent)_danderStrip.parent.removeChild(_danderStrip);
				_danderStrip.dispose();
			}
				_danderStrip = null;
			
			if(_im_btn)
			{
				if(_im_btn.parent)_im_btn.parent.removeChild(_im_btn);
				_im_btn.dispose();
			}
			_im_btn = null;
			if(_face_btn)
			{
				if(_face_btn.parent)_face_btn.parent.removeChild(_face_btn);
				_face_btn.dispose();
			}
			_face_btn = null;
			if(_fastChat_btn)
			{
				if(_fastChat_btn.parent)_fastChat_btn.parent.removeChild(_fastChat_btn);
				_fastChat_btn.dispose();
			}
			_fastChat_btn = null;
			if(_set_btn)
			{
				if(_set_btn.parent)_set_btn.parent.removeChild(_set_btn);
				_set_btn.dispose();
			}
			_set_btn = null;
			if(_exit_btn)
			{
				if(_exit_btn.parent)_exit_btn.parent.removeChild(_exit_btn);
				_exit_btn.dispose();
			}
			_exit_btn = null;
			while(this.numChildren != 0)
			{
				var mc : DisplayObject = this.getChildAt(0) as DisplayObject;
				if(mc && mc.parent)mc.parent.removeChild(mc);
				mc = null;
			}
			if(parent)parent.removeChild(this);
		}

		private function __fastChat(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			SoundManager.Instance.play("008");
			ChatManager.Instance.switchVisible();
			ChatManager.Instance.setFocus();
		}
		
		private function __setBtn(event:MouseEvent):void
		{
			SetPannelView.Instance.switchVisible();
			SoundManager.Instance.play("008");
		}
		
		private function __keydown(event:KeyboardEvent):void
		{
			if(event.keyCode == KeyStroke.VK_B.getCode())
			{
				__spellKill();
			}
		}
		
		private function __spellKill(event:Event = null):void
		{
			if(!specialEnabled){
				return;
			}
			if(skill_btn.mouseEnabled)
			{
				_self.isSpecialSkill = true;
				GameInSocketOut.sendGameCMDStunt();
				SoundManager.Instance.play("008");
				updateDander(0);
			}
		}
		
		private function skillOverListener(event:MouseEvent):void
		{
			var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
			
			itemTemplateInfo.Name = LanguageMgr.GetTranslation("ddt.game.ToolStripView.itemTemplateInfo.Name");
			itemTemplateInfo.Description = LanguageMgr.GetTranslation("ddt.game.ToolStripView.itemTemplateInfo.Description");
			skillTip.update(itemTemplateInfo,1)
			
			var skill_pos:Point = this.localToGlobal(new Point(skill_btn.x,skill_btn.y));
			skillTip.x = skill_pos.x -skill_btn.width/2;
			skillTip.y = skill_pos.y - skillTip.height-30;;
			TipManager.AddTippanel(skillTip);
		}
		
		private function skillOutListener(event:MouseEvent):void
		{
			TipManager.RemoveTippanel(skillTip);
		}
		
		private var _facePannel:SceneChatIIFacePanel;
		private function __face(event:MouseEvent):void
		{
			_facePannel.setVisible(true);
			SoundManager.Instance.play("008");
			if(_facePannel.parent == null)
				TipManager.AddTippanel(_facePannel);
		}
	
		private function __im(event:MouseEvent):void
		{
			IMController.Instance.switchVisible();
			SoundManager.Instance.play("008");
		}
		
		private function __blood(event:LivingEvent):void
		{
			_bloodStrip.update(_self.blood,_self.maxBlood);
		}
		
		private function update(blood:int):void
		{
			_bloodStrip.update(blood,_self.maxBlood);
		}
		
		private function updateDander(dander:int):void
		{
			_danderStrip.addFrameScript(_frame - 1,null);
			_frame = Number((_danderStrip.totalFrames / Player.TOTAL_DANDER)* dander);
			if(_frame > 0)
			{
				_danderStrip.addFrameScript(_frame - 1,remove);
				_danderStrip.play();
			}
			if(dander >= Player.TOTAL_DANDER)
			{
				_danderStrip.gotoAndStop(_danderStrip.totalFrames);
				cartoon_mc.gotoAndStop(2);
				if(_self.isAttacking)
				{
					skill_btn.mouseEnabled = true;
				}
			}
			else
			{
				skill_btn.mouseEnabled = false;
				cartoon_mc.gotoAndStop(1);
				if(dander == 0)
				{
					_danderStrip.gotoAndStop(1);
				}
			}
		}
		
		private function __energy(evt:LivingEvent):void
		{
			if(_self.isLiving)
			{
				_powerStrip.changePower(int(_self.energy/_self.maxEnergy*_powerStrip.totalFrames));
			}else
			{
				_powerStrip.changePower(int(_self.energy/_self.maxEnergy*_powerStrip.totalFrames));
			}
		}
		
		private var _frame:int;
		private function __dander(event:LivingEvent):void
		{
			if(_self.isLiving)
			{
				updateDander(_self.dander);
			}
		}
		
		private function remove():void
		{
			if(_danderStrip && _frame > 0)
			{
				_danderStrip.stop();
				_danderStrip.addFrameScript(_frame - 1,null);
			}
		}
		
		private function __changeAttack(event:LivingEvent):void
		{
			if(_self.dander >= Player.TOTAL_DANDER)
			{
				skill_btn.mouseEnabled = _self.isAttacking;
			}
			else
			{
				skill_btn.mouseEnabled = false;
			}
		}
		
		private function __exit(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			/**变鬼了随时退出**/
			if(!_self.isLiving)
			{
				if(_self.selfDieTimeDelayPassed)__ok();
				return;
			}
			var playTime:Number = TimeManager.Instance.TimeSpanToNow(_startDate).time;
			if(RoomManager.Instance.current.roomType >= 2)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.game.ToolStripView.isExit"),true,__ok,__cancel);
				return;
			}
			else if(playTime < RoomInfo.SucideTime)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ToolStripView.cannotExit"));
				return;
			}
			else
			{
				ExitHintView.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.game.ToolStripView.isExit"),true,__ok,__cancel);
				return;
			}
		}
		private function __ok():void
		{
			if((StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW) && _exit_btn.enable)
			{
				mouseChildren = false;
				GameInSocketOut.sendGamePlayerExit();
				SoundManager.Instance.play("008");
			}
		}
		
		private function __cancel():void
		{
			SoundManager.Instance.play("008");
		}
		
		private function __die(event:LivingEvent):void
		{
			_exit_btn.visible = true;		
			update(0);
			updateDander(0);
			showDeadTip();
		}
		private function showDeadTip():void{
			if(_self.playerInfo.Grade>=10){//等级限制
				return;
			}
			if(!GameManager.Instance.Current.haveAllias){//己方还有存活队员
				return;
			}
			if(SharedManager.Instance.deadtip<2){
				SharedManager.Instance.deadtip++;
				var deadTip:DeadTipDialog = new DeadTipDialog();
				TipManager.AddTippanel(deadTip,true);
			}
		}
		
		public function gameOver():void
		{
			if(_self.isLiving)
			{
				_exit_btn.enable = false;
			}
		}
		
		public function set enableExit(b : Boolean) : void
		{
			if(_exit_btn)_exit_btn.enable = b;
		}
	}
}