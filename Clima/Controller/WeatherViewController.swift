//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

// UITextFieldDelegate é do tipo protocol, que em OO é conhecido como Interface
class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weather = Weather(apiKey: "...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Padrao de projeto Delegate que faz funcionar alguns metodos definidos no protocolo
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
    
}

