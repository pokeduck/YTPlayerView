//
//  YoutubePlayerView.swift
//
//  Created by pokeduck on 2023/5/30.
//
//  Copyright © 2023 pokeduck. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import WebKit

extension Bool {
    var intValue: UInt {
        self ? 1 : 0
    }
}

struct YoutubePlayerConfiguration {
    init(isAutoplay: Bool, color: YoutubePlayerConfiguration.Color, isControlPannelHidden: Bool, startSeconds: UInt? = nil, endSeconds: UInt? = nil, isFullscreenButtonHidden: Bool, isAnnotationHidden: Bool, isEnableLoop: Bool, isBrandLogoHidden: Bool, isPlayInFullscreen: Bool, isRelationVideosHidden: Bool) {
        self.isAutoplay = isAutoplay
        self.color = color
        self.isControlPannelHidden = isControlPannelHidden
        self.startSeconds = startSeconds
        self.endSeconds = endSeconds
        self.isFullscreenButtonHidden = isFullscreenButtonHidden
        self.isAnnotationHidden = isAnnotationHidden
        self.isEnableLoop = isEnableLoop
        self.isBrandLogoHidden = isBrandLogoHidden
        self.isPlayInFullscreen = isPlayInFullscreen
        self.isRelationVideosHidden = isRelationVideosHidden
    }
    
    enum Color: String {
        case white
        case red
    }

    let isAutoplay: Bool // autoplay
    let color: Color // color
    let isControlPannelHidden: Bool // controls
    // let isDisableKeyboard: Bool disablekb
    // let isEnableJsAPI: Bool  enablejsapi
    let startSeconds: UInt? // start
    let endSeconds: UInt? // end
    let isFullscreenButtonHidden: Bool // fs
    let isAnnotationHidden: Bool // iv_load_policy
    let isEnableLoop: Bool // loop
    let isBrandLogoHidden: Bool // modestbranding
    let isPlayInFullscreen: Bool // playsinline
    let isRelationVideosHidden: Bool // rel

    static func `default`() -> Self {
        .init(
            isAutoplay: true,
            color: .white,
            isControlPannelHidden: true,
            startSeconds: nil,
            endSeconds: nil,
            isFullscreenButtonHidden: true,
            isAnnotationHidden: true,
            isEnableLoop: false,
            isBrandLogoHidden: true,
            isPlayInFullscreen: true,
            isRelationVideosHidden: true
        )
    }
    
    var json: String {
        let model = JSVarModel.init(config: self)
        return model.jsonString
    }
    
    fileprivate struct JSVarModel:Codable {

        let autoplay: UInt?
        let ccLangPref:String?
        let ccLoadPolicy: UInt?
        let color: String?
        let controls: UInt?
        let disablekb: UInt?
        let enablejsapai:UInt?
        let end: UInt?
        let fs: UInt?
        ///Interface language, The value is an ISO 639-1 two-letter language code or a fully specified locale. For example, fr and fr-ca are both valid values.
        let hl: String?
        let ivLoadPolicy: UInt?
        let loop: UInt?
        let origin: UInt?
        let playlist: String?
        let playsinline: UInt?
        let rel: UInt?
        let start: UInt?
        
        enum CodingKeys: String, CodingKey {
            case autoplay
            case ccLangPref = "cc_lang_pref"
            case ccLoadPolicy = "cc_load_policy"
            case color
            case controls
            case disablekb
            case enablejsapai
            case end
            case fs
            ///Interface language, The value is an ISO 639-1 two-letter language code or a fully specified locale. For example, fr and fr-ca are both valid values.
            case hl
            case ivLoadPolicy = "iv_load_policy"
            case loop
            case origin
            case playlist
            case playsinline
            case rel
            case start
        }
        
        init(config c: YoutubePlayerConfiguration) {
            self.autoplay = c.isAutoplay.intValue
            self.ccLangPref = "en"
            self.ccLoadPolicy = nil
            self.color = c.color.rawValue
            self.controls = c.isControlPannelHidden ? 0 : 1
            self.disablekb = 1
            self.enablejsapai = 0
            self.end = c.endSeconds
            self.fs = c.isFullscreenButtonHidden ? 0 : 1
            self.hl = "en"
            self.ivLoadPolicy = c.isAnnotationHidden ? 3 : 1
            self.loop = c.isEnableLoop.intValue
            self.origin = nil
            self.playlist = nil
            self.playsinline = c.isPlayInFullscreen ? 0 : 1
            self.rel = c.isRelationVideosHidden ? 0 : 1
            self.start = c.startSeconds
        }
        
        init(autoplay: UInt? = nil, ccLangPref: String? = nil, ccLoadPolicy: UInt? = nil, color: String? = nil, controls: UInt? = nil, disablekb: UInt? = nil, enablejsapai: UInt? = nil, end: UInt? = nil, fs: UInt? = nil, hl: String? = nil, ivLoadPolicy: UInt? = nil, loop: UInt? = nil, origin: UInt? = nil, playlist: String? = nil, playsinline: UInt? = nil, rel: UInt? = nil, start: UInt? = nil) {
            self.autoplay = autoplay
            self.ccLangPref = ccLangPref
            self.ccLoadPolicy = ccLoadPolicy
            self.color = color
            self.controls = controls
            self.disablekb = disablekb
            self.enablejsapai = enablejsapai
            self.end = end
            self.fs = fs
            self.hl = hl
            self.ivLoadPolicy = ivLoadPolicy
            self.loop = loop
            self.origin = origin
            self.playlist = playlist
            self.playsinline = playsinline
            self.rel = rel
            self.start = start
        }
        
        var jsonString: String {
            let jsonEncoder = JSONEncoder()
            if let jsonData = try? jsonEncoder.encode(self),
               let jsonStr = String(data: jsonData, encoding: .utf8) {
                return jsonStr
            } else {
                return "{}"
            }
        }
    }
}

protocol YoutubePlayerViewDelegate: AnyObject {
    func youtubePlayer(_ playerView: YoutubePlayerView,didUpdate current: Float, duration: Float)
    func youtubePlayer(_ playerView: YoutubePlayerView, didUpdateState state: YoutubePlayerView.State)
}

class YoutubePlayerView: UIView {
    fileprivate enum JSCommand: String {
        case play = "playVideoFromNative()"
        case pause = "pauseVideoFromNative()"
        case stop = "stopVideoFromNative()"
        case duration = "durationFromNative()"
        case currentTime = "currentTimeFromNative()"
    }

    fileprivate enum JSCallBackEventName {
        static let unstarted = "unstarted"
        static let playing = "playing"
        static let cued = "cued"
        static let buffering = "buffering"
        static let ended = "ended"
        static let pause = "paused"
        static let progress = "progress"
        static let log = "log"
        static let ready = "ready"
    }
    fileprivate enum JSCallBackPayloadKey {
        static let payload = "payload"
        static let durationTime = "duration"
        static let currentTime = "current"
    }
    
    enum State: String {
        case empty
        case ready
        case unstarted
        case playing
        case paused
        case stopped
        case buffering
    }
    
    private(set) var videoState = YoutubePlayerView.State.empty
    
    let JSBridgeKey = "JS_TO_NATIVE_BRIDGE"
    let overridingConsoleLogName = "log"
    private var webView: WKWebView?
    weak var delegate: YoutubePlayerViewDelegate?
    private func createWebView() -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = false
        config.userContentController.addUserScript(createConsoleInjectJS())
        config.userContentController.add(self, name: overridingConsoleLogName)
        config.userContentController.add(self, name: JSBridgeKey)
        let webView = WKWebView(frame: frame, configuration: config)
        webView.backgroundColor = .lightGray
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = self
        webView.uiDelegate = self

        return webView
    }

    func loadYoutube(videoId: String,config: YoutubePlayerConfiguration) {
        webView?.removeFromSuperview()
        webView = createWebView()
        addSubview(webView!)
        webView?.frame = bounds
        webView?.loadHTMLString(buildYTHtml(with: videoId, size: bounds.size, vars: config.json), baseURL: nil)
    }
    

    private func createConsoleInjectJS() -> WKUserScript {
        let jsScript = """
        console.log = (function(originalLogFunc) {
           return function(string) {
               originalLogFunc.call(console,string);
               window.webkit.messageHandlers.\(JSBridgeKey).postMessage({event:'\(JSCallBackEventName.log)',payload:{log:string}});
           }
        })(console.log);
        """
        let script = WKUserScript(source: jsScript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
        return script
    }

    func play() {
        evaluateJSForBool(command: .play) { result, error in
            print(result)
            print(error ?? "no error")
        }
    }

    func pause() {
        evaluateJSForBool(command: .pause) { result, error in
            print(result)
            print(error ?? "no error")
        }
    }

    func stop() {
        evaluateJSForBool(command: .stop) { result, error in
            print(result)
            print(error ?? "no error")
        }
    }

    func duration(resultHandler : @escaping (Float) -> Void) {
        evaluateJSForFloat(command: .duration) { result, error in
            resultHandler(result)
            print(result)
            print(error ?? "no error")
        }
    }

    func currentTime(resultHandler: @escaping (Float) -> Void) {
        evaluateJSForFloat(command: .currentTime) { result, error in
            resultHandler(result)
            print(result)
            print(error ?? "no error")
        }
    }

    private func evaluateJSForBool(command: JSCommand, completeHandler: ((_ result: Bool, _ error: Error?) -> Void)?) {
        webView?.evaluateJavaScript(command.rawValue, completionHandler: { obj, error in
            let result = obj as? Bool ?? false
            completeHandler?(result, error)
        })
    }

    private func evaluateJSForFloat(command: JSCommand, completeHandler: ((_ result: Float, _ error: Error?) -> Void)?) {
        webView?.evaluateJavaScript(command.rawValue, completionHandler: { obj, error in
            let result = obj as? NSNumber ?? 0.0
            completeHandler?(result.floatValue, error)
        })
    }
    private func dumpProgerssFrom(payload: [String:Any]) -> (current: Float?, duration: Float?){
        if let payload = payload[JSCallBackPayloadKey.payload] as? [String: Any] {
            if let duration = payload[JSCallBackPayloadKey.durationTime] as? NSNumber,
               let current = payload[JSCallBackPayloadKey.currentTime] as? NSNumber {
                return (current.floatValue,duration.floatValue)
            } else {
                return (nil,nil)
            }
        } else {
            return (nil,nil)
        }
    }
    
    private func updateProgressFrom(payload:[String:Any]) {
        let progress = dumpProgerssFrom(payload: payload)
        if let c = progress.current,
           let d = progress.duration {
            delegate?.youtubePlayer(self, didUpdate: c, duration: d)
        }
    }
}

extension YoutubePlayerView: WKNavigationDelegate {}

extension YoutubePlayerView: WKUIDelegate {}

extension YoutubePlayerView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let callbackDictionary = message.body as? [String:Any],
            let eventName = callbackDictionary["event"] as? String
        else {
            print("unknown event:,\(message.name)\n body:\(message.body)")
            return
        }
        switch eventName {
        case JSCallBackEventName.log:
            //print("[Log from JS]")
            //print(((callbackDictionary["payload"] as? [String: Any])?["log"] as? String) ?? "no log!")
            break
        case JSCallBackEventName.ready:
            videoState = .ready
            delegate?.youtubePlayer(self, didUpdateState: videoState)
        case JSCallBackEventName.progress:
            updateProgressFrom(payload: callbackDictionary)
        case JSCallBackEventName.buffering:
            videoState = .ready
            delegate?.youtubePlayer(self, didUpdateState: .buffering)
        case JSCallBackEventName.ended:
            
            videoState = .stopped
            delegate?.youtubePlayer(self, didUpdateState: videoState)
            updateProgressFrom(payload: callbackDictionary)
        case JSCallBackEventName.playing:
            
            videoState = .playing
            delegate?.youtubePlayer(self, didUpdateState: videoState)
        case JSCallBackEventName.unstarted:
            
            videoState = .stopped
            delegate?.youtubePlayer(self, didUpdateState: videoState)
        case JSCallBackEventName.cued:
            
            videoState = .stopped
            delegate?.youtubePlayer(self, didUpdateState: videoState)
        case JSCallBackEventName.pause:
            
            videoState = .paused
            delegate?.youtubePlayer(self, didUpdateState: videoState)
        default:
            print("Error!")
            print(message.name)
            print(message.body)
        }
    }
}

extension YoutubePlayerView {
    fileprivate func buildYTHtml(with videoId: String, size: CGSize, vars: String) -> String {
        let htmlString =
"""
<!DOCTYPE html>
<html>
  <style type="text/css">
    html,
    body {
      margin: 0;
      padding: 0;
    }
  </style>
  <meta
    name="viewport"
    content="width=device-width, initial-scale=1.0, user-scalable=no, maximum-scale=1, shrink-to-fit=no"
  />

  <body>
    <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
    <div id="player"></div>

    <script>
      console.log('start');
      // 2. This code loads the IFrame Player API code asynchronously.
      let tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      let firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates an <iframe> (and YouTube player)
      //    after the API code downloads.
      let player;
      let videoTime = 0.0;
      let durationTime = 0.0;
      function onYouTubeIframeAPIReady() {

          player = new YT.Player('player', {
              height: '\(size.height)',
              width: '\(size.width)',
              videoId: '\(videoId)',
              playerVars: \(vars),
              events: {
                  'onReady': onPlayerReady,
                  'onStateChange': onPlayerStateChange,
              }
          });

      }

      // 4. The API will call this function when the video player is ready.
      function onPlayerReady(event) {
          event.target.mute();
          sendMessageToNative('ready');
          durationTime = player.getDuration();
          //  event.target.playVideo();

      }


      // when the time changes, this will be called.
      function onProgress(currentTime) {
        sendMessageToNative('progress',{current: currentTime, duration: durationTime})
      }
      // 5. The API calls this function when the player's state changes.
      //    The function indicates that when playing a video (state=1),
      //    the player should play for six seconds and then stop.
      let done = false;
      let timerId;
      function onPlayerStateChange(event) {
          switch (event.data) {
              case -1:
                  console.log('[JS_LOG]unstarted');
                  sendMessageToNative('unstarted');
                  break;
              case 0:
                  console.log('[JS_LOG]ended');
                  clearTimer();
                  videoTime = player.getCurrentTime();
                  sendMessageToNative('ended',{current: videoTime, duration: durationTime});
                  break;
              case 1:
                  console.log('[JS_LOG]playing');
                  sendMessageToNative('playing');

                  clearTimer();
                  updateTime();
                  timerId = setInterval(updateTime, 100);
                  break;
              case 2:
                  console.log('[JS_LOG]paused');
                  clearTimer();
                  sendMessageToNative('paused');
                  break;
              case 3:
                  console.log('[JS_LOG]buffering');
                  sendMessageToNative('buffering');
                  ({event:"buffering"});
                  const duration = player.getDuration();
                  console.log(`[JS_LOG]${duration}`);

                  break;
              case 5:
                  console.log('[JS_LOG]video cued');
                  window.webkit.messageHandlers.JS_TO_NATIVE_CUED.postMessage({event:"paused"});
                  break;
          }
      }
      function updateTime() {

          var oldTime = videoTime;
          if (player && player.getCurrentTime) {
              videoTime = player.getCurrentTime();
              console.log(`[JS_LOG]VideoTime:${videoTime}`);
          }
          if (videoTime !== oldTime) {
              onProgress(videoTime);
          }
      }
      function clearTimer() {
          if (timerId) {
              clearInterval(timerId);
          }
      }
      function unmuteVideo() {
          //player.target.unMute();
          console.log(`[JS_LOG]${unmute}`);
      }
      function playVideoFromNative() {
          player.playVideo();
          return true;
      }
      function pauseVideoFromNative() {
          player.pauseVideo();
          return true;
      }
      function stopVideoFromNative() {
          player.stopVideo();
          clearTimer();
          videoTime = 0;
          return true;
      }

      function currentTimeFromNative() {
          var currentTime = player.getCurrentTime();

          if (currentTime) {

              return currentTime;
          } else {
              return 0.0;
          }
      }
      function durationFromNative() {
          var duration = durationTime;

          if (duration) {
              return duration;
          } else {
              return 0.0;
          }

      }

      function sendMessageToNative(eventName,payload) {
        window.webkit.messageHandlers.JS_TO_NATIVE_BRIDGE.postMessage({
          event:eventName,
          payload: payload
        });
      }
    </script>
  </body>
</html>

"""
        return htmlString
    }
}
