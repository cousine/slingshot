require 'rest_client'
require 'yajl/json_gem'

require 'slingshot/rubyext/hash'
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
require 'slingshot/model/search'
require 'slingshot/model/callbacks'

module Slingshot
  extend DSL
end
