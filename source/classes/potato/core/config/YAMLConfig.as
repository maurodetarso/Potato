package potato.core.config
{
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import org.as3yaml.YAML;
import potato.core.config.ObjectConfig;
import potato.core.dsl.ConditionalParser;

/**
 *  Dispatched after the YAML file has been loaded and parsed.
 *
 *  @eventType flash.events.Event.INIT
 */
[Event(name="init", type="flash.events.Event")]

/**
 * Configuration based on YAML files
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 10.0.0
 * 
 * @author Lucas Dupin, Fernando França
 * @since  15.06.2010
 */
public class YAMLConfig extends ObjectConfig implements IConfig
{
	/**
	 * URL for the YAML file
	 * @private
	 */
	protected var _url:String;
	
	/**
	 * @param	url	 The URL of the YAML configuration file
	 * @constructor
	 */
	public function YAMLConfig(url:String)
	{
		_url = url;
	}
	
	/**
	 * Starts loading the YAML file
	 */
	override public function init():void
	{
		var urlLoader:URLLoader = new URLLoader(new URLRequest(_url));
		urlLoader.addEventListener(Event.COMPLETE, onConfigLoaded);
	}
	
	/**
	 * Parses the YAML file after it has been loaded and dispatches the INIT event
	 * @private
	 */
	protected function onConfigLoaded(e:Event):void
	{
		// Removing listener, so that we won't have memory leaks
		e.target.removeEventListener(Event.COMPLETE, onConfigLoaded);
		
		// Parse YAML
		_config = YAML.decode(e.target.data);
		
		// Notify
		dispatchEvent(new Event(Event.INIT));
	}
	
}

}
