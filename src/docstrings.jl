# Docstring templates. Included before any docstring, as a `@template` only
# applies to docstrings written after it in the same module.

@template (FUNCTIONS, METHODS, MACROS) = """
$(TYPEDSIGNATURES)
$(DOCSTRING)
"""

@template TYPES = """
$(TYPEDEF)
$(DOCSTRING)

---
## Fields
$(TYPEDFIELDS)
"""

@template MODULES = """
$(DOCSTRING)

---
## Exports
$(EXPORTS)
---
## Imports
$(IMPORTS)
"""
