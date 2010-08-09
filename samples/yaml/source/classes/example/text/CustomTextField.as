package example.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import potato.display.safeRemoveChild;
	import potato.core.IDisposable;
	
	/**
	 * Custom TextField. Implements IDisposable interface and can be used seamlessly with Potato.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  09.08.2010
	 */
	public class CustomTextField extends TextField implements IDisposable
	{
		public function CustomTextField(x:Number, y:Number, text:String, htmlMode:Boolean = false)
		{
			this.x = x;
			this.y = y;
			this.autoSize = "left";
			this.multiline = true;
			this.selectable = false;

			if(htmlMode){
				this.htmlText = text;
			}
			else {
				this.text = text;
			}

			var tf:TextFormat = new TextFormat();
			tf.font = "Verdana";
			tf.size = 12;
			this.setTextFormat(tf);
		}
		 
		public function dispose():void
		{
			safeRemoveChild(this);
		}
	}

}