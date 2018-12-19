class GraphqlController < ApplicationController

  def execute
    operation_name = params[:operationName]
    query = params[:query]
    variables = ensure_hash(params[:variables])

    result = IwaTestSchema.execute(query, context: {}, operation_name: operation_name, variables: variables)
    render json: result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

end
