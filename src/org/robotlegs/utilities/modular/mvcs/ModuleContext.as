/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.utilities.modular.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.robotlegs.base.ContextEvent;
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
    public class ModuleContext extends Context implements IModuleContext
    {
        protected var _moduleDispatcher:IModuleEventDispatcher;

        protected function get moduleDispatcher():IModuleEventDispatcher
        {
            return _moduleDispatcher;
        }

        protected function set moduleDispatcher(value:IModuleEventDispatcher):void
        {
            _moduleDispatcher = value;
        }
        
        protected var _moduleCommandMap:IModuleCommandMap;

        protected function get moduleCommandMap():IModuleCommandMap
        {
            return _moduleCommandMap || (_moduleCommandMap = new ModuleCommandMap(moduleDispatcher, injector, reflector));
        }
        
        protected function set moduleCommandMap(value:IModuleCommandMap):void
        {
            _moduleCommandMap = value;
        }
        
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
            initializeModuleEventDispatcher();
            injector.mapValue(IModuleCommandMap, moduleCommandMap);
        }
        
        protected function initializeModuleEventDispatcher():void
        {
            if(injector.hasMapping(IModuleEventDispatcher) )
            {
                moduleDispatcher = injector.getInstance(IModuleEventDispatcher);
            }
            else
            {
                moduleDispatcher = new ModuleEventDispatcher(this);
                injector.mapValue(IModuleEventDispatcher, moduleDispatcher); 
            }          
        }
        
        
        protected function dispatchToModules(event:Event):void
        {
            _moduleDispatcher.dispatchEvent(event);
        }
        
        public function dispose():void
        {
            dispatchEvent(new ContextEvent(ContextEvent.SHUTDOWN));
            _moduleCommandMap.dispose();
            _moduleCommandMap = null;
            _moduleDispatcher = null;
            _contextView = null;
            _injector = null;
            _reflector = null;
            _commandMap = null;
            _mediatorMap = null;
            _viewMap = null;
            _eventDispatcher = null;
        }
    }
}