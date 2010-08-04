package potato.modules.tracking {

    import flash.events.*;
    import potato.core.config.*;
    import flash.external.ExternalInterface;
    import br.com.stimuli.string.printf;
    
	/**
	 * Default tracking implementation
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Lucas Dupin, Fernando França
	 * @since  26.07.2010
	 */
    public class Tracker{

        // Tracking call queue
        public var trackQueue:Array = [];
        // Tracking function
        public var functionName:String = "track";
        // Tracking configuration
        public var config:IConfig;
        // Flag
        private var configLoaded:Boolean;

        private static var _instance:Tracker;

		public function Tracker(singleton:SingletonEnforcer){}
		
		/**
		 * Get Tracker instance (Singleton)
		 */
        public static function get instance():Tracker{
            if(!_instance)
                _instance = new Tracker(new SingletonEnforcer());

            return _instance;
        }
		
		/**
		* Creates a new tracking call and pushes it to the queue.
		* @param	id	 The id of the tracking call.
		* @param	replace	 Optional arguments of the tracking call.
		*/
        public function track(id:String, ...replace):void{

            //Adding to the trackQueue
            trackQueue.push({id: id, replace: replace});

            //Check if it's loaded
            if(!configLoaded) {
                loadConfig();
            }
			else {
				processQueue();
			}
        }

       	/**
       	 * Process next queued tracking call
       	 */
        public function processQueue():void{
            
            // Tracking sequence
            while (trackQueue.length)
            {
                var o:Object = trackQueue.shift();

                //Getting the value of this key in the config
                var val:String = config.getProperty(o.id);
                
				//String interpolation
                val = printf.apply(null, [val].concat(o.replace));

                //Calling
                ExternalInterface.call(functionName, val);
            }
            
        }

        /**
         * Load configuration file
         * @private
         */
        protected function loadConfig():void
		{
			if(!config) {
                trace("[Tracker] no config");
                return;
            }
            config.addEventListener(Event.INIT, onConfigInit);
            config.init();
        }
		
		/**
		 * Setup tracker after configuration has been loaded.
		 * @param e Event 
		 * @private
		 */
		protected function onConfigInit(e:Event):void
		{
			e.target.removeEventListener(Event.INIT, onConfigInit);
            configLoaded = true;
            processQueue();
		}
    }
}

/**
 * Enforces the Singleton design pattern.
 */
internal class SingletonEnforcer{}
