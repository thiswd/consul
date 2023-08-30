class Legislation::ReviewsController < Legislation::BaseController
  load_and_authorize_resource :process
  load_and_authorize_resource through: :process

  def show
  end
end
