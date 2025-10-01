import XCTest
@testable import ATSResumeKit

final class ATSResumeKitTests: XCTestCase {

    func testBasicResumeGeneration() throws {
        // Create sample CV data
        let location = Location(city: "San Francisco", state: "CA")
        let basics = Basics(
            phone: "(555) 123-4567",
            firstName: "Jane",
            location: location,
            email: "jane.doe@example.com",
            lastName: "Doe"
        )

        let summary = Summary(
            priority: 1,
            summaryType: "general",
            summary: ["Experienced software engineer with 5+ years building scalable applications.", "Passionate about clean code and user experience."]
        )

        let skill1 = Skill(id: "1", level: "Expert", name: "Swift")
        let skill2 = Skill(id: "2", level: "Advanced", name: "iOS Development")

        let position = Position(
            id: "1",
            startDate: "January 2020",
            position: "Senior Software Engineer",
            highlights: [
                "Led development of new mobile app features",
                "Reduced crash rate by 40%"
            ]
        )

        let workEntry = WorkEntry(
            location: Location(city: "San Francisco", state: "CA"),
            id: "1",
            name: "Tech Company Inc",
            startDate: "January 2020",
            positions: [position]
        )

        let education = EducationEntry(
            area: "Computer Science",
            endDate: "May 2018",
            studyType: "Bachelor of Science",
            startDate: "September 2014",
            institution: "State University"
        )

        let cv = CV(
            id: "1",
            basics: basics,
            summaries: [summary],
            skills: [skill1, skill2],
            work: [workEntry],
            education: [education]
        )

        // Build resume
        let builder = ResumeBuilder(cv: cv)
        let resume = builder.build()

        // Verify key sections are present
        XCTAssertTrue(resume.contains("Jane Doe"))
        XCTAssertTrue(resume.contains("jane.doe@example.com"))
        XCTAssertTrue(resume.contains("PROFESSIONAL SUMMARY"))
        XCTAssertTrue(resume.contains("WORK EXPERIENCE"))
        XCTAssertTrue(resume.contains("EDUCATION"))
        XCTAssertTrue(resume.contains("SKILLS"))
        XCTAssertTrue(resume.contains("Senior Software Engineer"))
        XCTAssertTrue(resume.contains("Tech Company Inc"))
    }

    func testCustomConfiguration() throws {
        let location = Location(city: "Boston", state: "MA")
        let basics = Basics(
            firstName: "John",
            location: location,
            email: "john@example.com",
            lastName: "Smith"
        )

        let cv = CV(id: "1", basics: basics)

        let builder = ResumeBuilder(cv: cv)

        // Test custom configuration with only header
        let config = ResumeConfiguration(includedSections: [.header])
        let resume = builder.build(configuration: config)

        XCTAssertTrue(resume.contains("John Smith"))
        XCTAssertFalse(resume.contains("WORK EXPERIENCE"))
        XCTAssertFalse(resume.contains("EDUCATION"))
    }

    func testWorkFiltering() throws {
        let location = Location(city: "Seattle", state: "WA")
        let basics = Basics(
            firstName: "Alice",
            location: location,
            email: "alice@example.com",
            lastName: "Johnson"
        )

        let engineeringPosition = Position(
            id: "1",
            startDate: "June 2021",
            position: "Software Engineer",
            highlights: ["Built scalable microservices"]
        )

        let marketingPosition = Position(
            id: "2",
            startDate: "June 2019",
            position: "Marketing Coordinator",
            highlights: ["Managed social media campaigns"]
        )

        let workEntry = WorkEntry(
            id: "1",
            name: "Diverse Company",
            startDate: "June 2019",
            positions: [engineeringPosition, marketingPosition]
        )

        let cv = CV(
            id: "1",
            basics: basics,
            work: [workEntry]
        )

        let builder = ResumeBuilder(cv: cv)

        // Filter for engineering keywords
        let config = ResumeConfiguration(
            includedSections: [.header, .work],
            workKeywords: ["engineer", "software"]
        )

        let resume = builder.build(configuration: config)

        XCTAssertTrue(resume.contains("Software Engineer"))
        XCTAssertFalse(resume.contains("Marketing Coordinator"))
    }

    func testDateFormatting() {
        let formatter = ATSFormatter()

        let range1 = formatter.formatDateRange(startDate: "June 2020", endDate: "May 2023")
        XCTAssertEqual(range1, "June 2020 - May 2023")

        let range2 = formatter.formatDateRange(startDate: "June 2020", endDate: nil)
        XCTAssertEqual(range2, "June 2020 - Present")
    }

    func testLocationFormatting() {
        let formatter = ATSFormatter()

        let location1 = Location(city: "New York", state: "NY")
        XCTAssertEqual(formatter.formatLocation(location1), "New York, NY")

        let location2 = Location(city: "Boston")
        XCTAssertEqual(formatter.formatLocation(location2), "Boston")

        let location3 = Location()
        XCTAssertNil(formatter.formatLocation(location3))
    }

    func testVariantGeneration() throws {
        let location = Location(city: "Austin", state: "TX")
        let basics = Basics(
            firstName: "Bob",
            location: location,
            email: "bob@example.com",
            lastName: "Williams"
        )

        let technicalSummary = Summary(
            priority: 1,
            summaryType: "technical",
            summary: ["Technical expert in cloud architecture."]
        )

        let managementSummary = Summary(
            priority: 2,
            summaryType: "management",
            summary: ["Experienced team leader and strategist."]
        )

        let cv = CV(
            id: "1",
            basics: basics,
            summaries: [technicalSummary, managementSummary]
        )

        let builder = ResumeBuilder(cv: cv)
        let variants = builder.buildVariants()

        XCTAssertEqual(variants.count, 3)
        XCTAssertNotNil(variants["default"])
        XCTAssertNotNil(variants["technical"])
        XCTAssertNotNil(variants["management"])

        // Technical variant should contain technical summary
        XCTAssertTrue(variants["technical"]!.contains("Technical expert"))
    }
}
