//
//  AtprotoSyncGetLatestCommit.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-12.
//

import Foundation

/// The main data model definition for the output of getting a repository's latest commit CID.
///
/// - Note: According to the AT Protocol specifications: "Get the current commit CID & revision
/// of the specified repo. Does not require auth."
///
/// - SeeAlso: This is based on the [`com.atproto.sync.getLatestCommit`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getLatestCommit.json
public struct SyncGetLatestCommitOutput: Codable {
    /// The commit CID of the repository.
    public let commitCID: String
    /// The repository's revision.
    public let revision: String

    enum CodingKeys: String, CodingKey {
        case commitCID = "cid"
        case revision = "rev"
    }
}
