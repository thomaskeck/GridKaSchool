# In case of multiple GPUs we only use number 1, otherwise we block all of them
import os
os.environ['CUDA_VISIBLE_DEVICES'] = '1'
import collections
import inspect

import numpy as np
np.set_printoptions(precision=2, suppress=True)
import matplotlib.pyplot as plt


class TensorflowGraphToDot:
    def __init__(self, op, suppressed_nodes = []):
        from graphviz import Digraph
        self.dot = Digraph()
        self.nodes = collections.OrderedDict()
        import tensorflow.contrib.graph_editor as ge
        for node in ge.get_backward_walk_ops(op):
            self.nodes[node.node_def.name] = node.node_def.input
        self.suppressed_nodes = suppressed_nodes
        for node_name in self.nodes:
            self.draw_node(node_name)
            for input_node in self.nodes[node_name]:
                self.draw_edge(input_node, node_name)
            
    def is_suppressed(self, node_name):
        return any([s in node_name for s in self.suppressed_nodes])

    def draw_edge(self, from_node_name, to_node_name):
        if self.is_suppressed(from_node_name):
            if from_node_name in self.nodes:
                for next_node_name in self.nodes[from_node_name]:
                    self.draw_edge(next_node_name, to_node_name)
        else:
            if not self.is_suppressed(to_node_name):
                self.dot.edge(from_node_name, to_node_name)

    def draw_node(self, node_name):
        if not self.is_suppressed(node_name):       
            self.dot.node(node_name, label=node_name)
            
    def _repr_svg_(self):
        return self.dot._repr_svg_()

class NumpyToLatex:
    def __init__(self, expression, dictionary=None):
        if dictionary is None:
            dictionary = inspect.stack()[1][0].f_globals
        latex = ''
        for x in expression.split():
            if x in dictionary:
                if isinstance(dictionary[x], np.ndarray):
                    latex += ' ' + self.ndarray_to_latex(dictionary[x])
                else:
                    latex += ' ' + self.number_to_latex(dictionary[x])
            else:
                latex += ' ' + str(x)
        from IPython.display import Math
        self.display = Math(latex)
        
    def ndarray_to_latex(self, ndarray):
        lines = str(ndarray).replace('[', '').replace(']', '').splitlines()
        x = [r'\begin{bmatrix}']
        x += ['  ' + ' & '.join(l.split()) + r'\\' for l in lines]
        x += [r'\end{bmatrix}']
        return '\n'.join(x)
    
    def number_to_latex(self, number):
        return "{:.2f}".format(number)
    
    def _repr_latex_(self):
        return self.display._repr_latex_()

