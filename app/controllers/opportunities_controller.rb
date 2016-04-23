class OpportunitiesController < ApplicationController
  def index
    if params[:search].present?
      scope = Opportunity.order('id asc').search(params[:search])
    else
      scope = Opportunity.order('id asc')
    end
    @opportunities = scope.page(params[:page]).per(20)
  end
end
