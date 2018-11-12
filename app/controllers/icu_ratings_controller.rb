class IcuRatingsController < ApplicationController
  load_resource only: ["show"]
  authorize_resource

  def index
    if current_user && params[:commit] == "CSV"
      if params[:list]
        @icu_ratings = IcuRating.search(params, icu_ratings_path, false)
      else
        @icu_ratings = []
      end
      send_data IcuRating.to_csv(@icu_ratings), type: "text/csv; charset=utf-8", filename: "icu_ratings.csv"
    else
      @icu_ratings = IcuRating.search(params, icu_ratings_path)
      @show_original = params[:show_original] == "true"
      @show_id = params[:show_id] == "true"
      if request.xhr?
        render :results
      else
        @original_ratings_article = Article.get_by_identity("original ratings")
      end
    end
  end

  def show
    @ratings_graph = IcuRatings::Graph.new(IcuRating.find(params[:id]))
    render "shared/ratings_graph/show.js"
  end

  def war
    @war = IcuRatings::WAR.new(params)
    render "icu_ratings/war/#{ request.xhr? ? 'results' : 'index' }"
  end

  def juniors
    @use_hightide_ratings = IcuRatings::Juniors.use_hightide_sorting?
    @juniors = IcuRatings::Juniors.new(params)
    render "icu_ratings/juniors/#{ request.xhr? ? 'results' : 'index' }"
  end

  def seniors
    @seniors = IcuRatings::Seniors.new(params)
    render "icu_ratings/seniors/#{ request.xhr? ? 'results' : 'index' }"
  end

  def improvers
    @improvers = IcuRatings::Improvers.new(params)
    render "icu_ratings/improvers/#{ request.xhr? ? 'results' : 'index' }"
  end
end
