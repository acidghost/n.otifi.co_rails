class V1::Artists < Grape::API

  include V1::DefaultAPI

  resource :artists do

    desc 'Return all artists'
    oauth2
    get do
      current_user.artists
    end

    desc 'Search for artists'
    oauth2
    params do
      requires :search_text, type: String, desc: 'The artist to search', documentation: { example: 'Surgeon' }
    end
    get 'search' do
      query = permitted_params[:search_text]
      result = Wombat.crawl do
        base_url 'http://www.residentadvisor.net'
        path "/search.aspx?searchstr=#{query}"

        artists({ css: 'a[href^="/dj/"]' }, :list)
      end
      result['artists'].select! { |artist| !artist.empty? }.uniq!
      result
    end

    desc 'Get artist details'
    oauth2
    params do
      requires :raname, type: String, desc: 'The artist RA name', documentation: { example: 'surgeon' }
    end
    get ':raname' do
      Artist.find raname: permitted_params[:raname]
    end

  end

end
