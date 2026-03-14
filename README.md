# lex-semantic-memory

Tulving semantic memory store for LegionIO cognitive agents. Stores named concepts with typed relational links and spreading activation retrieval.

## What It Does

`lex-semantic-memory` provides the agent's long-term world knowledge base. Unlike episodic memory (`lex-memory`), which stores timestamped experience traces, semantic memory stores stable conceptual knowledge:

- **Concepts**: named entities with typed properties and confidence scores
- **Typed relations**: 11 relation types including `:is_a`, `:has_a`, `:part_of`, `:causes`, `:similar_to`, `:opposite_of`, and more
- **Spreading activation**: retrieve not just a concept but everything conceptually related, with activation strength decaying by hop distance
- **Taxonomic queries**: find all instances of a category (`:is_a` traversal), check category membership
- **Confidence decay**: unaccessed concepts slowly fade; accessed concepts gain confidence

## Usage

```ruby
require 'legion/extensions/semantic_memory'

client = Legion::Extensions::SemanticMemory::Client.new

# Store a concept
client.store_concept(name: 'ruby', domain: :programming, properties: { type: 'language' })

# Create a relation
client.relate_concepts(source: 'ruby', target: 'programming_language', type: :is_a)

# Retrieve a concept (boosts its confidence)
client.retrieve_concept(name: 'ruby')
# => { success: true, found: true, concept: { name: 'ruby', confidence: ..., relations: [...] } }

# Check category membership
client.check_category(concept: 'ruby', category: 'programming_language')
# => { success: true, is_member: true }

# Find all instances of a category
client.find_instances(category: 'programming_language')
# => { success: true, instances: ['ruby'], count: 1 }

# Spreading activation from a seed concept
client.activate_spread(seed: 'ruby', hops: 2)
# => { success: true, activated: { 'programming_language' => 0.6, ... }, count: 1 }

# Run the decay cycle (called automatically by Decay actor every 300s)
client.update_semantic_memory
```

## Relation Types

`:is_a`, `:has_a`, `:part_of`, `:property_of`, `:used_for`, `:causes`, `:prevents`, `:similar_to`, `:opposite_of`, `:instance_of`, `:category_of`

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
