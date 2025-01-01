
#import "template.typ": setrules, show_rules, getresumedata,cvpersonal, cveducation, cvexperience, cvprojects, cvskills

#let docsettings = (
  headingfont: "Calibri",
  bodyfont: "Calibri",
  fontsize: 10pt,
  linespacing: 6pt,
)
  
#let config = (
  //if true, will replace contact info with placeholders
  anonymize: false,
  //generally government sites want things like hours per week
  gov: false,
  //whether to include coursework, if applicable
  show_courses: true,
  //source(s) of resume data
  sources: ( "general_data.yml", ),
)

#let customrules(doc) = {
  // Add custom document style rules here
  set page(
    paper: "us-letter", // a4, us-letter
    //numbering: "1 / 1",
    number-align: center, // left, center, right
    margin: 1.0cm, // 1.25cm, 1.87cm, 2.5cm
  )
  doc
}

#let cvinit(doc) = {
  doc = setrules(docsettings, doc)
  doc = show_rules(docsettings, doc)
  doc = customrules(doc)
  doc
}

#let data = getresumedata(config)

#show: doc => cvinit(doc)
  

#cvpersonal(data.personal)
#cveducation(data.education)
#cvexperience(data.experience)
#cvprojects(data.projects)
#cvskills(data.skills)

