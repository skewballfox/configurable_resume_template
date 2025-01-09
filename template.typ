#let setrules(uservars,doc) = {
  set text(
    font: uservars.bodyfont,
    size: uservars.fontsize,
    hyphenate: false
  )
  set list(
    spacing: uservars.linespacing,
  )
  set par(
    leading: uservars.linespacing,
    justify: true,
  )
  doc
}

#let show_rules(uservars,doc) = {
  // Uppercase Section Headings
    show heading.where(
        level: 2,
    ): it => block(width: 100%)[
        #set align(left)
        #set text(font: uservars.headingfont, size: 1em, weight: "bold")
        #upper(it.body)
        #v(-0.75em) #line(length: 100%, stroke: 1pt + black) // Draw a line
    ]

    // Name Title
    show heading.where(
        level: 1,
    ): it => block(width: 100%)[
        #set text(font: uservars.headingfont, size: 1.5em, weight: "bold")
        #upper(it.body)
        #v(2pt)
    ]

    doc
}



#let anonymize(d) = {
  
  let anon_data = (
    name: "John Doe",
    phone: "123-456-7890",
    email: "john.doe@example.com",
    linkedin: "linkedin.com/in/johndoe",
    github: "github.com/johndoe",
    site: "example.com"
  )
  
  for k in d.keys() {
    if k in anon_data { d.insert(k,anon_data.at(k)) }
  }
  
  
  d

}

#let anonymize_education(education, name_map: (:)) ={
  
  let university_count = 1
  let new_education = ()
  for edu in education {
    if edu.name not in name_map {
      name_map.insert(edu.name, "University " + str(university_count))
      university_count = university_count + 1
    }
    edu.name =  name_map.at(edu.name)
    new_education.push(edu)
  }
  new_education
}

#let anonymize_experience(experience, name_map: (:)) = {
  let job_count = 1
  let new_experience = ()
  for exp in experience {
    if exp.name not in name_map {
      name_map.insert(edu.name, "Company " + str(job_count))
      job_count = job_count + 1
    }
    exp.name =  name_map.at(exp.name)
    new_experience.push(exp)
  }
  new_experience
}

#let anonymize_projects(projects, name_map: (:)) = {
  let project_count = 1
  let new_projects = ()
  for proj in projects {
    if proj.name not in name_map {
      name_map.insert(proj.name, "Project " + str(project_count))
      project_count = project_count + 1
    }
    proj.name =  name_map.at(proj.name)
    new_projects.push(proj)
  }
  new_projects
}



#let name_header(name) = {
  set text(size: 2.25em)
  [*#name*]
}

#let norm_link(url) = {
  let txt = if url.starts-with("https://") { url.slice(8) } else if url.starts-with("http://") { url.slice(7) } else { url }
  if txt.starts-with("www.") { txt = txt.slice(4) }
  let url = if url.starts-with("https://") { url } else if url.starts-with("http://") { url.insert(4, "s") } else { str("https://" + url) }
  link(url)[#txt]
}

/// Given a dictionary with a field "name", return a link if the dictionary has a field "url" or just the name otherwise
#let embed_name(d) = {
  if "url" in d and d.url!=none [ #link(d.url)[#d.name] ] else [ #d.name ]
}

/// Returns a list of fake contact info for 
#let anon_info(d) = {
  let contact_info=()
  for k in d.keys() {
    if k!="name" { contact_info.push(k) }
  }
  if "phone" in d { contact_info.push("123-456-7890")}
  if "email" in d { contact_info.push("john.doe@example.com")}
  if "linkedin" in d { contact_info.push("linkedin.com/in/johndoe") }
  if "github" in d { contact_info.push("github.com/johndoe") }
  if "site" in d { contact_info.push("example.com") }
  return contact_info
}

#let contact_info(
  d
) = {
  //if c.anonymize { return anon_info(d) }
  let contact_info=()
  if "phone" in d and d.phone!=none { contact_info.push(d.phone)}
  if "email" in d and d.email!=none { contact_info.push(link("mailto:" + d.email)[#d.email])}
  for k in ("linkedin", "github", "site") {
    if k in d and d.at(k)!=none { contact_info.push(norm_link(d.at(k))) }
  }
  return contact_info
}





#let resume_heading(txt) = {
  show heading: set text(size: 0.92em, weight: "regular")

  block[
    = #smallcaps(txt)
    #v(-4pt)
    #line(length: 100%, stroke: 1pt + black)
  ]
}
#let parsedate(s) = toml.decode("date = "+s).date.display("[month repr:short] [year]")

#let getdatestr(d) = {
  if "endDate" in d and d.endDate!=none [ 
  #if "startDate" in d and d.startDate!=none [
    #parsedate(d.startDate) -
  ]
  #if d.endDate!="present" [#parsedate(d.endDate)] else [Present]
  ]
}


#let edu_item(
  edu: (
    name: "Sample University", 
    degree: "Bachelor of Arts",
    major: "Bullshit Engineering",
    minor: "Marketing",
    location: "Foo, BA", 
    startDate: "1600-08-01",
    endDate: "1750-05-01",
    courses: ("Course 1", "Course 2", "Course 3")
  )
) = {

  
  let degree = {
    let deg = edu.degree
  if "major" in edu { deg = deg + " in " + edu.major }
  if "minor" in edu { deg = deg + ", minor in " + edu.minor }
  deg
  }
  set block(above: 0.7em)
  block(width: 100%, breakable: false)[
    *#embed_name(edu)* #h(1fr) #edu.location\
    _#degree _ #h(1fr) _#getdatestr(edu)_\
  ]
  if "courses" in edu [ #list(strong("Courses")+": "+edu.courses.join(", ")) ]
}

#let exp_item(
  exp: (
    position: "Worker",
    name: "Sample Workplace",
    location: "Foo, BA",
    startDate: "1837-06-01",
    endDate: "1845-05-01",
    hours: 40,
    highlights: ("Did a thing", "Did another thing")
  )
) = {
    set block(above: 0.7em)
    pad(left: 1em, right: 0.5em, box[
      #grid(
        columns: (3fr, 1fr),
        align(left)[
          *#exp.position* \
          _#embed_name(exp)_
        ],
        align(right)[
          #getdatestr(exp) \
          _#exp.location _
        ]
      )
      #if "hours" in exp [ #exp.hours *Hours/Week* ]
      #list(..exp.highlights)
    ])
}

#let project_item(
  name: "Example Project",
  skills: ("Programming Language 1", "Database3"),
  date: "May 1234 - June 4321",
  ..highlights
) = {
  set block(above: 0.7em, below: 1em)
  pad(left: 1em, right: 0.5em, box[
    *#name* #if skills != none [| _#skills _] #h(1fr) #date
    #list(..highlights)
  ])
}
#let show_skills(skills) = str(skills.join(", "))
  
#let skill_item(
  category: "Skills",
  skills: ("Balling", "Yoga", "Valorant"),
) = {
  set block(above: 0.7em)
  set text(size: 0.91em)
  if type(skills) != "array" [ #panic("skills must be an array") ]
  if skills == [] [ #panic("skills must not be empty") ]
  pad(left: 1em, right: 0.5em, block[*#category*: #show_skills(skills) ])
}


#let cvpersonal(personal) = {
  
  align(center,
    block[
      #name_header(personal.name)\
      #contact_info(personal).join(" | ")
    ]
  )
  v(5pt)
}

#let cveducation(d) = {
  [== Education]
  for edu in d {
    edu_item(
      edu: edu,
    )
  }
}

#let cvexperience(d) = {
  [== Experience]
  for exp in d {
    exp_item(
      exp: exp,
    )
  }
}

#let cvprojects(d) = {
  [== Projects & Contributions]
  for proj in d {
    project_item(
      name: proj.name,
      skills: if "skills" in proj [ #proj.skills.join(", ") ],
      date: getdatestr(proj),
      ..proj.highlights
    )
  }
}

#let cvskills(d) = {
  [== Skills]
  for skill in d {
    skill_item(
      category: skill.category,
      skills: skill.skills
    )
  }
}

#let getresumedata(config, ..sources) = {
  let data = (:)
  for source in config.sources {
    
    data = data + yaml(source)
  }
  if config.anonymize {
    data.personal = anonymize(data.personal)
    if "anon_map_source" in config {
      let anon_map = yaml(config.anon_map_source)
      
      data.education = anonymize_education(data.education, name_map: anon_map.education)
      data.experience = anonymize_experience(data.experience, name_map: anon_map.experience)
      data.projects = anonymize_projects(data.projects, name_map: anon_map.projects)
    } else {
      data.education = anonymize_education(data.education)
      data.experience = anonymize_experience(data.experience)
    } 
    
  }

  
  if not config.show_courses {
    data.education = data.education.map(edu => {
      if "courses" in edu {
        let _=edu.remove("courses")
      }
      edu

  })
  }

  if not config.gov {
    data.experience = data.experience.map(exp => {
      if "hours" in exp {
        let _=exp.remove("hours")
      }
      exp
    })
  }
  data
}
