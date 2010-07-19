package org.robotlegs.utilities.modular.loaders {
import flash.display.Loader;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

import org.robotlegs.core.IInjector;
import org.robotlegs.mvcs.Actor;
import org.robotlegs.utilities.modular.core.IModule;
import org.robotlegs.utilities.modular.core.IModuleLoader;

public class SWFModuleLoader extends Actor implements IModuleLoader {

    [Inject]
    public var injector:IInjector;

    private var _urlMap:Array;
    private var _loaderMap:Array;

    public function getModule(url:String, domain:ApplicationDomain = null):Boolean {
        if (hasMapping(url)) return ( getLoader(url).content != null );
        else  var loader:Loader = new Loader();
        map(url, loader);
        addEventListeners(loader.contentLoaderInfo);
        loader.load(new URLRequest(url), new LoaderContext(false, domain));
        return false;
    }

    public function create(url:String):Object {
        if (!hasMapping(url)) return null; // todo: throw error here;
        var loader:Loader = getLoader(url);
        if (loader.content == null) return null; // todo: throw error here;
        var o:Object = loader.content;
        if (o is IModule)return initiateModule(IModule(o));
        return o;
    }

    public function unload(url:String):void {
        if (!hasMapping(url)) return; // todo: throw error here;
        var loader:Loader = getLoader(url);
        loader.unload();
        unMap(url);
    }

    private function initiateModule(module:IModule):IModule {
        module.parentInjector = injector;
        return module;
    }

    private function getLoader(url:String):Loader {
        var index:int = urlMap.indexOf(url);
        return Loader(_loaderMap[ index ]);
    }

    private function addEventListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatch);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onError);
        dispatcher.addEventListener(Event.COMPLETE, onComplete);
        dispatcher.addEventListener(ProgressEvent.PROGRESS, dispatch);


    }

    private function removeEventListeners(dispatcher:IEventDispatcher):void {
        dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatch);
        dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        dispatcher.removeEventListener(Event.COMPLETE, onComplete);
        dispatcher.removeEventListener(ProgressEvent.PROGRESS, dispatch);
    }



    private function map(url:String, loader:Loader):void {
        urlMap.push(url);
        loaderMap.push(loader);
    }

    private function hasMapping(url:String):Boolean {
        return Boolean(urlMap.indexOf(url) != -1);
    }

    private function unMap(url:String):void {
        var index:int = urlMap.indexOf(url);
        urlMap.splice(index, 1);
        loaderMap.splice(index, 1);
    }

    private function get urlMap():Array {
        if (_urlMap == null) _urlMap = [];
        return _urlMap;
    }

    private function get loaderMap():Array {
        if (_loaderMap == null) _loaderMap = [];
        return _loaderMap;
    }

    private function onError(event:Event):void {
        removeEventListeners( IEventDispatcher( event.target ) );
        dispatch(event);
    }

    private function onProgress(event:Event):void {
        dispatch(event);
    }

    private function onComplete(event:Event):void {
        removeEventListeners( IEventDispatcher( event.target ) );
        dispatch(event);
    }




}
}