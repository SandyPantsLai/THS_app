class BooksController < ApplicationController
  # this filter requires the user to login before they can create new book
  before_action :require_login, only: [:new, :create, :edit]

  def search_google
    if params[:query]
      query = GGI.escape(params[:query])
      @results = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=" + query)
      @filtered_results = @results.map do |item|
        {
          # number of returned volumes from the search
          totalItems: item ["totalItems"]
          # returned individual item details
          title: item["volumeInfo"]["title"],
          subtitle: item ["volumeInfo"]["subtitle"],
          author: item ["volumeInfo"]["authors"],
          publisher: item ["volumeInfo"]["publisher"],
          publishedDate: item ["volumeInfo"]["publishedDate"],
          description: item ["volumeInfo"]["description"],
          type: item ["volumeInfo"]["type"],
          identifier: item ["volumeInfo"]["identifier"],
          image: item ["volumeInfo"]["imageLinks"]["thumbnail"]
        }
      end
    end
    render "google_results"
  end

  def new
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @holds = Hold.where(book_id: @book.id).sort_by{|hold| hold.pickup_expiry || Time.now + 100.years}
    @copies = BookCopy.where(book_id: @book.id)
    @checked_out = 0
    @due_dates = []
    @copies.each do |copy|
      @checkout = CheckOut.find_by(book_copy_id: copy.id)
      if @checkout
        @checked_out += 1
        @due_dates << @checkout.due_date
      end
    end
    @copies_available = @copies.count - @checked_out - Hold.where(book_id: @book.id).where("pickup_expiry IS NOT NULL").count
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
    @books = @search.result.order(:title).page params[:page]
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
