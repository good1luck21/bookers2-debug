class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  impressionist actions: [:show], unique: [:ip_address]

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    impressionist(@book, nil)
  end

  def index
    @book = Book.new
    start_date = Time.current.at_end_of_day
    end_data   = (start_date - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort { |a,b| b.favorited_users.includes(:favorites).where(created_at: end_data..start_date).count <=> a.favorited_users.includes(:favorites).where(created_at: end_data..start_date).count }
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    return unless @book.user_id != current_user.id
    redirect_to books_path
  end
end
