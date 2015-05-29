class FinesController < ApplicationController

  before_action :require_login

  def index
    @users = {}
    unsettled_fines = Fine.where( settlement_date: nil ).order( :created_at )

    unsettled_fines.each do |fine|
      check_out = CheckOut.find( fine.check_out_id )

      if @users[ check_out.user_id ].nil?
        @users[ check_out.user_id ] = { name: "#{check_out.user.last_name}, #{check_out.user.first_name}",
            check_outs: [], total_fine: 0 }
      end

      @users[ check_out.user_id ][ :check_outs ].push( check_out )
    end

    @users.each do |key, value|
      value[ :total_fine ] = value[ :check_outs ].inject( 0 ) do |fine_sum, check_out|
        fine_sum += check_out.fine.amount
        fine_sum
      end
    end
  end

  def update
    @check_out = CheckOut.find( params[ :check_out_id ] )
    @fine = @check_out.fine

    if @fine.update( settlement_date: DateTime.now )
      redirect_to check_out_path( @check_out )
    else
      render check_out_path( @check_out )
    end
  end
end
