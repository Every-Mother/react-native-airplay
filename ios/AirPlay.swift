import Foundation
import MediaPlayer

@objc(RCTAirPlay)
class RCTAirPlay: RCTEventEmitter {

  @objc func startScan() -> Void {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(RCTAirPlay.airplayChanged(sender:)),
                                           name: AVAudioSession.routeChangeNotification,
                                           object: AVAudioSession.sharedInstance())
  }

  @objc func airplayChanged(sender: NSNotification) {
    let currentRoute = AVAudioSession.sharedInstance().currentRoute
    var isAirPlayPlaying = false
    for output in currentRoute.outputs {
      if output.portType == AVAudioSession.Port.airPlay {
        print("Airplay Device connected with name: \(output.portName)")
        isAirPlayPlaying = true
        break;
      }
    }

    self.sendEvent(withName: "airplayConnected",
                   body: ["connected": isAirPlayPlaying])
  }

  @objc func isAlreadyConnected(callback: RCTResponseSenderBlock) -> Void {
    let currentRoute = AVAudioSession.sharedInstance().currentRoute
    for output in currentRoute.outputs {
      if output.portType == AVAudioSession.Port.airPlay {
        print("Airplay Device connected with name: \(output.portName)")
        callback([true])
        //return true
      }
    }
    callback([false])
    //return false
  }

  override func supportedEvents() -> [String]! {
    return ["airplayConnected"]
  }

}

@objc(RCTAirPlayButton)
class RCTAirPlayButton: RCTViewManager {
  override func view() -> UIView! {

    let volumneView = MPVolumeView()

    for view in volumneView.subviews {
        if view is UIButton {
            let buttonOnVolumeView : UIButton = view as! UIButton
            volumneView.setRouteButtonImage(buttonOnVolumeView.currentImage?.withRenderingMode(.alwaysTemplate), for: [])
            break;
        }
    }

    volumneView.tintColor = UIColor(red: 0.69, green: 0.41, blue: 0.36, alpha: 1.0)
    volumneView.showsVolumeSlider = false

    return volumneView
  }
}
