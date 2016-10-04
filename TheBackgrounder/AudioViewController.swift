//
//  AudioViewController.swift
//  TheBackgrounder
//
//  Created by Ray Fix on 12/9/14.
//  Copyright (c) 2014 Razeware, LLC. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Properties & Interface Builder
class AudioViewController: UIViewController {
    var player: AVQueuePlayer!
    
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            player.play()
        } else {
            player.pause()
        }
    }
}

// MARK: - Lifecycle Methods
extension AudioViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch {
            print("Failed to set audio session category.")
        }
        
        
        let songNames = ["FeelinGood", "IronBacon", "WhatYouWant"]
        let songs = songNames.map {
            AVPlayerItem(url: Bundle.main.url(forResource: $0, withExtension: "mp3")!)
        }
        
        player = AVQueuePlayer(items: songs)
        player.actionAtItemEnd = .advance
        player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial], context: nil)
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 100), queue: DispatchQueue.main) {
            [unowned self] time in
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            if UIApplication.shared.applicationState == .active {
                self.timeLabel.text = timeString
            } else {
                print("Background: \(timeString)")
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem", let player = object as? AVPlayer,
            let currentItem = player.currentItem?.asset as? AVURLAsset {
            songLabel.text = currentItem.url.lastPathComponent 
        }
    }
}

