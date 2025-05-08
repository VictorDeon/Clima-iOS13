//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

// UITextFieldDelegate é do tipo protocol, que em OO é conhecido como Interface
class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weather = WeatherManager(apiKey: "...")
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mostra o popup pedindo autorização para usar a localização
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        // Padrao de projeto Delegate que faz funcionar alguns metodos definidos no protocolo
        weather.delegate = self
        // UITextFieldDelegate para manipular eventos do UITextField
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    // Ao clicar no botao de return (enviar ou Go) do teclado dispara esse metodo
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    // Disparado quando o usuario para de focar no textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        
        textField.placeholder = "Type something here"
        return false
    }
    
    // Disparado quando foi finalizado o uso do text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weather.getWeather(city)
        }
        
        searchTextField.text = ""
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    // Como esse método roda em background precisamos inserir em uma queue para a thread principal novamente
    // para modificar os itens da tela, pois não sabemos quando a requisição http será finalizada.
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    // Executado toda vez que for requirido a location a partir do locationManager.requestLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got location update")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weather.getWeather(lat: Float(lat), lon: Float(lon))
        }
    }
    
    // Executado se der algum error ao tentar pegar a localização.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
