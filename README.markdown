Slingshot
=========

![Slingshot](https://github.com/karmi/slingshot/raw/image/slingshot.png)

_Slingshot_ aims to provide a rich Ruby API and DSL for the
[ElasticSearch](http://www.elasticsearch.org/) search engine/database.

_ElasticSearch_ is a scalable, distributed, highly-available,
RESTful database communicating by JSON over HTTP, based on [Lucene](http://lucene.apache.org/),
written in Java. It manages to very simple and very powerful at the same time.
You should seriously consider it to power search in your Ruby applications:
it will deliver all the features you want — and many more you may have not
imagined yet (native geo search? histogram facets?)

_Slingshot_ currently allow basic operation with the index and searching. See chapters below.


Installation
------------

First, you need a running _ElasticSearch_ server. Thankfully, it's easy. Let's define easy:

    $ curl -L -o elasticsearch-0.14.4.tar.gz http://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.14.4.tar.gz
    $ tar -zxvf elasticsearch-0.14.4.tar.gz
    $ ./elasticsearch-0.14.4/bin/elasticsearch -f

OK, easy. Now, install the gem via Rubygems:

    $ gem install slingshot

or from source:

    $ git clone git://github.com/karmi/slingshot.git
    $ rake install


Usage
-----

Currently, you can use _Slingshot_ via the DSL (eg. by extending your class with it).
Plans for full ActiveModel integration (and other convenience layers) are in progress.

To kick the tiers, require the gem in an IRB session or a Ruby script
(note that you can run the full example from [`examples/dsl.rb`](https://github.com/karmi/slingshot/blob/master/examples/dsl.rb)):

    require 'rubygems'
    require 'slingshot'

First, let's create an index named `articles` and store/index some documents:

    Slingshot.index 'articles' do
      delete
      create

      store :title => 'One',   :tags => ['ruby']
      store :title => 'Two',   :tags => ['ruby', 'python']
      store :title => 'Three', :tags => ['java']
      store :title => 'Four',  :tags => ['ruby', 'php']

      refresh
    end

Now, let's query the database:

We are searching for articles tagged _ruby_, sorted by `title` in `descending` order,
and also retrieving some [_facets_](http://www.lucidimagination.com/Community/Hear-from-the-Experts/Articles/Faceted-Search-Solr)
from the database:

    s = Slingshot.search 'articles' do
      query do
        terms :tags, ['ruby']
      end

      sort do
        title 'desc'
      end

      facet 'global-tags' do
        terms :tags, :global => true
      end

      facet 'current-tags' do
        terms :tags
      end
    end

Let's display the results:

    s.results.each do |document|
      puts "* #{ document['_source']['title'] }"
    end

    # * Two
    # * One
    # * Four

Let's display the facets (distribution of tags across the whole database):

    s.results.facets['global-tags']['terms'].each do |f|
      puts "#{f['term'].ljust(10)} #{f['count']}"
    end

    # ruby       3
    # python     1
    # php        1
    # java       1
    
We can display the full query JSON:

    puts s.to_json
    # {"facets":{"current-tags":{"terms":{"field":"tags"}},"global-tags":{"global":true,"terms":{"field":"tags"}}},"sort":[{"title":"desc"}],"query":{"terms":{"tags":["ruby"]}}}

See, a Ruby DSL for this thing is kinda handy? We can query _ElasticSearch_ manually with `curl`, simply:

    puts s.to_curl
    # curl -X POST "http://localhost:9200/articles/_search?pretty=true" -d '{"facets":{"current-tags":{"terms":{"field":"tags"}},"global-tags":{"global":true,"terms":{"field":"tags"}}},"sort":[{"title":"desc"}],"query":{"terms":{"tags":["ruby"]}}}'


Features
--------

Currently, _Slingshot_ supports only a limited subset of vast _ElasticSearch_ [Search API](http://www.elasticsearch.org/guide/reference/api/search/request-body.html) and it's [Query DSL](http://www.elasticsearch.org/guide/reference/query-dsl/):

* Creating, deleting and refreshing the index
* Storing a document in the index
* [Querying](https://github.com/karmi/slingshot/blob/master/examples/dsl.rb) the index with the `query_string`, `term` and `terms` types of queries
* Sorting the results by `fields`
* Retrieving a _terms_ type of [facets](http://www.elasticsearch.org/guide/reference/api/search/facets/index.html) -- other types are high priority
* Returning just specific fields from documents
* Paging with `from` and `size` query options

See the [`examples/dsl.rb`](blob/master/examples/dsl.rb).

Todo & Plans
------------

In order of importance:

* Basic wrapper class for _hits_ in results, so we could write `results.first.document.title` instead of using the raw Hash
* Getting document [by ID](http://www.elasticsearch.org/guide/reference/api/get.html)
* Seamless _ActiveModel_ compatibility for easy usage in _Rails_ applications (this also means nearly full _ActiveRecord_ compatibility)
* Allowing to set custom non-ActiveModel wrapper class (your own)
* Seamless [will_paginate](https://github.com/mislav/will_paginate) compatibility for easy pagination
* [Histogram](http://www.elasticsearch.org/guide/reference/api/search/facets/histogram-facet.html) facets
* Seamless support for [auto-updating _river_ index](http://www.elasticsearch.org/guide/reference/river/couchdb.html) for _CouchDB_ `_changes` feed
* [Mapping](http://www.elasticsearch.org/guide/reference/mapping/) management
* Infrastructure for query filters
* [Range](http://www.elasticsearch.org/guide/reference/query-dsl/range-filter.html) filters and queries
* [Geo Filters](http://www.elasticsearch.org/blog/2010/08/16/geo_location_and_search.html) for queries
* [Statistical](http://www.elasticsearch.org/guide/reference/api/search/facets/statistical-facet.html) facets
* [Geo Distance](http://www.elasticsearch.org/guide/reference/api/search/facets/geo-distance-facet.html) facets
* [Index aliases](http://www.elasticsearch.org/guide/reference/api/admin-indices-aliases.html) management
* [Analyze](http://www.elasticsearch.org/guide/reference/api/admin-indices-analyze.html) API support
* [Highligting](http://www.elasticsearch.org/guide/reference/api/search/highlighting.html) support
* [Bulk](http://www.elasticsearch.org/guide/reference/api/bulk.html) API
* Embedded webserver to display cluster statistics and allow easy searches

Feedback
--------

You can send feedback via [e-mail](mailto:karmi@karmi.cz) or via [Github Issues](https://github.com/karmi/slingshot/issues).

-----

[Karel Minarik](http://karmi.cz)
