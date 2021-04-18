require_relative 'config/environment'

require 'bundler'
Bundler.setup(:default)

use Rack::RequestId
use Rack::Ougai::LogRequests, Application.opts[:custom_logger]

run AdRoutes
