package ddt.game
{
	import flash.filters.GlowFilter;
	
	import game.crazyTank.view.VaneAsset;
	
	import ddt.view.common.CheckCodeMixedBack;
	import ddt.view.common.GradientText;

	/**
	 * 风向标 
	 * @author SYC
	 * 
	 */
	public class VaneView extends VaneAsset
	{
		
		private var _lastWind:Number;
		
		private var mixedBg1:CheckCodeMixedBack;
		private var mixedBg2:CheckCodeMixedBack;
		
		private var speedGradienText1:GradientText;
		private var speedGradienText2:GradientText;
		
		private var vane1PosX:Number = 0;
		private var vane2PosX:Number = -17.5;
		private var text1PosX:Number = 0;
		private var text2PosX:Number = 0;
		
		private var textGlowFilter:GlowFilter;
		private var textFilter:Array;
		public static const RandomVaneOffset:Number = 6;
		public static const RANDOW_COLORS:Array = [0x1a1a1a,0x171d32,0x1a2016,0x260d0d,0x1a260d,0x1c0d03,0x1c1d20,0x211d1d,0x101724,0x28222b];
		public static const RANDOW_COLORSII:Array = [ [0x47378c,0x25122b],
														[0x002e09,0x562d00],
														[0x062211,0x094957],
														[0x073b4c,0x631010],
														[0x8c0d9f,0x141626],
														[0x240616,0x6f16c2],
														[0x21581f,0x0e2550],
														[0x851f1f,0x3e3214],
														[0x1c0096,0x470035],
														[0x0e0805,0x703377],
														[0x191716,0x570928],
														[0x02460f,0x0d1619],
														[0x262225,0x0d4f40],
														[0x820000,0x144572],
														[0x581f2f,0x33330c],
														[0x143f51,0x6d1d53]]
		public function VaneView ():void
		{
			super();
			creatGraidenText();
			creatMixBg();
			initPos();
		}
		
		private function initPos():void
		{
			vane1PosX = vane1_mc.x;
			vane2PosX = vane2_mc.x;
			text1PosX = speedGradienText1.x;
			text2PosX = speedGradienText2.x;
		}
		
		private function creatMixBg():void
		{
			mixedBg1 = new CheckCodeMixedBack(mixedbgAccect.width,mixedbgAccect.height,0x6e7178);
			mixedBg1.x = mixedbgAccect.x;
			mixedBg1.y = mixedbgAccect.y;
//			addChildAt(mixedBg1,getChildIndex(speedGradienText1)+1);
			mixedBg1.mask = mixedbgAccect;
			mixedBg2 = new CheckCodeMixedBack(mixedbgAccect1.width,mixedbgAccect1.height,0x6e7178);
			mixedBg2.x = mixedbgAccect1.x;
			mixedBg2.y = mixedbgAccect1.y;
//			addChildAt(mixedBg2,getChildIndex(speedGradienText2)+1);
			mixedBg2.mask = mixedbgAccect1;
		}
		
		public function setUpCenter(xPos:Number,yPos:Number):void
		{
			this.x = xPos;
			this.y = yPos;
		}
		
		private function getRandomVaneOffset():Number
		{
			var n:Number = (Math.random()*RandomVaneOffset) - (RandomVaneOffset/2);
			return n;
		}
		
		private function creatGraidenText():void
		{
//			textGlowFilter = speed1_txt.filters[0];
//			textFilter = [textGlowFilter];
			speedGradienText1 = new GradientText(RANDOW_COLORSII);
			speedGradienText1.autoSize = speed1_txt.autoSize;
			speedGradienText1.x = speed1_txt.x;
			speedGradienText1.y = speed1_txt.y;
			speedGradienText1.width = speed1_txt.width;
//			speedGradienText1.filters = textFilter;
			addChildAt(speedGradienText1,getChildIndex(speed1_txt));
			removeChild(speed1_txt);
			speedGradienText1.setTextFormat(speed1_txt.defaultTextFormat);
		
			speedGradienText2 = new GradientText(RANDOW_COLORSII);
			speedGradienText2.autoSize = speed2_txt.autoSize;
			speedGradienText2.x = speed2_txt.x;
			speedGradienText2.y = speed2_txt.y;
			speedGradienText2.width = speed2_txt.width;
//			speedGradienText2.filters = textFilter;
			addChildAt(speedGradienText2,getChildIndex(speed2_txt));
			removeChild(speed2_txt);
			speedGradienText2.setTextFormat(speed2_txt.defaultTextFormat);
		}

		public function initialize():void
		{
			_lastWind = 11;
			lastTurn_mc.visible = false;
		}
	
		public function update(value:Number,upDateLast:Boolean=false):void
		{
			if(_lastWind != 11)
			{
				lastTurn(_lastWind);
			}
			if(upDateLast)
			{
				_lastWind = value;
			}
			if(value > 0)
			{
				vane1_mc.visible = true;
				speedGradienText1.visible = true;
				vane2_mc.visible = false;
				speedGradienText2.visible = false;
				mixedBg1.visible = true;
				mixedBg2.visible = false;
				speedGradienText1.setText(addZero(value), true, true);
//				textGlowFilter.color =  RANDOW_COLORS[int((Math.random()*10000)%10)];
//				speedGradienText1.filters = [textGlowFilter];
				
			}
			else 
			{	
				vane2_mc.visible = true;
				speedGradienText2.visible = true;
				vane1_mc.visible = false;
				speedGradienText1.visible = false;
				speedGradienText2.setText(addZero(value), true, true);
				mixedBg1.visible = false;
				mixedBg2.visible = true;
//				textGlowFilter.color =  RANDOW_COLORS[int((Math.random()*10000)%10)];
//				speedGradienText2.filters = [textGlowFilter];
				
			}
//			setRandomPos();
		}
		
		private function setRandomPos():void
		{
			var sp1:Number = getRandomVaneOffset();
			var sp2:Number = getRandomVaneOffset();
			vane1_mc.x = vane1PosX+sp1;
			speedGradienText1.x = text1PosX+sp1;
			vane2_mc.x = vane2PosX+sp2;
			speedGradienText2.x = text2PosX+sp2;
		}
		
		private function addZero(value:Number):String
		{
			var result:String;
			if(Math.ceil(value) == value || Math.floor(value) == value)
			{
				result = Math.abs(value).toString() + ".0";
			}
			else
			{
				result = Math.abs(value).toString();
			}
			return result;
		}
		
		private function lastTurn(value:Number):void
		{
			lastTurn_mc.visible = true;
			if(value > 0)
			{
				lastTurn_mc.windArrow_mc.gotoAndStop(1);
			}
			else
			{
				lastTurn_mc.windArrow_mc.gotoAndStop(2);
			}
			lastTurn_mc.lastTurn_txt.text = Math.abs(value).toString();
		}
	}
}