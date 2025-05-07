import Foundation

struct Weather {
    let weatherURL: String
    
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
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            
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
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString ?? "")
        }
    }
}
