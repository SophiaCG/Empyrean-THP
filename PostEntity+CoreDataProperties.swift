//
//  PostEntity+CoreDataProperties.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/4/25.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for comments
extension PostEntity {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: CommentEntity)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: CommentEntity)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

extension PostEntity : Identifiable {

}
