class InstructorsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    render json: Instructor.all
  end
  
  def show
    instructor = find_instructor
    render json: instructor, include: :students
  end
  
  def create
    render json: Instructor.create!(instructor_params), status: :created
  end
  
  def update
    instructor = Instructor.find_by(id: params[:id])
    instructor.update(instructor_params)
    render json: instructor
  end
  
  def destroy
    instructor = Instructor.find_by(id: params[:id])
    instructor.destroy
    head :no_content
  end
  
  private

  def instructor_params
    params.permit(:name)
  end

  def find_instructor
    Instructor.find(params[:id])
  end

  def render_unprocessable_entity_response(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found_response
    render json: { error: "Instructor not found" }, status: :not_found
  end
end
