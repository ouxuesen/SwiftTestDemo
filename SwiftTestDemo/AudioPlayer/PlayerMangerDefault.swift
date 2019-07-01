//
//  PlayerMangerDefault.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/6/6.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class PlayerMangerDefault: NSObject {
//NSNotificationCenter
    
    static let shared = PlayerMangerDefault()
    var  playerArray:[FileManagerModel]?
    var  playerIndex:Int?
    var spectrumPlayer = AudioSpectrumPlayer()
    override init() {
        /// 发送简单数据
        super.init()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { (Notification) in
            self.play(index: self.playerIndex ?? 0+1, playerS: self.playerArray ?? [FileManagerModel]())
            print("播放完成")
        }
    }
    func play(index:Int ,playerS:[FileManagerModel]) -> Void {
        
        self.playerArray = playerS
        self.playerIndex = index
        if playerS.count <=  index
        {
            return
        }
        let managerModel = playerS[index]
        if managerModel.filetype == .FileType_mp3{
            spectrumPlayer.playAbsolutePath(absolutePath: managerModel.pathStr ?? "")
        }else{
            play(index: index+1, playerS: playerS)
        }
        
      
    }
    func stop() -> Void {
        spectrumPlayer.stop()
    }
    func pause() -> Void {
        spectrumPlayer.pause()
    }
   
}

