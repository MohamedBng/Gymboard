class ExerciseSearchQuery
  attr_reader :message, :muscle_group_id, :scope, :current_user_id

  def self.call(message: nil, muscle_group_id: nil, scope: nil, current_user_id: nil)
    new(message:, muscle_group_id:, scope:, current_user_id:).call
  end

  def initialize(message:, muscle_group_id:, scope:, current_user_id:)
    @message = message
    @muscle_group_id = muscle_group_id
    @scope = scope
    @current_user_id = current_user_id
  end

  def call
    bool_query
  end

  def bool_query
    filter = []
    must = []
    bool = {}

    if message.present?
      must << match_query(field: "title", message: message)
    end

    if scope.present?
      case scope
      when "verified"
        filter << exists_query(field: "verified_at")
        filter << term_query(field: "public", field_value: "true")
      when "current_user"
        raise ArgumentError if current_user_id.blank?
        filter << term_query(field: "user_id", field_value: current_user_id)
      else
        raise ArgumentError
      end
    else
      filter << term_query(field: "public", field_value: "true")
    end


    if muscle_group_id.present?
      filter << term_query(field: "muscle_group_id", field_value: muscle_group_id)
    end

    bool[:must] = must if must.present?
    bool[:filter] = filter if filter.present?

    {
      bool: bool
    }
  end

  def match_query(field:, message:)
    {
      match: {
        field => {
          query: message,
          fuzziness: "AUTO"
        }
      }
    }
  end

  def term_query(field:, field_value:)
    {
      term: {
        field => {
          value: field_value
        }
      }
    }
  end

  def exists_query(field:)
    {
      exists: {
        field: field
      }
    }
  end
end
