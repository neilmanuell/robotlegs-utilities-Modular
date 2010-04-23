/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.utilities.modular.mvcs
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.Context;
	import org.robotlegs.utilities.modular.base.ModuleCommandMap;
	import org.robotlegs.utilities.modular.base.ModuleEventDispatcher;
	import org.robotlegs.utilities.modular.core.IModuleCommandMap;
	import org.robotlegs.utilities.modular.core.IModuleContext;
	import org.robotlegs.utilities.modular.core.IModuleEventDispatcher;

    /**
     * Contains additional mappings and facilitates the use of a parent injector
     * to create a child injector for a module. 
     * @author Joel Hooks
     * 
     */    
    public class ModuleContext extends Context
    {
        public function ModuleContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, injector:IInjector = null)
        {
            if(injector)
            {
                injector = injector.createChild();
                _injector = injector;
            }
            super(contextView, autoStartup);
        }
        
        override protected function mapInjections():void
        {
            super.mapInjections();
            if(!injector.hasMapping(IModuleEventDispatcher))
                injector.mapSingletonOf(IModuleEventDispatcher, ModuleEventDispatcher);
            if(!injector.hasMapping(IModuleCommandMap))
                injector.mapSingletonOf(IModuleCommandMap, ModuleCommandMap);
        }
    }
}