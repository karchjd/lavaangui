---
title: 'lavaangui: A graphical user interface for lavaan with integrated diagrammer'
tags:
  - R
  - psychology
  - visualization
  - path diagram
  - statistics
  - strucutral equation modeling
authors:
  - name: Julian D. Karch
    orcid: 0000-0002-1625-2822
    affiliation: "1" # (Multiple affiliations must be quoted)
affiliations:
 - name: Methodology and Statistics Department, Institute of Psychology, Leiden University, Leiden, the Netherlands
   index: 1
   ror: 00hx57361
date: 12 September 2024
bibliography: paper.bib
---

# Summary

Structural equation modeling (SEM) is a popular statistical technique within the social and behavioral sciences. 
Path diagrams facilitate the specification of Structural Equation Models because drawing them is often faster and less error-prone than specifying a model using equations or matrix algebra. lavaangui is a graphical user interface that allows specifying SEMs by drawing path diagrams. It is available as web application at https://lavaangui.org. Additionally, it can be installed as an R package and then supports creating interactive path diagrams from SEMs. A  tutorial is available at https://doi.org/10.31234/osf.io/f4ary.

# Statement of need

Traditionally, SEMs had to be specified using a specific modeling syntax, which created an unnecessary entry barrier for applied researchers. To remidy this, most current versions of closed-source commercial software packages, such as AMOS [@IBMAMOS26], Stata [@Stata18], Mplus [@MuthenMuthen2017], EQS [@Bentler2006EQS], and LISREL [@LISREL], support model specification through the drawing of path diagrams. These graphical user interfaces are typically referred to as diagrammers. While there are several open-source packages available for SEM [@sem; @lavaan; @neale2016openmx; @tidySEM; @igolkina2020semopy; @ernst2024structuralequationmodels; @von2015structural; @JASP2024; @jamovi2024], only $\Omega$nyx [@von2015structural] includes a diagrammer. However, $\Omega$nyx is standalone software and does not integrate well with other open-source statistical software, particularly R. A practical issue is that installing $\Omega$nyx requires administrator privileges, which many researchers lack. Additionally, $\Omega$nyx uses its own routine to fit SEMs instead of one of the more popular open-source packages. `lavaangui` addresses these limitations: it can be installed as an R package, accessed without installation via https://lavaangui.org on any computer with a browser, and uses `lavaan` as a backend for modeling fitting, which is arguably the most widely used open-source SEM software.

# Credits

`lavaangui` consists of a frontend and a backend. Most of the frontend is written in JavaScript, utilizing the Svelte framework. For drawing path diagrams, the Cytoscape.js [@franz2016cytoscape] library is used, along with extensions described in @Dogrusoz2018. The CSS framework is Bootstrap, and Bootbox.js is employed for displaying prompts. Parts of the frontend are written in R, using the `Shiny` [@Shiny] and `DT` [@DT] packages.

The backend is written in R, as a `Shiny` Server. The `lavaan` [@lavaan] package is used for fitting structural equation models. Some automatic layout algorithms are sourced from the semPlot [@epskamp2015semplot] package, while the promises [@promises] package enables asynchronous execution.
