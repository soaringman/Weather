//
//  WeatherViewController.swift
//  Weather
//
//  Created by Алексей Гуляев on 11.08.2022.
//
// https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid={API key}
// https://api.openweathermap.org/data/2.5/weather?q=London&appid={API key}
// c249427bcd4b587d71787111d6f0e949

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    var weatherManager = WeatherManager()
    let coreLocationManager = CLLocationManager()
    
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreLocationManager.delegate = self
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func LocationPressed(_ sender: UIButton) {
        coreLocationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
//        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    //Пропишем метод в котором будем ловить когда бфла нажата кнопка return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    //Так же мы можем использовать следующий метод для проверки того что
    //находиться в поле и если там пустота вывести "введите  что то"
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    //Метод сработает когда мы нажмем что то и курсор пропадет с поля ввода
    // Метод срабатывает когда ХКод понимает что мы закончили редактировать
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let currentCityName = searchTextField.text {
            weatherManager.fetchWeather(cityName: currentCityName)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
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

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            coreLocationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
         }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
