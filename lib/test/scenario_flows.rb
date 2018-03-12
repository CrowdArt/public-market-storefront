module Test
  module ScenarioFlows
    def formatter
      @formatter ||= RSpec.configuration.formatters.first
    end

    def formatter_names
      @formatter_names ||= RSpec.configuration.formatters.map { |f| f.class.to_s }.join(' ')
    end

    def output
      @output ||= formatter.output
    end

    def flow_info(msg, ending: "\n")
      output.printf("\e[1;36m#{msg}\e[0m#{ending}")
    end

    def flow(description)
      raise 'Feature flows must be used with blocks' unless block_given?
      flow_info('.', ending: '') if formatter_names.include?('Progress')
      flow_info("#{formatter.send(:current_indentation)}#{description}") if formatter_names.include?('Documentation')
      yield
    end
  end
end
