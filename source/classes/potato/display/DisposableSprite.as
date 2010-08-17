package potato.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import potato.core.IDisposable;
	import potato.control.DisposableGroup;
	
	/**
	 * Provides easier management of disposable child objects.
	 * This class mimetizes the addChild methods of the Sprite class.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  30.07.2010
	 */
	public class DisposableSprite extends Sprite implements IDisposable
	{
		protected var _disposableChildren:DisposableGroup;
	
		public function DisposableSprite()
		{
			_disposableChildren = new DisposableGroup();
		}
		
		/**
		 * Automatically disposes children.
		 */
		public function dispose():void
		{
			if(_disposableChildren != null) 
				_disposableChildren.dispose();
			_disposableChildren = null
		}
	
		/**
		 * Registers a disposable object.
		 * @param obj IDisposable 
		 */
		public function addDisposable(obj:IDisposable):void
		{
	    	_disposableChildren.addElement(obj);
	    }
		
		/**
		 * Adds and registers a disposable child DisplayObject.
		 * @param obj IDisposable 
		 */
	    public function addDisposableChild(obj:IDisposable):void
		{
	    	_disposableChildren.addElement(obj);
	    	addChild(obj as DisplayObject);
	    }
		
		/**
		 * Adds and registers a disposable child DisplayObject at the given index.
		 * @param obj IDisposable
		 */
		public function addDisposableChildAt(obj:IDisposable, index:int):void
		{
			_disposableChildren.addElement(obj);
	    	addChildAt(obj as DisplayObject, index);
	    }
		
		/**
		 * Dispose children that have been added to this object through the addDisposable methods.
		 */
	    public function disposeChildren():void
		{
			_disposableChildren.dispose();
	    }
	
	}

}