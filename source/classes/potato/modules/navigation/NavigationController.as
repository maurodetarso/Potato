package potato.modules.navigation
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import potato.modules.navigation.events.NavigationEvent;
	import potato.modules.navigation.View;
	import potato.core.config.IConfig;
	import potato.core.config.ObjectConfig;

	/**
	 * This class is responsible for changing, adding or removing views
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  17.06.2010
	 */
	public class NavigationController extends TreeController
	{
		/**
		 * @param	viewsConfig	         An object containing view configurations
		 * @param	currentView	         The current view being navigated
		 * @param	interpolationValues	 Optional string values to be interpolated against the view configurations
		 * @constructor
		 */
		public function NavigationController(viewsConfig:Object, currentView:View, interpolationValues:Object)
		{
            //Initializing the TreeController
            super(viewsConfig, currentView, interpolationValues);
		}
		
			
        /**
         * @param view String
         * Returns a proxy to a View
         */
        public function getViewMessenger(view:String):ViewMessenger{
            var v:View = root.nav.findChild(view);
            if (v)
                return new ViewMessenger(v);
            else
                return null;
        }
		
		/**
		 * @param viewOrId * String or View instance
		 * Load the requested view, returns the view loader, wich can notify completion and progress
		 */
		public function loaderFor(id:String):ViewLoader
		{
            //Generate the loader
			var vl:ViewLoader = root.nav.generateChainedLoader(id);
			
			//Add to the list of loaded views when done
			if(vl)
			{
				vl.addEventListener(Event.COMPLETE, onViewLoaded);
				return vl;
			}
			
			//None found
			trace("[NavigationController] no view named", id, "found");
			return null;
		}
		
		/**
		 * TODO test with mixed trees (Views and IConfigs)
		 * Go deeper in the tree and find where the config is,
		 * once found, build the loader form it
		 * @param id String 
		 * @return ViewLoader 
		 */
		public function generateChainedLoader(id:String):ViewLoader
		{
			var chainedLoader:ViewLoader;
            
            //Loop trough all views...
            //Check if we have this view in the config
            //  Yes - configLooper
            //  No - look for other ones

            var miner:Function = function(id:String, haystack:NavigationController):ViewLoader{

                //First of all, check our children -> base of the tree
                var chainedLoader:ViewLoader;
                for each (var v:View in haystack.children)
                {
                    chainedLoader = miner(id, v.nav);

                    //Stop searching
                    if(chainedLoader) {
                        chainedLoader.parentView = v;
                        return chainedLoader;
                    }
                }

                //Not found, check in the config
                if(haystack.findUnloadedChild(id)) {
                    chainedLoader = configLooper(id, haystack._childrenConfig);
                    chainedLoader.parentView = haystack.currentView;
                    return chainedLoader;
                }

                //Not here...
                return null;
            }
            
            return miner(id, root.nav);
           
		}
		
		/**
		 * This method is responsible for looping in the config and to create
		 * a chained ViewLoader.
		 * 
		 * @param search String Id of the view we want to loop for
		 * @param haystack Vector.<IConfig> list of child views
		 * @return ViewLoader chaned loader with all dependencies
		 */
		protected function configLooper(search:String, haystack:Vector.<IConfig>):ViewLoader
		{
			//Searching for this view in the config
			for each(var c:IConfig in haystack)
			{
				//Did we find our view?
				if(c.getProperty("id") == search)
					return new ViewLoader(c);

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
					var chainedConfig:ViewLoader = configLooper(search, newHaystack);
					
					//WOW!!!!!!!! found it with recursion!
					//Let start to chain!!!!
					if (chainedConfig)
						return new ViewLoader(c, chainedConfig);
					
				}
			}
			return null;
				
		}
		
		/**
		 * @param e Event 
		 * Default action for every loaded view.
		 * Add to the list, inherit parameters, if needed, set parent...
		 */
		internal function onViewLoaded(e:Event):void
		{
			var loadedView:View = e.target.view as View;
			viewsLoaded.push(loadedView);
			e.target.removeEventListener(Event.COMPLETE, onViewLoaded);

            //Adding other loaded views
            while(loadedView.nav._viewsLoaded.length > 0){
                viewsLoaded.push(loadedView.nav._viewsLoaded.pop());
            }
		
			//Add parameters inheritance
			if(loadedView.parameters)
				loadedView.parameters.inherit = _interpolationValues;
				
			//Set the parent of the loaded view
			//loadedView.nav.parent = currentView;
		}
		
		/**
         * Adds a view to the screen
		 * @param viewOrId * String or View instance
		 */
		public function addView(viewOrId:Object):void
		{
            if(viewOrId is View){
                var view:View = viewOrId as View;
                
                //Already a view, only adding it
                view.startup();
				onViewReadyToAdd(new NavigationEvent(Event.COMPLETE, view));

            } else if (viewOrId is String) {

                //View id
                var id:String = viewOrId + "";

                //Check if it already exists
                if (root.nav.findChild(id)) {
                    trace("[NavigationController] View already on stage", id);
                    //Nothing else to do...
                    return;
                }
                
                //Search in Loaded Views
                for each (view in viewsLoaded)
                {
                    if(view.id == id){
                        //add it
                        //this line may sound strange but we ned to add the view relative to it's parent
                        //not to the one who is calling addView
                        view.nav.parent.nav.onViewReadyToAdd(new NavigationEvent(Event.COMPLETE, view));
                        return;
                    }
                }
			
                //Get the loader
                var loader:ViewLoader = loaderFor(id);
                //Listens for complete
                loader.addEventListener(Event.COMPLETE, loader.parentView.nav.onViewReadyToAdd);
                //TODO Notify
                //dispatchEvent(new Event(NavigationEvent.LOAD_START));
                //Load!
                loader.start();

            }
		}
		
        /**
         * Removes a view from the screen
         * */
		public function removeView(viewOrId:Object):void
		{
            //Getting the view instance
            var targetView:View;
			if(viewOrId is View)
                targetView = viewOrId as View;
			else
				targetView = root.nav.findChild(viewOrId + "");
            
            if(targetView) {
                //Getting the parent Controller of the view,
                //It's where the transition will occur
                var parentNav:NavigationController = targetView.nav.parent.nav;
                //Adding to the list of views to be removed
                parentNav._viewsToHide.push(targetView);
                //removing
                parentNav.doTransition();
            } else {
                //None found...
                trace("[NavigationController] No view name", viewOrId, "found.");
                return;
            }

		}
		
        /**
         * Adds a view and remove it's siblings
         * */
		public function changeView(viewOrId:Object):void
		{
			//Is there something to do?
			if (root.nav.findChild(viewOrId+""))
			{
				trace("[NavigationController]", viewOrId, "already on stage");
				return;
			}
			
			trace("[NavigationController] changeView in:", viewOrId);
			
			//Setting which views we're going to hide
			_viewsToHide = _viewsToHide.concat(children);
			//Asking to add the view we want
            if(findUnloadedChild(viewOrId + ""))
    			addView(viewOrId);
            else
                trace("    ", viewOrId, "could not be found on", currentView);
		}
		
		public function hideAll():void
		{
			_viewsToHide = _viewsToHide.concat(children);
			doTransition();
		}
		
		/**
		 * @param e NavigationEvent 
		 * View loaded, this is the part we ask the parent view to add it's child to the screen
		 */
		internal function onViewReadyToAdd(e:NavigationEvent):void{
			//Removing listener
			if(e.target) e.target.removeEventListener(Event.COMPLETE, onViewReadyToAdd);
            
			//Add to the list of views to show
			_viewsToShow.push(e.view);
			
            //TODO Notify
            //dispatchEvent(new Event(NavigationEvent.LOAD_COMPLETE));
			
			//Start transition
			doTransition();
		}
		
		/**
		 * Starts a transition.
		 * Hides views marked and when they are all hidden, calls <code>continueTransition()</code>
		 * so the ones in the _viewsToShow will be shown
		 */
		internal function doTransition():void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_START));
			
			var v:View;
			if (_viewsToHide.length > 0)
			{
				for each (v in _viewsToHide)
				{
					//Remove from list of views
					var p:View = v.nav.parent;
					p.nav.children.splice(p.nav.children.indexOf(v),1);
					
					//Prepare to hide
					v.addEventListener(NavigationEvent.VIEW_HIDDEN, onViewHidden);
			
			        //Remove from list
			        _viewsToHide.splice(_viewsToHide.indexOf(v),1);
					
					//Hide
					v.hide();
				}
			} else
			{
				continueTransition();
			}
		}
		/**
		 * Called after all views are hidden.
		 * Show views in _viewsToShow
		 */
		protected function continueTransition():void
		{
			var v:View;
			if(_viewsToShow.length > 0)
			{
				for each (v in _viewsToShow)
				{
					//Remove from queue
					viewsLoaded.splice(viewsLoaded.indexOf(v), 1);
					
					//Add to the list of views
					if(children.indexOf(v) == -1)
						children.push(v);
					
					//Tell parent to add it
					dispatchEvent(new NavigationEvent(NavigationEvent.ADD_VIEW, v));
					
					//Prepare to show
					v.addEventListener(NavigationEvent.VIEW_SHOWN, onViewShown);
					
					//Show time
					v.show();
				}
			} else
			{
				finishTransition();
			}
			
		}
		/**
		 * All done
		 */
		protected function finishTransition():void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.TRANSITION_COMPLETE));
		}
		
				
		/**
		 * @private
		 */
		protected function onViewHidden(e:NavigationEvent):void
		{
			//Remove from stage
			dispatchEvent(new NavigationEvent(NavigationEvent.REMOVE_VIEW, e.view));

			//Free some memory
			e.view._dispose();
			
			//Are we done?
			if (_viewsToHide.length == 0)
				continueTransition();
		}
		/**
		 * @private
		 */
		protected function onViewShown(e:NavigationEvent):void
		{
			_viewsToShow.splice(_viewsToShow.indexOf(e.view),1);
			if (_viewsToShow.length == 0)
				finishTransition();
		}
        
        		
		/**
		 * @private
		 */
		override public function dispose():void
		{
			_interpolationValues = null;
			
			super.dispose();
		}
	
	}

}
