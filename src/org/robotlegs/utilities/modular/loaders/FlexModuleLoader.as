package org.robotlegs.utilities.modular.loaders {
import flash.system.ApplicationDomain;

import mx.events.ModuleEvent;
import mx.modules.IModuleInfo;
import mx.modules.ModuleManager;

import org.robotlegs.core.IInjector;
import org.robotlegs.mvcs.Actor;
import org.robotlegs.utilities.modular.core.IModule;
import org.robotlegs.utilities.modular.core.IModuleLoader;

public class FlexModuleLoader extends Actor implements IModuleLoader {

    [Inject]
    public var injector:IInjector;

    private var _urlMap:Array;

    public function getModule( url:String, domain:ApplicationDomain = null ):Boolean {
        var moduleInfo:IModuleInfo =  ModuleManager.getModule( url );
        if( hasMapping( url ) ) return moduleInfo.ready;
        map( url );
        addEventListeners( moduleInfo );
        moduleInfo.load(domain);
        return false;
    }

    public function create(url:String):Object {
        if( !hasMapping( url ) ) return null; // todo: throw error here;
        var moduleInfo:IModuleInfo =  ModuleManager.getModule( url );
        if( !moduleInfo.ready ) return null; // todo: throw error here;
        var o:Object = moduleInfo.factory.create();
        if( o is IModule )return initiateModule( IModule( o ) );
        return o;
    }

    public function unload(url:String):void {
        if( !hasMapping( url ) ) return ; // todo: throw error here;
        var moduleInfo:IModuleInfo =  ModuleManager.getModule( url );
        moduleInfo.unload();
        unMap(url);
    }

    private function initiateModule(module:IModule):IModule {
        module.parentInjector =  injector;
        return module;
    }

    // todo: how to implement unload listners.
    private function addEventListeners(moduleInfo:IModuleInfo):void {
        moduleInfo.addEventListener( ModuleEvent.ERROR, onError);
        moduleInfo.addEventListener( ModuleEvent.PROGRESS, onProgress );
        moduleInfo.addEventListener( ModuleEvent.READY, onReady );
        moduleInfo.addEventListener( ModuleEvent.SETUP, onSetUp );
    }

    private function removeEventListeners(moduleInfo:IModuleInfo):void {
        moduleInfo.removeEventListener( ModuleEvent.ERROR, onError);
        moduleInfo.removeEventListener( ModuleEvent.PROGRESS, onProgress );
        moduleInfo.removeEventListener( ModuleEvent.READY, onReady );
        moduleInfo.removeEventListener( ModuleEvent.SETUP, onSetUp );
    }

    private function map(url:String):void {
        _urlMap.push( url )
    }

    private function hasMapping(url:String):Boolean {
        return Boolean( _urlMap.indexOf( url ) != -1 );
    }

    private function unMap(url:String):void {
        var index:int = _urlMap.indexOf(url);
        _urlMap.splice(index, 1);
    }

    private function onError( event:ModuleEvent):void {
        var moduleProxy:IModuleInfo = IModuleInfo( event.target );
        removeEventListeners( moduleProxy );
    }

    private function onProgress( event:ModuleEvent):void {
    }

    private function onReady( event:ModuleEvent):void {
        var moduleProxy:IModuleInfo = IModuleInfo( event.target );
        removeEventListeners( moduleProxy );
    }

    private function onSetUp( event:ModuleEvent):void {
    }



}
}