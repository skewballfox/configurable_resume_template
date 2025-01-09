# Configurable Resume Template

Based off Jake's resume template. Modified from [NNJR](https://github.com/tzx/NNJR) and an older version of [imprecv](https://github.com/jskherman/imprecv). I wanted to make it easy to generate resumes tailored to different job types, and to quickly anonymize my resume when requesting feedback.

## Configuration Options

### So far

- anonymize: whether to replace contact info, universities, companies, and projects with placeholders
- show_course: whether to show courses for degrees earned
- gov: display fields generally only desired for applying to government jobs, such as hours per week

### Planned

- headerless: remove header entirely for anonymization (for Dice)
- courses: Instead of showing all courses, list an amount (to keep page lenght to 1).
- gpa: whether to show GPA
- merge strategy: when providing multiple yml sources, make the conflict behavior configurable
