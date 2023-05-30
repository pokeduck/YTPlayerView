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
        playerView.frame = .init(x: 20, y: 40, width: 300, height: 200)
        view.addSubview(playerView)
        let pannelView = UIStackView()
        pannelView.axis = .horizontal
        pannelView.spacing = 20
        pannelView.alignment = .fill
        pannelView.distribution = .equalSpacing
        view.addSubview(pannelView)
        pannelView.translatesAutoresizingMaskIntoConstraints = false
        pannelView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pannelView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pannelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        pannelView.addArrangedSubview(playButton)
        pannelView.addArrangedSubview(pauseButton)
        pannelView.addArrangedSubview(stopButton)
        pannelView.addArrangedSubview(durationButton)
        pannelView.addArrangedSubview(currentButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.loadYoutube(videoId: "a3ICNMQW7Ok")
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
        playerView.duration { value in
            print(value)
        }
    }

    @objc func currentHandler() {
        playerView.currentTime { value in
            print(value)
        }
    }
}
