//
//  getAllProblemQuestions.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 24/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let empty = try? newJSONDecoder().decode(Empty.self, from: jsonData)

import Foundation
import MobileCoreServices
import UniformTypeIdentifiers

// MARK: - Empty
struct AllQuestionResponse: Codable {
    let data: [AllQuestions]?
    let message, status: String
	let info: Info?
    let timestamp: Int
}


// MARK: - Datum -
struct AllQuestions: Codable {
    let active: String?
    let answers: [Answer]?
    let created_on, object_id, problem_id: String?
    var questions: [Question]?
    let target: [Target]?
    let size: String?
	let title: String?
}

// MARK: - Answer
struct Answer: Codable, Equatable, Hashable {
    var position: [String]?
    let question_id: String?
	let state: String?

}

// MARK: - Question
final class Question: NSObject,Codable {
    var question: String?
    let question_id: String?
	let state: String?
	let position: [String?]?
    
	init(question: String, question_id: String, state: String, position: [String?]?) {
        self.question = question
        self.question_id = question_id
		self.state = state
		self.position = position
    }
}

// MARK: - Target
struct Target: Codable , Equatable{
    let position: [String]?
    var question: String?
    var question_id: String?
	let state: String?
}

struct Info: Codable {
	let count: Int
	let lastEvaluatedKey: LastEvaluatedKey?
}

struct LastEvaluatedKey : Codable {
	let object_id, problem_id: String?
}


// MARK: -  Extension for drag and drop objects -

extension Question: NSItemProviderWriting {
	static var writableTypeIdentifiersForItemProvider: [String] {
		return [UTType.data.identifier]
	}

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        do {
          //Here the object is encoded to a JSON data object and sent to the completion handler
          let data = try JSONEncoder().encode(self)
          progress.completedUnitCount = 100
          completionHandler(data, nil)
        } catch {
          completionHandler(nil, error)
        }
        return progress
      }
}

extension Question: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [UTType.data.identifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Question {
        let decoder = JSONDecoder()
        do {
            //Here we decode the object back to it's class representation and return it
            let subject = try decoder.decode(Question.self, from: data)
            return subject
          } catch {
              fatalError(error.localizedDescription)
          }
        
    }
    
    
}

