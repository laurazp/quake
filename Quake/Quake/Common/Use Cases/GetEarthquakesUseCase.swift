
import Foundation

typealias GetEarthquakesResult = ([Feature]) -> ()

struct GetEarthquakesUseCase {
    private let getTimeRangeUseCase = GetTimeRangeUseCase()
    private let dataSource = EarthquakesApiDataSource()
    
    func getEarthquakes(completion: @escaping GetEarthquakesResult) {
        let timeRange = getTimeRangeUseCase.getTimeRange(days: 30)
        dataSource.getData(startTime: timeRange.start,
                           endTime: timeRange.end,
                           completion: completion)
    }
}
