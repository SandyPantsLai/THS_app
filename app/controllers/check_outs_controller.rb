class CheckOutsController < ApplicationController

  helper_method :can_renew?
  helper_method :get_fine_amount


  def index
    if ( params[ :user_id ] )
      if ( params[ :due_only ] )
        @check_outs = CheckOut.where( { user_id: params[ :user_id ], return_date: nil } )
      else
        @check_outs = CheckOut.where( user_id: params[ :user_id ] )
      end
    elsif ( params[ :due_only ] )
      @check_outs = CheckOut.where( return_date: nil )
    else
      @check_outs = CheckOut.all
    end
  end

  def show
    @check_out = CheckOut.find( params[ :id ] )
  end

  def new
    @check_out = CheckOut.new
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

  def check_in
    check_out = CheckOut.find( params[ :id ] )
    attributes = {}

    attributes[ :return_date ] = DateTime.now
    fine_amount = get_fine_amount( check_out, attributes[ :return_date ] )

    if fine_amount > 0
      attributes[ :fine ] = Fine.new
      attributes[ :fine ].amount = fine_amount
    end

    update_check_out( check_out, attributes )
  end

  def renew
    check_out = CheckOut.find( params[ :id ] )
    due_date = check_out.due_date
    attributes = {}

    attributes[ :due_date ] = DateTime.new( due_date.year, due_date.month, due_date.day + CheckOut::CHECK_OUT_PERIOD )
    attributes[ :renewal ] = check_out.renewal - 1

    update_check_out( check_out, attributes )
  end

  private
  def can_renew?( book )
    book_holds = Hold.where( book: book )
    book_copies = BookCopy.where( book: book )

    hold_count = book_holds.inject( 0 ) do |book_hold_count, book_hold|
      book_hold_count += 1 if book_hold.pickup_expiry.to_time.to_i > DateTime.now.to_time.to_i
      book_hold_count
    end

    checked_out_count = book_copies.inject( 0 ) do |book_copy_count, book_copy|
      book_copy_count += 1 if CheckOut.where( { book_copy: book_copy, return_date: nil } ).any?
      book_copy_count
    end

    hold_count <= book_copies.count - checked_out_count
  end

  def check_out_params
    params.require( :check_out ).permit( :user_id, :book_copy_id )
  end

  def get_fine_amount( check_out, return_date )
    days_due =  ( return_date.to_time.to_i - check_out.due_date.to_time.to_i ) / Fine::DAYS_IN_SECONDS
    days_due <= 0 ? 0 : ( days_due * Fine::DAILY_FINE_AMOUNT )
  end

  def update_check_out( check_out, attributes )
    if check_out.update( attributes )
      if attributes[ :fine ]
        redirect_to check_out_path( check_out )
      else
        redirect_to check_outs_path
      end
    else
      render check_out_path( check_out )
    end
  end

end
