package scratch
{
    import com.adobe.crypto.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class OSSUploader extends Object
    {
        public var partSize:uint = 1.04858e+007;
        public var payload:ByteArray;
        public var tasks:Array;
        public var finishedTasks:Array;
        public var currentFileNameID:String;
        public var fileUUID:String;

        public function OSSUploader()
        {
            this.tasks = new Array();
            return;
        }// end function

        public function uploadFile(fileName:String, fileData:ByteArray, filePath:String = "tmp/recordings/", fileType:String = ".flv") : Boolean
        {
            this.fileUUID = fileName;
            var _loc_5:* = fileData.length / this.partSize + (fileData.length % this.partSize > 0 ? (1) : (0));
            this.currentFileNameID = filePath + fileName + fileType;
            this.payload = fileData;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                this.tasks.push(_loc_6 * this.partSize);
                _loc_6 = _loc_6 + 1;
            }
            this.finishedTasks = new Array();
            this.nextTask();
            return true;
        }// end function

        protected function clean() : void
        {
            this.payload = null;
            this.tasks = new Array();
            return;
        }// end function

        protected function nextTask() : void
        {
            var i:uint;
            var len:uint;
            var data:ByteArray;
            var request:URLRequest;
            var urlLoader:URLLoader;
            var md5:String;
            var me:OSSUploader;
            i;
            while (i < this.tasks.length)
            {
                
                var onError:* = function () : void
            {
                me.clean();
                //Scratch.app.notify("recUploadError", me.fileUUID);
                return;
            }// end function
            ;
                if (this.tasks[i] == -1)
                {
                }
                else
                {
                   // Scratch.app.notify("recUploadingProgress", {current:i, len:this.tasks.length});
                    len = this.partSize;
                    if (len + this.tasks[i] > this.payload.length)
                    {
                        len = this.payload.length - this.tasks[i];
                    }
                    data = new ByteArray();
                    data.writeBytes(this.payload, this.tasks[i], len);
                    request = new URLRequest();
                    request.url = "http://upload.jita.im/" + this.currentFileNameID + "?append&position=" + this.tasks[i].toString();
                    request.method = URLRequestMethod.POST;
                    request.requestHeaders = [new URLRequestHeader("X-HTTP-Method-Override", "POST"), new URLRequestHeader("Cache-Control", "no-cache")];
                    urlLoader = new URLLoader();
                    urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
                    request.data = data;
                    md5 = MD5.hashBytes(data);
                    me;
                    urlLoader.addEventListener("complete", function ()
            {
                me.tasks[i] = -1;
                me.nextTask();
                if (i == (tasks.length - 1))
                {
                    me.clean();
                    if (Scratch.app.stagePane.info && Scratch.app.stagePane.info.name)
                    {
                       // Scratch.app.notify("recUploaded", {fileUUID:me.fileUUID, title:Scratch.app.stagePane.info.name});
                    }
                    else
                    {
                        //Scratch.app.notify("recUploaded", {fileUUID:me.fileUUID, title:null});
                    }
                }
                return;
            }// end function
            );
                    urlLoader.addEventListener(ErrorEvent.ERROR, onError);
                    urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
                    urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
                    urlLoader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
                    urlLoader.load(request);
                    return;
                }
                i = (i + 1);
            }
            return;
        }// end function

        public function uploadOneFile(fileName:String, fileData:ByteArray, filePath:String = "tmp/tmpfiles/", fileType:String = ".flv", param5:String = "aFileUploaded") : void
        {
            var fileName:* = fileName;
            var content:* = fileData;
            var path:* = filePath;
            var fileType:* = fileType;
            var message:* = param5;
            var fileUUID:* = fileName;
            var request:* = new URLRequest();
            request.url = "http://upload.jita.im";
            request.method = URLRequestMethod.POST;
            request.contentType = "multipart/form-data; boundary=" + UploadPostHelper.getBoundary();
            request.data = UploadPostHelper.getPostData(fileUUID + fileType, content, {key:path + fileUUID + fileType});
            request.requestHeaders.push(new URLRequestHeader("x-oss-object-acl", "public-read-write"));
            request.requestHeaders.push(new URLRequestHeader("Cache-Control", "no-cache"));
            var urlLoader:* = new URLLoader();
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            var me:OSSUploader;
            urlLoader.addEventListener("complete", function ()
            {
                Scratch.app.notify(message, fileName);
                return;
            }// end function
            );
            urlLoader.load(request);
            return;
        }// end function

    }
}
