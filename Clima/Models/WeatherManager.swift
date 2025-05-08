import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL: String
    var delegate: WeatherManagerDelegate?
    
    init(apiKey: String) {
        self.weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    }
    
    func getWeather(_ city: String) {
        let url = "\(weatherURL)&q=\(city)"
        performRequest(with: url)
    }
    
    func getWeather(lat: Float, lon: Float) {
        let url = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        // Create a URL
        if let url = URL(string: urlString) {
            // Create a URL Session
            let session = URLSession(configuration: .default)
            
            // Give the session a task
            // Quando a task finalizar, ele vai executar o metodo que esta no completionHandler
            // Esse handler vai receber 3 parametros data, response e error
            let task = session.dataTask(with: url, completionHandler: handle)
            
            // Start the task
            task.resume()
        }
    }
    
    // Roda em background
    func handle(data: Data?, response: URLResponse?, error: Error?) -> Void {
        if error != nil {
            delegate?.didFailWithError(error: error!)
            return
        }
        
        if let safeData = data {
            print(String(data: safeData, encoding: .utf8) ?? "")
            if let weather = parseJSON(safeData) {
                delegate?.didUpdateWeather(self, weather: weather)
            }
        }
    }
    
    func parseJSON(_ weatherData: Data) -> Weather? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherDTO.self, from: weatherData)
            return Weather(
                conditionId: decodedData.weather[0].id,
                cityName: decodedData.name,
                temperature: decodedData.main.temp
            )
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
