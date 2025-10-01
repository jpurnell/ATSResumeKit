import Foundation
import ATSResumeKit

// Example 1: Load CV from JSON file and generate default resume
func example1() throws {
    print("=== EXAMPLE 1: Basic Usage ===\n")

    let cvURL = URL(fileURLWithPath: "Examples/example.json")
    let builder = try ResumeBuilder(jsonFileURL: cvURL)

    let resume = builder.build()
    print(resume)
    print("\n\n")
}

// Example 2: Generate resume with custom configuration
func example2() throws {
    print("=== EXAMPLE 2: Custom Configuration ===\n")

    let cvURL = URL(fileURLWithPath: "Examples/example.json")
    let builder = try ResumeBuilder(jsonFileURL: cvURL)

    // Create custom configuration for technical role
    let config = ResumeConfiguration(
        summaryType: "technical",
        includedSections: [.header, .summary, .work, .skills, .education],
        maxWorkEntries: 2,
        workKeywords: ["iOS", "Swift", "engineer"]
    )

    let resume = builder.build(configuration: config)
    print(resume)
    print("\n\n")
}

// Example 3: Generate multiple variants
func example3() throws {
    print("=== EXAMPLE 3: Multiple Variants ===\n")

    let cvURL = URL(fileURLWithPath: "Examples/example.json")
    let builder = try ResumeBuilder(jsonFileURL: cvURL)

    let variants = builder.buildVariants()

    for (name, content) in variants.sorted(by: { $0.key < $1.key }) {
        print("--- \(name.uppercased()) RESUME ---\n")
        print(content)
        print("\n\n")
    }
}

// Example 4: Export resumes to files
func example4() throws {
    print("=== EXAMPLE 4: Export to Files ===\n")

    let cvURL = URL(fileURLWithPath: "Examples/example.json")
    let builder = try ResumeBuilder(jsonFileURL: cvURL)

    // Create output directory
    let outputDir = URL(fileURLWithPath: "Examples/output")
    try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

    // Export all variants
    try builder.exportVariants(to: outputDir)

    print("Resumes exported to \(outputDir.path)/")
    print("- default_resume.txt")
    print("- technical_resume.txt")
    print("- management_resume.txt")
    print("\n\n")
}

// Example 5: Programmatically create CV and generate resume
func example5() throws {
    print("=== EXAMPLE 5: Programmatic CV Creation ===\n")

    let location = Location(city: "Austin", state: "TX")
    let basics = Basics(
        phone: "(555) 987-6543",
        firstName: "John",
        location: location,
        socialProfiles: [
            SocialProfile(
                username: "johnsmith",
                url: "https://linkedin.com/in/johnsmith",
                network: "LinkedIn"
            )
        ],
        email: "john.smith@example.com",
        lastName: "Smith"
    )

    let summary = Summary(
        priority: 1,
        summaryType: "general",
        summary: [
            "Product manager with 5+ years of experience launching successful mobile and web applications.",
            "Proven track record of driving product strategy and collaborating with engineering teams."
        ]
    )

    let position = Position(
        id: "1",
        startDate: "March 2021",
        position: "Senior Product Manager",
        highlights: [
            "Launched 3 major product features resulting in 40% user growth",
            "Managed product roadmap and prioritized feature development",
            "Collaborated with engineering, design, and marketing teams"
        ]
    )

    let work = WorkEntry(
        location: Location(city: "Austin", state: "TX"),
        id: "1",
        name: "Innovative Products Co",
        startDate: "March 2021",
        positions: [position]
    )

    let education = EducationEntry(
        area: "Business Administration",
        endDate: "May 2018",
        studyType: "Master of Business Administration",
        startDate: "September 2016",
        institution: "University of Texas"
    )

    let cv = CV(
        id: "1",
        basics: basics,
        summaries: [summary],
        skills: [
            Skill(id: "1", level: "Expert", name: "Product Strategy"),
            Skill(id: "2", level: "Expert", name: "Agile Development"),
            Skill(id: "3", level: "Advanced", name: "Data Analysis"),
            Skill(id: "4", level: "Advanced", name: "User Research")
        ],
        work: [work],
        education: [education]
    )

    let builder = ResumeBuilder(cv: cv)
    let resume = builder.build()

    print(resume)
    print("\n\n")
}

// Example 6: Filter skills by keywords
func example6() throws {
    print("=== EXAMPLE 6: Skill Filtering ===\n")

    let cvURL = URL(fileURLWithPath: "Examples/example.json")
    let builder = try ResumeBuilder(jsonFileURL: cvURL)

    // Create configuration that only shows iOS/Swift related skills
    let config = ResumeConfiguration(
        includedSections: [.header, .skills],
        skillKeywords: ["Swift", "iOS", "Testing"]
    )

    let resume = builder.build(configuration: config)
    print(resume)
    print("\n\n")
}

// Run all examples
do {
    try example1()
    try example2()
    try example3()
    try example4()
    try example5()
    try example6()
} catch {
    print("Error: \(error)")
}
