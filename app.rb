require_relative 'models'

require 'roda'

class App < Roda
  plugin :json
  plugin :empty_root

  logger =
    if ENV['RACK_ENV'] == 'test'
      Class.new{def write(_) end}.new
    else
      $stderr
    end

  plugin :common_logger, logger

  plugin :not_found do
    @page_title = "File Not Found"
    view(:content=>"")
  end

  plugin :error_handler do |e|
    case e
    when Roda::RodaPlugins::RouteCsrf::InvalidToken
      @page_title = "Invalid Security Token"
      response.status = 400
      view(:content=>"<p>An invalid security token was submitted with this request, and this request could not be processed.</p>")
    else
      $stderr.print "#{e.class}: #{e.message}\n"
      $stderr.puts e.backtrace
      next exception_page(e, :assets=>true) if ENV['RACK_ENV'] == 'development'
      @page_title = "Internal Server Error"
      view(:content=>"")
    end
  end

  # plugin :sessions,
  #   key: '_App.session',
  #   #cookie_options: {secure: ENV['RACK_ENV'] != 'test'}, # Uncomment if only allowing https:// access
  #   secret: ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'APP_SESSION_SECRET')

  Unreloader.require('routes'){}

  hash_routes do
    view '', 'index'
  end

  route do |r|
    r.root do

    end
  end
end
