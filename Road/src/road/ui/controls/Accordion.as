package road.ui.controls
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.transitions.Tween;
	import fl.transitions.easing.None;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import road.ui.controls.accordion.AccordionHeader;

	public class Accordion extends UIComponent
	{
		private var background:DisplayObject;
		private var contentClip:Sprite;
		private var headerClip:Sprite;
		private var maskClip:Sprite;
		
		private var _openDuration:Number = 4;
		private var _contentHeight:Number = 50;
		private var _headerHeight:Number = 20;
		
		private static const defaultStyle:Object = {skin:Accordion_skin};
		public static function getStyleDefinition():Object 
		{ 
			return mergeStyles(defaultStyle, UIComponent.getStyleDefinition());
		}
		private static const HEADER_STYLE:Object = {textFormat:new TextFormat("Verdana", 12, 0x003366, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)}
		
		public function Accordion()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			this._headerHeight = 24;
			
			headerClip = new Sprite();
			contentClip = new Sprite();
			
			maskClip = new Sprite();
			maskClip.graphics.beginFill(0xFFFFFF,0);
			maskClip.graphics.drawRect(0,0,1,1);
			maskClip.width = this.width + 2;
			maskClip.height = this.width + 2;
			maskClip.x = -1;
			maskClip.y = -1;
			
			this.addChild(contentClip);
			this.addChild(headerClip);
			this.addChild(maskClip);
			this.mask = maskClip;
		}
		
		private var _selectedIndex:int = -1;
		private var _proseletedIndex:int = -1;
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
	        if (value == -1)
	            return;

	        // Bail if the index isn't changing.
	        if (value == _selectedIndex)
	            return;
	        _proseletedIndex = value;
	        
	        invalidate(InvalidationType.SELECTED);
		}
		
		public function append(content:UIComponent,title:String):void
		{
			var header:AccordionHeader = new AccordionHeader();
			header.label = title;
			header.mouseChildren = false;
			header.addEventListener(MouseEvent.CLICK,__headerClick);
			
			content.x = 0;
			contentClip.addChild(content);
			copyStylesToChild2(UIComponent(header),HEADER_STYLE);
			headerClip.addChild(header);
			
			this.invalidate(InvalidationType.DATA);
			
		}
		
		public function setChildrenTitle(n:int,title:String):void
		{
			if(n >= this.headerClip.numChildren)
				return;
			var tmp:AccordionHeader = getHeaderAt(n);
			if(tmp != null)
			{
				tmp.label = title;
			}
		}
		
		protected function copyStylesToChild2(child:UIComponent, map:Object):void
		{
			for( var n:String in map)
			{
				child.setStyle(n,map[n]);
			}
		}
		private function __headerClick(event:MouseEvent):void
		{
			var header:AccordionHeader = event.currentTarget as AccordionHeader;
			this.selectedIndex = headerClip.getChildIndex(header);
		}
		private function getHeaderAt(index:int):AccordionHeader
		{
			return AccordionHeader(headerClip.getChildAt(index));
		}
		private function getContentAt(index:int):UIComponent
		{
			return UIComponent(contentClip.getChildAt(index));
		}
		private function calcContentHeight():Number
	    {
	        return this.height - headerClip.numChildren * _headerHeight;
	    }
	    private function calcContentWidth():Number
	    {
	    	return this.width;
	    }
	    private function calcHeaderHeight():Number
	    {
	    	return _headerHeight;
	    }
			
		override protected function draw():void
		{
			if (isInvalid(InvalidationType.STYLES)) 
			{
				drawBackground();
			}
			
			if (isInvalid(InvalidationType.SIZE))
			{
				validateSize();
				validateList();
			}
			if (isInvalid(InvalidationType.SELECTED))
			{
				this.validateSelectedIndex();
			}
			super.draw();
		}
		
		protected function drawBackground():void
		{
			var bg:DisplayObject = background;
			
			background = getDisplayObjectInstance(getStyleValue("skin"));
			background.width = width;
			background.height = height;
			addChildAt(background,0);
			
			if (bg != null && bg != background) { removeChild(bg); }
		}	
		
		protected function validateSize():void
		{
			if(this.background)
			{
				background.width = width;
				background.height = height;
			}
			this.maskClip.width = this.width + 2;
			this.maskClip.height = this.height + 2;
		}
		
		protected function validateList():void
		{
			var contentWidth:Number = this.calcContentWidth();
			var contectHeight:Number = this.calcContentHeight();
			var headerHeight:Number = this.calcHeaderHeight();
			
			var y:Number = 0;
			var len:int = contentClip.numChildren;
			
			for(var i:int = 0;i<len;i++)
			{
				var header:AccordionHeader = getHeaderAt(i);
				header.setSize(contentWidth,headerHeight);
				header.y = y;
				y += header.height;
				
				var content:UIComponent = getContentAt(i);
				content.setSize(contentWidth,contectHeight);
				content.y = y;
				
				if(i == _selectedIndex)
				{
					content.visible = true;
					y += content.height;
				}
				else
				{
					content.visible = false;
				}
			}
		}
		
		private var tweenFinishValue:int;
	    private var tweenOldSelectedIndex:int;
	    private var tweenNewSelectedIndex:int;
		private var tween:Tween;

		protected function validateSelectedIndex():void
		{
			if ( _proseletedIndex == -1)
            return;

	        var newIndex:int = _proseletedIndex;
	        _proseletedIndex = -1;
	
	        // The selectedIndex must be undefined if there are no children,
	        // even if a selectedIndex has been proposed.
	        if (contentClip.numChildren == 0)
	        {
	            _selectedIndex = -1;
	            return;
	        }
	
	        // Ensure that the new index is in bounds.
	        if (newIndex < 0)
	        {
	            newIndex = 0;
	        }
	        else if (newIndex > contentClip.numChildren - 1)
	        {
	            newIndex = contentClip.numChildren - 1;
	        }
	        
	
	        // Remember the old index.
	        var oldIndex:int = _selectedIndex;
	
	        // Bail if the index isn't changing.
	        if (newIndex == oldIndex)
	            return;
		      
	        // Deselect the old header.
	        if (oldIndex != -1)
	            getHeaderAt(oldIndex).selected = false;
	
	        // Commit the new index.
	        _selectedIndex = newIndex;
	
	        // Select the new header.
	        getHeaderAt(newIndex).selected = true;
	
	        if ( _openDuration == 0)
	        {
	        	this.invalidate(InvalidationType.DATA);
	        }
	        else
	        {
	            if (tween)
	                tween.stop();
	
	            startTween(oldIndex, newIndex);
	        }
		}
		
		/**
	     *  @private
	     */
	    private function startTween(oldSelectedIndex:int, newSelectedIndex:int):void
	    {
	        tweenOldSelectedIndex = oldSelectedIndex;
	        tweenNewSelectedIndex = newSelectedIndex;
	        tweenFinishValue = calcContentHeight();
	        // A single instance of Tween drives the animation.
	        tween = new Tween(this,"onTweenUpdate",None.easeIn,0,tweenFinishValue,_openDuration);
	    }
	    public function set onTweenUpdate(value:Number):void 
	    {
	    	trace("value:",value);
	        var y:Number = 0;
	        var n:int = contentClip.numChildren;
	        for (var i:int = 0; i < n; i++)
	        {
	            var header:AccordionHeader = getHeaderAt(i);
	            var content:UIComponent = getContentAt(i);
	            
	            header.y = y;
	            y += header.height;
	            
	            content.y = y;
	            if (i == tweenOldSelectedIndex)
	            {
	                content.cacheAsBitmap = true;
	                content.scrollRect = new Rectangle(0,0,width,tweenFinishValue - value);
	                content.visible = true;
	                y += content.scrollRect.height;
	            }
	            else if (i == tweenNewSelectedIndex)
	            {
	                content.cacheAsBitmap = true;
	               	content.scrollRect = new Rectangle(0,0,width,value);
	                content.visible = true;
	                y += value;
	            }
	        }
	        if(value == this.tweenFinishValue)
	        {
	        	this.tween = null;
	        	this.validateList();
	        }
	    }
	}
}