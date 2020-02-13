import Foundation

enum ServiceError: Error {
    case urlError
    case networkRequestError
    case impossibleToGetJSONData
    case impossibleToParseJSON
}
