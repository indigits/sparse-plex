from docutils import nodes
from docutils.parsers.rst import Directive
from sphinx.locale import _

def setup(app):
    app.add_node(highlights,
                 html=(visit_highlights_node, depart_highlights_node),
                 latex=(visit_highlights_node, depart_highlights_node),
                 text=(visit_highlights_node, depart_highlights_node))
    app.add_directive('highlights', HighlightsDirective)


    app.add_node(abstract,
                 html=(visit_abstract_node, depart_abstract_node),
                 latex=(visit_abstract_node, depart_abstract_node),
                 text=(visit_abstract_node, depart_abstract_node))
    app.add_directive('abstract', AbstractDirective)
    return 

class highlights(nodes.Admonition, nodes.Element):
    pass

def visit_highlights_node(self, node):
    self.visit_admonition(node)

def depart_highlights_node(self, node):
    self.depart_admonition(node)

class HighlightsDirective(Directive):

    # this enables content in the directive
    has_content = True

    def run(self):
        env = self.state.document.settings.env

        targetid = "highlights-%d" % env.new_serialno('highlights')
        targetnode = nodes.target('', '', ids=[targetid])

        highlights_node = highlights('\n'.join(self.content))
        highlights_node += nodes.title(_('Highlights'), _('Highlights'))
        self.state.nested_parse(self.content, self.content_offset, highlights_node)

        return [targetnode, highlights_node]


class abstract(nodes.Admonition, nodes.Element):
    pass

def visit_abstract_node(self, node):
    self.visit_admonition(node)

def depart_abstract_node(self, node):
    self.depart_admonition(node)

class AbstractDirective(Directive):

    # this enables content in the directive
    has_content = True

    def run(self):
        env = self.state.document.settings.env

        targetid = "abstract-%d" % env.new_serialno('abstract')
        targetnode = nodes.target('', '', ids=[targetid])

        abstract_node = abstract('\n'.join(self.content))
        abstract_node += nodes.title(_('Abstract'), _('Abstract'))
        self.state.nested_parse(self.content, self.content_offset, abstract_node)

        return [targetnode, abstract_node]
