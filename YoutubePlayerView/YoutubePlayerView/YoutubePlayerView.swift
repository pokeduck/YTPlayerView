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

struct YoutubePlayerConfiguration {
    enum Color {
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
        .init(isAutoplay: false, color: .white, isControlPannelHidden: true, startSeconds: nil, endSeconds: nil, isFullscreenButtonHidden: true, isAnnotationHidden: true, isEnableLoop: false, isBrandLogoHidden: true, isPlayInFullscreen: false, isRelationVideosHidden: true)
    }
}

protocol YoutubePlayerViewDelegate: AnyObject {
    func youtubePlayer(_ view: YoutubePlayerView, didUpdateProgress: Float)
}

class YoutubePlayerView: UIView {
    enum JSCommand: String {
        case play = "playVideoFromNative()"
        case pause = "pauseVideoFromNative()"
        case stop = "stopVideoFromNative()"
        case duration = "durationFromNative()"
        case currentTime = "currentTimeFromNative()"
    }

    enum JSCallBack {
        static let unstarted = "JS_TO_NATIVE_UNSTARTED"
        static let playing = "JS_TO_NATIVE_PLAYING"
        static let cued = "JS_TO_NATIVE_CUED"
        static let buffering = "JS_TO_NATIVE_BUFFERING"
        static let end = "JS_TO_NATIVE_END"
        static let progress = "JS_TO_NATIVE_PROGRESS"
    }

    private var webView: WKWebView?
    weak var delegate: YoutubePlayerViewDelegate?
    private func createWebView() -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = false
        config.userContentController.addUserScript(createConsoleInjectJS())
        config.userContentController.add(self, name: "log")
        config.userContentController.add(self, name: "JS_TO_NATIVE_PROGRESS")
        let webView = WKWebView(frame: frame, configuration: config)
        webView.backgroundColor = .lightGray
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = self
        webView.uiDelegate = self

        return webView
    }

    func loadYoutube(videoId: String) {
        webView?.removeFromSuperview()
        webView = createWebView()
        addSubview(webView!)
        webView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        webView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        webView?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        webView?.loadHTMLString(videoId.buildYTHtml(with: bounds.size), baseURL: nil)
    }

    private func createConsoleInjectJS() -> WKUserScript {
        let jsScript = """
        console.log = (function(originalLogFunc) {
           return function(string) {
               originalLogFunc.call(console,string);
               window.webkit.messageHandlers.log.postMessage(string);
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

    func duration(result: (Float) -> Void) {
        evaluateJSForFloat(command: .duration) { result, error in
            print(result)
            print(error ?? "no error")
        }
    }

    func currentTime(result: (Float) -> Void) {
        evaluateJSForFloat(command: .currentTime) { result, error in
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
}

extension YoutubePlayerView: WKNavigationDelegate {}

extension YoutubePlayerView: WKUIDelegate {}

extension YoutubePlayerView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "log":
            // print(message.body)
            break
        case JSCallBack.progress:
            let progress = (message.body as? NSNumber)?.floatValue ?? 0.0
            delegate?.youtubePlayer(self, didUpdateProgress: progress)
            print("progress:\(progress)")
        case JSCallBack.buffering:
            print("buffering")
        case JSCallBack.end:
            print("end")
        case JSCallBack.playing:
            print("playing")
        case JSCallBack.unstarted:
            print("unstarted")
        case JSCallBack.cued:
            print("cued")
        default:
            print("Error!")
            print(message.name)
            print(message.body)
        }
    }
}
