//
//  Splashvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 19/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AudioToolbox
import SwiftEventBus
import Foundation

class Splashvc: Executeapi {
    
    @IBOutlet weak var usernametxt: UILabel!
    var playerLayer: AVPlayer?
    let playerController = AVPlayerViewController()
    var flag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if flag {
            playVideo()
        }
    }
    
    private func playvideowithurl(){
       }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "splashscreen", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        
        let player = AVPlayer(url: NSURL(fileURLWithPath: path) as URL)
        
        playerController.showsPlaybackControls = false
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }

         NotificationCenter.default.addObserver(self, selector: #selector(Splashvc.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func finishVideo()
    {
        print("Video Finished")
        flag = false
        
        if (UserDefaults.standard.string(forKey: "usercode") == nil || UserDefaults.standard.string(forKey: "usercode") == ""){

            self.playerController.dismiss(animated: false)

            pushnext(identifier: "Registrationvc", controller: self)

           }
           else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let registrationVC = storyboard.instantiateViewController(withIdentifier: "login") as! Loginvc
//            UIApplication.shared.delegate?.window?!.rootViewController = registrationVC
            self.playerController.dismiss(animated: false)
            pushnext(identifier: "login", controller: self)
        }
    }
}
