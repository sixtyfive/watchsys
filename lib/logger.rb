require 'logger'

def logger
  @logger ||= Logger.new($stdout)
  @logger.level = ARGV.include?('-v') ? Logger::DEBUG : Logger::INFO
  ARGV.include?('-q') ? Logger.new('/dev/null') : @logger
end
