module API
  module V1
    class Enterprises < Grape::API
      before { detect_stuff_by_domain }
      before { authenticate! }
   
      resource :enterprises do

        # Collect comments from articles
        #
        # Parameters:
        #   from             - date where the search will begin. If nothing is passed the default date will be the date of the first article created
        #   oldest           - Collect the oldest comments from reference_id comment. If nothing is passed the newest comments are collected
        #   limit            - amount of comments returned. The default value is 20
        #
        # Example Request:
        #  GET /enterprises?from=2013-04-04-14:41:43&until=2014-04-04-14:41:43&limit=10
        #  GET /enterprises?reference_id=10&limit=10&oldest
        get do
          enterprises = select_filtered_collection_of(environment, 'enterprises', params)
          present enterprises, :with => Entities::Enterprise
        end
  
        desc "Return the article id" 
        get ':id' do
          present environment.enterprises.find(params[:id]), :with => Entities::Enterprise
        end

      end
   
    end
  end
end