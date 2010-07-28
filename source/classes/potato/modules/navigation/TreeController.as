package potato.modules.navigation {

    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
	import potato.core.config.*;
    import potato.modules.navigation.View;
    
    public class TreeController extends EventDispatcher{

		protected var _childrenConfig:Vector.<IConfig> = new Vector.<IConfig>();

        //Performance stuff
        //Keeps a reference of search results
        //internal var _cachedSearchResults:Dictionary = new Dictionary(true);
		
		/**
		 * List of visible children
		 */
		public var children:Vector.<View> = new Vector.<View>();
        
        /**
		 * The view which this nav belongs
		 */
		public var currentView:View;
		/**
		 * Parent View (null if there is none)
		 */
		public var parent:View;

        //Parameters glue
		protected var _interpolationValues:Object;
		
		//Transition control
		internal var _viewsToShow:Vector.<View> = new Vector.<View>();
		internal var _viewsToHide:Vector.<View> = new Vector.<View>();
		internal var _viewsLoaded:Vector.<View> = new Vector.<View>();


        public function TreeController(viewsConfig:Object, currentView:View, interpolationValues:Object){
            //Node's view
            this.currentView = currentView;

            //Parameters glue
			_interpolationValues = interpolationValues || {};
			
			//Creating a config object
			for each(var raw:Object in viewsConfig)
			{
				//Creating a config from the raw data
				var c:IConfig = new ObjectConfig(raw);
				c.interpolationValues = _interpolationValues;
				//No need to wait for the INIT event in ObjectConfigs
				c.init();
				
				//Checking if this is the config we want
				_childrenConfig.push(c)
			}

        }

        /**
		 * @param id String 
		 * @return Boolean 
		 * Checks if this view has a VISIBLE view (children list) with the name of the id
		 */
		protected function findChild(id:String):View
		{
            //Check if we have already searched for this view
            //if(_cachedSearchResults[id]) return _cachedSearchResults[id];

			for each (var child:View in children)
			{
				if(child.id == id)
					return child;
				
                //Looking up
				var c:View = child.nav.findChild(id);
                //Found
				if(c) {
                    //Performance stuff
                    //_cachedSearchResults[id] = c;
                    //Return the view
                    return c;
                }
			}
			return null;
		}

         /**
		 * @param id String 
		 * @return Boolean 
		 * Checks if this view has a referente to <code>id</code> in the CONFIGs (_childrenConfig list)
		 */
		protected function findUnloadedChild(id:String):IConfig
		{
			var miner:Function = function(search:String, haystack:Vector.<IConfig>):IConfig {
				for each (var c:IConfig in haystack)
				{
					//Did we find our view?
					if(c.getProperty("id") == search) return c;

					//No... look in the child
					if(c.hasProperty("views"))
					{
						//List of children views
						var views:IConfig = c.configForKey("views");
						
						//Generate a new haystack
						var newHaystack:Vector.<IConfig> = new Vector.<IConfig>();
						var keys:Array = views.keys;
						for (var i:int = 0; i < keys.length; i++)
						{
							newHaystack.push(views.configForKey(keys[i]));
						}

						//Search in the children
						return miner(search, newHaystack);
					}
				}
				return null;
			}
			return miner(id, _childrenConfig);
		}

        /**
		 * Searches the view and go up untill it finds a common ancestor
		 * 
		 * @param startFrom View a point in the haystack
		 * @param needle String The view we're looking for
		 * @return View Common ancestor
		 */
		public function findCommonAncestor(startFrom:View, needle:String):View
		{
			//No more places to search
			if(!startFrom) return null;

			//Search in loaded views and unloaded views
			if(startFrom.nav.findChild(needle) || startFrom.nav.findUnloadedChild(needle))
				return startFrom;
			else
			//Could not find, go up in the tree
				return findCommonAncestor(startFrom.nav.parent, needle);
		}

        public function get root():View
		{
            //Performance stuff
            //if(_cachedSearchResults["potatoRoot"]) return _cachedSearchResults["potatoRoot"];

			//Go to the root of the tree
			var topView:View = currentView;
			while (topView.nav.parent){
				topView = topView.nav.parent;
            }
				
            //Caching the result
            //_cachedSearchResults["potatoRoot"] = topView;
			return topView;
		}

        public function get viewsLoaded():Vector.<View>{
            return root.nav._viewsLoaded;
        }

        /**
		 * @private
		 */
		public function dispose():void
		{
			if (children)
			{
				for each (var v:View in children)
					v.dispose();
				children = null;
			}
			
			_childrenConfig = null;
			
			_viewsToHide =
			_viewsToShow =
			children = null;
			
		}



    }
}

