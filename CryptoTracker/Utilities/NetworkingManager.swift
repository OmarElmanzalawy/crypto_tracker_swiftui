//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by MAC on 17/06/2025.
//

import Foundation
import Combine

class NetworkingManager{
    
    enum NetworkingError: LocalizedError{
        case badURLResonse
        case unkown
        
        var errorDescription: String? {
            switch self {
            case .badURLResonse:
                return "Bad response from url"
            case .unkown:
                return "Unkown error occured"
            }
        }
    }
    
    // uses Combine framework to handle network requests and responses and return the response as a publisher
    static func downloadData(from url: URL) -> AnyPublisher<Data,Error> {
        //uses combine to fetch data from api and make it as a publisher
        return URLSession.shared.dataTaskPublisher(for: url)
        //converts the data into json format and do task in background
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap ({ try handleUrlResponse(output: $0)})
        
            //Move back to main thread to update UI
            .receive(on: DispatchQueue.main)
            //return publisher of type Anypublisher so that specify a return type
            .eraseToAnyPublisher()
    }
    
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data{
        print("data: \(output.data)")
        guard let response = output.response
        as? HTTPURLResponse,
        response.statusCode >= 200 && response.statusCode < 300 else {
            print("error while fetching url")
            throw NetworkingError.badURLResonse
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>?){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(String(describing: error))
        default: break
        }
    }
}
