package ddt.game
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import game.crazyTank.view.ArrowAsset;
	
	import org.aswing.KeyStroke;
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.WeaponInfo;
	import ddt.data.game.LocalPlayer;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.PropInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.LivingEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	import ddt.utils.GraphicsUtils;
	import ddt.view.common.GradientText;
	import ddt.view.common.RoomIIPropTip;
	
	public class ArrowViewIII extends ArrowAsset
	{
		private var _info:LocalPlayer;
		
		private var _sector:Sprite;
		
		private var _recordChangeBefore:Number;
		
		public static const FLY_CD:int = 2;
		/* 隐藏工具条事件 */
		public static const HIDE_BAR:String = "hide bar";
		/**
		 * 是否飞机 
		 */		
		private var _flyCoolDown:int = 0;
		private var _flyEnable:Boolean;
		
		private var rotationCountField:GradientText;
		private var fieldCenterX:Number;
		private var fieldCenterY:Number;
		
		private var _hammerCoolDown:int = 0;
		private var _hammerEnable:Boolean;
		private var textGlowFilter:GlowFilter;
		private var _deputyWeaponResCount:int;//副武器使用剩余次数(加血枪)
		
		public static const ADD_BLOOD_CD:int = 2;
		
		private var _closeFly : Boolean;//新手
		
		
		public static const RANDOW_COLORSII:Array = [ [0x149dfd,0xffde00],
														[0x168fff,0x27c8f0],
														[0x17bb3a,0xda182f],
														[0x78bb17,0xda18cf],
														[0xc4430a,0x75d108],
														[0xde6e00,0xf3af03],
														[0x5bbbfe,0x0cb324],
														[0x07f656,0xcca60a],
														[0xe56e04,0xacd718],
														[0xe6b213,0x7fb70a],
														[0x21c799,0x7bd9f9],
														[0xa3ce21,0xdd385a],
														[0xebe813,0xeb740a],
														[0xc6dc08,0x2ba8ff],
														[0xfe5e5b,0xbee43a],
														[0x00aeff,0x75d108]  ]
		public function set closeFly(b : Boolean) : void
		{
			_closeFly = b;
		}
		
		public function set flyEnable(value:Boolean):void
		{
			if(_closeFly)value = false;
			if(value == _flyEnable) return;
			_flyEnable = value;
			if(_flyEnable)
			{
				airplane_mc.gotoAndStop(2);
			}
			else
			{
				airplane_mc.gotoAndStop(1);
			}
			airplane_mc.buttonMode = _flyEnable;
			//airplane_mc.mouseEnabled = _flyEnable;
			airplane_mc.mouseChildren = _flyEnable;
		}
		public function get flyEnable():Boolean
		{
			return _flyEnable;
		}
		
		
		public function set hammerEnable(value:Boolean):void
		{
			if(value == _hammerEnable) return;
			if(!_info.hasDeputyWeapon()) 
			{
				_hammerEnable = false;
			}else
			{
				_hammerEnable = value;
			}
			if(_hammerEnable)
			{
				hammer_mc.gotoAndStop(2);
				
				hammer_mc.txtNumber.textColor=0xfff600;
				hammer_mc.txtNumber.filters=[new GlowFilter(0x000000, 1, 1.2, 1.2, 50, 2)];
				
				hammer_mc.txtNumberBg.textColor=0xfff600;
				hammer_mc.txtNumberBg.filters=[new DropShadowFilter(0, 0, 0xFF0000, 1, 8, 8, 4, 2)];
			}
			else
			{
				hammer_mc.gotoAndStop(1);
				
				hammer_mc.txtNumber.textColor=0xc1c1c1;
				hammer_mc.txtNumber.filters=[new GlowFilter(0x000000, 1, 1.2, 1.2, 50, 2)];
				
				hammer_mc.txtNumberBg.textColor=0xc1c1c1;
				hammer_mc.txtNumberBg.filters=[new DropShadowFilter(0, 0, 0x3b3b3b, 1, 8, 8, 4, 2)];
			}
			hammer_mc.buttonMode = _hammerEnable;
			//hammer_mc.mouseEnabled = _hammerEnable;
			hammer_mc.mouseChildren = _hammerEnable;
		}
		public function get hammerEnable():Boolean
		{
			return _hammerEnable;
		}
		
		public function ArrowViewIII(info:LocalPlayer)
		{
			arrowSub.arrowClone_mc.visible = false;
			arrowSub.arrowChonghe_mc.visible = false; // 重合线
			_sector = GraphicsUtils.drawSector(0,0,55,0,90);
			arrowSub.circle_mc.mask = _sector;
			arrowSub.circle_mc.visible = true;
			arrowSub.green_mc.visible = false;
			arrowSub.addChild(_sector);
			//			rotation_txt.text = "";
			removeChild(rotation_txt);
			rotationCountField = new GradientText(RANDOW_COLORSII);
			rotationCountField.width = rotation_txt.width;
			fieldCenterX = rotation_txt.x;
			fieldCenterY = rotation_txt.y;
			rotationCountField.x = fieldCenterX;
			rotationCountField.y = fieldCenterY;
			rotationCountField.autoSize = TextFieldAutoSize.CENTER;
			rotationCountField.setTextFormat(rotation_txt.defaultTextFormat);
//			textGlowFilter  =rotation_txt.filters[0];
//			rotationCountField.filters = [textGlowFilter];
			addChild(rotationCountField);
			rotationCountField.setText(rotationCountField.text);
			
			_info = info;
			addEvent();
			reset();
			__weapAngle(null);
			__changeDirection(null);
			_flyEnable = false;
			flyEnable = true;
			_hammerEnable = false;
			hammerEnable = true;
			_flyCoolDown = 0;
			_hammerCoolDown = 0;
			
			hammer_mc.txtNumber.mouseEnabled=hammer_mc.txtNumberBg.mouseEnabled=false;
			if(_info.selfInfo && _info.selfInfo.DeputyWeapon)
			{//副武器显示总共可以使用多少次
				_deputyWeaponResCount=_info.selfInfo.DeputyWeapon.StrengthenLevel+1;
				hammer_mc.txtNumber.visible=hammer_mc.txtNumberBg.visible=true;
				hammer_mc.txtNumberBg.text=hammer_mc.txtNumber.text=_deputyWeaponResCount.toString();
			}
			else
			{
				hammer_mc.txtNumber.visible=hammer_mc.txtNumberBg.visible=false;
			}
		}
		
		private function reset():void
		{
			arrowSub.green_mc.mask = null;
			arrowSub.circle_mc.mask = _sector;
			arrowSub.circle_mc.visible = true;
			arrowSub.green_mc.visible = false;
			if(_info && _info.currentWeapInfo)
			{
				GraphicsUtils.changeSectorAngle(_sector,0,0,55,_info.currentWeapInfo.armMinAngle,_info.currentWeapInfo.armMaxAngle - _info.currentWeapInfo.armMinAngle);
			}
		}
		
		/**
		 *是否隐藏工具条 bret 09.6.4 
		 * 
		 */		
		private var _hideState:Boolean;
		public function set hideState(param:Boolean):void
		{
			_hideState = param;
		}
		public function get hideState():Boolean
		{
			return _hideState;
		}
		
		/**
		 * 传送角度 
		 * 
		 */		
		private function carrayAngle():void
		{
			arrowSub.circle_mc.mask = null;
			arrowSub.green_mc.mask = _sector;
			arrowSub.circle_mc.visible = false;
			arrowSub.green_mc.visible = true;		
			GraphicsUtils.changeSectorAngle(_sector,0,0,55,0,90);
		}
		
		public function dispose():void
		{
			removeEvent();
			while(this.numChildren != 0)
			{
				var mc : DisplayObject = this.getChildAt(0) as DisplayObject;
				if(mc && mc.parent)mc.parent.removeChild(mc);
				mc = null;
			}
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		private function addEvent():void
		{
			_info.addEventListener(LivingEvent.GUNANGLE_CHANGED,__weapAngle);
			_info.addEventListener(LivingEvent.DIR_CHANGED,__changeDirection);
			_info.addEventListener(LivingEvent.ANGLE_CHANGED,__changeAngle);
			_info.addEventListener(LivingEvent.BOMB_CHANGED,__changeBall);
			_info.addEventListener(LivingEvent.ATTACKING_CHANGED,__setArrowClone);
			_info.addEventListener(LivingEvent.ATTACKING_CHANGED,__change);
			_info.addEventListener(LivingEvent.ENERGY_CHANGED,__energyChanged);
			_info.addEventListener(LivingEvent.BEGIN_NEW_TURN,__onTurnChange);
			_info.addEventListener(LivingEvent.DIE,__die);
			_info.addEventListener(LivingEvent.LOCKANGLE_CHANGE,__lockAngleChangeHandler);
			addEventListener(Event.ENTER_FRAME,__enterFrame);
			hammer_mc.addEventListener(MouseEvent.CLICK,__hammer);
			hammer_mc.addEventListener(MouseEvent.MOUSE_OVER,haummerOverListener);
			hammer_mc.addEventListener(MouseEvent.MOUSE_OUT,haummerOutListener);
			hideBtn.addEventListener(MouseEvent.MOUSE_OVER,hideOverListener);
			hideBtn.addEventListener(MouseEvent.MOUSE_OUT,hideOutListener);
			airplane_mc.addEventListener(MouseEvent.CLICK,__airplane);
			airplane_mc.addEventListener(MouseEvent.MOUSE_OVER,airplaneOverListener);
			airplane_mc.addEventListener(MouseEvent.MOUSE_OUT,airplaneOutListener);
			KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,__keydown);
			KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,__inputKeyDown);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,__setDeputyWeaponNumber);
		}
		
		private function removeEvent():void
		{
			_info.removeEventListener(LivingEvent.GUNANGLE_CHANGED,__weapAngle);
			_info.removeEventListener(LivingEvent.DIR_CHANGED,__changeDirection);
			_info.removeEventListener(LivingEvent.ANGLE_CHANGED,__changeAngle);
			_info.removeEventListener(LivingEvent.BOMB_CHANGED,__changeBall);
			_info.removeEventListener(LivingEvent.ATTACKING_CHANGED,__setArrowClone);
			_info.removeEventListener(LivingEvent.ATTACKING_CHANGED,__change);
			_info.removeEventListener(LivingEvent.ENERGY_CHANGED,__energyChanged);
			_info.removeEventListener(LivingEvent.DIE,__die);
			_info.removeEventListener(LivingEvent.BEGIN_NEW_TURN,__onTurnChange);
			_info.removeEventListener(LivingEvent.LOCKANGLE_CHANGE,__lockAngleChangeHandler);
			
			hideBtn.removeEventListener(MouseEvent.MOUSE_OVER,hideOverListener);
			hideBtn.removeEventListener(MouseEvent.MOUSE_OUT,hideOutListener);
			
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			hammer_mc.removeEventListener(MouseEvent.CLICK,__hammer);
			hammer_mc.removeEventListener(MouseEvent.MOUSE_OVER,haummerOverListener);
			hammer_mc.removeEventListener(MouseEvent.MOUSE_OUT,haummerOutListener);
			airplane_mc.removeEventListener(MouseEvent.CLICK,__airplane);
			airplane_mc.removeEventListener(MouseEvent.MOUSE_OVER,airplaneOverListener);
			airplane_mc.removeEventListener(MouseEvent.MOUSE_OUT,airplaneOutListener);
			
			KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,__keydown);
			KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,__inputKeyDown);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,__setDeputyWeaponNumber);
		}
		
		private function __lockAngleChangeHandler(e:LivingEvent):void
		{
			if(e.value == 1)
				enableArrow = true;
			else
				enableArrow = false;
		}
		
		private var _enableArrow : Boolean;
		public function set enableArrow(b : Boolean) : void
		{
			_enableArrow = b;
			if(!b)
			{
				addEventListener(Event.ENTER_FRAME,   __enterFrame);
				KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,__inputKeyDown);
			}
			else 
			{
				KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,__inputKeyDown);
				removeEventListener(Event.ENTER_FRAME, __enterFrame);
			}
		}
		
		private function __onTurnChange(e:LivingEvent):void
		{
			//			rotationCountField.y = fieldCenterY+Math.random()*16;
			rotationCountField.setText(rotationCountField.text);
//			textGlowFilter.color = VaneView.RANDOW_COLORS[int((Math.random()*10000)%10)];
//			rotationCountField.filters = [textGlowFilter];
		}
		
		private function __die(event:Event):void
		{
			if(!_info.isLiving)
			{
				flyEnable = false;
				hammerEnable = false;
			}
		}
		
		private function __hammer(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			
			var deputyEnergy:Number = Number(_info.currentDeputyWeaponInfo.energy);//取得使用副武器所需消耗的体力,默认为110
			
			if(_hammerBlocked) return;
			
			if(_hammerEnable)
			{
				if(_info.isAttacking)
				{
					if(_info.selfInfo && _info.selfInfo.DeputyWeapon && _deputyWeaponResCount<=0)
					{//副武器如果剩余次数为0
						switch(_info.selfInfo.DeputyWeapon.TemplateID)
						{
							case 17001:
							case 17002://天使之赐
								MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.deputyWeapon.canNotUse"));
								break;
							case 17003://啵咕盾牌
								MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.deputyWeapon.canNotUse2"));
								break;
							case 17004://巴罗夫的盾牌
								MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.deputyWeapon.canNotUse3"));
								break;
						}
						return;
					}
					
					_hammerCoolDown = _info.currentDeputyWeaponInfo.coolDown;
					SocketManager.Instance.out.useDeputyWeapon();
					
					var dis:DisplayObject = _info.currentDeputyWeaponInfo.getDeputyWeaponIcon();
					dis.x += 7;
					_info.useItemByIcon(dis);//获取副武器Icon
					
					_info.energy -= deputyEnergy;
					if(_info.hasDeputyWeapon() && _info.currentDeputyWeaponInfo.ballId > 0)
					{
						_info.currentBomb = _info.currentDeputyWeaponInfo.ballId;
					}
					
					hammerEnable = false;			
				}
				else
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.fall"));
					//MessageTipManager.getInstance().show("轮到你行动时才可以使用");
				}
				
			}
			else if(_info.hasDeputyWeapon())
			{
				if(_info.isLiving)
				{
					if(_hammerCoolDown >0)
					{
						LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.bout")
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.skill",_hammerCoolDown));
						//MessageTipManager.getInstance().show("技能还需要"+_flyCoolDown+"回合才能使用");
					}
					else if(!_info.isAttacking)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.fall"));
						//MessageTipManager.getInstance().show("轮到你行动时才可以使用");
					}
					else if(_info.energy < deputyEnergy)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.actions.SelfPlayerWalkAction"));
						//MessageTipManager.getInstance().show("体力不足");
					}
				}
			}	
		}
		
		
		
		private function __energyChanged(event:LivingEvent):void
		{
			var deputyEnergy:Number = _info.currentDeputyWeaponInfo.energy;//取得使用副武器所需消耗的体力,默认为110
			if(_info.energy < FLY_ENERGY)
			{
				flyEnable = false;
			}
			if(_info.energy < deputyEnergy)
			{
				hammerEnable = false;
			}
		}
		
		public static const FLY_ENERGY:int = 150;
		private function __airplane(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			
			if(_flyEnable)
			{
				if(_info.isAttacking)
				{
					_flyCoolDown = FLY_CD;
					SocketManager.Instance.out.sendAirPlane();
					var item:InventoryItemInfo = new InventoryItemInfo();
					var temInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(10016);
					item.TemplateID = temInfo.TemplateID;
					item.Pic = "2";
					item.Property4 = temInfo.Property4;
					
					var info:PropInfo = new PropInfo(item);
					_info.useItem(info.Template);
					_info.currentBomb = 3;
					flyEnable = false;			
				}
				else
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.fall"));
					//MessageTipManager.getInstance().show("轮到你行动时才可以使用");
				}
				
			}
			else 
			{
				if(_info.isLiving)
				{
					if(_flyCoolDown >0)
					{
						LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.bout")
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.skill",_flyCoolDown));
						//MessageTipManager.getInstance().show("技能还需要"+_flyCoolDown+"回合才能使用");
					}
					else if(!_info.isAttacking)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.fall"));
						//MessageTipManager.getInstance().show("轮到你行动时才可以使用");
					}
					else if(_info.energy < FLY_ENERGY)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.actions.SelfPlayerWalkAction"));
						//MessageTipManager.getInstance().show("体力不足");
					}
				}
			}		
			
		}
		
		private var hideBtnTip:RoomIIPropTip;
		private var planeTip:RoomIIPropTip;
		
		private function hideOverListener(event:MouseEvent):void
		{
			var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
			itemTemplateInfo.Name = LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.big");
			itemTemplateInfo.Description = LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.alpha");
			
			hideBtnTip = new RoomIIPropTip(false,false,false);
			hideBtnTip.update(itemTemplateInfo,1);
			
			var hide_pos:Point = this.localToGlobal(new Point(hideBtn.x,hideBtn.y));
			hideBtnTip.x = hide_pos.x;
			hideBtnTip.y = hide_pos.y - hideBtnTip.height-10;
			TipManager.AddTippanel(hideBtnTip);
		}
		
		private function hideOutListener(event:MouseEvent):void
		{
			TipManager.RemoveTippanel(hideBtnTip);
		}
		
		private function airplaneOverListener(event:MouseEvent):void
		{
			if(planeTip == null)
			{
				var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
				itemTemplateInfo.Name = LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.send");
				itemTemplateInfo.Property4 = "150";
				itemTemplateInfo.Description = LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.give");
				
				planeTip = new RoomIIPropTip(false,false,true);
				planeTip.update(itemTemplateInfo,1);
				
				var plan_pos:Point = this.localToGlobal(new Point(airplane_mc.x,airplane_mc.y));
				planeTip.x = plan_pos.x;
				planeTip.y = plan_pos.y - planeTip.height;
			}
			TipManager.AddTippanel(planeTip);
		}
		
		private function airplaneOutListener(event:MouseEvent):void
		{
			if(planeTip) TipManager.RemoveTippanel(planeTip);
		}
		private var hammerTip:RoomIIPropTip;
		private function haummerOverListener(event:MouseEvent):void
		{
			if(hammerTip == null)
			{
				if(_info.playerInfo.DeputyWeapon == null) return;
				var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
				itemTemplateInfo.Name = LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.deputyweapon.title");
				itemTemplateInfo.Property4 = String(_info.playerInfo.DeputyWeapon.Property4);
				itemTemplateInfo.Description = LanguageMgr.GetTranslation("ddt.game.ArrowViewIII.deputyweapon.description");
				hammerTip = new RoomIIPropTip(false,false,true);
				hammerTip.update(itemTemplateInfo,1);
				
				var plan_pos:Point = this.localToGlobal(new Point(hammer_mc.x,hammer_mc.y));
				hammerTip.x = plan_pos.x;
				hammerTip.y = plan_pos.y - hammerTip.height;
			}
			TipManager.AddTippanel(hammerTip);
		}
		
		private function haummerOutListener(event:MouseEvent):void
		{
			if(hammerTip)TipManager.RemoveTippanel(hammerTip);
		}
		
		public static const ANGLE_NEXTCHANGE_TIME:int = 100;
		private var _currentAngleChangeTime:int = 0;
		private function __enterFrame(event:Event):void
		{
			var currentTime:int = getTimer();
			if(currentTime - _currentAngleChangeTime < ANGLE_NEXTCHANGE_TIME)return;
			var playSound:Boolean = false;
			var angleChanged:Boolean;
			if(KeyboardManager.isDown(83) || KeyboardManager.isDown(Keyboard.DOWN))
			{
				if(_currentAngleChangeTime != 0)
				{
					playSound = _info.setGunAngle(_info.gunAngle - WeaponInfo.ROTATITON_SPEED);
				}
				else
				{
					_currentAngleChangeTime = getTimer();
				}
				angleChanged = true;
			}else if(KeyboardManager.isDown(87) || KeyboardManager.isDown(Keyboard.UP))
			{
				if(_currentAngleChangeTime != 0)
				{
					playSound = _info.setGunAngle(_info.gunAngle + WeaponInfo.ROTATITON_SPEED);
				}
				if(_currentAngleChangeTime == 0)
				{
					_currentAngleChangeTime = getTimer();
				}
				angleChanged = true;
			}
			
			if(!angleChanged)_currentAngleChangeTime = 0;
			if(playSound) SoundManager.Instance.play("006");
		}
		
		private function __inputKeyDown(event:KeyboardEvent):void
		{
			if(!ChatManager.Instance.input.inputField.isFocus())
			{
				var playSound:Boolean = false;
				if(event.keyCode == 83 || event.keyCode == Keyboard.DOWN)
				{
					playSound = _info.setGunAngle(_info.gunAngle - WeaponInfo.ROTATITON_SPEED);
					_currentAngleChangeTime = 0;
				}else if(event.keyCode == 87 || event.keyCode == Keyboard.UP)
				{
					playSound = _info.setGunAngle(_info.gunAngle + WeaponInfo.ROTATITON_SPEED);
					_currentAngleChangeTime = 0;
				}
				if(playSound) SoundManager.Instance.play("006");
			}
		}
		
		private function __keydown(event:KeyboardEvent):void
		{
			if(event.keyCode == KeyStroke.VK_F.getCode())
			{
				__airplane(null);
			}else if(event.keyCode ==KeyStroke.VK_T.getCode())
			{
				dispatchEvent(new Event(ArrowViewIII.HIDE_BAR));
			}
			else if(event.keyCode ==KeyStroke.VK_R.getCode())
			{
				__hammer(null);
			}
		}
		
		private function __changeBall(event:LivingEvent):void
		{
			if(_info.currentBomb == 3)
			{
				carrayAngle();
			}
			else
			{
				resetAngle();
			}
		}
		
		private function resetAngle():void
		{
			reset();
		}
		
		private function __change(event:LivingEvent):void
		{
			var deputyEnergy:Number = Number(_info.currentDeputyWeaponInfo.energy);//取得使用副武器所需消耗的体力,默认为110
			resetAngle();
			if(_info.isAttacking)
			{
				_flyCoolDown --;
				if(_flyCoolDown <= 0 && _info.energy >= FLY_ENERGY)
				{
					flyEnable = true;
				}
				
				_hammerCoolDown -- ;
				if(_hammerCoolDown <= 0 && _info.energy >= deputyEnergy)
				{
					hammerEnable = true;
				}
			}
			else
			{
				if(_flyCoolDown <= 0)
				{
					flyEnable = true;
				}
				
				if(_hammerCoolDown <= 0)
				{
					hammerEnable = true;
				}
			}
		}
		
		private function __weapAngle(event:LivingEvent):void
		{
			var temp:Number = 0;
			if(_info.direction == -1)
			{
				temp = 0;	
			}
			else 
			{
				temp = 180;
			}
			
			if(_info.gunAngle < 0)
			{
				arrowSub.arrow.rotation = 360 - (_info.gunAngle - 180 + temp) * _info.direction;
			}
			else 
			{
				arrowSub.arrow.rotation = 360 - (_info.gunAngle +180 + temp) * _info.direction ;
			}
			_recordChangeBefore = _info.gunAngle;
			rotationCountField.setText( String(_info.gunAngle + _info.playerAngle * -1 * _info.direction),false);
			//			rotation_txt.text = String(_info.gunAngle + _info.playerAngle * -1 * _info.direction);
				
			if(arrowSub.arrow.rotation == arrowSub.arrowClone_mc.rotation)
			{
				arrowSub.arrowChonghe_mc.visible = true; // 
				arrowSub.arrowChonghe_mc.rotation = arrowSub.arrow.rotation;
			}
			else
			{
				arrowSub.arrowChonghe_mc.visible = false; // 
			}
		}
		
		private function __changeDirection(event:LivingEvent):void
		{
			__weapAngle(null);
			if(_info.direction == -1)
			{
				_sector.scaleX = -1; 
			}
			else
			{
				_sector.scaleX = 1;
			}
		}
		
		private function __changeAngle(event:LivingEvent):void
		{
			var dis:Number = arrowSub.rotation - _info.playerAngle;
			arrowSub.rotation = _info.playerAngle;
			_recordRotation = _recordRotation + dis;
			arrowSub.arrowClone_mc.rotation = _recordRotation;
			rotationCountField.setText( String(_info.gunAngle + _info.playerAngle * -1 * _info.direction),false);
			
			if(arrowSub.arrow.rotation == arrowSub.arrowClone_mc.rotation)
			{
				arrowSub.arrowChonghe_mc.visible = true; // 
				arrowSub.arrowChonghe_mc.rotation = arrowSub.arrow.rotation;
			}
			else
			{
				arrowSub.arrowChonghe_mc.visible = false; // 
			}
		}
		
		private var _recordRotation:Number;
		private function __setArrowClone(event:Event):void
		{
			if(!_info.isAttacking)
			{
				arrowSub.arrowClone_mc.visible = true;
				_recordRotation = arrowSub.arrow.rotation;
				arrowSub.arrowClone_mc.rotation = arrowSub.arrow.rotation;
			}
		}
		
		private var _hammerBlocked:Boolean;
		public function blockHammer():void{
			_hammerBlocked = true;
			_hammerCoolDown = 100000;
		}
		public function allowHammer():void{
			_hammerBlocked = false;
			_hammerCoolDown = 0;
		}
		
		private function __setDeputyWeaponNumber(event:CrazyTankSocketEvent):void
		{
			_deputyWeaponResCount=event.pkg.readInt();
			hammer_mc.txtNumber.visible=hammer_mc.txtNumberBg.visible=true;
			hammer_mc.txtNumber.text=hammer_mc.txtNumberBg.text=_deputyWeaponResCount.toString();
		}
	}
}