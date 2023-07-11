class Api::V1::BooksController < ApplicationController
  before_action :set_books, only: %i[index]
  before_action :set_book, only: %i[show update destroy]
  before_action :authentication_with_token!

  def index
    json_response(
      'Index book successfully',
      true,
      { books: @books },
      :ok
    )
  rescue StandardError => e
    render_rescue(e)
  end

  def show
    json_response(
      'Show book successfully',
      true,
      { books: @book },
      :ok
    )
  rescue StandardError => e
    render_rescue(e)
  end

  def create
    @book = Book.create(set_book_params)
    json_response(
      'Create book successfully',
      true,
      { book: @book },
      :ok
    )
  rescue StandardError => e
    render_rescue(e)
  end

  def update
    @book.update(set_book_params)
    json_response(
      'Update book successfully',
      true,
      { book: @book },
      :ok
    )
  rescue StandardError => e
    render_rescue(e)
  end

  def destroy
    @book.delete
    json_response(
      'Delete book successfully',
      true,
      {},
      :ok
    )
  rescue StandardError => e
    render_rescue(e)
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id])
    unless @book.present?
      json_response(
        'Can not found books',
        false,
        {},
        :not_found
      )
    end
  end

  def set_books
    @books = Book.all
  end

  def set_book_params
    params.require(:book).permit(Book.allowed_attributes)
  end
end