class CheckOutsController < ApplicationController

  def index
    @details = {}

    if ( params[ :user_id ] )
      if ( params[ :due_only ] )
        @check_outs = CheckOut.where( { user_id: params[ :user_id ], due_date: nil } )
      else
        @check_outs = CheckOut.where( user_id: params[ :user_id ] )
      end
    elsif ( params[ :due_only ] )
      @check_outs = CheckOut.where( return_date: nil )
    else
      @check_outs = CheckOut.all
    end

  end

  def new
    @check_out = CheckOut.new
  end

  def edit
  end

  def create
    currentDate = DateTime.now

    @check_out = CheckOut.new( check_out_params )
    @check_out.checkout_date = currentDate
    @check_out.due_date = currentDate + CheckOut::CHECK_OUT_PERIOD
    @check_out.renewal = CheckOut::RENEWAL_COUNT

    if @check_out.save
      redirect_to check_outs_path
    else
      render :new
    end
  end

  def update
  end

  private
  def check_out_params
    params.require( :check_out ).permit( :user_id, :book_copy_id )
  end

end
