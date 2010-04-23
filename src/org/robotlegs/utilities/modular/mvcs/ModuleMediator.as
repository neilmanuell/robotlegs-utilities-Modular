/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.utilities.modular.mvcs
{
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.modular.core.IModuleEventDispatcher;
	import org.robotlegs.utilities.modular.core.IModuleCommandMap;
	
	import flash.events.Event;
	
	public class ModuleMediator extends Mediator
	{
		[Inject]
		public var moduleDispatcher:IModuleEventDispatcher;
	   		
		[Inject]
		public var moduleCommandMap:IModuleCommandMap;

        /**
         * Map an event type to globally redispatch to all modules within an application.
         * <p/>
         * <listing version="3.0">
         * mapRedispatchToModules(MyEvent.SOME_EVENT);
         * </listing>
         * 
         * @param event
         * 
         */
        protected function mapRedispatchToModules(eventType:String):void
        {
            eventMap.mapListener(eventDispatcher, eventType, redispatchToModules);
        }
        
        /**
         * Globally redispatch an event to all modules within an application.
         * <p/>
         * <listing version="3.0">
         * eventMap.mapEvent(view, MyEvent.SOME_EVENT, redispatchToModule);
         * </listing>
         * 
         * @param event
         * 
         */
		protected function redispatchToModules(event:Event):void
        {
			moduleDispatcher.dispatchEvent(event);
		}

        /**
         * Map an event type to locally redispatch to all modules within an application.
         * This is equivelant to using the <code>dispatch</code> method.
         * 
         * <p/>
         * @example The following example maps MyEvent.SOME_EVENT to redispatch to THIS module.
         * <listing version="3.0">
         * mapRedispatchInternally(MyEvent.SOME_EVENT);
         * </listing>
         * 
         * @param event
         * @see 
         * 
         */
        protected function mapRedispatchInternally(eventType:String):void
        {
            eventMap.mapListener(moduleDispatcher, eventType, redispatchInternally);
        }
        
        /**
         * Locally redispatch an event to all modules within an application.
         * This is equivelant to using the <code>dispatch</code> method.
         * 
         * <p/>
         * @example The following example relays directly.
         * <listing version="3.0">
         * eventMap.mapEvent(view, MyEvent.SOME_EVENT, redispatchInternally);
         * </listing>
         * 
         * @param event
         * @see 
         * 
         */
		protected function redispatchInternally(event:Event):void
        {
			eventDispatcher.dispatchEvent(event);
		}
	}
}