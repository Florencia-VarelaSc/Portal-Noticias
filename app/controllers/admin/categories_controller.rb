
module Admin
  class CategoriesController < Admin::BaseController

    # Solo los administradores pueden modificar categorías.
    before_action :require_admin_role,
      except: [:index, :show]

    before_action :set_category,
      only: [:show, :edit, :update, :destroy]

    def index
      @categories = Category.order(:name)
    end

    def show
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to admin_categories_path,
          notice: "Categoría creada."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path,
          notice: "Categoría actualizada."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @category.destroy
        redirect_to admin_categories_path,
          notice: "Categoría eliminada."
      else
        redirect_to admin_categories_path,
          alert: "No se puede eliminar: tiene noticias asociadas."
      end
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

  end
end