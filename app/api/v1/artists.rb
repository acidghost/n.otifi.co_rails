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

        artists 'css=a[href^="/dj/"]', :iterator do
          # noinspection RubyArgCount
          name 'xpath=text()'
          ra_link 'xpath=@href' do |href|
            "http://www.residentadvisor.net#{href}"
          end
          href 'xpath=@href' do |href|
            "#{Figaro.env.ROOT_URL}#{href.gsub('/dj/', '/api/v1/artists/')}"
          end
        end
      end
      result['artists'].select! { |artist| artist['full_name'].present? }.try :uniq!
      result
    end

    desc 'Get artist details'
    oauth2
    params do
      requires :raname, type: String, desc: 'The artist RA name', documentation: { example: 'surgeon' }
    end
    get ':raname' do
      raname = permitted_params[:raname]
      begin
        Artist.find_by_raname raname
      rescue ActiveRecord::RecordNotFound
        Wombat.crawl do
          base_url 'http://www.residentadvisor.net'
          path "/dj/#{raname}"

          # noinspection RubyArgCount
          name 'css=#featureHead h1'
          ra_link "http://www.residentadvisor.net/dj/#{raname}"
          images do
            normal "http://www.residentadvisor.net/images/profiles/#{raname}.jpg"
            large "http://www.residentadvisor.net/images/profiles/lg/#{raname}.jpg"
          end

          events 'css=#items li', :iterator do
            # noinspection RubyArgCount
            name 'css=h1.title>a'
            date 'css=span>time' do |date|
              Date.parse(date).to_datetime.to_i
            end
          end
        end
      end
    end

  end

end
