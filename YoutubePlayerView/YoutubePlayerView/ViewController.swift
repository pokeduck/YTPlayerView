//
//  ViewController.swift
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

class ViewController: UIViewController {
    private lazy var playerView = YoutubePlayerView()
    
    private lazy var videoIdTextField: UITextField = {
        let t = UITextField()
        t.placeholder = "video id"
        t.text = "a3ICNMQW7Ok"
        t.borderStyle = .roundedRect
        t.textAlignment = .center
        return t
    }()
    
    private lazy var durationLabel: UILabel = {
        let l = UILabel()
        l.text = "0"
        l.textAlignment = .center
        return l
    }()
    
    private lazy var currentLabel: UILabel = {
        let l = UILabel()
        l.text = "0"
        l.textAlignment = .center
        return l
    }()
    
    private lazy var stateLabel: UILabel = {
        let l = UILabel()
        l.text = "not working"
        l.textAlignment = .center
        return l
    }()
    
    
    private lazy var reloadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("RELOAD", for: .normal)
        btn.addTarget(self, action: #selector(reloadHandler), for: .touchUpInside)
        return btn
    }()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("PLAY", for: .normal)
        btn.addTarget(self, action: #selector(playHandler), for: .touchUpInside)
        return btn
    }()

    private lazy var pauseButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("PAUSE", for: .normal)
        btn.addTarget(self, action: #selector(pauseHandler), for: .touchUpInside)
        return btn
    }()

    private lazy var stopButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("STOP", for: .normal)
        btn.addTarget(self, action: #selector(stopHandler), for: .touchUpInside)
        return btn
    }()

    private lazy var durationButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("DURATION", for: .normal)
        btn.addTarget(self, action: #selector(durationHandler), for: .touchUpInside)
        return btn
    }()

    private lazy var currentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("CURRENT", for: .normal)
        btn.addTarget(self, action: #selector(currentHandler), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        playerView.frame = .init(x: 20, y: 40, width: 300, height: 300)
        view.addSubview(playerView)
        playerView.backgroundColor = .green
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        playerView.widthAnchor.constraint(equalTo: playerView.heightAnchor, multiplier: 16.0/9.0).isActive = true
        let pannelView = UIStackView()
        pannelView.axis = .vertical
        pannelView.spacing = 20
        pannelView.alignment = .fill
        pannelView.distribution = .equalSpacing
        view.addSubview(pannelView)
        pannelView.translatesAutoresizingMaskIntoConstraints = false
        //pannelView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        pannelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pannelView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 20).isActive = true
        pannelView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pannelView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        pannelView.addArrangedSubview(videoIdTextField)
        pannelView.addArrangedSubview(currentLabel)
        pannelView.addArrangedSubview(durationLabel)
        pannelView.addArrangedSubview(stateLabel)
        pannelView.addArrangedSubview(reloadButton)
        pannelView.addArrangedSubview(playButton)
        pannelView.addArrangedSubview(pauseButton)
        pannelView.addArrangedSubview(stopButton)
        pannelView.addArrangedSubview(durationButton)
        pannelView.addArrangedSubview(currentButton)
        
        let config = YoutubePlayerConfiguration.default()
        print(config.json)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadHandler()
    }

    
    @objc func reloadHandler() {
        playerView.loadYoutube(videoId: videoIdTextField.text ?? "",config: SettingStorage.shared.currentConfig())
    }
    
    
    
    @objc func playHandler() {
        playerView.play()
    }

    @objc func pauseHandler() {
        playerView.pause()
    }

    @objc func stopHandler() {
        playerView.stop()
    }

    @objc func durationHandler() {
        playerView.duration { [weak self] value in
            self?.durationLabel.text = "\(value)"
        }
    }

    @objc func currentHandler() {
        playerView.currentTime { [weak self] value in
            self?.currentLabel.text = "\(value)"
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        [.portrait]
    }
}

extension ViewController: YoutubePlayerViewDelegate {
    
    
    
    func youtubePlayer(_ playerView: YoutubePlayerView, didUpdate current: Float, duration: Float) {
        currentLabel.text = "\(current)"
        let progress = current / duration
        print(progress)
    }
    
    func youtubePlayer(_ playerView: YoutubePlayerView, didUpdateState state: YoutubePlayerView.State) {
        if state == .ready {
            playerView.duration { [weak self] duration in
                self?.durationLabel.text = "\(duration)"
            }
        }
        stateLabel.text = state.rawValue
    }
}


class SettingStorage {
    var isAutoplay: Bool
    var color: YoutubePlayerConfiguration.Color
    var isControlPannelHidden: Bool
    var startSeconds: UInt?
    var endSeconds: UInt?
    var isFullscreenButtonHidden: Bool
    var isAnnotationHidden: Bool
    var isEnableLoop: Bool
    var isBrandLogoHidden: Bool
    var isPlayInFullscreen: Bool
    var isRelationVideosHidden: Bool
    
    private init() {
        let d = YoutubePlayerConfiguration.default()
        self.isAutoplay = d.isAutoplay
        self.color = d.color
        self.isControlPannelHidden = d.isControlPannelHidden
        self.startSeconds = d.startSeconds
        self.endSeconds = d.endSeconds
        self.isFullscreenButtonHidden = d.isFullscreenButtonHidden
        self.isAnnotationHidden = d.isAnnotationHidden
        self.isEnableLoop = d.isEnableLoop
        self.isBrandLogoHidden = d.isBrandLogoHidden
        self.isPlayInFullscreen = d.isPlayInFullscreen
        self.isRelationVideosHidden = d.isRelationVideosHidden
    }
    static let shared = SettingStorage()
    
    func currentConfig() -> YoutubePlayerConfiguration {
        .init(isAutoplay: isAutoplay, color: color, isControlPannelHidden: isControlPannelHidden, isFullscreenButtonHidden: isFullscreenButtonHidden, isAnnotationHidden: isAnnotationHidden, isEnableLoop: isEnableLoop, isBrandLogoHidden: isBrandLogoHidden, isPlayInFullscreen: isPlayInFullscreen, isRelationVideosHidden: isRelationVideosHidden)
    }
}
