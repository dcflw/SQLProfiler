class SQLProfiler
  VERSION = "0.1.1"

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
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |_name, start, finish, _id, payload|

      query = payload[:sql].strip
      # replace binds with values
      payload[:binds].each_with_index do |bind, i|
        query.gsub!("$#{i+1}", bind.value.to_s)
      end

      queries << {
        start: start,
        finish: finish,
        duration: ((finish - start) * 1000).round(4),
        query: query
      }
    end

    yield

    ActiveSupport::Notifications.unsubscribe(subscriber)
    Result.new(queries)
  end
end
