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
 * @playerversion Flash 9.0.0
 * 
 * @author Lucas Dupin
 * @since  15.06.2010
 */
public class YAMLConfig extends ObjectConfig implements IConfig
{
	//JSON URL
	protected var _url:String;
	
	public function YAMLConfig(url:String)
	{
		_url = url;
	}
	
	/**
	 * Starts to load the JSON
	 */
	override public function init():void
	{
		//Loading our file!
		var l:URLLoader = new URLLoader(new URLRequest(_url));
		l.addEventListener(Event.COMPLETE, onConfigLoaded);
	}
	
	/**
	 * @private
	 */
	public function onConfigLoaded(e:Event):void
	{
		//Removing listener, so that we won't have memory leaks
		e.target.removeEventListener(Event.COMPLETE, onConfigLoaded);
		
		//var unpaserdConfig:Object = YAML.decode(e.target.data);
		
		_config = YAML.decode(e.target.data);
		
		//Continue from where we left
		//_config = unpaserdConfig;
		
		dispatchEvent(new Event(Event.INIT));
	}
	
}

}