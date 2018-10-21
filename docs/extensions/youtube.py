#-*- coding:utf-8 -*-
from docutils import nodes
from docutils.parsers import rst


def setup(app):

    app.add_node(youtube,
                 html=(visit, depart))
    app.add_directive('youtube', YoutubeDirective)

class youtube(nodes.General, nodes.Element):
    pass

def visit(self, node):
    url = u'//www.youtube.com/embed/{0}?feature=player_detailpage'.format(node.video_id)
    tag = u'''<iframe width="640" height="360" src="{0}" frameborder="0" allowfullscreen="1">&nbsp;</iframe>'''.format(url)
    self.body.append(tag)

def depart(self, node):
    pass


class YoutubeDirective(rst.Directive):

    name = 'youtube'
    node_class = youtube

    has_content = False
    required_arguments = 1
    optional_arguments = 0
    final_argument_whitespace = False
    option_spec = {}

    def run(self):
        node = self.node_class()
        node.video_id = self.arguments[0]
        return [node]

