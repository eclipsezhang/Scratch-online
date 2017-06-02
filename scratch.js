
      window.SWFready=$.Deferred(); // Deferred makes sure we don't call ASSetEditMode before SWF is ready.
      function JSeditorReady() {
        try {
          SWFready.resolve();
          return true;
        } catch (error) {
          console.error(error.message, "\n", error.stack);
          throw error;
        }
      }

//      function changeProjectTitle(e){
//          console.info(e);
//
//      }
      /*function notify(e){
        console.info(e);
      }
      function beep(e){
        console.info(e);
      }*/

      function handleEmbedStatus(e) {
        $('#scratch-loader').hide();
        if(!e.success) {
          $('#scratch').css('marginTop', '10');
          $('#scratch IMG.proj_thumb').css('width', '179px');
          $('#scratch DIV.scratch_unsupported').show();
          $('#scratch DIV.scratch_loading').hide();
        }else{
          $('#scratch').css('visibility', 'visible');
        }
      }

      // The flashvars tell flash about the project data (and autostart=true)
      var flashvars = {
        autostart: 'false',
        cloudToken: '00000000-0000-0000-0000-000000000000',
        cdnToken: '-',
        challengeMode: 'false',
        urlOverrides: {
          sitePrefix: window.location.protocol + '//' + window.location.host + '/',
          siteCdnPrefix: "https://zhishi.oss-cn-beijing.aliyuncs.com/",
          assetPrefix: "https://zhishi.oss-cn-beijing.aliyuncs.com/",
          assetCdnPrefix: "https://zhishi.oss-cn-beijing.aliyuncs.com/",
          projectPrefix: "https://zhishi.oss-cn-beijing.aliyuncs.com/",
          projectCdnPrefix: "https://zhishi.oss-cn-beijing.aliyuncs.com/",
          internalAPI: "internalapi/",
          siteAPI: "site-api/",
          staticFiles: "scratchr2/static/"
        },

        inIE: (navigator.userAgent.indexOf('MSIE') > -1),
        showOnly:'false',
        userID:"590b1bd95f94a60e6566524c",
        userName:"Elmo"
      };

      $.each(flashvars, function(prop, val) {
        if($.isPlainObject(val))
          flashvars[prop] = encodeURIComponent(JSON.stringify(val));
      });

      /*$.each(Scratch.INIT_DATA.PROJECT.model, function(i, val) {
        if(val != null)
          flashvars['project_'+i] = encodeURIComponent(val);
      });

      if(Scratch.INIT_DATA.PROJECT.is_new)
        flashvars.project_isNew = true;
       */
      var params = {
        allowscriptaccess: 'always',
        allowfullscreen: 'true',
        wmode: 'opaque',
        menu: 'false'
      };

      // url format flashvars for createSWF call (see
      // https://github.com/LLK/scratchr2/blob/f42c289a5fa890d9c5562cc1fa54b0aea3dfa45e/static/js/swfobject.js#L673-L682)
      for (var i in flashvars) {
        if (typeof params.flashvars !== 'undefined') {
          params.flashvars += '&' + i + '=' +flashvars[i];
        } else {
          params.flashvars = i + '=' + flashvars[i];
        }
      }

      var swfFile = (swfobject.hasFlashPlayerVersion('11.7.0') ? 'Scratch.swf' : 'ScratchFor10.2.swf');

      var swfAtt = {
        data: "https://zhishi.oss-cn-beijing.aliyuncs.com/scratch/Scratch.swf",
        width: "100%",
        height: "100%"
      };

      swfobject.addDomLoadEvent(function() {
        // check if mobile/tablet browser user bowser
        //if(bowser.mobile || (bowser.tablet && typeof bowser.msie === 'undefined')) {
        // if on mobile, show error screen
        //    handleEmbedStatus({success: false});
        //} else {
        // if not on ie, let browser try to handle flash loading
        var swf = swfobject.createSWF(swfAtt, params, "scratch");
        handleEmbedStatus({success: true, ref: swf});
        //}
        document.getElementById('scratch').style.visibility = 'visible';
      });

      //Dynamically add iframe for registration window
      $.when(window.SWFready).done(function() {$('<iframe id="registration-iframe" class="iframeshim" style="background:#fff;z-index:-1;" frameborder="0" scrolling="no">').insertBefore('#registration')});

      // enables the SWF to log errors
      function JSthrowError(e) {
        if (window.onerror) window.onerror(e, 'swf', 0);
        else console.error(e);
      }
    