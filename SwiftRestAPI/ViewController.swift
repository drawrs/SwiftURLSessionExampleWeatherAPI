//
//  ViewController.swift
//  SwiftRestAPI
//
//  Created by Rizal Hilman on 05/08/20.
//  Copyright © 2020 Rizal Hilman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelWeatherDesc: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var imageWeatherIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchAPI()
    }
    

    func fetchAPI() {
                
        guard let gitURL = URL(string: "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=439d4b804bc8187953eb36d2a8c26a02") else {return}
        URLSession.shared.dataTask(with: gitURL) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(CurrentWeather.self, from: data)
                
                let temp = gitData.main?.temp ?? 0.0
                let formattedTemp = String(format: "%.0f", (temp - 273.15))
                
                let weatherDesc = gitData.weather?[0].description ?? "empty"
                
                DispatchQueue.main.async {
                    self.labelLocation.text = "London"
                    self.labelTemp.text = "\(formattedTemp)°"
                    self.labelWeatherDesc.text = weatherDesc.capitalized
                    self.imageWeatherIcon.image = UIImage(named: gitData.weather?[0].icon ?? "none")
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

struct CurrentWeather: Codable {
    let main: Main?
    let weather: [Weather]?
    
    private enum CodingKeys: String, CodingKey {
        case main
        case weather = "weather"
    }
    
}

struct Main: Codable {
    let temp: Double?
    let humidity: Double?

    private enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        
    }
}

struct Weather: Codable {
    let main: String?
    let description: String?
    let icon: String?
    
    private enum CodingKeys: String, CodingKey {
        case main
        case description
        case icon
    }
}
