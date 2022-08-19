
import Foundation

typealias GetEarthquakesResult = ([Feature]) -> ()

struct GetEarthquakesUseCase {
    private let getTimeRangeUseCase = GetTimeRangeUseCase()
    private let apiDataSource = EarthquakesApiDataSource()
    
    func getEarthquakes(completion: @escaping GetEarthquakesResult) {
        let timeRange = getTimeRangeUseCase.getTimeRange(days: 30)
        apiDataSource.getData(startTime: timeRange.start,
                           endTime: timeRange.end,
                           completion: completion)
    }
}
