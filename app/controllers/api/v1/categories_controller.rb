module Api
  module V1
    class CategoriesController < Api::BaseController
      def index
        render json: Category.order(:name).as_json(only: [ :id, :name ])
      end
    end
  end
end
