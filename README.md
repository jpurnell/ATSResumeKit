# ATSResumeKit

A Swift library for generating ATS (Applicant Tracking System) compliant resumes from structured CV data in JSON format.

## Features

- **Parse structured CV data** conforming to JSON schema
- **Generate ATS-friendly resumes** following industry best practices
- **Multiple resume variants** optimized for different job types (technical, management, etc.)
- **Flexible filtering** by keywords, skills, and experience
- **Customizable sections** to tailor resumes for specific applications
- **Export to plain text** format compatible with ATS systems

## Installation

### Swift Package Manager

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/jpurnell/ATSResumeKit", from: "1.0.0")
]
```

## Usage

### Basic Usage

```swift
import ATSResumeKit

// Load CV from JSON file
let cvURL = URL(fileURLWithPath: "cv.json")
let builder = try ResumeBuilder(jsonFileURL: cvURL)

// Generate default resume
let resume = builder.build()
print(resume)
```

### Custom Configuration

```swift
// Create custom configuration
let config = ResumeConfiguration(
    summaryType: "technical",
    includedSections: [.header, .summary, .work, .skills, .education],
    maxWorkEntries: 5,
    workKeywords: ["Swift", "iOS", "engineering"]
)

let resume = builder.build(configuration: config)
```

### Generate Multiple Variants

```swift
// Generate default, technical, and management variants
let variants = builder.buildVariants()

for (name, content) in variants {
    print("=== \(name.uppercased()) ===")
    print(content)
    print("\n")
}
```

### Export to File

```swift
// Export single resume
let outputURL = URL(fileURLWithPath: "resume.txt")
try builder.exportToText(configuration: .technical, to: outputURL)

// Export all variants
let outputDir = URL(fileURLWithPath: "resumes/")
try builder.exportVariants(to: outputDir)
// Creates: default_resume.txt, technical_resume.txt, management_resume.txt
```

### Programmatic CV Creation

```swift
import ATSResumeKit

let location = Location(city: "San Francisco", state: "CA")
let basics = Basics(
    phone: "(555) 123-4567",
    firstName: "Jane",
    location: location,
    socialProfiles: [
        SocialProfile(
            username: "janedoe",
            url: "https://linkedin.com/in/janedoe",
            network: "LinkedIn"
        )
    ],
    email: "jane.doe@example.com",
    lastName: "Doe"
)

let summary = Summary(
    priority: 1,
    summaryType: "technical",
    summary: [
        "Senior software engineer with 8+ years of experience building scalable applications.",
        "Expertise in Swift, iOS development, and cloud architecture."
    ]
)

let position = Position(
    id: "1",
    startDate: "June 2020",
    position: "Senior iOS Engineer",
    highlights: [
        "Led development of flagship mobile app with 1M+ downloads",
        "Reduced crash rate by 60% through improved error handling",
        "Mentored team of 5 junior developers"
    ]
)

let work = WorkEntry(
    location: location,
    id: "1",
    name: "Tech Innovations Inc",
    startDate: "June 2020",
    positions: [position]
)

let cv = CV(
    id: "1",
    basics: basics,
    summaries: [summary],
    skills: [
        Skill(id: "1", level: "Expert", name: "Swift"),
        Skill(id: "2", level: "Expert", name: "iOS Development"),
        Skill(id: "3", level: "Advanced", name: "SwiftUI")
    ],
    work: [work]
)

let builder = ResumeBuilder(cv: cv)
let resume = builder.build()
```

## Configuration Options

### ResumeConfiguration

- `summaryType`: Filter summaries by type (e.g., "technical", "management")
- `includedSections`: Set of sections to include (header, summary, work, education, skills, volunteer, publications)
- `maxWorkEntries`: Limit number of work experience entries
- `maxSkills`: Limit number of skills displayed
- `workKeywords`: Filter work experience by keywords
- `skillKeywords`: Filter skills by keywords

### Pre-defined Configurations

```swift
// Include all sections
ResumeConfiguration.default

// Optimized for technical roles
ResumeConfiguration.technical

// Optimized for management roles
ResumeConfiguration.management
```

## Resume Sections

The library supports the following sections:

- **Header**: Name, contact info, LinkedIn
- **Professional Summary**: Brief overview of experience and skills
- **Work Experience**: Job history with positions, dates, and achievements
- **Education**: Degrees, institutions, and graduation dates
- **Skills**: Technical and professional skills
- **Volunteer Experience**: Community involvement and volunteer work
- **Publications**: Academic or professional publications

## ATS Compliance

The library follows ATS best practices:

- Simple, clean text formatting
- Standard section headings
- Consistent date formats (Month/Year - Month/Year)
- Bullet points for lists
- No special characters or graphics
- Easy-to-parse structure

## JSON Schema

Your CV data should conform to the provided `schema.json`. Key structures:

```json
{
  "id": "unique-id",
  "basics": {
    "firstName": "Jane",
    "lastName": "Doe",
    "email": "jane@example.com",
    "phone": "(555) 123-4567",
    "location": {
      "city": "San Francisco",
      "state": "CA"
    }
  },
  "summaries": [
    {
      "priority": 1,
      "summaryType": "technical",
      "summary": ["Your professional summary here."]
    }
  ],
  "work": [...],
  "education": [...],
  "skills": [...]
}
```

## License

MIT

## Contributing

Contributions welcome! Please submit pull requests or open issues for bugs and feature requests.
