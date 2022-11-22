
import Foundation

typealias GetEarthquakesResult = ([Feature]) -> ()
private let dateFormatterGet = DateFormatter()

struct GetEarthquakesUseCase {
    private let getTimeRangeUseCase = GetTimeRangeUseCase()
    private let apiDataSource = EarthquakesApiDataSource()
    
    func getLatestEarthquakes(days: Int = 30, offset: Int, pageSize: Int, completion: @escaping GetEarthquakesResult) {
        let timeRange = getTimeRangeUseCase.getTimeRange(days: days)
        apiDataSource.getData(startTime: timeRange.start,
                              endTime: timeRange.end,
                              offset: offset,
                              pageSize: pageSize,
                              completion: completion)
    }
    
    func getEarthquakesBetweenDates(_ startDate: Date, _ endDate: Date?, offset: Int, pageSize: Int, completion: @escaping GetEarthquakesResult) {
        let dateRange = getTimeRangeUseCase.getDateRangeFromDates(startDate: startDate, endDate: endDate)
        apiDataSource.getData(startTime: dateRange.start,
                              endTime: dateRange.end,
                              offset: offset,
                              pageSize: pageSize,
                              completion: completion)
    }
}
