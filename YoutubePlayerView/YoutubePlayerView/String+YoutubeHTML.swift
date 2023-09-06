//
//  String+YoutubeHTML.swift
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

import Foundation
extension String {
    func buildYTHtml(with size: CGSize, vars: String) -> String {
        let ytHtml =
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
              videoId: '\(self)',
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
        return ytHtml
    }
}
