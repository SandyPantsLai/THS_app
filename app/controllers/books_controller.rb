class BooksController < ApplicationController
  # this filter requires the user to login before they can create new book
  before_action :require_login, only: [:new, :create]

  def new
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to books_url
    else
      render "new"
    end
  end

  def index
    @books = Book.all
  end

  def delete
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_url
  end

    private
  def book_params
    params.require(:book).permit(:title, :author, :subject, :published, :publisher, :page_count, :price, :description, :cover_image, :isbn)
  end
end
