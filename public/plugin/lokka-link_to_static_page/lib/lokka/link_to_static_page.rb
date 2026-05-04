module Lokka
  module LinkToStaticPage
    module Helpers
      def link_to_static_page( name )
        if :home == name.to_sym and request_path != '/'
          '<a href="/">Home</a>'
        else
          page = Page( name )
          if not page.nil? and request_path != page.link
            "<a href=\"#{page.link}\">#{page.title}</a>"
          elsif not page.nil?
            page.title
          else
            name.to_s
          end
        end
      end
    end

    def self.registered(app)
      app.helpers ::Lokka::LinkToStaticPage::Helpers
    end
  end
end
