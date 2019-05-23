//
//  AudioSpectrumAudioSpectrumViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/5/23.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import AVFoundation

class AudioSpectrumViewController: UIViewController {
    
    @IBOutlet weak var spectrumView: SpectrumView!
    @IBOutlet weak var trackTableView: UITableView!
    
    var player: AudioSpectrumPlayer!
    
    private lazy var trackPaths: [String] = {
        if  let  path =  Bundle.main.path(forAuxiliaryExecutable: "Audio"){
            var paths = try?FileManager.default.contentsOfDirectory(atPath: path)
            paths?.sort()
            return paths?.map { $0.components(separatedBy: "/").last! } ?? []
        }
        return []
    }()
    
    private var currentPlayingRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trackTableView.register(UINib.init(nibName: "TrackCell", bundle: Bundle.main), forCellReuseIdentifier:"TrackCell")
        trackTableView.dataSource = self
        player = AudioSpectrumPlayer()
        player.delegate = self
    }
    override func viewDidLayoutSubviews() {
        let barSpace = spectrumView.frame.width / CGFloat(player.analyzer.frequencyBands * 3 - 1)
        spectrumView.barWidth = barSpace * 2
        spectrumView.space = barSpace
    }
}

// MARK: UITableViewDataSource
extension AudioSpectrumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackPaths.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        cell.configure(trackName: "\(trackPaths[indexPath.row])", playing: currentPlayingRow == indexPath.row)
        cell.delegate = self
        return cell
    }
}

// MARK: TrackCellDelegate
extension AudioSpectrumViewController: TrackCellDelegate {
    func playTapped(_ cell: TrackCell) {
        if let indexPath = trackTableView.indexPath(for: cell) {
            let previousPlayingRow = currentPlayingRow
            self.currentPlayingRow = indexPath.row
            if indexPath.row != previousPlayingRow && previousPlayingRow != nil  {
                trackTableView.reloadRows(at: [IndexPath(row: previousPlayingRow!, section: 0)], with: .none)
            }
            player.play(withFileName: trackPaths[indexPath.row])
        }
    }
    func stopTapped(_ cell: TrackCell) {
        self.currentPlayingRow = nil
        player.stop()
    }
}

// MARK: SpectrumPlayerDelegate
extension AudioSpectrumViewController: AudioSpectrumPlayerDelegate {
    func player(_ player: AudioSpectrumPlayer, didGenerateSpectrum spectra: [[Float]]) {
        DispatchQueue.main.async {
            self.spectrumView.spectra = spectra
        }
    }
}
