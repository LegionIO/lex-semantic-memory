# frozen_string_literal: true

require_relative 'lib/legion/extensions/semantic_memory/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-semantic-memory'
  spec.version       = Legion::Extensions::SemanticMemory::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Semantic Memory'
  spec.description   = 'Tulving semantic memory store for brain-modeled agentic AI — concept storage, ' \
                       'taxonomic relations (is_a, has_a, part_of), spreading activation retrieval, ' \
                       'and knowledge consolidation with confidence-based decay.'
  spec.homepage      = 'https://github.com/LegionIO/lex-semantic-memory'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/LegionIO/lex-semantic-memory'
  spec.metadata['documentation_uri']     = 'https://github.com/LegionIO/lex-semantic-memory'
  spec.metadata['changelog_uri']         = 'https://github.com/LegionIO/lex-semantic-memory'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/LegionIO/lex-semantic-memory/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-semantic-memory.gemspec Gemfile]
  end
  spec.require_paths = ['lib']
end
