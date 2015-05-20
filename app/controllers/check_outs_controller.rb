class CheckOutsController < ApplicationController

  helper_method :get_check_out_complete_details


  def index
    # only display books that have not been returned
    if ( params[ :user_id ] )
      @check_outs = CheckOut.where( { user_id: params[ :user_id ], return_date: nil } )
    else
      @check_outs = CheckOut.where( return_date: nil )
    end

  end

  def new
    @check_out = CheckOut.new
  end

  def edit
  end

  def create
    @check_out = CheckOut.new( check_out_params )

    if @check_out.save
    else

    end
  end

  def update
  end

  private
  def check_out_params
  end

  def get_check_out_complete_details( check_out )
    book_copy = BookCopy.find( check_out.book_copy )
    book = Book.find( book_copy.book_id )
    user = User.find( check_out.user_id )
    overdue = Time.new.to_i > check_out.due_date.to_time.to_i

    return { book_copy: book_copy, book: book, user: user, overdue: overdue }
  end
end