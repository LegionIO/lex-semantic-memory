# frozen_string_literal: true

require 'legion/extensions/semantic_memory/helpers/constants'
require 'legion/extensions/semantic_memory/helpers/concept'
require 'legion/extensions/semantic_memory/helpers/knowledge_store'
require 'legion/extensions/semantic_memory/runners/semantic_memory'

module Legion
  module Extensions
    module SemanticMemory
      class Client
        include Runners::SemanticMemory

        def initialize(knowledge_store: nil, **)
          @knowledge_store = knowledge_store || Helpers::KnowledgeStore.new
        end

        private

        attr_reader :knowledge_store
      end
    end
  end
end
