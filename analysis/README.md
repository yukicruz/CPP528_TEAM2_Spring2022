# Analysis

This directory stores the source code that is used to migrate lab files as chapters that go onto to be displayed on the website. Each .rmd file that lives within this analysis/ directory serves as a direct input into the eventual .md files that go onto live within the _posts/ directory: the folder that stores the chapters hosted on your website.

## Requirements

This is where you will store the .rmd files that make up your "Chapters" that will eventually live within the _posts/ directory as .md files. Each .rmd file is a chapter and needs to be saved like this YYYY-MM-DD-chXX-short_name.rmd, where:

- YYYY is a four digit year (i.e. 2022),
- MM is a two digit month (i.e. 05 for May5)
- DD is a two digit day (i.e. 02 for the 2nd day)
- chXX references the chapter number (i.e. ch01 is the first chapter)

short_name is a placeholder and needs to replaced with something meaningful (i.e. descriptive_statistics)
The title that is displayed back to the user is what you store within the title: section in your YAML header within the .md file.

## YAML header must include a gfm variant of markdown output

Each .rmd file within analysis/ must have a YAML header that contains an explicit reference to the GitHub flavored markdown (gfm) variant of markdown as the output that the .rmd knits out. Said differently, rather than only knitting out an HTML, you need to have your .rmd file also knit out an .md file.

Upon closer inspection of the YAML header within 2022-05-02-ch01-example_page.rmd reveals that the file contains two outputs: an HTML document (courtesy of rmdformats::downcute()) and md_document.
