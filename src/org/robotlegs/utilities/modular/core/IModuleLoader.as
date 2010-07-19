package org.robotlegs.utilities.modular.core {
import flash.system.ApplicationDomain;

public interface IModuleLoader {


    function getModule(url:String, domain:ApplicationDomain = null):Boolean;

    function create(url:String):Object;

    function unload(url:String):void;
}
}