require 'rest_client'
require 'yajl/json_gem'
require 'active_model'

require 'slingshot/rubyext/hash'
require 'slingshot/rubyext/symbol'
require 'slingshot/configuration'
require 'slingshot/client'
require 'slingshot/client'
require 'slingshot/search'
require 'slingshot/search/query'
require 'slingshot/search/sort'
require 'slingshot/search/facet'
require 'slingshot/results/collection'
require 'slingshot/results/item'
require 'slingshot/index'
require 'slingshot/dsl'
require 'slingshot/model/naming'
require 'slingshot/model/callbacks'
require 'slingshot/model/search'
require 'slingshot/model/persistence/finders'
require 'slingshot/model/persistence/attributes'
require 'slingshot/model/persistence'

module Slingshot
  extend DSL
end
