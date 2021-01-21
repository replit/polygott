"""
simple wrapper around the python ast module to return the JSON formated
string of a given python program.
"""

import ast
import json

def parse(program):
    lines = program.count('\n') + 1

    root_node = ast.parse(program)
    root_node = ast.fix_missing_locations(root_node)
    root_node = serialize_node(root_node, lines)

    return json.dumps(root_node)

def serialize_nodes(nodes, lines, parent):

    nodes = [node for node in nodes if isinstance(node, ast.AST)]

    children = []

    # loop through the nodes in reverse this way we can pass in `sibling` as
    # the last node we parsed. Which (in order) is the child's next sibling
    node_count = len(nodes)
    next_node = None
    for i in reversed(range(node_count)):
        node = nodes[i]

        child = serialize_node(node, lines, parent, next_node)
        children = [child] + children

        next_node = child

    return children

def serialize_node(node, lines, parent=None, sibling=None):
    serialized_node = {
        'type': type(node).__name__,
    }

    # position is mostly just a rough estimate and we ignore column entirely
    # but it should work well enough for now. All we really care about righ
    # now is being able to split code based on function boundaries
    start_line = None
    start_column = None
    end_line = None
    end_column = None

    if isinstance(node, (ast.expr, ast.stmt)):
        start_line = node.lineno
    elif parent is None:
        start_line = 1

    if sibling != None:
        end_line = sibling['position']['start']['line'] - 1
    elif parent != None:
        end_line = parent['position']['end']['line']
    else:
        end_line = lines

    serialized_node['position'] = {
        'start': {'line': start_line, 'column': start_column},
        'end': {'line': end_line, 'column': end_column},
    }

    node_fields = ast.iter_fields(node)

    for key, value in node_fields:
        if isinstance(value, ast.AST):
            serialized_node[key] = serialize_node(value, lines, serialized_node)
        elif isinstance(value, list):
            serialized_node[key] = serialize_nodes(value, lines, serialized_node)
        else:
            serialized_node[key] = value

    return serialized_node
