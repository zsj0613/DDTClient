package road.ui
{
	import road.events.ComponentEvent;
	import road.utils.ObjectUtils;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	[Event(name="propertiesChanged",type="road.events.ComponentEvent")]
	/**
	 * 组件类的基类， 实现了两个接口，一个是Disposeable
	 * 所有的组件都必须有dispose方法来实现内存释放。
	 * component 还实现了ITipedDisplay接口，也就是说所有的组件都可以添加TIP
	 * 
	 * 其中大写P开头的此类属性
	 * 当相对应的属性改变时会发出 ComponentEvent.PROPERTIES_CHANGED
	 * 其中的changedProperties属性中的此属性为true,反之则没有该属性，或者为false 
	 * 
	 * @author Herman
	 */
	public class Component extends Sprite implements Disposeable,ITipedDisplay
	{

		public static const P_height:String = "height";
		public static const P_tipData:String = "tipData";
		public static const P_tipDirction:String = "tipDirction";
		public static const P_tipGap:String = "tipGap";
		public static const P_tipStyle:String = "tipStyle";
		public static const P_width:String = "width";
		public function Component()
		{
			init();
		}

		/**
		 * 此为保存组件截图的对象<br>
		 * 此对象在初始化时并没有构建，必须在调用了getBitmapdata()之后才会存在<br>
		 * 详细请看getBitmapdata()方法<br>
		 */		
		protected var _bitmapdata:BitmapData;
		/**
		 *	主动调用改变次数的临时变量。 此变量主要用来控制一些冗余的改变造成的改变<br>
		 * 	详细请看beginChanges 与 commitChanges<br>
		 */		
		protected var _changeCount:int = 0;
		/**
		 *	 保存当前此此提交所发生的改变了的属性。<br>
		 * 	他用来保存以P大写字母开头静态变量属性相关的属性是否发生了改变<br>
		 * 	具体请参考onPropertiesChanged方法。与 ComponentEvent<br>
		 */		
		protected var _changedPropeties:Dictionary;
		/**
		 *  保存高度的临时变量。由于Component重写了 get height() 与 set height()方法。<br>
		 *  所以此方法取到的值与实际的值可能存在差异<br>
		 */		
		protected var _height:Number = 0;
		/**
		 *	一个用来标识Component变量。通过ComponentFactory创建出来的Component的ID是自动生成的<br>
		 */		
		protected var _id:int = -1;
		/**
		 *	用来保存tip数据的临时变量<br>
		 * 	详见get tipData() 与set tipData()方法<br>
		 */		
		protected var _tipData:Object;
		/**
		 *	用来保存tip方向的临时变量<br>
		 * 	详见get tipDirction() 与set tipDirction()方法 <br>
		 */		
		protected var _tipDirction:String;
		/**
		 *	用来保存tip与对象间距的临时变量<br>
		 * 	详见get tipGap() 与set tipGap()方法 <br>
		 */		
		protected var _tipGap:int;
		/**
		 *	用来保存Tip的样式的临时变量<br>
		 * 	详见get tipStyle() 与set tipStyle()方法 <br>
		 */		
		protected var _tipStyle:String;
		/**
		 *  保存宽度的临时变量。由于Component重写了 get width() 与 set width()方法。<br>
		 *  所以此方法取到的值与实际的值可能存在差异<br>
		 */	
		protected var _width:Number = 0;

		/**
		 * 实现 IDisplayObject接口方法
		 * @return 
		 * 
		 */		
		public function asDisplayObject():DisplayObject
		{
			return this;
		}

		 /**
		  * 标识组件发生改变<br>
		  * _changeCount 小于等于0时就说明改变已经修改完成可以执行提交更新操作<br>
		  * 
		  */		 
		 public function beginChanges():void
		 {
		 	_changeCount ++;
		 }
		
		/**
		 * 提交组件在beginChanges 到 commitChanges 代码段中间所操作的更新<br>
		 *  _changeCount 小于等于0时就说明改变已经修改完成可以执行提交更新操作<br>
		 * 
		 */		
		
		public function commitChanges():void
		 {
		 	_changeCount --;
		 	invalidate();
		 }
		
		public function getMousePosition():Point
		{
			return new Point(mouseX,mouseY);
		}
		 
		 public function dispose():void
		 {
		 	_changedPropeties = null;
			ObjectUtils.disposeObject(_bitmapdata);
			if(parent)parent.removeChild(this);
			ShowTipManager.Instance.removeTip(this);
			ComponentFactory.Instance.removeComponent(_id);
		 }
		
		
		/**
		 * 绘制组件 在此方法执行之后会 发出ComponentEvent.PROPERTIES_CHANGED事件，并且会
		 * 吧_changedPropeties 清空;
		 */
		public function draw():void
		{
			onProppertiesUpdate();
			addChildren();
			dispatchEvent(new ComponentEvent(ComponentEvent.PROPERTIES_CHANGED,_changedPropeties));
			_changedPropeties = new Dictionary(true);
		}
		 /**
		  * 
		  * @param reflesh 标识是否刷新 当调用一次getBitmapdata方法后 _bitmapdata便会存在，
		  * 如果reflesh为false则会返回原有的_bitmapdata 如果reflesh为true则无论_bitmapdata是否存在都会重新绘制
		  * 
		  * 注意: 此方法尽量少用，一般用来做一些渐变动画用。
		  * 
		  * @return 组件对象的截图。
		  * 
		  */		 
		 public function getBitmapdata(reflesh:Boolean = false):BitmapData
		 {
			 if(_bitmapdata == null || reflesh)
			 {
				 ObjectUtils.disposeObject(_bitmapdata);
				 _bitmapdata = new BitmapData(_width,_height,true,0xFF0000);
				 _bitmapdata.draw(this);
			 }
			 return _bitmapdata;
		 }
		/**
		 * 
		 * 获取conponent的高 此值 不一定与实际显示的高相等，原因是此值全部都被重写了 <br>
		 * 设置Component的高  此值 不一定与实际显示的高相等 必须在子类进行重写并改变在此Component容器内的现实对象的高<br>
		 * 进而使得此值与实际的高相等<br>
		 * 
		 */		
		override public function get height():Number
		{
			return _height;
		}

		override public function set height(h:Number):void
		{
			if(h == _height) return;
			_height = h;
			onPropertiesChanged(P_height);
		}
		/**
		 * 
		 * Component的标识。只要是通过ComponentFactory创建的Component都会自动生成一个唯一的标识，用来标识此Component<br>
		 * 设置 Component的ID此值一般情况下不用设置，ComponentFactory已经设置好了.<br>
		 * 但是如果是自己手动实例化的Component在必要时可以对他进行赋值.<br>
		 * 推荐采用 ComponentFactory.Instance.componentID方法来进行赋值。这样可以保证组件的ID全局唯一<br>
		 */
		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}
		
		/**
		 * 设置 x,y坐标。
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x = xpos;
			y = ypos;
		}

		public function get tipData():Object
		{
			return _tipData;
		}
	
		public function set tipData(value:Object):void
		{
			if(_tipData == value)return;
			_tipData = value;
			onPropertiesChanged(P_tipData);
		}

		public function get tipDirctions():String
		{
			return _tipDirction;
		}
		public function set tipDirctions(value:String):void
		{
			if(_tipDirction == value)return;
			_tipDirction = value;
			onPropertiesChanged(P_tipDirction);
		}
			
		public function get tipGap():int
		{
			return _tipGap;
		}

		public function set tipGap(value:int):void
		{
			if(_tipGap == value)return;
			_tipGap = value;
			onPropertiesChanged(P_tipGap);
		}
			
		public function get tipStyle():String
		{
			return _tipStyle;
		}
	
		public function set tipStyle(value:String):void
		{
			if(_tipStyle == value)return;
			_tipStyle = value;
			onPropertiesChanged(P_tipStyle);
		}
		
		/**
		 * 
		 * 获取conponent的宽 此值 不一定与实际显示的宽相等，原因是此值全部都被重写了 <br>
		 * 设置Component的宽  此值 不一定与实际显示的宽相等 必须在子类进行重写并改变在此Component容器内的现实对象的宽<br>
		 * 进而使得此值与实际的宽相等<br>
		 * 
		 */
		override public function get width():Number
		{
			return _width;
		}

		override public function set width(w:Number):void
		{
			if(w == _width)return;
			_width = w;
			onPropertiesChanged(P_width);
		}
		
		/**
		 * 此方法重写了sprite原始的 set x,让Component放在整数点的像素上
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		/**
		 * 此方法重写了sprite原始的 set y,让Component放在整数点的像素上
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}
		
		/**
		 *添加子显示对象的方法，此方法为 抽象方法，必须由子类实现
		 * 
		 */		
		protected function addChildren():void
		{
			
		}
		
		/**
		 * 此方法在 实例化Component的时候会调用，可以将一些初始化的对象放在此方法内
		 */
		protected function init():void
		{
			_changedPropeties = new Dictionary();
			addChildren();
		}
		
		
		/**
		 * 尝试更新显示对象
		 * 当执行onPropertiesChanged或者commitChanges 时会调用到此方法。
		 */
		protected function invalidate():void
		{
			if(_changeCount <= 0)
		 	{
		 		_changeCount = 0;
		 		draw();
		 	}
		}
		/**
		 * 
		 * @param propName 所更新属性的标识。
		 * 每次更新属性的标识保存在_changedPropeties当中.
		 * 此方法会调用invalidate,尝试进行更新操作。
		 * 
		 */		
		protected function onPropertiesChanged(propName:String = null):void
		 {
		 	if(propName != null)
		 	{
		 		_changedPropeties[propName] = true;
		 	}
		 	invalidate();
		 }
		/**
		 * 执行属性更新操作。 一般的属性跟新操作都要重写此方法并把属性更新操作写在此方法内。并且调用super.onProppertiesUpdate();<br>
		 * Component类由于实现了ITipedDisplay所以Component实现了添加TIP的操作.<br>
		 * 
		 */		
		protected function onProppertiesUpdate():void
		{
			if(_changedPropeties[P_tipDirction] || _changedPropeties[P_tipGap] || _changedPropeties[P_tipStyle] || _changedPropeties[P_tipData])
			{
				ShowTipManager.Instance.addTip(this);
			}
		}
	}
}