require 'active_support/ordered_hash'

module AppScrolls
  class Config
    attr_reader :questions

    def initialize(schema)
      @questions = ActiveSupport::OrderedHash.new
      schema.each do |hash| 
        key = hash.keys.first
        details = hash.values.first

        kind = details['type']
        raise ArgumentError, "Unrecognized question type, must be one of #{QUESTION_TYPES.keys.join(', ')}" unless QUESTION_TYPES.keys.include?(kind)
        @questions[key] = QUESTION_TYPES[kind].new(details)
      end
    end

    def compile(values = {})
      result = []
      result << "config.merge! #{values.inspect}" unless values.empty?
      @questions.each_pair do |key, question|
        result << "config['#{key}'] = #{question.compile} unless config.key?('#{key}')"
      end
      result.join("\n")
    end

    class Prompt
      attr_reader :prompt, :details
      def initialize(details)
        @details = details
        @prompt = details['prompt']
      end

      def compile
        "#{question}#{conditions}"
      end

      def question
        "ask_wizard(#{prompt.inspect})"
      end

      def conditions
        conditions_string = [config_conditions, scroll_conditions].reject{|v| v=='true'}.join(' && ')
        " if " + conditions_string unless conditions_string.empty?
      end

      def config_conditions
        if details['if']
          "config['#{details['if']}']"
        elsif details['unless']
          "!config['#{details['unless']}']"
        else
          'true'
        end
      end

      def scroll_conditions
        if details['if_scroll']
          "scroll?('#{details['if_scroll']}')"
        elsif details['unless_scroll']
          "!scroll?('#{details['unless_scroll']}')"
        else
          'true'
        end
      end
    end

    class TrueFalse < Prompt
      def question 
        "yes_wizard?(#{prompt.inspect})"
      end
    end

    class MultipleChoice < Prompt
      def question
        "multiple_choice(#{prompt.inspect}, #{@details['choices'].inspect})"
      end 
    end

    QUESTION_TYPES = {
      'boolean' => TrueFalse,
      'string' => Prompt,
      'multiple_choice' => MultipleChoice
    }
  end
end
