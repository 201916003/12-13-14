//
//  ViewController.swift
//  MoviePlayer
//
//  Created by Ho-Jeong Song on 2021/11/26.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPlayInternalMovie(_ sender: UIButton) {
        // 내부 파일 mp4
        let filePath:String? = Bundle.main.path(forResource: "FastTyping", ofType: "mp4")
        //우선 비디오 파일명을 사용하여 비디오가 저장된 앱 내부의 파일 경로를 받아옵니다.
        let url = NSURL(fileURLWithPath: filePath!)
        //앱 내부의 파일명을 NSURL 형식으로 변경합니다.

        playVideo(url: url)
    }
    
    @IBAction func btnPlayerExternalMovie(_ sender: UIButton) {
        // 외부 파일 mp4
        let url = NSURL(string: "https://dl.dropboxusercontent.com/s/e38auz050w2mvud/Fireworks.mp4")!

        playVideo(url: url)
    }
    
    private func playVideo(url: NSURL)  {
        let playerController = AVPlayerViewController()
        //AVPlayerViewController의 인스턴스를 생성합니다.
        
        let player = AVPlayer(url: url as URL)
        //앞에서 얻은 비디오 URL로 초기화된 AVPlayer의 인스턴스를 생성합니다.
        playerController.player = player
        //AVPlayerViewController의 player 속성에 AVPlayer 인스턴스를 할당합니다.
        
        self.present(playerController, animated: true) {
            player.play()
            //비디오를 재생합니다.
        }
    }
}

