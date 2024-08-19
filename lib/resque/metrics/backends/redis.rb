require 'redis'

module Resque
  module Metrics
    module Backends
      class Redis
        attr_accessor :redis

        def initialize(redis)
          @redis = redis
        end

        def increment_metric(metric, by = 1)
          redis.incrby("_metrics_:#{metric}", by)
        end

        def set_metric(metric, val)
          redis.set("_metrics_:#{metric}", val)
        end

        def set_avg(metric, num, total)
          val = total < 1 ? 0 : num / total
          set_metric(metric, val)
        end

        def get_metric(metric)
          metric_value = redis.mget("_metrics_:#{metric}").first

          metric_value.to_i
        end

        def register_job(job)
          redis.sadd('_metrics_:known_jobs', job)
        end

        def known_jobs
          redis.smembers('_metrics_:known_jobs')
        end
      end
    end
  end
end
