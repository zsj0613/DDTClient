package ddt.consortia.consortiadiplomatism
{
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	
	import ddt.consortia.ConsortiaControl;
	import ddt.consortia.ConsortiaModel;
	import ddt.consortia.IConsortiaViewPage;
	import tank.consortia.accect.ConsortiaDiplomatismAsset;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.data.ConsortiaDutyType;
	import ddt.manager.ConsortiaDutyManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	public class ConsortiaDiplomatismView extends ConsortiaDiplomatismAsset implements IConsortiaViewPage
	{
		private var _consortiaList       : ConsortiaInfoList ;
		private var _makePeaceList       : MakePeaceList;
		private var _searchBtnAccect     : HBaseButton;
		private var _declareWarBtnsAsset : HBaseButton;
		private var _makePeaceBtnAsset   : HBaseButton;
		private var _model               : ConsortiaModel;
		private var _controler           : ConsortiaControl;
		
		private var _nextPageBtnAsset    : HBaseButton;
		private var _prePageAsset        : HBaseButton;
		
		private var _currentPage         : int = 1;
		private var _type                : int;/* 0中立,1友好,2敌对*/
		
		private var _total:int;
		private var _totalPage:int;
		private var _countperpage:int = 6;
		private var _text:TextArea;
		private var keyName:String = "";//关键字
		
		public function ConsortiaDiplomatismView(model : ConsortiaModel,controler:ConsortiaControl)
		{
			this._model = model;
			_controler = controler;
			super();
			init();
		}
		private function init() : void
		{
			_consortiaList = new ConsortiaInfoList();
			_consortiaList.x = this.consortiaListPos.x;
			_consortiaList.y = this.consortiaListPos.y;
			this.consortiaListPos.visible = false;
			addChild(_consortiaList);
			
			 _makePeaceList = new MakePeaceList();
			 _makePeaceList.x = makePeaceListPos.x;
			 _makePeaceList.y = makePeaceListPos.y;
			 makePeaceListPos.visible = false;
			 addChild(_makePeaceList);
			
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
			_text.setSize(382,206);
			_text.textField.defaultTextFormat = new TextFormat("Arial",16,0x013465);
			
			var filterA:Array = [];
			var glowFilter:GlowFilter = new GlowFilter(0xffffff,1,4,4,10);
			filterA.push(glowFilter);
			_text.textField.filters = filterA;
			addChild(_text);
			_text.x = 568;
			_text.y = 127;
			
			_text.editable = false;
			
			//**********************************************************
//			initTextField(this.consortiaDeclarationTxt);
			
			
			_searchBtnAccect = new HBaseButton(searchBtnAccect);
			_searchBtnAccect.useBackgoundPos = true;
			addChild(_searchBtnAccect);
		    
			_declareWarBtnsAsset  = new HBaseButton(declareWarBtnsAsset);
			_declareWarBtnsAsset.useBackgoundPos = true;
			addChild(_declareWarBtnsAsset);
			_makePeaceBtnAsset    = new HBaseButton(makePeaceBtnAsset);
			_makePeaceBtnAsset.useBackgoundPos = true;
			addChild(_makePeaceBtnAsset);
			neutralBtnAsset.buttonMode = true;
			antagonizeBtnsAsset.buttonMode = true;
			
			_nextPageBtnAsset = new HBaseButton(nextPageBtnAsset);
			_nextPageBtnAsset.useBackgoundPos = true;
			addChild(_nextPageBtnAsset);
			//_nextPageBtnAsset.enable = false;
			_prePageAsset   = new HBaseButton(prePageBtnAsset);
			_prePageAsset.useBackgoundPos = true;
			addChild(_prePageAsset);
			//_prePageAsset.enable = false;
			
			neutralBtnAsset.gotoAndStop(2);
			antagonizeBtnsAsset.gotoAndStop(1);
			_makePeaceBtnAsset.enable = false;
			_declareWarBtnsAsset.enable = false;
		}
		private function addEvent() : void
		{
			neutralBtnAsset.addEventListener(MouseEvent.CLICK,                     __consortiaTypeSearchHandler);
			antagonizeBtnsAsset.addEventListener(MouseEvent.CLICK,                 __consortiaTypeSearchHandler);
			_consortiaList.addEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM,  __selectItem);
			_declareWarBtnsAsset.addEventListener(MouseEvent.CLICK,                __diplomatismWarHander);
			_makePeaceBtnAsset.addEventListener(MouseEvent.CLICK,                  __diplomatismPeaceHander);
			_model.addEventListener(ConsortiaDataEvent.CONSORTIA_ALLY_LIST_CHANGE, __consortiaAllyHandler);
			_model.addEventListener(ConsortiaDataEvent.ALLY_APPLY_LIST_CHANGE,     __allyApplyListChange);
			_model.addEventListener(ConsortiaDataEvent.DELETE_ALLY_APPLY_ITEM,     __deleteAllyApplyItem);
			_model.addEventListener(ConsortiaDataEvent.CONSORTIA_ALLY_ITEM_REMOVE, __deleteAllyItemHandler);
			_prePageAsset.addEventListener(MouseEvent.CLICK,                       __upPageHandler);
			_nextPageBtnAsset.addEventListener(MouseEvent.CLICK,                   __downPageHandler);
			_searchBtnAccect.addEventListener(MouseEvent.CLICK,                    __startSearchHandler);
			searchTxt.addEventListener(FocusEvent.FOCUS_IN,                        __setSearchDefaultValue);
			searchTxt.addEventListener(FocusEvent.FOCUS_OUT,                       __clearSearchDefaultValue);
			addEventListener(KeyboardEvent.KEY_DOWN,                               __keyDownHandler);
			
		}
		private function __setSearchDefaultValue(evt : FocusEvent) : void
		{
			if(searchTxt.text == LanguageMgr.GetTranslation("ddt.consortia.consortiadiplomatism.ConsortiaDiplomatismView.searchTxt"))
			//if(searchTxt.text == "请输入公会名称")
			{
				searchTxt.text = "";
			}
		}
		private function __clearSearchDefaultValue(evt : FocusEvent) : void
		{
			if(searchTxt.text == "")searchTxt.text = LanguageMgr.GetTranslation("ddt.consortia.consortiadiplomatism.ConsortiaDiplomatismView.searchTxt");
			//if(searchTxt.text == "")searchTxt.text = "请输入公会名称";
		}
		
		private function __allyApplyListChange(e:ConsortiaDataEvent):void
		{
			_makePeaceList.info = _model.allyApplyList;
		}
		private function __upPageHandler(evt : MouseEvent) : void
		{
	    	SoundManager.Instance.play("008");
			if(_currentPage > 1)
			{
				_controler.loadAllyList((--_currentPage),_type,keyName);
			}
			
			_makePeaceBtnAsset.enable = false;
			_declareWarBtnsAsset.enable = false;
			_consortiaList.currentItemEmpty();
		}
		private function __downPageHandler(evt:MouseEvent):void
	    {
	    	SoundManager.Instance.play("008");
			_makePeaceBtnAsset.enable = false;
			_declareWarBtnsAsset.enable = false;
	    	if(_currentPage < _totalPage)
				_controler.loadAllyList((++_currentPage),_type,keyName);
			_consortiaList.currentItemEmpty();
	    }
		private function __startSearchHandler(evt : MouseEvent) : void
		{
	    	SoundManager.Instance.play("008");
			if(searchTxt.text == LanguageMgr.GetTranslation("ddt.consortia.consortiadiplomatism.ConsortiaDiplomatismView.searchTxt"))
			//if(searchTxt.text == "请输入公会名称")
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.consortiadiplomatism.ConsortiaDiplomatismView.inputPlease"));
				//MessageTipManager.getInstance().show("请输入搜索条件");
				return;
			}
			_makePeaceBtnAsset.enable = false;
			_declareWarBtnsAsset.enable = false;
			_currentPage = 1;
			_controler.loadAllyList(1,_type,this.searchTxt.text);
			_consortiaList.currentItemEmpty();
			keyName = this.searchTxt.text;
				
		}
		private function __selectItem(evt : ConsortiaDataEvent) : void
		{
			if(_consortiaList.currentItem)
			{
				var str : String = String(_consortiaList.currentItem.info.Description);
				if(str == "")_text.text = LanguageMgr.GetTranslation("ddt.consortia.consortiadiplomatism.ConsortiaDiplomatismView.text");
				//if(str == "")this.consortiaDeclarationTxt.text = "这小子很懒,什么也没留下!";
				else _text.text = str;
				//else this.consortiaDeclarationTxt.text = str;
				if(ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._7_Diplomatism))
				{
					if(_consortiaList.currentItem.info.State == 0)
					{
						_declareWarBtnsAsset.enable = true;
						_makePeaceBtnAsset.enable = false;
					}
					else if(_consortiaList.currentItem.info.State == 2)
					{
						_declareWarBtnsAsset.enable = false;
						_makePeaceBtnAsset.enable = true;
					}
				}
			}
			
			else
			_text.textField.text = "";
			//this.consortiaDeclarationTxt.text = "";
		}
		public function dispose() : void
		{
			removeEvent();
			_consortiaList.dispose();
			if(_consortiaList && _consortiaList.parent)_consortiaList.parent.removeChild(_consortiaList);
			_consortiaList = null;
			_makePeaceList.dispose();
			if(_makePeaceList && _makePeaceList.parent)_makePeaceList.parent.removeChild(_makePeaceList);
			_makePeaceList= null;
			if(_searchBtnAccect)
			{
				_searchBtnAccect.dispose();
				if(_searchBtnAccect.parent)_searchBtnAccect.parent.removeChild(_searchBtnAccect);
			} 
			_searchBtnAccect = null;
			if(_declareWarBtnsAsset)
			{
				_declareWarBtnsAsset.dispose();
				if(_declareWarBtnsAsset.parent)_declareWarBtnsAsset.parent.removeChild(_declareWarBtnsAsset);
			}
			_declareWarBtnsAsset = null;
			if(_makePeaceBtnAsset)
			{
				_makePeaceBtnAsset.dispose();
				if(_makePeaceBtnAsset.parent)_makePeaceBtnAsset.parent.removeChild(_makePeaceBtnAsset);
			}
			_makePeaceBtnAsset = null;
			if(_nextPageBtnAsset)
			{
				_nextPageBtnAsset.dispose();
				if( _nextPageBtnAsset.parent)_nextPageBtnAsset.parent.removeChild(_nextPageBtnAsset);
			}
			
			_nextPageBtnAsset = null;
			if(_prePageAsset)
			{
				_prePageAsset.dispose();
				if(_prePageAsset.parent)_prePageAsset.parent.removeChild(_prePageAsset);
			}
			_prePageAsset = null;
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function __keyDownHandler(evt : KeyboardEvent) : void
		{
			evt.stopPropagation();
			if(evt.keyCode == Keyboard.ENTER)
			{
				_makePeaceBtnAsset.enable = false;
		    	_declareWarBtnsAsset.enable = false;
		    	_currentPage = 1;
	    		_controler.loadAllyList(1,_type,this.searchTxt.text);
	    		keyName = this.searchTxt.text;
			}
		}
		private function __consortiaAllyHandler(evt : ConsortiaDataEvent) : void
		{
			
			_total = _model.consortiaAllyCount;
			this.pageTxt.text = String(_currentPage);
			_totalPage = Math.ceil(_total/_countperpage);
			_nextPageBtnAsset.enable = !((_totalPage <= 1) || (_currentPage >= _totalPage));
			_prePageAsset.enable = !(_currentPage == 1);
			this.pageTxt.text = String(_currentPage);
			
			this._consortiaList.infoList(_model.consortiaAllyList);
		}
		
		public function __deleteAllyItemHandler(evt : ConsortiaDataEvent) : void
		{
			_consortiaList.removeItem(int(evt.data));
			_text.text = "";
			_declareWarBtnsAsset.enable = false;
			_makePeaceBtnAsset.enable   = false;
		}
		
//		private var _totalPage   : int ;
		private function buttonStatus() : void
		{
			if(_currentPage <=1)this._prePageAsset.enable = false;
			else this._prePageAsset.enable = true;
			if(_currentPage == _totalPage)
			{
			   this._nextPageBtnAsset.enable = false;
			
			}else 
			{
			   this._nextPageBtnAsset.enable = true;
			}
			
		}
		private function initTextField(txt : TextField) : void
		{
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.text = "";
		}
		private function __deleteAllyApplyItem(evt : ConsortiaDataEvent) : void
		{
			_makePeaceBtnAsset.enable = false;
			_declareWarBtnsAsset.enable = false;
			this._makePeaceList.removeItem(int(evt.data));
		}
		private function __consortiaTypeSearchHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			_makePeaceBtnAsset.enable = false;
			_declareWarBtnsAsset.enable = false;
			_currentPage = 1;
			if(evt .target.name == "neutralBtnAsset")
			{
			    //中立
				neutralBtnAsset.gotoAndStop(2);
				antagonizeBtnsAsset.gotoAndStop(1);
				_controler.loadAllyList(1,0);
				_currentPage = 1;
			    _type = 0;
			}
			else
			{
				//敌对
				neutralBtnAsset.gotoAndStop(1);
				antagonizeBtnsAsset.gotoAndStop(2);
				_currentPage = 1;
				_controler.loadAllyList(1,2);
			    _type = 2;
			}
			keyName = "";
			_consortiaList.clearList();
			_consortiaList.currentItemEmpty();
		}
		private function __diplomatismWarHander(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("1001");
			_declareWarBtnsAsset.enable = false;
			_makePeaceBtnAsset.enable   = false;
			if(this._consortiaList.currentItem)
			{
				//宣战
				SocketManager.Instance.out.sendConsortiaAddAlly(_consortiaList.currentItem.info.ConsortiaID,true);
			}
		}
		
		private function __diplomatismPeaceHander(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("1001");
			_declareWarBtnsAsset.enable = false;
			_makePeaceBtnAsset.enable   = false;
			if(this._consortiaList.currentItem)
			{
				//议和
				SocketManager.Instance.out.sendConsortiaAddApplyAlly(_consortiaList.currentItem.info.ConsortiaID,false);
			}
		}
		
		
		private function removeEvent():void
		{
			
			neutralBtnAsset.removeEventListener(MouseEvent.CLICK,       __consortiaTypeSearchHandler);
			antagonizeBtnsAsset.removeEventListener(MouseEvent.CLICK,  __consortiaTypeSearchHandler);
			_consortiaList.removeEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM, __selectItem);
			_declareWarBtnsAsset.removeEventListener(MouseEvent.CLICK,   __diplomatismWarHander);
			_makePeaceBtnAsset.removeEventListener(MouseEvent.CLICK,     __diplomatismPeaceHander);
			_model.removeEventListener(ConsortiaDataEvent.CONSORTIA_ALLY_LIST_CHANGE, __consortiaAllyHandler);
			
			_model.removeEventListener(ConsortiaDataEvent.ALLY_APPLY_LIST_CHANGE,__allyApplyListChange);
			_model.removeEventListener(ConsortiaDataEvent.DELETE_ALLY_APPLY_ITEM, __deleteAllyApplyItem);
			
			_model.removeEventListener(ConsortiaDataEvent.CONSORTIA_ALLY_ITEM_REMOVE, __deleteAllyItemHandler);
			_prePageAsset.removeEventListener(MouseEvent.CLICK,      __upPageHandler);
			_nextPageBtnAsset.removeEventListener(MouseEvent.CLICK,  __downPageHandler);
			_searchBtnAccect.removeEventListener(MouseEvent.CLICK,   __startSearchHandler);
			
			searchTxt.removeEventListener(FocusEvent.FOCUS_IN,  __setSearchDefaultValue);
			searchTxt.removeEventListener(FocusEvent.FOCUS_OUT, __clearSearchDefaultValue);
			removeEventListener(KeyboardEvent.KEY_DOWN,         __keyDownHandler);
		}
		
		public function leaveView ():void
		{
			_consortiaList.currentItemEmpty();
			visible = false;
			removeEvent();
		}
		
		
//		public function _controler.loadAllyList(page:int = 1,state:int = 0,name:String =""):void
//		{
//			new LoadConsortiaAllyList(PlayerManager.Instance.Self.ConsortiaID,state,-1,page,6,name).loadSync(__on_controler.loadAllyListBack);
//		}
//		
//		
//		private function __on_controler.loadAllyListBack(loader:LoadConsortiaAllyList):void
//		{
//			_currentpage = loader.page;
//			_total = loader.totalCount;
//			_totalPage = Math.ceil(_total / _countperpage);
//			_nextPageBtnAsset.enable = !((_totalPage <= 1) || (_currentpage == _totalPage));
//			_prePageAsset.enable = !(_currentpage == 1);
//			
//			this.pageTxt.text = String(_currentpage);
////			this.pageTxt.text = String((_currentpage - 1) * _countperpage + 1) + "-" + String(_currentpage * _countperpage) + "(总数" + String(_total) + ")";
//			
//			this._consortiaList.infoList(loader.list);
//		}
//		
		public function enterView ():void
		{
			visible = true;
			addEvent();
			_controler.loadAllyList(1,0);
			_type = 0;
			_currentPage = 1;
			neutralBtnAsset.gotoAndStop(2);
			antagonizeBtnsAsset.gotoAndStop(1);
			_makePeaceBtnAsset.enable = false;
			_declareWarBtnsAsset.enable = false;
			this.searchTxt.text = LanguageMgr.GetTranslation("ddt.consortia.consortiadiplomatism.ConsortiaDiplomatismView.searchTxt");
			//this.searchTxt.text = "请输入公会名称";
			_controler.loadAllyApplyList(0,PlayerManager.Instance.Self.ConsortiaID);
		}
		
		
		
	}
}