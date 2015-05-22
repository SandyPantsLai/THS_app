class BooksController < ApplicationController
  # this filter requires the user to login before they can create new book
  before_action :require_login, only: [:new, :create, :edit]

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
    @search = Book.search(params[:q])
    @books = @search.result

    # @books = []
    # if params[:search]
    #   params[:search].split.each do |s|
    #     @books << Book.where("LOWER(title) LIKE LOWER(?) OR LOWER(first_name) LIKE LOWER(?) OR LOWER(last_name) LIKE LOWER(?)", "%#{s}%", "%#{s}%", "%#{s}%")
    #   end
    #   @books.flatten!
    #   @books.uniq!
    # else
    #   @books = Book.all
    # end
    # if request.xhr?
    #   render :partial => "book", :collection => @books
    # end
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
