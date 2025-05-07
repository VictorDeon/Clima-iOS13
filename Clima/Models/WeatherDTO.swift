struct WeatherData: Codable {
    let id: Int
}

struct Main: Codable {
    let temp: Double
}

// Codable = Encodable + Decodable, ou seja, transforma em obj -> json ou json -> obj (Typealiases)
struct WeatherDTO: Codable {
    let name: String
    let main: Main
    let weather: [WeatherData]
}
