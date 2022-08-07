class BookCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:create, :destroy]
  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    book_comment = BookComment.find(params[:id])
    book_comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private
    def book_comment_params
      params.require(:book_comment).permit(:comment)
    end

    def ensure_correct_user
      @book = Book.find(params[:book_id])
      return unless @book.user_id != current_user.id
      redirect_to books_path
    end
end
