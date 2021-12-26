import Foundation

class NetworkingSessionTask {
    var response: URLResponse? {
        return task?.response
    }
    weak var task: URLSessionTask?
    
    init(_ task: URLSessionTask) {
        self.task = task
    }
    
    func resume() {
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}

protocol NetworkingSession {
    func networkingDataTask(with request: URLRequest) -> NetworkingSessionTask
    func networkingDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingSessionTask
    func finishTasksAndInvalidate()
    func invalidateAndCancel()
}

extension URLSession: NetworkingSession {
    func networkingDataTask(with request: URLRequest) -> NetworkingSessionTask {
        let task = dataTask(with:request)
        return NetworkingSessionTask(task)
    }
    
    func networkingDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingSessionTask {
        let task = dataTask(with: url, completionHandler: completionHandler)
        return NetworkingSessionTask(task)
    }
}
