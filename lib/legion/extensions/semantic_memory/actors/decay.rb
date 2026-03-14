# frozen_string_literal: true

require 'legion/extensions/actors/every'

module Legion
  module Extensions
    module SemanticMemory
      module Actor
        class Decay < Legion::Extensions::Actors::Every
          def runner_class
            Legion::Extensions::SemanticMemory::Runners::SemanticMemory
          end

          def runner_function
            'update_semantic_memory'
          end

          def time
            300
          end

          def run_now?
            false
          end

          def use_runner?
            false
          end

          def check_subtask?
            false
          end

          def generate_task?
            false
          end
        end
      end
    end
  end
end
