tatort-graph
============

script for creating graphs based on tatort data.

![Screenshot](screenshot.png)

## Usage ##
1. `python tatort-graph.py --layout=sfdp ../tatort.json sfdp`
2. `inkscape sfdp.svg --export-png=sfdp.png`
3. `gdal2tiles.py -p raster -z 0-6 -w none sfdp.png`
