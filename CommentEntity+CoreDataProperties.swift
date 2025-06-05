//
//  CommentEntity+CoreDataProperties.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/4/25.
//
//

import Foundation
import CoreData


extension CommentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentEntity> {
        return NSFetchRequest<CommentEntity>(entityName: "CommentEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var message: String?
    @NSManaged public var timestamp: String?
    @NSManaged public var posts: PostEntity?

}

extension CommentEntity : Identifiable {

}
