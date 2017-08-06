require 'sequel'

DB = Sequel.connect('sqlite://sysinfo.sqlite3')

# "epoch","total cpu usage",,,,,,"load avg",,,"net/eth0",,"pkt/eth0",,"thermal"
# "epoch","usr","sys","idl","wai","hiq","siq","1m","5m","15m","recv","send","#recv","#send","k10temp-pci-00c3"
# 1501716616.749,3.244,0.819,95.691,0.187,0.0,0.060,0.020,0.050,0.080,0.0,0.0,0.0,0.0,46.500

=begin
DB.create_table :data_points do
  primary_key :id
  Integer :epoch
  Float :cpu_usage_usr
  Float :cpu_usage_sys
  Float :cpu_usage_idl
  Float :load
  Float :net_bytes_in
  Float :net_bytes_out
  Float :net_packets_in
  Float :net_packets_out
  Float :temp
end
=end

DB.create_table :minutes do
  primary_key :id
  Time :min
  Float :cpu_usage_usr
  Float :cpu_usage_sys
  Float :cpu_usage_idl
  Float :load
  Float :net_bytes_in
  Float :net_bytes_out
  Float :net_packets_in
  Float :net_packets_out
  Float :temp
end
