module ApplicationHelper
  def opportunity_range(opportunity)
    if opportunity.min_amount == opportunity.max_amount
      number_to_currency opportunity.min_amount
    elsif opportunity.min_amount && opportunity.max_amount
      "#{number_to_currency opportunity.min_amount} - #{number_to_currency opportunity.max_amount}"
    elsif opportunity.min_amount
      number_to_currency opportunity.min_amount
    else
      number_to_currency opportunity.max_amount
    end
  end
end
