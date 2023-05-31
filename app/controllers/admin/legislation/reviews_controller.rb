class Admin::Legislation::ReviewsController < Admin::Legislation::BaseController
  load_and_authorize_resource :process, class: "Legislation::Process"
  load_and_authorize_resource :review, class: "Legislation::Review", through: :process
end
