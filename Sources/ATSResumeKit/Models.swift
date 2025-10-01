import Foundation

// MARK: - Main CV Structure

public struct CV: Codable {
    public let id: String
    public let basics: Basics
    public let summaries: [Summary]?
    public let skills: [Skill]?
    public let publications: [Publication]?
    public let work: [WorkEntry]?
    public let education: [EducationEntry]?
    public let volunteer: [VolunteerEntry]?

    public init(
        id: String,
        basics: Basics,
        summaries: [Summary]? = nil,
        skills: [Skill]? = nil,
        publications: [Publication]? = nil,
        work: [WorkEntry]? = nil,
        education: [EducationEntry]? = nil,
        volunteer: [VolunteerEntry]? = nil
    ) {
        self.id = id
        self.basics = basics
        self.summaries = summaries
        self.skills = skills
        self.publications = publications
        self.work = work
        self.education = education
        self.volunteer = volunteer
    }
}

// MARK: - Basics

public struct Basics: Codable {
    public let phone: String?
    public let url: String?
    public let firstName: String
    public let id: String?
    public let location: Location
    public let socialProfiles: [SocialProfile]?
    public let picture: String?
    public let email: String
    public let label: String?
    public let lastName: String

    public init(
        phone: String? = nil,
        url: String? = nil,
        firstName: String,
        id: String? = nil,
        location: Location,
        socialProfiles: [SocialProfile]? = nil,
        picture: String? = nil,
        email: String,
        label: String? = nil,
        lastName: String
    ) {
        self.phone = phone
        self.url = url
        self.firstName = firstName
        self.id = id
        self.location = location
        self.socialProfiles = socialProfiles
        self.picture = picture
        self.email = email
        self.label = label
        self.lastName = lastName
    }
}

// MARK: - Location

public struct Location: Codable {
    public let address: String?
    public let city: String?
    public let state: String?
    public let postalCode: String?
    public let countryCode: String?

    public init(
        address: String? = nil,
        city: String? = nil,
        state: String? = nil,
        postalCode: String? = nil,
        countryCode: String? = nil
    ) {
        self.address = address
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.countryCode = countryCode
    }
}

// MARK: - Social Profile

public struct SocialProfile: Codable {
    public let username: String
    public let id: String?
    public let url: String
    public let network: String

    public init(username: String, id: String? = nil, url: String, network: String) {
        self.username = username
        self.id = id
        self.url = url
        self.network = network
    }
}

// MARK: - Summary

public struct Summary: Codable {
    public let priority: Int
    public let summaryType: String
    public let summary: [String]

    public init(priority: Int, summaryType: String, summary: [String]) {
        self.priority = priority
        self.summaryType = summaryType
        self.summary = summary
    }
}

// MARK: - Skill

public struct Skill: Codable {
    public let id: String
    public let level: String
    public let name: String
    public let keywords: [String]?

    public init(id: String, level: String, name: String, keywords: [String]? = nil) {
        self.id = id
        self.level = level
        self.name = name
        self.keywords = keywords
    }
}

// MARK: - Publication

public struct Publication: Codable {
    public let id: String
    public let releaseDate: String
    public let name: String
    public let publisher: String?
    public let url: String
    public let highlights: [String]?

    public init(
        id: String,
        releaseDate: String,
        name: String,
        publisher: String? = nil,
        url: String,
        highlights: [String]? = nil
    ) {
        self.id = id
        self.releaseDate = releaseDate
        self.name = name
        self.publisher = publisher
        self.url = url
        self.highlights = highlights
    }
}

// MARK: - Story

public struct Story: Codable {
    public let id: String
    public let title: String
    public let situation: String?
    public let task: String?
    public let action: String?
    public let result: String?
    public let summary: String?
    public let tags: [String]?
    public let used: Bool?

    public init(
        id: String,
        title: String,
        situation: String? = nil,
        task: String? = nil,
        action: String? = nil,
        result: String? = nil,
        summary: String? = nil,
        tags: [String]? = nil,
        used: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.situation = situation
        self.task = task
        self.action = action
        self.result = result
        self.summary = summary
        self.tags = tags
        self.used = used
    }
}

// MARK: - Position

public struct Position: Codable {
    public let location: Location?
    public let url: String?
    public let name: String?
    public let endDate: String?
    public let id: String
    public let startDate: String
    public let position: String
    public let project: String?
    public let highlights: [String]?
    public let stories: [Story]?

    public init(
        location: Location? = nil,
        url: String? = nil,
        name: String? = nil,
        endDate: String? = nil,
        id: String,
        startDate: String,
        position: String,
        project: String? = nil,
        highlights: [String]? = nil,
        stories: [Story]? = nil
    ) {
        self.location = location
        self.url = url
        self.name = name
        self.endDate = endDate
        self.id = id
        self.startDate = startDate
        self.position = position
        self.project = project
        self.highlights = highlights
        self.stories = stories
    }
}

// MARK: - Work Entry

public struct WorkEntry: Codable {
    public let location: Location?
    public let endDate: String?
    public let id: String
    public let name: String
    public let startDate: String
    public let url: String?
    public let positions: [Position]?

    public init(
        location: Location? = nil,
        endDate: String? = nil,
        id: String,
        name: String,
        startDate: String,
        url: String? = nil,
        positions: [Position]? = nil
    ) {
        self.location = location
        self.endDate = endDate
        self.id = id
        self.name = name
        self.startDate = startDate
        self.url = url
        self.positions = positions
    }
}

// MARK: - Education Entry

public struct EducationEntry: Codable {
    public let location: Location?
    public let area: String?
    public let url: String?
    public let endDate: String
    public let studyType: String
    public let id: String?
    public let startDate: String
    public let institution: String
    public let gpa: String?
    public let courses: [String]?

    public init(
        location: Location? = nil,
        area: String? = nil,
        url: String? = nil,
        endDate: String,
        studyType: String,
        id: String? = nil,
        startDate: String,
        institution: String,
        gpa: String? = nil,
        courses: [String]? = nil
    ) {
        self.location = location
        self.area = area
        self.url = url
        self.endDate = endDate
        self.studyType = studyType
        self.id = id
        self.startDate = startDate
        self.institution = institution
        self.gpa = gpa
        self.courses = courses
    }
}

// MARK: - Volunteer Position

public struct VolunteerPosition: Codable {
    public let id: String?
    public let url: String?
    public let name: String?
    public let project: String?
    public let position: String
    public let startDate: String?
    public let endDate: String?
    public let highlights: [String]?
    public let location: Location?

    public init(
        id: String? = nil,
        url: String? = nil,
        name: String? = nil,
        project: String? = nil,
        position: String,
        startDate: String? = nil,
        endDate: String? = nil,
        highlights: [String]? = nil,
        location: Location? = nil
    ) {
        self.id = id
        self.url = url
        self.name = name
        self.project = project
        self.position = position
        self.startDate = startDate
        self.endDate = endDate
        self.highlights = highlights
        self.location = location
    }
}

// MARK: - Volunteer Entry

public struct VolunteerEntry: Codable {
    public let location: Location?
    public let url: String?
    public let endDate: String?
    public let id: String?
    public let organization: String
    public let startDate: String?
    public let position: String?
    public let highlights: [String]?
    public let positions: [VolunteerPosition]?

    public init(
        location: Location? = nil,
        url: String? = nil,
        endDate: String? = nil,
        id: String? = nil,
        organization: String,
        startDate: String? = nil,
        position: String? = nil,
        highlights: [String]? = nil,
        positions: [VolunteerPosition]? = nil
    ) {
        self.location = location
        self.url = url
        self.endDate = endDate
        self.id = id
        self.organization = organization
        self.startDate = startDate
        self.position = position
        self.highlights = highlights
        self.positions = positions
    }
}
