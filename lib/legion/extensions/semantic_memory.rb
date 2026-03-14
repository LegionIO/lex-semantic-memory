# frozen_string_literal: true

require 'securerandom'
require 'legion/extensions/semantic_memory/version'
require 'legion/extensions/semantic_memory/helpers/constants'
require 'legion/extensions/semantic_memory/helpers/concept'
require 'legion/extensions/semantic_memory/helpers/knowledge_store'
require 'legion/extensions/semantic_memory/runners/semantic_memory'
require 'legion/extensions/semantic_memory/client'

module Legion
  module Extensions
    module SemanticMemory
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
