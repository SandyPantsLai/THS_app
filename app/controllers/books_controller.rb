class BooksController < ApplicationController
  # this filter requires the user to login before they can create new book
  before_action :require_login, only: [:new, :create, :edit]

  def index
    @books = Book.all
    @search = Book.search(params[:q])
    @books = @search.result.order(:title).page params[:page]
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

  def new
    @books = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to books_url
    else
      render "new"
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def delete
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_url
  end

  def search_google
    if params[:query]
      query = CGI.escape(params[:query])
      @results = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=" + query)
      @filtered_results = {}
      @filtered_results['volumes'] = @results['items'].map do |item|
        {
          volume_id: item["id"],  
          title: item["volumeInfo"]["title"],
          subtitle: item["volumeInfo"]["subtitle"],
          author: item["volumeInfo"]["authors"],
          publisher: item["volumeInfo"]["publisher"],
          published_date: item["volumeInfo"]["publishedDate"],
          description: item["volumeInfo"]["description"],
          page_count: item["volumeInfo"]["pageCount"],
          category: item["volumeInfo"]["categories"],
          identifier: item["volumeInfo"]["industryIdentifiers"].map {|e| e["identifier"]} # isbn
        }
      end
    end
    render "results"
  end

  private
  
  def book_params
    params.require(:book).permit(:title, :subtitle, :author, :publisher, :published_date, :description, :page_count, :category, :cover_image, :type, :indetifier, :qr_code)
  end

end
