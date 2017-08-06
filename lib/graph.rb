require 'gruff'
require_relative 'models'

$resolution = '1024x600'

def write_graph_recent
  t = 10 # minutes
  logger.info "writing graph for the past #{t} minutes..."

  g = Gruff::Area.new($resolution)
  g.title = 'Die letzten paar Minuten'
  
  labels = {}
  (t + 1).times {|i| labels[i * 65] = -(t-i)}
  g.labels = labels

  g.marker_font_size = 8
  g.legend_font_size = 10

  t1 = (Time.now - t * 60).to_i
  t2 = (Time.now).to_i

  records = DataPoint.select(:temp, 
                             Sequel.+(:cpu_usage_usr, :cpu_usage_sys).as(:cpu), 
                             Sequel.+(:net_packets_in, :net_packets_out).as(:pps),
                             Sequel.+(:net_bytes_in, :net_bytes_out).as(:bps))
                     .where(epoch: t1..t2)

  records = records.each_with_object({temp: [], cpu: [], kbps: [], pps: []}) {|data, acc|
    acc[:temp] << data[:temp] * 2    # to bring up into a range that looks like within 100
    acc[:cpu]  << data[:cpu]  * 10   # to bring up into a range that looks like within 100
    acc[:kbps] << data[:bps]  / 1000 # bytes / 1000 = kilobytes
    acc[:pps]  << data[:pps]  / 2    # make it look smaller than bps
  }

  records.each {|name, data_points|
    g.data name, data_points
  }

  g.minimum_value = 0
  g.maximum_value = 3000
  g.write 'recent.png'
end

def write_graph_today
  logger.info "writing graph for today..."

  g = Gruff::Area.new($resolution)
  g.title = 'Seit heute morgen um drei'

  g.marker_font_size = 8
  g.legend_font_size = 10

  tc = Time.now
  t1 = Time.new(tc.year, tc.month, tc.day, 3)
  t2 = Time.new(tc.year, tc.month, tc.day + 1, 3)

  records = Minute.select(:temp, 
                          Sequel.+(:cpu_usage_usr, :cpu_usage_sys).as(:cpu), 
                          Sequel.+(:net_packets_in, :net_packets_out).as(:pps),
                          Sequel.+(:net_bytes_in, :net_bytes_out).as(:bps))
                  .where(min: t1..t2)

  records = records.each_with_object({temp: [], cpu: [], kbps: [], pps: []}) {|data, acc|
    acc[:temp] << data[:temp] * 2    # to bring up into a range that looks like within 100
    acc[:cpu]  << data[:cpu]  * 10   # to bring up into a range that looks like within 100
    acc[:kbps] << data[:bps]  / 1000 # bytes / 1000 = kilobytes
    acc[:pps]  << data[:pps]  / 2    # make it look smaller than bps
  }

  records.each {|name, data_points|
    g.data name, data_points
  }

  g.minimum_value = 0
  g.maximum_value = 3000
  g.write 'today.png'
end

if $0 == __FILE__
  case ARGV[0]
    when 'today' then write_graph_today
    else write_graph_recent
  end
end
