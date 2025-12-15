class TrainingSessionForm
  include ActiveModel::Model

  attr_accessor :training_session, :session, :user
  attr_reader :current_step

  FIRST_STEP = "exercises"
  LAST_STEP = "name"

  def initialize(params = {})
    super(params)
    @training_session = TrainingSession.find_or_create_by!(user:, status: :draft)
    @current_step = session[:training_session_step] ||= FIRST_STEP
  end

  def current_step_instance(params = {})
    current_step_class.new(training_session:, session:, **params)
  end

  def current_step_class
    "TrainingSessionForm::Steps::#{current_step.camelize}Step".constantize
  end

  def next_step
    current_step_instance.next_step
  end

  def go_back!
    previous = current_step_instance.previous_step
    session[:training_session_step] = previous if previous
  end
end
