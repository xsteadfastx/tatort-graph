'''
Usage:
    tatort-graph.py svg (--layout=circo | --layout=sfdp) <JSON_FILE> <OUT_FILENAME>
    tatort-graph.py web <SVG_FILE> <OUT_FILENAME>
    tatort-graph.py (-h | --help)

Options:
    --layout=circo --layout=sfdp        choose graphviz layout
    -h --help                           show this help message and exit

'''
import json
import pygraphviz as pgv
from docopt import docopt


arguments = docopt(__doc__)

if arguments['svg']:
    with open(arguments['<JSON_FILE>']) as f:
        data = json.load(f)

    G = pgv.AGraph()

    for i in data:
        if len(i['darsteller']) > 0:
            try:
                G.add_node(i['titel'])
                G.node_attr['color'] = 'green'
                G.node_attr['fillcolor'] = 'green'
                G.node_attr['style'] = 'filled'
                G.node_attr['fontcolor'] = 'white'
                G.node_attr['shape'] = 'hexagon'
            except:
                pass

    for i in data:
        try:
            for j in i['darsteller']:
                G.add_node(j.strip())
                G.node_attr['shape'] = 'box'
                G.node_attr['color'] = 'grey'
                G.node_attr['fillcolor'] = 'grey'
                G.node_attr['fontcolor'] = 'white'
                G.add_edge(i['titel'], j.strip())
                G.edge_attr['color'] = 'grey'
        except:
            pass

    layout = arguments['--layout']

    G.layout(prog=layout, args='-Goverlap=scale')
    G.draw(arguments['<OUT_FILENAME>']+'.svg', prog=layout)
    G.write(arguments['<OUT_FILENAME>']+'.gv')

elif arguments['web']:
    with open(arguments['<SVG_FILE>'], 'r') as f:
        l = f.readlines()
        l_num = list(enumerate(l))
        g_tag = []
        for i, j in l_num:
            if j.startswith('<g'):
                g_tag.append(i)

        l.insert(g_tag[0], '<g id="viewport">'+'\n')
        l.insert(g_tag[0], '<script xlink:href="SVGPan_pangu.js"/>'+'\n')
        l.insert(l_num[-1][0], '</g>'+'\n')

    with open(arguments['<OUT_FILENAME>'], 'w') as f:
        f.writelines(l)
