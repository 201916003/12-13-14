
import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var audioPlayer : AVAudioPlayer!
    //AVAudioPlayer 인스턴스 변수
    var audioFile : URL!
    //재생할 오디오의 파일명 변수
    let MAX_VOLUME : Float = 10.0
    //최대 볼륨, 실수형 상수
    var progressTimer : Timer!
    //타이머를 위한 변수
    let timePlayerSelector:Selector = #selector(ViewController.updatePlayTime)
    let timeRecordSelector:Selector = #selector(ViewController.updateRecordTime)

    @IBOutlet var pvProgressPlay: UIProgressView!
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var slVolume: UISlider!
    
    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var lblRecordTime: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    //audioRecorder 인스턴스를 추가합니다.
    var isRecordMode = false
    //현재 '녹음 모드'라는 것을 나타낼 isRecordMode를 추가합니다. 기본값은 faise로 하여 처음 앱을 실행 했을 때 '녹음 모드'가 아닌 '재생 모드'가 나타나게 합니다.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectAudioFile()
        if !isRecordMode {
            initPlay()
            //if문의 조건이 '!isRecordMode'입니다. 이는 '녹음 모드가 아니라면' 이므로 재생 모드를 말합니다. 따라서 initPlay 함수를 호출합니다.
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
            //조건에 해당하는 것이 재생 모드이므로 [Record] 버튼과 재생 시간은 비활성화로 설정합니다.
        } else {
            initRecord()
            //조건에 해당하지 않는 경우, 이는 '녹음 모드라면'이므로 initRecord 함수를 호출합니다.
        }
    }
    
    func selectAudioFile() {
        if !isRecordMode {
            audioFile = Bundle.main.url(forResource: "Sicilian_Breeze", withExtension: "mp3")
            // 재생 모드일 때는 오디오 파일인 "Sicilian_Breeze.mp3"가 선택됩니다.
        } else {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
            //녹음 모드일 때는 새 파일인 "recordFile.m4a"가 생성됩니다.
        }
    }
    
    func initRecord() {
        let recordSettings = [
        AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
        AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey : 2,
        AVSampleRateKey : 44100.0] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFile, settings: recordSettings)
        } catch let error as NSError {
            print("Error-initRecord : \(error)")
        }
        audioRecorder.delegate = self
        // AudioRecorder의 델리게이트(Delegate)를 self로 설정합니다.
        slVolume.value = 1.0
        //볼륨 슬라이더 값을 1.0을 설정합니다.
        audioPlayer.volume = slVolume.value
        //audioPlyaer의 볼륨도 슬라이더 값과 동일한 1.0으로 설정합니다.
        lblEndTime.text = convertNSTimeInterval2String(0)
        //총 재생 시간을 0으로 바꿉니다.
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        //현재 재생 시간을 0으로 바꿉니다.
        setPlayButtons(false, pause: false, stop: false)
        //[Play], [Pause] 및 [Stop] 버튼을 비활성화로 설정합니다.
        let session = AVAudioSession.sharedInstance()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(" Error-setCategory : \(error)")
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(" Error-setActive : \(error)")
        }
    }
    
    func initPlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        slVolume.maximumValue = MAX_VOLUME
        //슬라이더(siVolume)의 최대 볼륨을 상수 MAX_VOLUME인 10.0으로 초기화 됩니다.
        slVolume.value = 1.0
        //슬라이더(siVolume)의 볼륨을 1.0으로 초기화 합니다.
        pvProgressPlay.progress = 0
        //프로그레스 뷰(pvProgressPlay)의 진행을 0으로 초기화 합니다.
        audioPlayer.delegate = self
        //audioPlayer의 델리게이트를 self로 합니다.
        audioPlayer.prepareToPlay()
        //prepareToPlay()를 실행합니다.
        audioPlayer.volume = slVolume.value
        //audioPlayer의 볼륨을 방금 앞에서 초기화한 슬라이더(siVolume)의 볼륨 값 1.0으로 초기화 합니다.
        
        lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        //오디오 파일의 재생 시간인 audioPlayer.duration값을 convertNSTimeInterval2String 함수를 이용해 lblEndTime의 텍스트에 출력합니다.
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        //lblCurrentTime의 텍스트에는 convertNSTimeInterval2String 함수를 이용해 00:00가 출력 되도록 0의 값을 입력합니다.
        setPlayButtons(true, pause: false, stop: false)
    }
    
    func setPlayButtons(_ play:Bool, pause:Bool, stop:Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = stop
    }
    
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        //재생 시간의 매개변수인 time 값을 60으로 나눈 '몫'을 정수 값으로 변환하여 상수 min 값에 초기화 합니다.
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        //time 값을 60으로 나눈 '나머지' 값을 정수 값으로 변환하여 상수 sec 값에 초기화 합니다.
        let strTime = String(format: "%02d:%02d", min, sec)
        //이 두 값을 활용해 "%02d:%02d" 형태의 문자열(String)로 변환하여 상수 strTime에 초기화 합니다.
        return strTime
        //이 값을 호출한 함수로 돌려보냅니다.
    }

    @IBAction func btnPlayAudio(_ sender: UIButton) {
        audioPlayer.play()
        //audioPlayer.play 함수를 실행해 오디오를 재생합니다.
        setPlayButtons(false, pause: true, stop: true)
        //[Play] 버튼을 비활성화, 나머지 두 버튼은 활성화 합니다.
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    
    @objc func updatePlayTime() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }
    
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        audioPlayer.pause()
        setPlayButtons(true, pause: false, stop: true)
    }
    
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        //오디오를 정지하고 다시 재생하면 처음부터 재생해야 하므로 audioPlayer.currentTime을 0으로 합니다.
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        //재생 시간도 00:00로 초기화하기 위해 convertNSTimeInterval2String(0)을 활용합니다.
        setPlayButtons(true, pause: false, stop: false)
        progressTimer.invalidate()
        //타이머도 무효화합니다.
    }
    
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        progressTimer.invalidate()
        //타이머를 무효화합니다.
        setPlayButtons(true, pause: false, stop: false)
        //[Play] 버튼을 활성화하고 나머지 버튼은 비활성화합니다.
    }
    
    @IBAction func swRecordMode(_ sender: UISwitch) {
        if sender.isOn {
            audioPlayer.stop()
            audioPlayer.currentTime=0
            lblRecordTime!.text = convertNSTimeInterval2String(0)
            isRecordMode = true
            btnRecord.isEnabled = true
            lblRecordTime.isEnabled = true
            //스위치가 [On]이 되었을 때는 '녹음 모드'이므로 오디오 재생을 중지하고, 현재 재생 시간을 00:00으로 만들고, isRecordMode의 값을 참(true)으로 설정하고, [Record] 버튼과 녹음 시간을 활성화로 설정합니다.
        } else {
            isRecordMode = false
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
            lblRecordTime.text = convertNSTimeInterval2String(0)
            //스위치가 [On]이 아닐 때, 즉 '재생 모드'일 때는 isRecordMode의 값을 거짓(faise)으로 설정하고, [Record] 버튼과 녹음 시간을 비활성화하며, 녹음 시간은 0으로 초기화 합니다.
        }
        selectAudioFile()
        if !isRecordMode {
            initPlay()
        } else {
            initRecord()
            //selectAudioFile 함수를 호출하여 오디오 파일을 선택하고, 모드에 따라 초기화할 함수를 호출합니다.
        }
    }
    
    @IBAction func btnRecord(_ sender: UIButton) {
        if (sender as AnyObject).titleLabel?.text == "Record" {
            audioRecorder.record()
            (sender as AnyObject).setTitle("Stop", for: UIControl.State())
            //만약에 버튼 이름이 'Record'이면 녹음을 하고 버튼 이름을 'Stop'으로 변경합니다.
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
            //녹음할 때 타이머가 작동하도록 progressTimer에 Timer.scheduledTimer 함수를 사용하는데, 0.1초 간격으로 타이머를 생성합니다.
        } else {
            audioRecorder.stop()
            progressTimer.invalidate()
            //녹음이 중지되면 타이머를 무효화 합니다.
            (sender as AnyObject).setTitle("Record", for: UIControl.State())
            btnPlay.isEnabled = true
            initPlay()
            //그렇지 않으면 현재 녹음 중이므로 녹음을 중단하고 버튼 이름을 'Stop'으로 변경합니다. 그리고 [Play]버튼을 활성화하고 방금 녹음한 파일로 재생을 초기화 합니다.
        }
    }
    
    @objc func updateRecordTime() {
        lblRecordTime.text = convertNSTimeInterval2String(audioRecorder.currentTime)
        //재생 시간인 audioPlayer.currentTime을 레이블 'lblCurrentTime'에 나타납니다.
    }
    
}

















