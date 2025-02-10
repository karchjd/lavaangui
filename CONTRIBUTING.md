# Contributing to lavaangui

First of all, thank you for considering contributing to lavaangui! Your time and effort are appreciated, and I want to make the process as simple and clear as possible. This document outlines the process for contributing to our project. By contributing to this project, you agree to abide by to the [Contributor Code of Conduct](CODE_OF_CONDUCT.md)


### 1. Reporting Bugs

If you've found a bug in the project, please open an issue on GitHub and include:
- Clear steps to reproduce the problem.
- Your environment setup (most importantly: version of lavaangui, your browser, and operating system).
- Any relevant log or error messages.

### 2. Feature Requests

I welcome feature requests! If you have an idea for a feature, please open a GitHub issue that includes:
- A clear description of the feature.
- Why you think it’s beneficial for the project.
- Any examples or mockups if applicable.

### 3. Pull Requests

When submitting a pull request (PR), please adhere to the following guidelines:

#### Before Starting

1. Ensure there is an open issue that addresses the problem/feature you are working on. Thus, if there is not already an issue, please open an issue.
2. Fork the repository and create your branch from the `main` branch.

### Building

To build a new version of lavaangui, you can use the [compile_restart_dev.R](dev/compile_restart_dev.R) file. If you need assistance in installing and setting up the required software for this, please contact me. 

#### Testing

- Add unit or integration tests for any new feature or fix.
- Make sure the existing tests pass, that is, the R-CMD-check, and playwright-test Github action. In case you need guidance on how to run those locally, please contact me.

#### Pull Request Process

1. Submit your pull request from your forked branch.
2. Describe the purpose of the pull request, referencing any issues it addresses.
3. Ensure your PR is focused and does not contain unrelated changes.
4. Be responsive to feedback and make necessary changes.

### 4. Documentation Improvements

If you find typos or areas where documentation is lacking, feel free to submit PRs for those. Documentation contributions are just as important as code contributions!

## Getting Started

### Install Prerequesites

- R https://cran.r-project.org/
- Node.js https://nodejs.org/en/download
- Front-end dependencies: Run `npm run install` from a shell in the src/ folder.
- Back-end dependencies: Execute `devtools::install_local(dependencies = TRUE)` in R, with the working directory set to the root folder of the package.

### Compile 
The file https://github.com/karchjd/lavaangui/blob/main/dev/compile_restart_dev.R compiles the front-end and starts the app locally in your browser.

## Code of Conduct

Please note that this project adheres to the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/). By participating, you are expected to uphold this code.

## Questions?

If you have any questions, feel free to reach out by opening an issue. I am happy to help!
