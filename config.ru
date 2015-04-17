require_relative 'app/app'
require_relative 'app/middlewares/server_error'

use Rack::ServerError
run Mosscow
