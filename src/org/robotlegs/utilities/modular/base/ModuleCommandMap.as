/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.robotlegs.utilities.modular.base
{
	import flash.utils.Dictionary;
	
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.utilities.modular.core.IModuleCommandMap;
	import org.robotlegs.utilities.modular.core.IModuleEventDispatcher;

    /**
     * Create command mappings that are global across all modules.
     *  
     * @author Joel Hooks
     * 
     */    
	public class ModuleCommandMap extends CommandMap implements IModuleCommandMap
	{
		public function ModuleCommandMap(eventDispatcher:IModuleEventDispatcher, injector:IInjector, reflector:IReflector)
		{
			super(eventDispatcher, injector, reflector);
		}
        
        public function dispose():void
        {
            for(var key:Object in eventTypeMap);
            {
                for each(var value:Object in eventTypeMap[key])
                {
                    if(value is Dictionary)
                    {
                        for(var innerKey:Object in value)
                        {
                            eventDispatcher.removeEventListener(String(key), value[innerKey]);                            
                            delete value[innerKey];                   
                        }
                    }
                }
                delete eventTypeMap[key];
            }
        }
	}
}