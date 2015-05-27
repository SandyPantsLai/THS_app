class CheckOutsController < ApplicationController

  helper_method :can_renew?


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
    fine_amount = check_out.get_fine_amount( attributes[ :return_date ] )

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
    hold_count = Hold.where( book: book ).count
    book_copies = BookCopy.where( book: book )

    checked_out_count = book_copies.inject( 0 ) do |book_copy_count, book_copy|
      book_copy_count += 1 if CheckOut.where( { book_copy: book_copy, return_date: nil } ).any?
      book_copy_count
    end

    hold_count <= book_copies.count - checked_out_count
  end

  def check_out_params
    params.require( :check_out ).permit( :user_id, :book_copy_id )
  end

  def update_check_out( check_out, attributes )
    if check_out.update( attributes )
      update_hold(check_out)

      if attributes[ :fine ]
        redirect_to check_out_path( check_out )
      else
        redirect_to check_outs_path
      end
    else
      render check_out_path( check_out )
    end
  end

  def update_hold(check_out)
    if check_out.return_date
      hold = Hold.where(book_id: check_out.book_copy.book_id).where("pickup_expiry IS NULL").first
      hold.update(pickup_expiry: Time.now + 7.days) if hold
    end
  end

end
