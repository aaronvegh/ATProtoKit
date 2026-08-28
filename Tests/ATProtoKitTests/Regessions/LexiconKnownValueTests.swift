//
//  LexiconKnownValueTests.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2026-08-23.
//

import Foundation
import Testing
@testable import ATProtoKit

extension RegressionTests {

    @Suite("Lexicon Known Value Tests")
    struct LexiconKnownValueTests {

        @Test("Known raw values create their named cases")
        func knownRawValuesCreateNamedCases() {
            let value =
            AppBskyLexicon.Actor.ContentLabelPreferencesDefinition.Visibility(
                rawValue: "warn"
            )

            #expect(value == .warn)
        }

        @Test("Known string literals create their named cases")
        func knownStringLiteralsCreateNamedCases() {
            let value:
            AppBskyLexicon.Actor.ContentLabelPreferencesDefinition.Visibility =
            "warn"

            #expect(value == .warn)
        }

        @Test("Unknown values remain forward compatible")
        func unknownValuesArePreserved() {
            let value =
            AppBskyLexicon.Actor.ContentLabelPreferencesDefinition.Visibility(
                rawValue: "future-visibility"
            )

            #expect(value == .unknown("future-visibility"))
            #expect(value.rawValue == "future-visibility")
        }

        @Test("Known values round-trip through Codable")
        func knownValuesRoundTrip() throws {
            let data = try JSONEncoder().encode(
                AppBskyLexicon.Actor.ContentLabelPreferencesDefinition.Visibility.warn
            )

            #expect(String(decoding: data, as: UTF8.self) == #""warn""#)

            let decoded = try JSONDecoder().decode(
                AppBskyLexicon.Actor.ContentLabelPreferencesDefinition.Visibility.self,
                from: data
            )

            #expect(decoded == .warn)
        }

        @Test("Safelink reasons encode as Lexicon strings")
        func safelinkReasonsEncodeAsStrings() throws {
            let data = try JSONEncoder().encode(
                ToolsOzoneLexicon.Safelink.ReasonTypeDefinition.phishing
            )

            #expect(String(decoding: data, as: UTF8.self) == #""phishing""#)
        }
    }
}
