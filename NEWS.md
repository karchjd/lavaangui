# lavaangui 0.3.1
- Bugfix: New lines in syntax are now more consistent


# lavaangui 0.3.0
-	Added: Allow renaming of nodes and edges in plot_lavaan.
-	Added: Switch latent variable appearance between ellipse and rectangle.
-	Added: Change fixed values in the context menu.
-	Added: Directed arrow from latent to observed variable can be marked as a factor loading or regression coefficient.
-	Added: Line style can be changed between solid, dashed, and dotted.
- Added: Latent variables can also be displayed as hexagons
- Bugfix: Width of dialog windows is now more reasonable. Was caused by a CSS bug.
- Bugfix: Indentation of intercept syntax is correct now.
- Bugfix: Hotkey that deactivates drawing is now listened to everywhere.
- Bugfix: plot_lavaan now works also if do.fit = FALSE.
- Playwright testing is only done on the local version now.
- Switched to lavaan 0.6-20 for the webserver versions.

# lavaangui 0.2.6
- Bugfix: `plot_lavaan()` after `efa` is now working
- Bugfix: Avoid crashing when data("estimates") for an edge is undefined
- Added: renv for deployed version
- Added: display of `lavaan` version number in app


# lavaangui 0.2.5
- Bugfix: Standardized results were not displayed correctly for fixed edges, see https://github.com/karchjd/lavaangui/issues/83

# lavaangui 0.2.4
- Bugfix: Label move, node move, and edge bend interactions no longer cause issues.
- Bugfix: Invalid variables can no longer be entered via the drag-and-drop menu.
= Bugfix: Disabled king edges due to conflicts with the label move algorithm.

# lavaangui 0.2.3
- First version automatic undirected edge bend
- Multiple bug fixes

# lavaangui 0.2.2
- Renamed Download to Save
- Fixed bug that enforced fixed values to be integers

# lavaangui 0.2.1
Multiple bug fixes:
- Undirected arrows no longer change orientation when added to the user model.  
- Renamed "Automatically.." to "Automatically...".  
- Fixed a bug in the code for changing the orientation of loops.

# lavaangui 0.2.0-online
- Enabled the cancel button only for shinyapps.io again

# lavaangui 0.2.0
- Temporarily disabled the cancel button on shinyapps.io due to technical reasons.
- Bugfix: Bootstrap + ordered now works.
- Overly long node names are now automatically abbreviated.
- Removed buggy edge reconnection feature.
- Moved "Mean" options menu into the "Automatically" menu to better convey its functionality.
- Ordinal variables now work for all tested models; included the `auto.th` and `auto.delta` options; added DWLS estimator.
- Data upload now supports a wider range of CSV files.
- Added an auto-save feature to prevent data loss on timeout.
- Data preparation for download has been speed up by 10x.
- Bugfix in hashing functions for caching.
- Improved file upload, now with a status bar.
- The hide/show status of elements is now saved to the file.
- Renamed `plot_interactive` to `plot_lavaan`.
- `plot_lavaan`: Bugfix for multiple groups.
- Removed dependencies on `qgraph` and `htmlwidgets`.

# lavaangui 0.1.2
- Initial CRAN submission.