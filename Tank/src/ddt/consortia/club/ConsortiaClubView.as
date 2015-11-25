package ddt.consortia.club
{
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.TipManager;
	
	import tank.assets.ScaleBMP_18;
	import tank.assets.ScaleBMP_23;
	import ddt.consortia.ConsortiaControl;
	import ddt.consortia.ConsortiaModel;
	import ddt.consortia.IConsortiaViewPage;
	import tank.consortia.accect.consortiaClubViewAsset;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.data.EquipType;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.common.FastPurchaseGoldBox;
	public class ConsortiaClubView extends consortiaClubViewAsset implements IConsortiaViewPage
	{
		private var _applyRecordList       : ConsortiaRecordList;
		private var _clubList              : ConsortiaClubList;
		private var _randomSearchBtnAccect : HBaseButton;
		private var _applyJoinBtnAccect    : HBaseButton;
		private var _searchBtnAccect       : HBaseButton;
		private var _createConsortiaBtn    : HBaseButton;
		private var _model                 : ConsortiaModel;
		private var _contro                : ConsortiaControl;
		private var _text:TextArea;
		private var _bg1:ScaleBMP_18;
		private var _bg2:ScaleBMP_23;
		public function ConsortiaClubView(model : ConsortiaModel,contro : ConsortiaControl)
		{
			super();
			_model = model;
			_contro = contro;
			init();
			addEvent();
		}
		
		private function init() : void
		{
			_bg1 = new ScaleBMP_18();
			_bg1.x = pos1.x;
			_bg1.y = pos1.y;
			addChildAt(_bg1 , 0);
			removeChild(pos1);
			_bg2 = new ScaleBMP_23();
			_bg2.x = pos2.x;
			_bg2.y = pos2.y;
			addChildAt(_bg2 , 1);
			removeChild(pos2);
			_applyRecordList = new ConsortiaRecordList(_model,_contro);
			_clubList        = new ConsortiaClubList(_model);
			_applyRecordList.x = applyRecordListPos.x;
			_applyRecordList.y = applyRecordListPos.y;
			_clubList.x        = consortiaListPos.x;;
			_clubList.y        = consortiaListPos.y;
			this.addChild(_applyRecordList);
			this.addChild(_clubList);
			this.removeChild(applyRecordListPos);
			this.removeChild(consortiaListPos);
			
			_randomSearchBtnAccect = new HBaseButton(this.randomSearchBtnAccect);
			_randomSearchBtnAccect.useBackgoundPos = true;
			addChild(_randomSearchBtnAccect);
			_applyJoinBtnAccect  = new HBaseButton(this.applyJoinBtnAccect);
			_applyJoinBtnAccect.useBackgoundPos = true;
			addChild(_applyJoinBtnAccect);
			_applyJoinBtnAccect.enable = false;
			_searchBtnAccect = new HBaseButton(this.searchBtnAccect);
			_searchBtnAccect.useBackgoundPos = true;
			addChild(_searchBtnAccect);
			_createConsortiaBtn = new HBaseButton(this.createConsortiaBtn);
			_createConsortiaBtn.useBackgoundPos = true;
			addChild(_createConsortiaBtn);
			
			this.searchTxt.text = LanguageMgr.GetTranslation("ddt.consortia.club.searchTxt");
			//this.searchTxt.text = "请输入公会名称";
			var order : int = Math.floor(Math.random() * 5)+1;
			_contro.searchConsortiaClubList(1,6,order,"",1);
			
			/* 公会宣言 bret 09.6.2 */ 
			_text = new TextArea();
			_text.setStyle("upSkin",new Sprite());
			_text.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 16;
			format.color = 0x013465;
			format.leading = 4;
			_text.setStyle("disabledTextFormat",format);
			_text.setStyle("textFormat",format);
			_text.setSize(413,166);
			_text.textField.defaultTextFormat = new TextFormat("Arial",16,0x013465);
			
			var filterA:Array = [];
			var glowFilter:GlowFilter = new GlowFilter(0xffffff,1,4,4,10);
			filterA.push(glowFilter);
			_text.textField.filters = filterA;
			addChild(_text);
			_text.x = 536;
			_text.y = 117;
			
			_text.editable = false;
			
			//**********************************************************
			_text.textField.selectable = false;
			_text.textField.mouseEnabled = false;
			applyNoteBtnAccect.buttonMode = true;
			inviteNoteBtnAccect.buttonMode = true;
//			consortiaDeclarationTxt.selectable = false;
//			consortiaDeclarationTxt.mouseEnabled = false;
		}
		private function addEvent() : void
		{
			_randomSearchBtnAccect.addEventListener(MouseEvent.CLICK, __searchConsortiaClubHandler);
			_searchBtnAccect.addEventListener(MouseEvent.CLICK,       __searchConsortiaClubHandler);
			_applyJoinBtnAccect.addEventListener(MouseEvent.CLICK,    __applyJoinClickHandler);
			_createConsortiaBtn.addEventListener(MouseEvent.CLICK,    __createConsortiaClickHandler);
			applyNoteBtnAccect.addEventListener(MouseEvent.CLICK,     __selectRecordClickHandler);
			inviteNoteBtnAccect.addEventListener(MouseEvent.CLICK,    __selectRecordClickHandler);
			_clubList.addEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM, __selectClubItemHandler);
			
			searchTxt.addEventListener(Event.ADDED_TO_STAGE,    __searchTxt);
			searchTxt.addEventListener(FocusEvent.FOCUS_IN,     __focusInHandler);
			searchTxt.addEventListener(FocusEvent.FOCUS_OUT,    __focusOutHandler);
			addEventListener(KeyboardEvent.KEY_DOWN,            __keyDownHandler);
			_applyRecordList.addEventListener(ConsortiaDataEvent.SELECT_RECORD_TYPE,   __gotoRecordStatus);
			PlayerManager.Instance.addEventListener(PlayerManager.CONSORTIAMEMBER_STATE_CHANGED,   __gotoMyConsortiaView);
		}
		
		private function removeEvent():void
		{
			_randomSearchBtnAccect.removeEventListener(MouseEvent.CLICK, __searchConsortiaClubHandler);
			_searchBtnAccect.removeEventListener(MouseEvent.CLICK,       __searchConsortiaClubHandler);
			_applyJoinBtnAccect.removeEventListener(MouseEvent.CLICK,    __applyJoinClickHandler);
			_createConsortiaBtn.removeEventListener(MouseEvent.CLICK,    __createConsortiaClickHandler);
			applyNoteBtnAccect.removeEventListener(MouseEvent.CLICK,     __selectRecordClickHandler);
			inviteNoteBtnAccect.removeEventListener(MouseEvent.CLICK,    __selectRecordClickHandler);
			_clubList.removeEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM,                       __selectClubItemHandler);
			PlayerManager.Instance.removeEventListener(PlayerManager.CONSORTIAMEMBER_STATE_CHANGED,   __gotoMyConsortiaView);
			_applyRecordList.removeEventListener(ConsortiaDataEvent.SELECT_RECORD_TYPE,               __gotoRecordStatus);
			searchTxt.removeEventListener(Event.ADDED_TO_STAGE,    __searchTxt);
			searchTxt.removeEventListener(FocusEvent.FOCUS_IN,     __focusInHandler);
			searchTxt.removeEventListener(FocusEvent.FOCUS_OUT,    __focusOutHandler);
			removeEventListener(KeyboardEvent.KEY_DOWN,            __keyDownHandler);
		}
		
		/*当玩家申请时，自动切换到申请列表页面*/
		private function __gotoRecordStatus(evt : ConsortiaDataEvent) : void
		{
			if(int(evt.data) == 1)
			{
				applyNoteBtnAccect.gotoAndStop(1);
				inviteNoteBtnAccect.gotoAndStop(2);
			}
			else
			{
				applyNoteBtnAccect.gotoAndStop(2);
				inviteNoteBtnAccect.gotoAndStop(1);
			}
			
		}
		
		
		/*搜索文本取得OR失去焦点时*/
		private function __focusInHandler(evt : FocusEvent) : void
		{
			if(searchTxt.text == LanguageMgr.GetTranslation("ddt.consortia.club.searchTxt"))
			//if(searchTxt.text == "请输入公会名称")
			searchTxt.text = "";
		}
		private function __focusOutHandler(evt : FocusEvent) : void
		{
			if(searchTxt.text == "")
			{
				this.searchTxt.text = LanguageMgr.GetTranslation("ddt.consortia.club.searchTxt");
				//this.searchTxt.text = "请输入公会名称";
			}
		}
		private function __searchTxt(e:Event):void
		{
			this.searchTxt.text = LanguageMgr.GetTranslation("ddt.consortia.club.searchTxt");
			//this.searchTxt.text = "请输入公会名称";
		}
		
		/*go to 我的公会*/
		private function __gotoMyConsortiaView(evt : Event) : void
		{
			this._contro.viewState = ConsortiaControl.MYCONSORTIA_STATE;
		}
		
		
		/*公会搜索(随机搜/按名称搜)*/
		private var _consortiaClubPage : int = 1;
		private function __searchConsortiaClubHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			this._applyJoinBtnAccect.enable = false;
			if(evt.target.name == "randomSearchBtnAccect")
			{
				_consortiaClubPage ++;
				if(_model.consortiaListTotalPage != 0)
				{
					if(_consortiaClubPage > _model.consortiaListTotalPage)_consortiaClubPage = 1;
				}
				else
				{
					_consortiaClubPage = 1;
				}
				this._contro.searchConsortiaClubList(_consortiaClubPage,6,-1,"",1);
			}
			else if(evt.target.name == "searchBtnAccect")
			{
				if(searchTxt.text == "" || searchTxt.text == LanguageMgr.GetTranslation("ddt.consortia.club.searchTxt"))
				//if(searchTxt.text == "" || searchTxt.text == "请输入公会名称")
				{
					_consortiaClubPage ++;
				    if(_model.consortiaListTotalPage != 0)
			    	{
					if(_consortiaClubPage > _model.consortiaListTotalPage)_consortiaClubPage = 1;
			    	}
					this._contro.searchConsortiaClubList(_consortiaClubPage,6);
				}
				else
				{
					this._contro.searchConsortiaClubList(1,6,-1,this.searchTxt.text);
				}
				
			}
			_clubList.currentItemEmpty();
			
		}
		/*查看记录(申请记录/邀请记录)*/
		private function __selectRecordClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			if(evt.target.name == "applyNoteBtnAccect")
			{
				_applyRecordList.displayRecordType(2);
			}
			else if(evt.target.name == "inviteNoteBtnAccect")
			{
				_applyRecordList.displayRecordType(1);
			}
		}
		/*加入申请*/
		private function __applyJoinClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			if(!_clubList.currentSelectItem.info.OpenApply)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.club.ConsortiaClubView.applyJoinClickHandler"));
				//MessageTipManager.getInstance().show("该公会暂时不允许申请加入");
				return;
			}
			_applyJoinBtnAccect.enable = false;
			SocketManager.Instance.out.sendConsortiaTryIn(_clubList.currentSelectItem.info.ConsortiaID);
			_clubList.currentSelectItem.status = false;
			_clubList.currentSelectItem.isApply = true;
		}
		/*创建公会*/
		private function __createConsortiaClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			var createConsortia :CreatConsortiaFrame  = new CreatConsortiaFrame(_contro);
			TipManager.AddTippanel(createConsortia,true);
		}
		/*选中公会*/
		private function __selectClubItemHandler(evt : ConsortiaDataEvent) : void
		{
			if(!_clubList.currentSelectItem)
			{
				_applyJoinBtnAccect.enable = false;
				_text.text = "";
				return;
			}
			
			this._applyJoinBtnAccect.enable = (!_clubList.currentSelectItem.isApply) ? true : false;
	    	_text.text = _clubList.currentSelectItem.info.Description;
		    //consortiaDeclarationTxt.text = _clubList.currentSelectItem.info.Description;
		    if(_clubList.currentSelectItem.info.Description == "")
		    _text.text = LanguageMgr.GetTranslation("ddt.consortia.club.text");
		    //_text.text = "这小子很懒,什么也没留下!";
		    //consortiaDeclarationTxt.text = "这小子很懒,什么也没留下!";
			
			
		}
		/*回车时搜索*/
		private function __keyDownHandler(evt : KeyboardEvent) : void
		{
			
			evt.stopPropagation();
			if(evt.keyCode == Keyboard.ENTER)
			{
				SoundManager.instance.play("008");
				_applyJoinBtnAccect.enable = false;
				if(searchTxt.text != LanguageMgr.GetTranslation("ddt.consortia.club.searchTxt"))
				//if(searchTxt.text != "请输入公会名称")
	    		this._contro.searchConsortiaClubList(1,6,-1,this.searchTxt.text);
			}
			
		}
		
		public function dispose ():void
		{
			
			removeEvent();
			if(_applyRecordList)_applyRecordList.dispose();
			if(_applyRecordList && _applyRecordList.parent)_applyRecordList.parent.removeChild(_applyRecordList);
			_applyRecordList = null;
			if(_clubList)_clubList.dispose();
			if(_clubList && _clubList.parent)_clubList.parent.removeChild(_clubList);
			_clubList = null;
			if(_randomSearchBtnAccect && _randomSearchBtnAccect.parent)_randomSearchBtnAccect.parent.removeChild(_randomSearchBtnAccect);
			if(_randomSearchBtnAccect)_randomSearchBtnAccect.dispose();
			_randomSearchBtnAccect = null;
			if(_applyJoinBtnAccect && _applyJoinBtnAccect.parent)_applyJoinBtnAccect.parent.removeChild(_applyJoinBtnAccect);
			if(_applyJoinBtnAccect)_applyJoinBtnAccect.dispose();
			_applyJoinBtnAccect = null;
			if(_searchBtnAccect && _searchBtnAccect.parent)_searchBtnAccect.parent.removeChild(_searchBtnAccect);
			if(_searchBtnAccect)_searchBtnAccect.dispose();
			_searchBtnAccect = null;
			if(_createConsortiaBtn && _createConsortiaBtn.parent)_createConsortiaBtn.parent.removeChild(_createConsortiaBtn);
			if(_createConsortiaBtn)_createConsortiaBtn.dispose();
			_createConsortiaBtn = null;
			if(_bg1)
			{
				removeChild(_bg1);
			}
			_bg1 = null;
			if(_bg2)
			{
				removeChild(_bg2);
			}
			_bg2 = null;
//			super.dispose();
			if(parent)this.parent.removeChild(this);
				
		}
		
		
		public function leaveView():void
		{
			visible = false;
			removeEvent();
		}
		
		public function enterView ():void
		{
			visible = true;
			addEvent();
			_contro.searchConsortiaApplyRecordList();
			_contro.searchConsortiaInviteRecordList();
		}

	}
}