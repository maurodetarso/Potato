package potato.core.config
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.adobe.serialization.json.JSON;
	import potato.core.config.ObjectConfig;
	import potato.core.dsl.ConditionalParser;

	/**
	 *  Dispatched after the JSON file has been loaded and parsed.
	 *
	 *  @eventType flash.events.Event.INIT
	 */
	[Event(name="init", type="flash.events.Event")]

	/**
	 * 
	 * Conditional operators:
	 * 	!= >= > == <= < ~=
	 * 
	 * Variables type:
	 * 	Number, String, null, RegEx, Object
	 * 
	 * Conditionals example:
	 * 'age': 35, 
	 * 'site': {
	 *     'if': {        
	 *         "age >= 30": 'http://age.com',
	 *         "age >= 18": 'http://anurl.com',
	 * 		   "otherParam == 'stringValue'": "http://anotherurl.com",
	 *         "else": "http://defaulturl.com"
	 *     } 
	 * }
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  15.06.2010
	 */
	public class JSONConfig extends ObjectConfig implements IConfig
	{
		/**
		 * URL for the JSON file
		 * @private
		 */
		protected var _url:String;
	
		/**
		 * @param	url	 The URL of the JSON configuration file
		 * @constructor
		 */
		public function JSONConfig(url:String)
		{
			_url = url;
		}
	
		/**
		 * Starts loading the JSON file
		 */
		override public function init():void
		{
			var l:URLLoader = new URLLoader(new URLRequest(_url));
			l.addEventListener(Event.COMPLETE, onConfigLoaded);
		}
	
		/**
		 * Parses the JSON file after it has been loaded and dispatches the INIT event
		 * @private
		 */
		public function onConfigLoaded(e:Event):void
		{
			// Removing listener, so that we won't have memory leaks
			e.target.removeEventListener(Event.COMPLETE, onConfigLoaded);
		
			// Parse JSON
			_config = JSON.decode(e.target.data);
		
			// Notify
			dispatchEvent(new Event(Event.INIT));
		}
	
	}

}