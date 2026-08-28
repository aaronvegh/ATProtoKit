//
//  ComAtprotoRepoDescribeRepoMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Describes the repository.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get information about an account
    /// and repository, including the list of collections. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.describeRepo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/describeRepo.json
    ///
    /// - Parameter repositoryDID: The decentralized identifier (DID) or handle of the repository.
    /// - Returns: Some general information about the repository that matches `repositoryDID`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func describeRepository(
        _ repositoryDID: String
    ) async throws -> ComAtprotoLexicon.Repository.DescribeRepositoryOutput {
        let host = try await self.atidentityResolver.resolvePDSEndpoint(from: repositoryDID)

        guard let requestURL = URL(string: "\(host)/xrpc/com.atproto.repo.describeRepo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("repo", repositoryDID))

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Repository.DescribeRepositoryOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
