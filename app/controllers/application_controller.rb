class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_users_list
  helper_method :can_renew?

  protected

  def current_users_list
    current_users.map {|u| u.first_name}.join(", ")
  end

  private

	def not_authenticated
  redirect_to login_path, alert: "Please login first"
	end

  def can_renew?( book )
    hold_count = Hold.where( book: book ).count
    book_copies = BookCopy.where( book: book )

    checked_out_count = book_copies.inject( 0 ) do |book_copy_count, book_copy|
      book_copy_count += 1 if CheckOut.where( { book_copy: book_copy, return_date: nil } ).any?
      book_copy_count
    end

    hold_count <= book_copies.count - checked_out_count
  end

end
