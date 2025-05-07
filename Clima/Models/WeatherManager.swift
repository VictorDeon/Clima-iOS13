import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: Weather)
}

struct WeatherManager {
    let weatherURL: String
    var delegate: WeatherManagerDelegate?
    
    init(apiKey: String) {
        self.weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    }
    
    func getWeather(_ city: String) {
        let url = "\(weatherURL)&q=\(city)"
        performRequest(url)
    }
    
    func performRequest(_ urlString: String) {
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
    
    func handle(data: Data?, response: URLResponse?, error: Error?) -> Void {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            print(String(data: safeData, encoding: .utf8) ?? "")
            if let weather = parseJSON(weatherData: safeData) {
                delegate?.didUpdateWeather(weather: weather)
            }
        }
    }
    
    func parseJSON(weatherData: Data) -> Weather? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherDTO.self, from: weatherData)
            return Weather(
                conditionId: decodedData.weather[0].id,
                cityName: decodedData.name,
                temperature: decodedData.main.temp
            )
        } catch {
            print(error)
            return nil
        }
    }
}
