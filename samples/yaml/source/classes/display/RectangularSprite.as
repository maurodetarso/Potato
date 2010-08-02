package display
{
	import flash.display.Sprite;
	import potato.core.IDisposable;
	import potato.display.safeRemoveChild;
	
	/**
	 * Simple colored rectangle Sprite. Useful for layout mock-ups.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  30.07.2010
	 */
	public class RectangularSprite extends Sprite implements IDisposable
	{
	
		public function RectangularSprite(width:Number, height:Number, color:uint = 0xff0000, alpha:Number = 1.0)
		{
			super();
			graphics.beginFill(color, alpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		public function dispose():void
		{
			safeRemoveChild(this);
		}
	
	}

}