package potato.utils
{
	import potato.utils.construct;
	import flash.utils.getDefinitionByName;
	
	/** 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  05.08.2010
	 * 
	 * 
	 * Utility method for flash.utils.getDefinitionByName.
	 * 
	 * @param	className	 String The qualified class name for this instance
	 * @return		The instance of the given class, or <i>null</i> if the class defition can't be found.
	 */
	
	public function getInstanceByName(className:String, ...args):*
	{
		try
		{
			//Check if the module was included and create an instance
			var classDefinition:Class = getDefinitionByName(className) as Class;
		} 
		catch (e:ReferenceError) {
			trace("[getInstanceByName] Error, "+ className +" was not found.");
			return null;
		}
		
		var classInstance:* = construct.apply(null, [classDefinition].concat(args));
		return classInstance;
		
	}
}
