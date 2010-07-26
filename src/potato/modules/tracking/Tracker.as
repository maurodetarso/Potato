package potato.modules.tracking {

    import flash.events.*;
    import potato.core.config.*;
    import flash.external.ExternalInterface;
    import br.com.stimuli.string.printf;
    
	/**
	 * Default tracking implementation
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  26.07.2010
	 */
    public class Tracker{

        //List of thing to track
        public var line:Array=[];
        //Tracking function
        public var functionName:String = "track";
        //tracking values
        public var config:IConfig;
        //flag
        private var configLoaded:Boolean;

        private static var _instance:Tracker;

        public static function get instance():Tracker{
            if(!_instance)
                _instance = new Tracker();

            return _instance;
        }

        public function track(id:String, ...replace):void{

            //Adding to the line
            line.push({id: id, replace: replace});

            //Check if it's loaded
            if(!configLoaded) {
                if(!config) {
                    trace("[Tracker] no config");
                    return;
                }

                loadConfig();
                return;
            }

            if(configLoaded) move();
        }

        //Deals with the line
        public function move():void{
            
            //Tracking sequence
            while (line.length)
            {
                var o:Object = line.shift();

                //Getting the value of this key in the config
                var val:String = config.getProperty(o.id);
                //Stirng interpolation
                val = printf.apply(null, [val].concat(o.replace));

                //Calling
                ExternalInterface.call(functionName, val);
            }
            
        }

        /*
         * @private
         * */
        protected function loadConfig():void{
            var onConfigInit:Function = function(e:Event):void{
                e.target.removeEventListener(Event.INIT, onConfigInit);
                configLoaded = true;
                move();
            }
            config.addEventListener(Event.INIT, onConfigInit);
            config.init();
        }
    }
}
