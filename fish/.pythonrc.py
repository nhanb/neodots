'''
import datetime
import json
import os
import time


# Poor man's scoping, to avoid polluting global namespace:
def pp():
    from pygments import highlight
    from pygments.lexers import PythonLexer
    from pygments.formatters import TerminalFormatter
    from pprint import pformat

    lexer = PythonLexer()
    formatter = TerminalFormatter()

    def pprint_color(obj, **kwargs):
        """
        Pretty printing with colors.
        kwargs are passed as-is to pprint.pformat()
        """
        print(highlight(pformat(obj, **kwargs), lexer, formatter))

    return pprint_color


pp = pp()
'''
