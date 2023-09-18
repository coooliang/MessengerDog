(function (window) {
  var runtime = (function () {
    return {
      createFrame: function (url) {
        var iframe = document.createElement('iframe');
        iframe.style.display = 'none';
        iframe.src = url;
        document.body.appendChild(iframe);

        setTimeout(function () {
          iframe.parentNode.removeChild(iframe);
          iframe = null;
        }, 0);
      },
      callFunctionMessage: function (url) {
        if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.yypt && window.webkit.messageHandlers.yypt.postMessage) {
          window.webkit.messageHandlers.yypt.postMessage(url);
        } else {
          runtime.createFrame(url);
        }
      }
    }
  }());

  window.yyptJs2native = (function () {
    var uniqueId = 1;       // 回调方法唯一id
    var callbackCache = {}; // 回调方法容器
    return {
      exec:
        function (className, methodName, params) {
          params = params || {};
          var callback = params['success'] || params['fail'] ? {
            success: params['success'],
            fail: params['fail']
          } :
            null;
          delete params['success'];
          delete params['fail'];
          var time = new Date().getTime();
          var callbackId = ['cid', className, methodName, uniqueId++, time].join('_');
          if (callback) {
            callbackCache[callbackId] = callback;
          }
          var jsonString = "{}";
          if (params.message) {
            jsonString = JSON.stringify(params.message);
          }
          var url = "https://www.yypt.com/callfunction/callbackId=" + callbackId + "&className=" + className + "&method=" + methodName + "&param=" + encodeURIComponent(jsonString) + "&tt=" + time;
          runtime.callFunctionMessage(url);
        },
      callbackFromNative: function (result) {
        if (result) {
          var callback = callbackCache[result.callbackId];
          if (callback) {
            var message = result.message;
            if (result.callbackType == 1 && callback.success) {
              callback.success(message);
            } else if (result.callbackType == 0 && callback.fail) {
              callback.fail(message);
            }
            if (result.isFinish) {
              delete callbackCache[result.callbackId];
            }
          }
        }
      }
    }
  }());
})(window);

if(!window.yyptPlugins){window.yyptPlugins={};};
window.yyptPlugins.infoPlugin = {};
window.yyptPlugins.infoPlugin.world = function(params){ window.yyptJs2native.exec("InfoPlugin", "world", params); };
window.yyptPlugins.infoPlugin.keyboard = function(params){ window.yyptJs2native.exec("InfoPlugin", "keyboard", params); };
window.yyptPlugins.infoPlugin.privateMethod3 = function(params){ window.yyptJs2native.exec("InfoPlugin", "privateMethod3", params); };
window.yyptPlugins.infoPlugin.hello = function(params){ window.yyptJs2native.exec("InfoPlugin", "hello", params); };
window.yyptPlugins.urlPlugin = {};
window.yyptPlugins.urlPlugin.nextStepJson = function(params){ window.yyptJs2native.exec("UrlPlugin", "nextStepJson", params); }; 