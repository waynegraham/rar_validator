# README

This is a quick tool for testing if online resources from CLIR-sponsored grants are available.

## Dependencies

-   [Ruby](https://www.ruby-lang.org/): On macOS, use [homebrew](https://brew.sh/) to install (`brew install ruby`)

## Setup

-   Create a projects directory (`mkdir -p ~/projects/`)
-   Change in to the projects directory (`cd ~/projects`)
-   Clone the github repository (`git clone https://github.com/waynegraham/rar_validator.git`)
-   Change in to the `rar_validator` directory (`cd rar_validator`)
-   Install the dependencies (`bundle install`)

## Running

-   Place any new manifests in the `_data/` directory.
-   Ensure the spreadsheet is filled out properly. There's still a lot of work to **validate** the spreadsheet, but if there are problems in the manifest spreadsheets, you will get errors.
-   Run the rake task (`rake reports:manifests`)
-   Check out the result (`jekyll serve --config "_config.yml,_config.dev.yml"`)

The rake tasks will run software to parse the items on the spreadsheet and attempt to reach files that are marked as unrestricted, and are valid URLs (e.g. they start with **http**). Network paths (that start with letters) are not accessible via the Internet and will not be checked.

## Running Locally

  jekyll serve -l --config "\_config.yml,\_config.dev.yml"
