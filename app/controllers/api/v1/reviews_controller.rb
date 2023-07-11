class Api::V1::ReviewsController < ApplicationController
  before_action :set_book, only: %i[index]
  before_action :set_review, only: %i[show update destroy]
  before_action :set_reviews, only: %i[index]
  before_action :authentication_with_token!, only: %i[create update destroy]

  # Consultar el listado de calificaciones de un libro
  def index
    json_response(
      'Index reviews successfully',
      true,
      { reviews: @reviews },
      :ok
    )
  rescue StandardError => e
    render_rescue(e)
  end

  # Consultar una calificación específica de un libro por su identificador único
  def show
    json_response(
      'Show review successfully',
      true,
      { review: @review },
      :ok
    )
  rescue StandardError => e
    render_rescue(e)
  end

  # Crear una calificación de un libro
  def create
    review = Review.new(set_review_params)
    review.user_id = current_user.id
    review.book_id = params[:book_id]

    if review.save
      json_response(
        'Create review successfully',
        true,
        { review: review },
        :ok
      )
    else
      json_response(
        'Create review fail',
        false,
        {},
        :unproccesable_entity
      )

    end
  rescue StandardError => e
    render_rescue(e)
  end

  # Modificar una calificación de un libro por su identificador único
  def update
    if correct_user?(@review.user)
      if @review.update(set_review_params)
        json_response(
          'Updated review successfully',
          true,
          { review: @review },
          :ok
        )
      else
        json_response(
          'Updated review fail',
          false,
          {},
          :unproccesable_entity
        )
      end
    else
      json_response(
        'You do not have permission to do this',
        false,
        {},
        :unproccesable_entity
      )
    end
  rescue StandardError => e
    render_rescue(e)
  end

  # Eliminar una calificación de un libro por su identificador único
  def destroy
    if correct_user?(@review.user)
      if @review.destroy
        json_response(
          'Deleted review successfully',
          true,
          {},
          :ok
        )
      else
        json_response(
          'Deleted review fail',
          false,
          {},
          :unproccesable_entity
        )
      end
    else
      json_response(
        'You do not have permission to do this',
        false,
        {},
        :unproccesable_entity
      )
    end
  rescue StandardError => e
    render_rescue(e)
  end

  private

  def set_book
    @book = Book.find_by(id: params[:book_id])
    unless @book.present?
      json_response(
        'Can not find book',
        false,
        {},
        :not_found
      )
    end
  end

  def set_review
    @review = Review.find_by(id: params[:id])
    unless @review.present?
      json_response(
        'Can not fin review',
        false,
        {},
        :not_found
      )
    end
  end

  def set_reviews
    @reviews = @book.reviews
  end

  def set_review_params
    params.require(:review).permit(Review.allowed_attributes)
  end
end
