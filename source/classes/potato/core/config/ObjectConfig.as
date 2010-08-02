package potato.core.config
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import potato.core.dsl.ConditionalParser;
	import br.com.stimuli.string.printf;

	/**
	 * Main config implementation
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  26.07.2010
	 */
	public class ObjectConfig extends EventDispatcher implements IConfig
	{
		// Source object
		internal var _config:Object;
		//Interpolation values
		protected var _interpolationValues:Object;
		//Conditional parser
		protected var _conditionalParser:ConditionalParser;
		//Magic word for creating conditionals
		public const CONDITIONAL_KEYWORD:String = "when";
		
		public function ObjectConfig(source:Object=null):void
		{
			_config = source || {};
			
			//Creating our default parser
			_conditionalParser = new ConditionalParser();
		}
		
		public function init():void
		{
			//Notify we're done
			dispatchEvent(new Event(Event.INIT));
		}
	
		/**
		 * @inheritDoc
		 */
		public function getProperty(...props):*
		{
			//Start from the config
			var lastVal:Object = _config;

			//Going deeper
			for each (var prop:Object in props)
			{
				lastVal = getPropertyValue(lastVal[prop]);
			}

			return lastVal;
		}

		public function hasProperty(...props):Boolean
		{
			//Start from the config
			var lastVal:Object = _config;

			//Going deeper
			for each (var prop:Object in props)
			{
				lastVal = getPropertyValue(lastVal[prop]);
				if(!lastVal) return false;
			}

			return true;
		}
		
		/**
		* Parse the config, search for conditionals and cast to the right types
		 * @param target Object 
		 * @return Object 
		 */
		public function getPropertyValue(target:Object):Object
		{
			var r:Object = target;

			//Dealing with null
			if (!r) return null;

			//Dealing with conditionals
			if (r.hasOwnProperty(CONDITIONAL_KEYWORD))
			{
				//Isolating conditions
				var conditions:Array = r[CONDITIONAL_KEYWORD];

				//Check for matches
				for each (var condition:Object in conditions)
				{
					if(_conditionalParser.match(condition.key)){
						r = condition.value;
						break;
					}	
				}
			}
			
			if(r is String){
				r = printf(r+"", _interpolationValues);
			}
				
			
			
			return r;
		}
		
		/**
		 * Inserts or modifies a property
		 * If it contains a valid conditional syntax,
		 * the conditional will be used
		 */
		public function setProperty(name:Object, value:Object):void
		{
			_config[name] = value;
		}
		
		/**
		 * All property keys
		 */
		public function get keys():Array
		{
			var k:Array=[];
			if (_config is Array)
			{
				for (var i:int = 0; i < _config.length; i++)
					k.push(i);
			} else {
				for (var s:String in _config)
					k.push(s);
			}
			
			
			return k;
		}
		
		/**
		 * @param key Object 
		 * Generates a new IConfig based in one item
		 */
		public function configForKey(key:Object):IConfig
		{
			var o:ObjectConfig = new ObjectConfig(_config[key]);
			o.interpolationValues = _interpolationValues;
			o.init();
			return o;
		}
		
		public function set interpolationValues(value:Object):void
		{
			_interpolationValues = value;
		}
	}

}
