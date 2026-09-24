
class ReaderProfilesController < ApplicationController

  before_action :require_reader

  def show
    @reader = current_reader
  end

end