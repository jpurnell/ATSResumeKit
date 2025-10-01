import Foundation

/// Formats CV data into ATS-compliant resume text
public struct ATSFormatter {

    public init() {}

    /// Formats a location as "City, State" or returns nil if no location data
    public func formatLocation(_ location: Location?) -> String? {
        guard let location = location else { return nil }

        var parts: [String] = []
        if let city = location.city { parts.append(city) }
        if let state = location.state { parts.append(state) }

        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }

    /// Formats a date range (e.g., "June 2020 - Present" or "June 2020 - May 2023")
    public func formatDateRange(startDate: String, endDate: String?) -> String {
        let end = endDate ?? "Present"
        return "\(startDate) - \(end)"
    }

    /// Formats the header section with name and contact info
    public func formatHeader(basics: Basics) -> String {
        var lines: [String] = []

        // Full name
        lines.append("\(basics.firstName) \(basics.lastName)")

        // Contact info on one line
        var contactInfo: [String] = []
        if let phone = basics.phone {
            contactInfo.append(phone)
        }
        contactInfo.append(basics.email)

        // Add LinkedIn if available
        if let linkedin = basics.socialProfiles?.first(where: { $0.network.lowercased() == "linkedin" }) {
            contactInfo.append(linkedin.url)
        }

        lines.append(contactInfo.joined(separator: "\n"))

        return lines.joined(separator: "\n")
    }

    /// Formats the professional summary section
    public func formatSummary(_ summaries: [Summary]?, summaryType: String? = nil) -> String? {
        guard let summaries = summaries, !summaries.isEmpty else { return nil }

        // Filter by summaryType if provided, otherwise take highest priority
        let filtered: [Summary]
        if let type = summaryType {
            filtered = summaries.filter { $0.summaryType == type }
        } else {
            filtered = summaries
        }

        guard let selected = filtered.sorted(by: { $0.priority < $1.priority }).first else {
            return nil
        }

        var output = "PROFESSIONAL SUMMARY\n"
        output += selected.summary.joined(separator: " ")

        return output
    }

    /// Formats work experience section
    public func formatWorkExperience(_ work: [WorkEntry]?) -> String? {
        guard let work = work, !work.isEmpty else { return nil }

        var output = "WORK EXPERIENCE\n"

        for company in work {
            if let positions = company.positions, !positions.isEmpty {
                // Company has multiple positions
                for position in positions {
                    let location = formatLocation(position.location ?? company.location)
                    let locationStr = location.map { ", \($0)" } ?? ""

                    output += "\(position.position) — \(company.name)\(locationStr) (\(formatDateRange(startDate: position.startDate, endDate: position.endDate)))\n"

                    // Add highlights as bullet points
                    if let highlights = position.highlights, !highlights.isEmpty {
                        for highlight in highlights {
                            output += "- \(highlight)\n"
                        }
                    }

                    output += "\n"
                }
            } else {
                // Simple work entry without positions
                let location = formatLocation(company.location)
                let locationStr = location.map { ", \($0)" } ?? ""

                output += "\(company.name)\(locationStr) (\(formatDateRange(startDate: company.startDate, endDate: company.endDate)))\n\n"
            }
        }

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Formats education section
    public func formatEducation(_ education: [EducationEntry]?) -> String? {
        guard let education = education, !education.isEmpty else { return nil }

        var output = "EDUCATION\n"

        for entry in education {
            let location = formatLocation(entry.location)
            let locationStr = location.map { ", \($0)" } ?? ""

            var degreeLine = "\(entry.studyType)"
            if let area = entry.area {
                degreeLine += " in \(area)"
            }
            degreeLine += " — \(entry.institution)\(locationStr) (\(formatDateRange(startDate: entry.startDate, endDate: entry.endDate)))"

            if let gpa = entry.gpa {
                degreeLine += " | GPA: \(gpa)"
            }

            output += "\(degreeLine)\n"

            // Add relevant courses if any
            if let courses = entry.courses, !courses.isEmpty {
                output += "Relevant Coursework: \(courses.joined(separator: ", "))\n"
            }

            output += "\n"
        }

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Formats skills section
    public func formatSkills(_ skills: [Skill]?) -> String? {
        guard let skills = skills, !skills.isEmpty else { return nil }

        var output = "SKILLS\n"

        let skillNames = skills.map { $0.name }
        output += skillNames.joined(separator: ", ")

        return output
    }

    /// Formats volunteer experience section
    public func formatVolunteerExperience(_ volunteer: [VolunteerEntry]?) -> String? {
        guard let volunteer = volunteer, !volunteer.isEmpty else { return nil }

        var output = "VOLUNTEER EXPERIENCE\n"

        for entry in volunteer {
            if let positions = entry.positions, !positions.isEmpty {
                for position in positions {
                    let location = formatLocation(position.location ?? entry.location)
                    let locationStr = location.map { ", \($0)" } ?? ""

                    var dateRange = ""
                    if let startDate = position.startDate {
                        dateRange = " (\(formatDateRange(startDate: startDate, endDate: position.endDate)))"
                    }

                    output += "\(position.position) — \(entry.organization)\(locationStr)\(dateRange)\n"

                    if let highlights = position.highlights, !highlights.isEmpty {
                        for highlight in highlights {
                            output += "- \(highlight)\n"
                        }
                    }

                    output += "\n"
                }
            } else {
                let location = formatLocation(entry.location)
                let locationStr = location.map { ", \($0)" } ?? ""

                var dateRange = ""
                if let startDate = entry.startDate {
                    dateRange = " (\(formatDateRange(startDate: startDate, endDate: entry.endDate)))"
                }

                var positionStr = ""
                if let position = entry.position {
                    positionStr = "\(position) — "
                }

                output += "\(positionStr)\(entry.organization)\(locationStr)\(dateRange)\n"

                if let highlights = entry.highlights, !highlights.isEmpty {
                    for highlight in highlights {
                        output += "- \(highlight)\n"
                    }
                }

                output += "\n"
            }
        }

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Formats publications section
    public func formatPublications(_ publications: [Publication]?) -> String? {
        guard let publications = publications, !publications.isEmpty else { return nil }

        var output = "PUBLICATIONS\n"

        for pub in publications {
            var pubLine = "\(pub.name)"
            if let publisher = pub.publisher {
                pubLine += ", \(publisher)"
            }
            pubLine += " (\(pub.releaseDate))"

            output += "\(pubLine)\n"

            if let highlights = pub.highlights, !highlights.isEmpty {
                for highlight in highlights {
                    output += "- \(highlight)\n"
                }
            }

            output += "\n"
        }

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
