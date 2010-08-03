package potato.core.config
{
	import flash.events.IEventDispatcher;

	/**
	 * Default interface for all Potato configurations
	 * Mainly used for lazy config evaluation (conditionals)
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Lucas Dupin, Fernando França
	 * @since  15.06.2010
	 */
	public interface IConfig extends IEventDispatcher
	{
		/**
		 * Handles config initialization. 
		 * Should dispatch <code>Event.INIT</code> when done.
		 */
		function init():void;
		
		/**
		 * Returns a property's value or null when none is found.
		 * Types MUST be already converted:
		 * 		"String", 1, "01"
		 * 
		 * @example
		 * 	getProperty("dependencies", "homeBg");
		 */
		function getProperty(...prop):*;
		
		/**
		 * Checks for a property existence
		 * 
		 * @example
		 * 	hasProperty("dependencies", "homeBg");
		 */
		function hasProperty(...prop):Boolean;
		
		/**
		 * Returns an Array containing all property keys
		 */
		function get keys():Array;
		
		/**
		 * Inserts or modifies a property
		 * If it contains a valid conditional syntax,
		 * the conditional will be processed when the value is requested (lazy evaluation)
		 */
		function setProperty(name:Object, value:Object):void;
		
		/**
		 * @param key Object 
		 * Generates a new IConfig based in one item
		 */
		function configForKey(key:Object):IConfig;
		
		/**
		 * In case you want to do string interpolation,
		 * you can pass an object or a parameters instance!
		 */
		function set interpolationValues(value:Object):void;
	}

}

