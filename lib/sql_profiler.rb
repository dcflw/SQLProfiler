class SQLProfiler
  VERSION = 0.1

  class Result
    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

    def queries
      entries.collect{ |x| x[:query]}
    end

    def total_time(unit: :ms)
      total = entries.sum{ |x| x[:duration]}
      if unit.to_s == "s" || unit.to_s == "seconds"
        return total / 1000.0
      end
      total
    end

  end

  def self.run
    raise ArgumentError.new("Block is required") unless block_given?
    queries = []
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |name, start, finish, id, payload|
      queries << {
        start: start,
        finish: finish,
        duration: ((finish - start) * 1000).round(4),
        query: payload[:sql].strip
      }
    end
    yield
    ActiveSupport::Notifications.unsubscribe(subscriber)
    Result.new(queries)
  end
end