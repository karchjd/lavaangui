# lavaangui 0.2.0

- Temporarily disabled the cancel button on shinyapps.io due to technical reasons.
- Bugfix: Bootstrap + ordered now works.
- Overly long node names are now automatically abbreviated.
- Removed buggy edge reconnection feature.
- Moved "Mean" options menu into the "Automatically" menu to better convey its functionality.
- Ordinal variables now work for all tested models; included the `auto.th` and `auto.delta` options; added DWLS estimator.
- Data upload now supports a wider range of CSV files.
- Added an auto-save feature to prevent data loss on timeout.
- Data preparation for download has been sped up by 10x.
- Bugfix in hashing functions for caching.
- Improved file upload, now with a status bar.
- The hide/show status of elements is now saved to the file.
- `plot_lavaan`: Bugfix for multiple groups.
- Renamed `plot_interactive` to `plot_lavaan`.
- Removed dependencies on qgraph and htmlwidgets.

# lavaangui 0.1.2

* Initial CRAN submission.


