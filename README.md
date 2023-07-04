# Mastery

A quiz generator.  
It generates quiz with predefined template.

## Data structures for each nouns

### Template

- name: atom
- category: atom
- instructions: string

### Question

- raw: string
- compiled: macro
- generators: `%{substitution: list or function}`
- checker: `function(substitution, string) -> boolean`
