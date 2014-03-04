# based on: sfdp -x -Goverlap=scale -Tsvg viz.gv > viz.svg

import json
import pygraphviz as pgv


with open('../TatortScrape/tatort.json') as f:
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


G.layout(prog='sfdp', args='-Goverlap=scale')
G.draw('sfdp.svg', prog='sfdp')
G.write('sfdp.gv')
