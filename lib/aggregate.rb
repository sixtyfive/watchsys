require_relative 'models'
require 'active_support/core_ext/numeric/time'

def save_minutes(day, records)
  i = 0
  loop do
    minute_records = records[i...i+60]
    if minute_records.count == 60 # only work with complete minutes
      sum = minute_records.inject {|aggregate, hash| aggregate.to_hash.merge(hash) {|k, v1, v2| v1 + v2}}
      avg = Hash[sum.map {|k, v| [k, v / 60]}]
      t = Time.at(avg[:epoch])
      min = Time.new(t.year, t.month, t.day, t.hour, t.min)
      unless Minute.where(min: min).any?
        params = avg.merge(min: min).delete_if {|k,v| [:id, :epoch].include? k}
        Minute.insert(params)
      end
    end
    i += 60
    break if i >= records.count
  end
end

def aggregate_datapoints
  tc = Time.now
  begin
    DataPoint.where(Sequel.lit "epoch < #{60*60*24}").destroy # haven't yet been able to figure out how these even get into the database
    t1 = Time.at(DataPoint.first.epoch)
    logger.info "starting to aggregate (tc=#{tc})"
    loop do
      t2 = Time.new(t1.year, t1.month, t1.day, 3, 0)+1.day
      records = DataPoint.where(epoch: t1.to_i...t2.to_i)
      logger.info "from #{t1} to #{t2}: #{records.count} records"
      day = Time.new(t1.year, t1.month, t1.day)
      today = Time.new(tc.year, tc.month, tc.day)
      save_minutes(day, records.to_a)
      if day < today
        logger.info "deleting records for #{day}"
        records.delete
      end
      t1 = t2
      break if !DataPoint.last || t1.to_i > DataPoint.last.epoch # don't keep going beyond the end of the data
    end
  rescue Exception => e
    logger.warn "error: no datapoints to aggregate (#{e})"
  end
end

aggregate_datapoints if $0 == __FILE__
