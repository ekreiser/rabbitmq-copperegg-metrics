This script is sending RabbitMQ queue sizes (sum of all ready and unacknowledged messages in all queues) and the used memory (in Bytes) of all queues to [CopperEgg](http://www.copperegg.com/).

1. Make sure that you have `rabbitmqctl` installed.
2. Run `bundle install`
3. Run the script manually to see if it works: `$ ruby rabbitmq-copperegg-metrics.rb YOUR_API_KEY YOUR_RABBITMQ_NODE_NAME YOUR_DIRECTORY_PATH_TO RABBITMQ_SBIN`
4. Add the script to your Crontab to let it report metrics every minute:

     * * * * * /usr/bin/ruby /opt/copperegg/rabbitmq-copperegg-metrics/rabbitmq-copperegg-metrics.rb YOUR_API_KEY YOUR_RABBITMQ_NODE_NAME YOUR_DIRECTORY_PATH_TO_RABBITMQ_SBIN

It might be that you have to append a `:U` to the end of your API KEY. The CopperEgg documentation shows that for all examples except Ruby and it is not working without the `:U` for me. Support request is sent so this might be clarified soon.

Support for passing the parameter named YOUR_RABBITMQ_NODE_NAME allows for the scenario of running multiple RabbitMQ server instances on a single machine.

Support for passing the parameter named YOUR_DIRECTORY_PATH_TO_RABBITMQ_SBIN allows for installing RabbitMQ into different directory structures - and not having to edit the ruby script.
