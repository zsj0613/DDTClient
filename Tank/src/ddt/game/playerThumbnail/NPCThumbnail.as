package ddt.game.playerThumbnail
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	import game.crazyTank.view.common.LevelTipAsset;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.game.Living;
	import ddt.data.game.SimpleBoss;
	import ddt.events.LivingEvent;
	import ddt.view.common.Repute;
	import ddt.view.common.ShineObject;
	import ddt.view.common.WinRate;
	
	import webgame.crazytank.game.view.playerThumbnailAsset;
	import webgame.crazytank.game.view.thumbnailShineAsset;
	public class NPCThumbnail extends playerThumbnailAsset
	{
		private  var _living:Living;
		private var _headFigure:HeadFigure;
		private var _blood:BloodItem;
		private var _name:TextField;
		
		private var _shiner:ShineObject;
		
		private var _tipContainer:Sprite;
		private var _tip:LevelTipAsset;
		private var _repute:Repute;
		private var lightingFilter:BitmapFilter;
		private var _winRate:WinRate;
		private var _marryedTip:Sprite;
		public function NPCThumbnail(living:Living)
		{
			_living=living;
			init();
			initEvents();
		}
		public function init():void
		{
			
			_headFigure = new HeadFigure( this.headFigure.width , this.headFigure.height,_living);
			_blood = new BloodItem(_living.maxBlood);
			_name = new TextField();
			initHead();
			initBlood();
			initName();
		}
		
		public function initHead():void
		{
			_headFigure.x = this.headFigure.x;
			_headFigure.y = this.headFigure.y;
			removeChild(this.headFigure);
			addChild(_headFigure);
			
			_shiner = new ShineObject(new thumbnailShineAsset(),false);
			_shiner.mouseChildren = false;
			_shiner.mouseEnabled = false;
			addChild(_shiner);
		}
		
		public function initBlood():void
		{
			_blood.width = this._bloodItem.width;
			_blood.height = this._bloodItem.height;
			_blood.x = this._bloodItem.x;
			_blood.y = this._bloodItem.y;
			this._bloodItem.visible = false;
			addChild(_blood);
		}
		
		public function initName():void
		{
			_name.defaultTextFormat = name_txt.getTextFormat();
			_name.filters = name_txt.filters;
			_name.autoSize = "left";
			_name.wordWrap = false;
			_name.text = _living.name//.info.NickName;	
		
			if(_name.width>65)
			{
				var tempIndex:int = _name.getCharIndexAtPoint(50,5);
				_name.text = _name.text.substring(0,tempIndex)+"...";
			}
			_name.x = name_txt.x;
			_name.y = name_txt.y;
			_name.mouseEnabled = false;
			name_txt.visible = false;
			addChild(_name)
		}
		
		public function initEvents():void
		{
			if(_living)
			{
				_living.addEventListener(LivingEvent.BLOOD_CHANGED,__updateBlood);
				_living.addEventListener(LivingEvent.DIE,__die);
				_living.addEventListener(LivingEvent.ATTACKING_CHANGED,__shineChange);
				
				addEventListener(MouseEvent.ROLL_OVER,overHandler);
				addEventListener(MouseEvent.ROLL_OUT,outHandler);
			}
		}
		public function __updateBlood(evt:LivingEvent):void
		{
			_blood.bloodNum = _living.blood;
		}
		
		public function __die(evt:LivingEvent):void
		{
			if(_headFigure)_headFigure.gray();
			if(_blood)_blood.visible = false;
		}
		
		private function __shineChange(evt:LivingEvent):void
		{
			var boss:SimpleBoss = _living as SimpleBoss;
			if(boss&&boss.isAttacking)
			{
				_shiner.shine();
			}else
			{
				_shiner.stopShine();
			}
		}
		
		protected function overHandler(evt:MouseEvent):void
		{
			if(lightingFilter)
			{
				this.filters = [lightingFilter];
				TipManager.setCurrentTarget(this,_tipContainer);
			}
		}
		
		protected function outHandler(evt:MouseEvent):void
		{
			this.filters = null;
			TipManager.setCurrentTarget(null,_tipContainer);
		}
		
		public function setUpLintingFilter():void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]) ;// alpha
			lightingFilter = new ColorMatrixFilter(matrix);   //这里好像是 new BitmapFilter(matrix);
		}
		
		public function removeEvents():void
		{
			if(_living)
			{
				_living.removeEventListener(LivingEvent.BLOOD_CHANGED,__updateBlood);
				_living.removeEventListener(LivingEvent.DIE,__die);
				_living.removeEventListener(LivingEvent.ATTACKING_CHANGED,__shineChange);
				removeEventListener(MouseEvent.ROLL_OVER,overHandler);
				removeEventListener(MouseEvent.ROLL_OUT,outHandler);
			}
		}
		
		public function updateView():void
		{
			if(!_living)
			{
				this.visible = false;
			}else
			{
				if(_headFigure)
				{
					_headFigure.dispose();
					_headFigure = null;
				}
				if(_blood)
				{
					_blood = null;
				}
				init();
			}
		}
		
		public function set info(value:Living):void
		{
			if(!value)
			{
				removeEvents();
			}
			_living = value;
			updateView();
		}
		
		public function dispose():void
		{
			if(_tipContainer)
			{
				if(_repute)_tipContainer.removeChild(_repute);
				_repute = null;
				if(_winRate)_tipContainer.removeChild(_winRate);
				_winRate = null;
				if(_tip)_tipContainer.removeChild(_tip);
				_tip = null;
				if(_tipContainer.parent)
				{
					removeChild(_tipContainer);
				}
				_tipContainer = null;
			}
			
			removeEvents();
			if(parent)
			{
				parent.removeChild(this);
			}
			_headFigure.dispose();
			_headFigure = null;
			_blood.dispose();
			_blood = null;
			_living = null;
		}
		
	}
}