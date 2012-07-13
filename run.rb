require "./luhgdf_bot"
require "logger"

$logger = Logger.new 'logfile.log', 3, 10000
$config = YAML.load_file 'config.yaml'

account = $config['account']
server = $config['server']

bot = LUHGDFbot.new(account['username'], account['password'], $config['reddit'], $config['seen_file'], $config['comment_file'])

while true
  bot.run
  sleep(30)
end
