import Foundation

/// Configuration for customizing resume output
public struct ResumeConfiguration {
    /// The type of summary to use (filters by summaryType)
    public var summaryType: String?

    /// Sections to include in the resume
    public var includedSections: Set<ResumeSection>

    /// Maximum number of work entries to include
    public var maxWorkEntries: Int?

    /// Maximum number of skills to include
    public var maxSkills: Int?

    /// Filter work entries by keywords (matches in position title or highlights)
    public var workKeywords: [String]?

    /// Filter skills by keywords
    public var skillKeywords: [String]?

    public init(
        summaryType: String? = nil,
        includedSections: Set<ResumeSection> = ResumeSection.allSections,
        maxWorkEntries: Int? = nil,
        maxSkills: Int? = nil,
        workKeywords: [String]? = nil,
        skillKeywords: [String]? = nil
    ) {
        self.summaryType = summaryType
        self.includedSections = includedSections
        self.maxWorkEntries = maxWorkEntries
        self.maxSkills = maxSkills
        self.workKeywords = workKeywords
        self.skillKeywords = skillKeywords
    }

    /// Default configuration including all sections
    public static let `default` = ResumeConfiguration()

    /// Configuration optimized for technical roles
    public static let technical = ResumeConfiguration(
        summaryType: "technical",
        includedSections: [.header, .summary, .work, .skills, .education],
        workKeywords: ["engineering", "developer", "architect", "technical", "software"]
    )

    /// Configuration optimized for management roles
    public static let management = ResumeConfiguration(
        summaryType: "management",
        includedSections: [.header, .summary, .work, .education, .skills],
        workKeywords: ["manager", "lead", "director", "strategy", "team"]
    )
}

/// Resume sections that can be included
public enum ResumeSection: String, CaseIterable, Hashable {
    case header
    case summary
    case work
    case education
    case skills
    case volunteer
    case publications

    public static let allSections: Set<ResumeSection> = Set(ResumeSection.allCases)
}

/// Main builder for generating ATS-compliant resumes
public class ResumeBuilder {
    private let cv: CV
    private let formatter: ATSFormatter

    public init(cv: CV) {
        self.cv = cv
        self.formatter = ATSFormatter()
    }

    /// Convenience initializer from JSON data
    public convenience init(jsonData: Data) throws {
        let decoder = JSONDecoder()
        let cv = try decoder.decode(CV.self, from: jsonData)
        self.init(cv: cv)
    }

    /// Convenience initializer from JSON file URL
    public convenience init(jsonFileURL: URL) throws {
        let data = try Data(contentsOf: jsonFileURL)
        try self.init(jsonData: data)
    }

    /// Generates a resume with the specified configuration
    public func build(configuration: ResumeConfiguration = .default) -> String {
        var sections: [String] = []

        // Header (always included)
        if configuration.includedSections.contains(.header) {
            sections.append(formatter.formatHeader(basics: cv.basics))
        }

        // Professional Summary
        if configuration.includedSections.contains(.summary) {
            if let summary = formatter.formatSummary(cv.summaries, summaryType: configuration.summaryType) {
                sections.append(summary)
            }
        }

        // Work Experience
        if configuration.includedSections.contains(.work) {
            let filteredWork = filterWork(cv.work, configuration: configuration)
            if let work = formatter.formatWorkExperience(filteredWork) {
                sections.append(work)
            }
        }

        // Education
        if configuration.includedSections.contains(.education) {
            if let education = formatter.formatEducation(cv.education) {
                sections.append(education)
            }
        }

        // Skills
        if configuration.includedSections.contains(.skills) {
            let filteredSkills = filterSkills(cv.skills, configuration: configuration)
            if let skills = formatter.formatSkills(filteredSkills) {
                sections.append(skills)
            }
        }

        // Volunteer Experience
        if configuration.includedSections.contains(.volunteer) {
            if let volunteer = formatter.formatVolunteerExperience(cv.volunteer) {
                sections.append(volunteer)
            }
        }

        // Publications
        if configuration.includedSections.contains(.publications) {
            if let publications = formatter.formatPublications(cv.publications) {
                sections.append(publications)
            }
        }

        return sections.joined(separator: "\n\n")
    }

    /// Generates multiple resume variants for different job types
    public func buildVariants() -> [String: String] {
        return [
            "default": build(configuration: .default),
            "technical": build(configuration: .technical),
            "management": build(configuration: .management)
        ]
    }

    // MARK: - Private Filtering Methods

    private func filterWork(_ work: [WorkEntry]?, configuration: ResumeConfiguration) -> [WorkEntry]? {
        guard var work = work else { return nil }

        // Filter by keywords if provided
        if let keywords = configuration.workKeywords, !keywords.isEmpty {
            work = work.compactMap { entry in
                var filteredEntry = entry

                // Filter positions within each work entry
                if let positions = entry.positions {
                    let filteredPositions = positions.filter { position in
                        matchesKeywords(
                            keywords,
                            in: [position.position] + (position.highlights ?? [])
                        )
                    }

                    if filteredPositions.isEmpty {
                        return nil
                    }

                    filteredEntry = WorkEntry(
                        location: entry.location,
                        endDate: entry.endDate,
                        id: entry.id,
                        name: entry.name,
                        startDate: entry.startDate,
                        url: entry.url,
                        positions: filteredPositions
                    )
                }

                return filteredEntry
            }
        }

        // Limit number of entries if specified
        if let maxEntries = configuration.maxWorkEntries, work.count > maxEntries {
            work = Array(work.prefix(maxEntries))
        }

        return work.isEmpty ? nil : work
    }

    private func filterSkills(_ skills: [Skill]?, configuration: ResumeConfiguration) -> [Skill]? {
        guard var skills = skills else { return nil }

        // Filter by keywords if provided
        if let keywords = configuration.skillKeywords, !keywords.isEmpty {
            skills = skills.filter { skill in
                matchesKeywords(keywords, in: [skill.name] + (skill.keywords ?? []))
            }
        }

        // Limit number of skills if specified
        if let maxSkills = configuration.maxSkills, skills.count > maxSkills {
            skills = Array(skills.prefix(maxSkills))
        }

        return skills.isEmpty ? nil : skills
    }

    private func matchesKeywords(_ keywords: [String], in strings: [String]) -> Bool {
        let lowercasedStrings = strings.map { $0.lowercased() }
        return keywords.contains { keyword in
            let lowercasedKeyword = keyword.lowercased()
            return lowercasedStrings.contains { $0.contains(lowercasedKeyword) }
        }
    }
}

// MARK: - Export Utilities

extension ResumeBuilder {
    /// Exports resume to a plain text file
    public func exportToText(
        configuration: ResumeConfiguration = .default,
        to url: URL
    ) throws {
        let resume = build(configuration: configuration)
        try resume.write(to: url, atomically: true, encoding: .utf8)
    }

    /// Exports multiple resume variants to text files
    public func exportVariants(to directoryURL: URL) throws {
        let variants = buildVariants()

        for (name, content) in variants {
            let fileURL = directoryURL.appendingPathComponent("\(name)_resume.txt")
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
}
