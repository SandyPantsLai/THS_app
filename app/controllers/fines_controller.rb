class FinesController < ApplicationController

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
