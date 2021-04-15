//
//  Photo.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 02.04.2021.
//

import Foundation
import UIKit

// оставлены только необходимые для задачи данные
// MARK: - Photo
struct Photo: Codable {
    var id: String
    //var createdAt: Date
    //var updatedAt: Date
    //var promotedAt: Date
    var width: Int
    var height: Int
    var color: String
    //var blurHash: String
    //var photoDescription: String?
    //var altDescription: String?
    var urls: Urls
  //  var links: Links
    //var categories: [String]
    //var likes: Int
    //var likedByUser: Bool
    //var currentUserCollections: [CurrentUserCollection]?
    //var sponsorship: String?
    //var user: User
    //var downloads: Int
    //var views: Int
    //var exif: Exif
    //var location: Location

    enum CodingKeys: String, CodingKey {
        case id
        //case createdAt = "created_at"
        //case updatedAt = "updated_at"
        //case promotedAt = "promoted_at"
        case width, height, color
        //case blurHash = "blur_hash"
        //case downloads, likes
        //case views
        //case sponsorship
        //case categories
        //case likedByUser = "liked_by_user"
        //case photoDescription = "description"
        //case altDescription = "alt_description"
        //case exif, location
        case urls//, links
        //case currentUserCollections = "current_user_collections"
        //case user
    }
    
}

// MARK: - Links
/*struct Links: Codable {
    var linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
} */

// MARK: - Urls
struct Urls: Codable {
    var raw, full, regular, small: String
    var thumb: String
}


// MARK: - Exif
/*struct Exif: Codable {
    var make, model, exposureTime, aperture: String
    var focalLength: String
    var iso: Int

    enum CodingKeys: String, CodingKey {
        case make, model
        case exposureTime = "exposure_time"
        case aperture
        case focalLength = "focal_length"
        case iso
    }
} */

// MARK: - CurrentUserCollection
/*struct CurrentUserCollection: Codable {
    var id: Int
    var title: String
    var publishedAt, lastCollectedAt, updatedAt: Date
    var coverPhoto, user: User
    

    enum CodingKeys: String, CodingKey {
        case id, title
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case coverPhoto = "cover_photo"
        case user
    }
} */

// MARK: - Location
/*struct Location: Codable {
    var title, name, city, country: String
    var position: Position
} */

// MARK: - Position
/*struct Position: Codable {
    var latitude, longitude: Double
} */

// MARK: - ProfileImage
/*struct ProfileImage: Codable {
    var small, medium, large: String
} */

// MARK: - LinksUser
/*struct LinksUser: Codable {
    var linksSelf, html, photos, likes, portfolio, following, followers: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
} */

// MARK: - User
/*struct User: Codable {
    var id: String
    var updatedAt: Date
    var username, name: String
    var firstName: String
    var lastName: String
    var portfolioURL: String
    var bio, location: String
    var totalLikes, totalPhotos, totalCollections: Int
    var instagramUsername, twitterUsername: String
    var links: LinksUser
    var acceptedTos: Bool
    var forHire: Bool
    var profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case instagramUsername = "instagram_username"
        case links
        case acceptedTos = "accepted_tos"
        case forHire = "for_hire"
        case profileImage = "profile_image"
    }
} */

