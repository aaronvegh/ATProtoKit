//
//  DeleteLike.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    public func deleteLikeRecord(_ record: RecordIdentifier) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.deleteRecord") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var likeRecord: RecordQuery? = nil
        switch record {
            case .recordQuery(let recordQuery):
                let output = try await ATProtoKit.getRepoRecord(from: recordQuery, pdsURL: sessionURL)

                switch output {
                    case .success(let result):
                        // Perform the fetch and validation based on recordQuery.
                        let recordURI = "at://\(recordQuery.repo)/\(recordQuery.collection)/\(recordQuery.recordKey)"
                        guard result.atURI == recordURI else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record"])
                        }

                        likeRecord = recordQuery
                    case .failure(let error):
                        throw error
                }

            case .atURI(let atURI):
                // Perform the fetch and validation based on the parsed URI.
                let parsedURI = try ATProtoKit.parseURI(atURI)
                let output = try await ATProtoKit.getRepoRecord(from: parsedURI, pdsURL: sessionURL)

                switch output {
                    case .success(let result):
                        guard atURI == result.atURI else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record"])
                        }

                        likeRecord = parsedURI
                    case .failure(let error):
                        throw error
                }
        }

        let requestBody = likeRecord

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, authorizationValue: "Bearer \(session.accessToken)")

        do {
            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
        }
    }

    public enum RecordIdentifier {
        case recordQuery(recordQuery: RecordQuery)
        case atURI(atURI: String)
    }
}
