package com.rainbowcreatures.swf
{
    import flash.display.*;
    import flash.display3D.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class FWVideoEncoder extends EventDispatcher
    {
        private var loader:Loader;
        private var parentMC:Sprite = null;
        private var encoderMc:MovieClip = null;
        private var myEncoder:Object = null;
        public var platform:String = "FLASH";
        private var fps:int = 0;
        private var recordAudio:String = "audioOff";
        private var realtime:Boolean = true;
        private var w:Number = 0;
        private var h:Number = 0;
        private var bitrate:int = 1000000;
        private var audio_sample_rate:int = 44100;
        private var audio_bit_rate:int = 64000;
        private var keyframe_freq:Number = 0;
        private var frameOffset:Point = null;
        private var SWFBridgeLoaded:Boolean = false;
        private var _SWFBridgePath:String = "";
        private var SWFBridgePreload:Boolean = false;
        public var domainMemoryPrealloc:int = 0;
        public static const LOGGING_BASIC:int = 0;
        public static const LOGGING_VERBOSE:int = 1;
        public static const FRAMEDROP_AUTO:int = 0;
        public static const FRAMEDROP_OFF:int = 1;
        public static const FRAMEDROP_ON:int = 2;
        public static const PTS_AUTO:int = 0;
        public static const PTS_MONO:int = 1;
        public static const PTS_REALTIME:int = 2;
        public static const AUDIO_MICROPHONE:String = "audioMicrophone";
        public static const AUDIO_MONO:String = "audioMono";
        public static const AUDIO_STEREO:String = "audioStereo";
        public static const AUDIO_OFF:String = "audioOff";
        public static const PLATFORM_IOS:String = "IOS";
        public static const PLATFORM_ANDROID:String = "ANDROID";
        public static const PLATFORM_WINDOWS:String = "WINDOWS";
        public static const PLATFORM_MAC:String = "MAC";
        public static const PLATFORM_FLASH:String = "FLASH";
        public static const PLATFORM_TYPE_MOBILE:String = "MOBILE";
        public static const PLATFORM_TYPE_DESKTOP:String = "DESKTOP";
        private static var instance:FWVideoEncoder = null;

        public function FWVideoEncoder(param1:Sprite) : void
        {
            this.parentMC = param1;
            return;
        }// end function

        public function configureRAMGuard(param1:Number = 2, param2:Number = 1.5) : void
        {
            this.myEncoder.configureRAMGuard(param1, param2);
            return;
        }// end function

        public function load(param1:String) : void
        {
            var path:* = param1;
            this.unload();
            this._SWFBridgePath = path;
            var request:* = new URLRequest(this._SWFBridgePath + "FW_SWFBridge_ffmpeg.swf?v=" + 24);
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onEncoderLoaded);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function () : void
            {
                throw new Error("[FlashyWrappers error] FW_SWFBridge_ffmpeg.swf couldn\'t be loaded! Please make sure it\'s in the same path as your main SWF or specify the path in the \'load\' method like this: myEncoder.load(\'path/to/FW_SWFBridge_ffmpeg/\')");
            }// end function
            );
            var loaderContext:* = new LoaderContext(false, new ApplicationDomain(null), null);
            this.loader.load(request, loaderContext);
            return;
        }// end function

        public function unload() : void
        {
            if (this.SWFBridgeLoaded)
            {
                this.encoderMc.parent.removeChild(this.encoderMc);
                this.encoderMc = null;
                this.loader.unload();
                System.gc();
                this.SWFBridgeLoaded = false;
            }
            return;
        }// end function

        private function onEncoderLoaded(event:Event) : void
        {
            var _loc_2:* = event.target as LoaderInfo;
            this.encoderMc = _loc_2.content as MovieClip;
            if (this.encoderMc)
            {
                trace("[FlashyWrappers] Got encoder class from FW_SWFBridge_ffmpeg");
                var _loc_3:* = this.encoderMc;
                this.myEncoder = _loc_3["getInstance"](this.parentMC, this.domainMemoryPrealloc);
                this.myEncoder.addEventListener(StatusEvent.STATUS, this.onStatus);
                this.SWFBridgeLoaded = true;
                dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "ready", ""));
            }
            else
            {
                throw new Error("[FlashyWrappers error] Couldn\'t find the encoder class in FW_SWFBridge_ffmpeg!");
            }
            return;
        }// end function

        private function onStatus(event:StatusEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function setFps(param1:int) : void
        {
            this.myEncoder.setFps(param1);
            return;
        }// end function

        public function setDimensions(param1:Number, param2:Number) : void
        {
            this.myEncoder.setDimensions(param1, param2);
            return;
        }// end function

        public function setAudioRealtime(param1:Boolean) : void
        {
            this.myEncoder.setAudioRealtime(param1);
            return;
        }// end function

        public function setLogging(param1:int) : void
        {
            this.myEncoder.setLogging(param1);
            return;
        }// end function

        public function askMicPermission() : void
        {
            this.myEncoder.askMicPermission();
            return;
        }// end function

        public function start(param1:int = 0, param2:String = "audioOff", param3:Boolean = true, param4:Number = 0, param5:Number = 0, param6:int = 1000000, param7:int = 44100, param8:int = 64000, param9:Number = 0, param10:Point = null) : void
        {
            this.myEncoder.start(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10);
            return;
        }// end function

        public function addVideoFrame(param1:ByteArray) : void
        {
            this.myEncoder.addVideoFrame(param1);
            return;
        }// end function

        public function addAudioFrame(param1:ByteArray) : void
        {
            this.myEncoder.addAudioFrame(param1);
            return;
        }// end function

        private function setTotalFrames(param1:int) : void
        {
            this.myEncoder.setTotalFrames(param1);
            return;
        }// end function

        public function setRecordAudio(param1:String) : void
        {
            this.myEncoder.setRecordAudio(param1);
            return;
        }// end function

        public function getEncodingProgress() : Number
        {
            return this.myEncoder.getEncodingProgress();
        }// end function

        public function finish() : void
        {
            this.myEncoder.finish();
            return;
        }// end function

        private function encodeItBase64() : void
        {
            this.myEncoder.encodeItBase64();
            return;
        }// end function

        public function capture(param1 = null) : void
        {
            this.myEncoder.capture(param1);
            return;
        }// end function

        public function iOS_captureFullscreen(param1:Boolean = false) : void
        {
            this.myEncoder.iOS_captureFullscreen();
            return;
        }// end function

        public function iOS_startAudioMix(param1:String, param2:Number) : void
        {
            this.myEncoder.iOS_startAudioMix(param1, param2);
            return;
        }// end function

        public function iOS_stopAudioMix(param1:String) : void
        {
            this.myEncoder.iOS_stopAudioMix(param1);
            return;
        }// end function

        public function iOS_saveToCameraRoll(param1:String = "") : void
        {
            this.myEncoder.iOS_saveToCameraRoll(param1);
            return;
        }// end function

        public function set stage3DWithMC(param1:Boolean) : void
        {
            this.myEncoder.stage3DWithMC = param1;
            return;
        }// end function

        public function get stage3DWithMC() : Boolean
        {
            return this.myEncoder.stage3DWithMC;
        }// end function

        public function set platform_type(param1:Boolean) : void
        {
            this.myEncoder.platform_type = param1;
            return;
        }// end function

        public function get platform_type() : Boolean
        {
            return this.myEncoder.platform_type;
        }// end function

        public function getVideo() : ByteArray
        {
            return this.myEncoder.getVideo();
        }// end function

        public function captureMC(param1:DisplayObject) : void
        {
            this.myEncoder.captureMC(param1);
            return;
        }// end function

        public function captureStage3D(param1:Context3D, param2:Boolean = true) : void
        {
            this.myEncoder.captureStage3D(param1, param2);
            return;
        }// end function

        public function addSoundtrack(param1:Sound) : void
        {
            this.myEncoder.addSoundtrack(param1);
            return;
        }// end function

        public function forcePTSMode(param1:int) : void
        {
            this.myEncoder.forcePTSMode(param1);
            return;
        }// end function

        public function forceFramedropMode(param1:int) : void
        {
            this.myEncoder.forceFramedropMode(param1);
            return;
        }// end function

        public function dispose() : void
        {
            this.myEncoder.dispose();
            return;
        }// end function

        public static function getInstance(param1:Sprite = null, param2:Number = 0) : FWVideoEncoder
        {
            if (instance == null)
            {
                instance = new FWVideoEncoder(param1);
                instance.domainMemoryPrealloc = param2;
            }
            return instance;
        }// end function

    }
}
