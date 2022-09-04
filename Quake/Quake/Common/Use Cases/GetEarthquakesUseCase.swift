
import Foundation

typealias GetEarthquakesResult = ([Feature]) -> ()

struct GetEarthquakesUseCase {
    private let getTimeRangeUseCase = GetTimeRangeUseCase()
    private let apiDataSource = EarthquakesApiDataSource()
    
    func getLatestEarthquakes(days: Int = 30, completion: @escaping GetEarthquakesResult) {
        let timeRange = getTimeRangeUseCase.getTimeRange(days: days)
        apiDataSource.getData(startTime: timeRange.start,
                           endTime: timeRange.end,
                           completion: completion)
    }
    
    func getEarthquakesByDate(_ date: Date, completion: @escaping GetEarthquakesResult) {
        let dateRange = getTimeRangeUseCase.getDateRange(date: date)
        apiDataSource.getData(startTime: dateRange.start,
                           endTime: dateRange.end,
                           completion: completion)
    }
}
