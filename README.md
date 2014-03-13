tatort-graph
============

script for creating graphs based on tatort data. [here](http://xsteadfastx.github.io/tatort-graph/sfdp.web.svg) you can see a example. 

![Screenshot](screenshot.png)

## Usage ##
`python tatort-graph.py svg --layout=sfdp ../tatort.json sfdp`

for web browsable svg files:

`python tatort-graph.py web sfdp.svg sfdp.web.svg`

## Based on ##
- graphviz
- pygraphviz
- [SVGPan_fixed](https://github.com/iascchen/SVGPan_fixed)
