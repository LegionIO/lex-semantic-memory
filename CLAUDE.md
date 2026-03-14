# lex-semantic-memory

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-semantic-memory`
- **Version**: `0.1.0`
- **Namespace**: `Legion::Extensions::SemanticMemory`

## Purpose

Tulving-inspired semantic memory store for the agent's general world knowledge. Stores named concepts with properties and typed relational links (is_a, has_a, part_of, etc.). Supports spreading activation retrieval (BFS from a seed concept across relation links), taxonomic querying (instances of a category), and confidence-based decay. Distinct from `lex-memory` (which stores episodic traces) — this stores stable conceptual knowledge.

## Gem Info

- **Gem name**: `lex-semantic-memory`
- **License**: MIT
- **Ruby**: >= 3.4
- **No runtime dependencies** beyond the Legion framework

## File Structure

```
lib/legion/extensions/semantic_memory/
  version.rb                           # VERSION = '0.1.0'
  helpers/
    constants.rb                       # limits, relation types, confidence values, spreading activation params
    concept.rb                         # Concept class — named node with properties and relation list
    knowledge_store.rb                 # KnowledgeStore class — hash-indexed concept store
  runners/
    semantic_memory.rb                 # Runners::SemanticMemory module
  actors/
    decay.rb                           # Decay actor — Every 300s, calls update_semantic_memory
  client.rb                            # Client class including Runners::SemanticMemory
```

## Key Constants

| Constant | Value | Purpose |
|---|---|---|
| `MAX_CONCEPTS` | 500 | Maximum stored concepts |
| `MAX_RELATIONS_PER_CONCEPT` | 50 | Max relations per concept; trims weakest when exceeded |
| `MAX_HISTORY` | 200 | Retrieval history ring buffer size |
| `RELATION_TYPES` | 11 symbols | `:is_a`, `:has_a`, `:part_of`, `:property_of`, `:used_for`, `:causes`, `:prevents`, `:similar_to`, `:opposite_of`, `:instance_of`, `:category_of` |
| `DEFAULT_CONFIDENCE` | 0.5 | Starting confidence for new concepts |
| `CONFIDENCE_FLOOR` | 0.05 | Floor; faded concepts are removed |
| `CONFIDENCE_DECAY` | 0.005 | Per-tick confidence decrease |
| `ACCESS_BOOST` | 0.05 | Confidence increase on retrieval |
| `SPREAD_FACTOR` | 0.6 | Activation multiplier per hop in spreading activation |
| `MAX_SPREAD_HOPS` | 3 | Maximum spreading activation depth |
| `SPREAD_THRESHOLD` | 0.1 | Minimum activation strength to continue spreading |

## Helpers

### `Helpers::Concept`

Named node with properties and typed relation list.

- `initialize(name:, domain: :general, confidence:, properties: {})` — UUID id, clamps confidence
- `add_relation(type:, target_name:, confidence:)` — rejects invalid types; reinforces existing relations; trims weakest if at `MAX_RELATIONS_PER_CONCEPT`
- `relations_of_type(type)` — filter relations by type
- `related_concepts` — flat array of target names from all relations
- `set_property(key, value)` / `get_property(key)` — arbitrary property hash
- `access` — increments access_count and applies `ACCESS_BOOST` to confidence
- `decay` — decrements confidence and all relation confidences by `CONFIDENCE_DECAY`; removes relations at floor
- `faded?` — confidence <= `CONFIDENCE_FLOOR`
- `label` — `:established`, `:reliable`, `:provisional`, `:tentative`, or `:uncertain`

### `Helpers::KnowledgeStore`

Hash-indexed store keyed by concept name.

- `store(name:, domain:, confidence:, properties:)` — creates or accesses existing; merges new properties
- `relate(source:, target:, type:, confidence:)` — auto-creates both concepts if missing
- `retrieve(name:)` — accesses concept, records retrieval history, returns nil if absent
- `query_relations(name:, type:)` — returns all or type-filtered relations
- `check_is_a(concept_name, category_name)` — checks for `:is_a` relation to category
- `instances_of(category_name)` — all concepts with `:is_a` pointing to category
- `spreading_activation(seed:, hops:)` — BFS across related_concepts, multiplies strength by SPREAD_FACTOR per hop; returns activated hash sorted by strength descending
- `concepts_in_domain(domain)` — filter by domain
- `search(query)` — substring match on concept name
- `decay_all` — decays and removes faded concepts
- `ensure_capacity` — evicts weakest concept when at `MAX_CONCEPTS`

## Runners

| Runner | Parameters | Returns |
|---|---|---|
| `store_concept` | `name:, domain: :general, confidence:, properties: {}` | `{ success:, concept: }` |
| `relate_concepts` | `source:, target:, type:, confidence:` | `{ success:, source:, target:, type:, relation: }` |
| `retrieve_concept` | `name:` | `{ success:, found:, concept: }` |
| `query_concept_relations` | `name:, type:` | `{ success:, name:, relations:, count: }` |
| `check_category` | `concept:, category:` | `{ success:, is_member: }` |
| `find_instances` | `category:` | `{ success:, instances:, count: }` |
| `activate_spread` | `seed:, hops:` | `{ success:, activated:, count: }` |
| `concepts_in` | `domain:` | `{ success:, concepts:, count: }` |
| `update_semantic_memory` | (none) | `{ success:, concepts:, relations: }` — calls decay_all |
| `semantic_memory_stats` | (none) | KnowledgeStore summary hash |

## Actors

`Actor::Decay` — `Every` actor, fires every 300 seconds. Calls `update_semantic_memory` to run the decay cycle. `run_now?: false`, `use_runner?: false`, `check_subtask?: false`, `generate_task?: false`.

## Integration Points

- **lex-tick / lex-cortex**: `update_semantic_memory` wired as a tick handler or run periodically via Decay actor
- **lex-schema**: schema builds causal relations between entities; semantic memory stores the conceptual definitions of those same entities
- **lex-dream**: association walking in the dream cycle can leverage spreading activation to find related concepts
- **lex-coldstart**: ClaudeParser imports semantic knowledge from CLAUDE.md files as semantic traces; semantic_memory provides a complementary structured store

## Development Notes

- Store is keyed by concept name (string/symbol), not UUID — allows direct lookup without scanning
- `spreading_activation` operates on `related_concepts` (target names), not UUIDs, so cross-concept links work without a secondary index
- `access` on `retrieve` means frequently-retrieved concepts gain confidence; infrequently-accessed ones decay away — recency bias is intentional
- Relation trimming removes the lowest-confidence relation when `MAX_RELATIONS_PER_CONCEPT` is hit
- `ensure_capacity` removes the globally weakest concept (by confidence) when at `MAX_CONCEPTS`
