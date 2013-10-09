require_relative 'components/fwd'
require_relative 'components/jekyll'
require_relative 'components/stringer'
require_relative 'components/gitolite'
require_relative 'components/nginx'

module BinarySolo
  module Components

    def all
      [Fwd, Jekyll, Stringer, Gitolite, Nginx]
    end

  end
end