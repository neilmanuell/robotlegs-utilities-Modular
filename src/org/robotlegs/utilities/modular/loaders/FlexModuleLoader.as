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
    private var _moduleMap:Array;

    public function getModule(url:String, domain:ApplicationDomain = null):Boolean {
        var moduleInfo:IModuleInfo = getModuleInfo(url);
        if (hasMapping(url)) return moduleInfo.ready;
        map(url, moduleInfo);
        addEventListeners(moduleInfo);
        moduleInfo.load(domain);
        return false;
    }

    public function create(url:String):Object {
        if (!hasMapping(url)) return null; // todo: throw error here;
        var moduleInfo:IModuleInfo = getModuleInfo(url);
        if (!moduleInfo.ready) return null; // todo: throw error here;
        var o:Object = moduleInfo.factory.create();
        if (o is IModule)return initiateModule(IModule(o));
        return o;
    }

    public function unload(url:String):void {
        if (!hasMapping(url)) return; // todo: throw error here;
        var moduleInfo:IModuleInfo = getModuleInfo(url);
        moduleInfo.unload();
        unMap(url);
    }

    private function initiateModule(module:IModule):IModule {
        module.parentInjector = injector;
        return module;
    }

    private function getModuleInfo(url:String):IModuleInfo {
        return ModuleManager.getModule(url);
    }

    // todo: how to implement unload listners.
    private function addEventListeners(moduleInfo:IModuleInfo):void {
        moduleInfo.addEventListener(ModuleEvent.ERROR, onError);
        moduleInfo.addEventListener(ModuleEvent.PROGRESS, onProgress);
        moduleInfo.addEventListener(ModuleEvent.READY, onReady);
        moduleInfo.addEventListener(ModuleEvent.SETUP, onSetUp);
    }

    private function removeEventListeners(moduleInfo:IModuleInfo):void {
        moduleInfo.removeEventListener(ModuleEvent.ERROR, onError);
        moduleInfo.removeEventListener(ModuleEvent.PROGRESS, onProgress);
        moduleInfo.removeEventListener(ModuleEvent.READY, onReady);
        moduleInfo.removeEventListener(ModuleEvent.SETUP, onSetUp);
    }

    private function map(url:String, moduleInfo:IModuleInfo):void {
        urlMap.push(url);
        moduleMap.push(moduleInfo);
    }

    private function hasMapping(url:String):Boolean {
        return Boolean(urlMap.indexOf(url) != -1);
    }

    private function unMap(url:String):void {
        var index:int = urlMap.indexOf(url);
        urlMap.splice(index, 1);
        moduleMap.splice(index, 1);
    }

    private function get urlMap():Array {
        if (_urlMap == null) _urlMap = [];
        return _urlMap;
    }

    private function get moduleMap():Array {
        if (_moduleMap == null) _moduleMap = [];
        return _moduleMap;
    }

    private function onError(event:ModuleEvent):void {
        var moduleProxy:IModuleInfo = IModuleInfo(event.target);
        removeEventListeners(moduleProxy);
        dispatch(event);
    }

    private function onProgress(event:ModuleEvent):void {
        dispatch(event);
    }

    private function onReady(event:ModuleEvent):void {
        var moduleProxy:IModuleInfo = IModuleInfo(event.target);
        removeEventListeners(moduleProxy);
        dispatch(event);
    }

    private function onSetUp(event:ModuleEvent):void {
        dispatch(event);
    }


}
}