package potato.modules.navigation
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import potato.core.config.IConfig;
	import flash.utils.Proxy;
	import flash.utils.getDefinitionByName;
	import potato.modules.dependencies.IDependencies;
	import potato.core.IDisposable;
	import potato.core.IVisible;
	import potato.core.config.ObjectConfig;
	import potato.modules.navigation.ViewLoader;
	import potato.modules.navigation.ViewMessenger;
	import potato.modules.navigation.NavigationController;
	import potato.modules.navigation.events.NavigationEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * Main piece of the navigation
	 * Can be initialized with a configuration
	 * 
	 * A default format is assumed for the config where parameters and dependencies
	 * can be present
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  17.06.2010
	 */
	public class View extends Sprite implements IDisposable, IVisible
	{
		/**
		 * id used for sending messages and doing navigation operations
		 */
		public var id:String;
		
		/**
		 * navigation controller,
		 * used to change, remove, add or load views
		 * 
		 */
		public var nav:NavigationController;
	
		/**
		 * Default order on stage
		 * TODO Getter/Setter -> managed by the navigation controller
		 */
		public var zIndex:int=0;
		
		protected var _parameters:Object;
		protected var _dependencies:IDependencies;
		protected var _config:IConfig;
		
		//Flag
		protected var _initialized:Boolean = false;
	
		/**
		 * @constructor
		 * Nothing is done here...
		 * logic moved to <code>startup</code>
		 * @see	startup
		 */
		public function View()
		{
			
		}
		
		/**
		 * @param value IConfig View configuration
		 * Prepares the view to receive interaction
		 * This was moved from the constructor due
		 * to synchronization issues
		 */
		internal final function startup(value:IConfig=null):void
		{
			//Flag
			_initialized = true;
			
			_config = value || new ObjectConfig();
			
			//Config initialization
			_config.interpolationValues = parameters;
			_config.addEventListener(Event.INIT, onConfigInit, false, 0, true);
			_config.init();
		}
		
		/**
		 * @param e Event 
		 * Runs after que configuration is loaded.
		 * Responsable for setting default view behaviours: init, resize, transitions
		 */
		public function onConfigInit(e:Event=null):void
		{
			/*
			Initial config done
			*/
			_config.removeEventListener(Event.INIT, onConfigInit);

			if(_config.hasProperty("id"))
				id = _config.getProperty("id");
			else if (!id)
				id = getQualifiedClassName(this);
				
			if(_config.hasProperty("parameters"))
				parameters.inject(_config.configForKey("parameters"));
			
			//Creating the navigation controller to add, remove or change views
			nav = new NavigationController(_config.hasProperty("views") ? _config.getProperty("views") : null, this, parameters);
			nav.addEventListener(NavigationEvent.ADD_VIEW, onViewReadyToAdd);
			nav.addEventListener(NavigationEvent.REMOVE_VIEW, onViewReadyToRemove);
			
			//Default view behaviour
			addEventListener(Event.ADDED_TO_STAGE, _init, false, 0, true);
			
			//If this is the first view, it's already on stage
			if(stage)
				_init();
			
		}

        /**
         * @param view String
         * Returns a proxy to a View
         */
        public function msg(view:String):ViewMessenger{
            return nav.getViewMessenger(view);
        }

        public function addView(viewOrId:Object):void{
            nav.root.nav.addView(viewOrId);
        }
        public function removeView(viewOrId:Object):void{
            nav.root.nav.removeView(viewOrId);
        }
        public function changeView(viewOrId:Object):void{
            nav.changeView(viewOrId);
        }
        public function loaderFor(view:String):ViewLoader{
            return nav.loaderFor(view);
        }


		/**
		 * @private
		 * Internal init
		 */
		protected function _init(e:Event=null):void
		{
			//Init only once
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			
			//Enable resize
			stage.addEventListener(Event.RESIZE, _resize, false, 0, true);
			
			//User implementation
			init();
			//Position all stuff
			resize();
		}
		/**
		 * @private
		 * Internal resize
		 */
		protected function _resize(e:Event):void
		{
			if(stage)
				resize();
		}
		/**
		 * @private
		 * Internal dispose
		 */
		internal function _dispose():void
		{
			//Call user implementation
			dispose();
			
			if(nav){
				nav.dispose();
				nav = null;
			}
			if(dependencies){
				dependencies.dispose();
				dependencies = null;
			}
			parameters = null;
		}
		
		/**
		 * @private
		 */
		protected function onViewReadyToAdd(e:NavigationEvent):void
		{
			addChild(e.view);
			sortViews();
		}
		/**
		 * @private
		 */
		public function onViewReadyToRemove(e:NavigationEvent):void
		{
			if(e.view.parent == this)
				removeChild(e.view);
		}
		
		/**
		 * Put every view in it's correct zIndex
		 * (not adding them again to keep other stuff order)
		 */
		public function sortViews():void
		{
			//Sorting
			var lastView:View = nav.children[0];
			for each (var view:View in nav.children)
			{
				if (view.zIndex > lastView.zIndex)
				{
					swapChildren(view, lastView);
				}
				lastView = view;
			}
		}
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		public function get config():IConfig
		{
			return _config;
		}
		
		/**
		 * Potato parameters.
		 * Returns null when the module is not included
		 * Otherwise, a <code>potato.modules.parameters.Parameters</code> instace is returned
		 * (automatically created if needed)
		 */
		public function get parameters():Object
		{
			//Initialization?
			if(!_parameters)
			{
				try
				{
					//Check if the module was included and create an instance
					var klass:Class = getDefinitionByName("potato.modules.parameters.Parameters") as Class;
					//Create an instance
					_parameters = new klass();
				} 
				catch (e:ReferenceError) {
					trace("[View] Error, potato.modules.parameters.Parameters was not found");
				}
			}
			
			return _parameters;
		}
		/**
		 * Used by parent view to override the parameters
		 */
		public function set parameters(value:Object):void
		{
			_parameters = value;
		}
		
		/**
		 * Potato dependencies.
		 * Returns null when the module is not included
		 * Otherwise, a <code>potato.modules.dependencies.Dependencies</code> instace is returned
		 * 
		 * Dependencies should be added in the main config file, but nothing blocks you from adding them
		 * by code
		 * 
		 * (automatically created if needed)
		 */
		public function get dependencies():IDependencies
		{
			return _dependencies;
		}
		public function set dependencies(value:IDependencies):void
		{
			_dependencies = value;
		}
		
	
		/**
		 * Method to override
		 * View initialization, all stuff available: Dependencies, parameters, stage
		 */
		public function init():void {}
	
		/**
		 * Method to override
		 * Transition stuff
		 * *********************************************************
		 * Don't forget to call super if you override this method
		 */
		public function show():void {
			nav.addEventListener(NavigationEvent.TRANSITION_COMPLETE, _showComplete, false, 0, true);
			nav.doTransition();
		}
		public function _showComplete(e:Event):void
		{
			nav.removeEventListener(NavigationEvent.TRANSITION_COMPLETE, _showComplete);
			dispatchEvent(new NavigationEvent(NavigationEvent.VIEW_SHOWN, this));
		}
	
		/**
		 * Method to override
		 * Transition stuff
		 * *********************************************************
		 * Don't forget to call super if you override this method
		 */
		public function hide():void {
			nav.addEventListener(NavigationEvent.TRANSITION_COMPLETE, _hideComplete, false, 0, true);
			nav.hideAll();
		}
		public function _hideComplete(e:Event):void
		{	
			nav.removeEventListener(NavigationEvent.TRANSITION_COMPLETE, _hideComplete);
			dispatchEvent(new NavigationEvent(NavigationEvent.VIEW_HIDDEN, this));
		}
	
		/**
		 * Method to override
		 * Stage resize callback
		 */
		public function resize():void {}
	
		/**
		 * Method to override
		 * Destroy view
		 */
		public function dispose():void {}

        override public function toString():String{
            return "[View: " + id + "]"
        }
	}

}
