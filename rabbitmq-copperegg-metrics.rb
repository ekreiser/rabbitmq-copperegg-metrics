require 'rubygems'
require 'copperegg'
require 'socket'

CopperEgg::Api.apikey = ARGV[0]
RabbitMQ_NODE = ARGV[1]
RabbitMQCTL_DIR = ARGV[2]

metric_group = CopperEgg::MetricGroup.new(
  :name => "rabbitmq_waiting_messages",
  :label => "RabbitMQ Waiting Messages",
  :frequency => 60
)

metric_group.metrics << {"type"=>"ce_gauge", "name"=>"waiting_messages", "unit"=>"Messages"}

metric_group.save

# http://www.rabbitmq.com/man/rabbitmqctl.1.man.html
queues = `#{RabbitMQCTL_DIR}rabbitmqctl list_queues messages -n #{RabbitMQ_NODE}`.split("\n")

total_waiting_messages = 0
if queues.size == 1
    total_waiting_messages = -1
end

queues.each_with_index do |queue,i|
  next if i == 0 or i == queues.size-1 # Skip first and last line.

  begin
    waiting_messages = 0
    if queue.start_with?('Error:')
        waiting_messages = -1
    else
        waiting_messages = queue.to_i
    end

    total_waiting_messages += waiting_messages
  rescue => e
    puts e
    next
  end

end

source = "RabbitMQ__" + Socket.gethostname + "__" + RabbitMQ_NODE

# puts "#{Time.now}: M: #{total_waiting_messages}"
# puts "#{metric_group.name} (source: #{source}) ..."

metrics = {:waiting_messages => total_waiting_messages}

CopperEgg::MetricSample.save(metric_group.name, source, Time.now.to_i, metrics)
