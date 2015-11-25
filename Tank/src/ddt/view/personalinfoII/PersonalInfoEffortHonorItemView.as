package ddt.view.personalinfoII
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.personalinfoII.EffortHonorItemAsset;

	public class PersonalInfoEffortHonorItemView extends EffortHonorItemAsset
	{
		private var _honor:String;
		private var _isSelect:Boolean;
		private var _id:int
		public function PersonalInfoEffortHonorItemView(honor:Array)
		{
			super();
			_id    = honor[0];
			_honor = honor[1];
			init();
			initEvent();
		}

		private function init():void
		{
			this.out_txt.text = _honor;
			this.over_txt.text = _honor;
			this.over_txt.visible = false;
			this.gotoAndStop(1);
			this.buttonMode = true;
			this.mask_mc.buttonMode = true;
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER , __itemOver);
			addEventListener(MouseEvent.MOUSE_OUT  , __itemOut);
		}
		
		private function textState(value:Boolean):void
		{
			if(value)
			{
				this.out_txt.visible = true;
				this.over_txt.visible= false;
			}else
			{
				this.out_txt.visible = false;
				this.over_txt.visible= true;
			}
		}
		
		private function __itemOver(evt:MouseEvent):void
		{
			this.gotoAndStop(2);
			textState(false);
		}
		
		private function __itemOut(evt:MouseEvent):void
		{
			if(!_isSelect)
			{
				this.gotoAndStop(1);
				textState(true);
			}
		}
		
		public function set select(value:Boolean):void
		{
			_isSelect = value;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get select():Boolean
		{
			return _isSelect;
		}
		
		public function get honor():String
		{
			return _honor;
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER , __itemOver);
			removeEventListener(MouseEvent.MOUSE_OUT  , __itemOut);
		}
	}
}