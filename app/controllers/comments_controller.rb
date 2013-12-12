class CommentsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :like, :unlike]
  before_filter :comment_exists?, only: [:edit, :show, :update, :like, :unlike]
  before_filter :user_owns_comment?, only: [:edit, :update]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user

    if @comment.save
      redirect_to :back
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to :back
    end
  end

  def new
    @comment = Comment.new
  end

  def edit
    @post = params[:comment]
  end

  def show
    @post = params[:comment]
  end

  def update
    if @comment.update_attributes(params[:comment])
      redirect_to :back
    else
      flash.now[:errors] = @comment.errors.full_messages
      redirect_to :back
    end
  end

  def destroy
    @comment = comment
  end

  def like
    like_total(1)
  end

  def unlike
    like_total(0)
  end

  private
    def comment_exists?
      @comment = Comment.includes(:user_comment_likes).find_by_id(params[:id])
      redirect_to :back unless @comment
    end

    def like_total(direction)
      @user_comment_like = UserCommentLike.find_by_comment_id_and_user_id(@comment.id, current_user.id)

      if @user_comment_like
        @user_comment_like.update_attributes(value: direction)
      else
        @comment.user_comment_likes.create(user_id: current_user.id, value: direction)
      end

      redirect_to :back
    end

    def user_owns_comment?
      redirect_to :back unless @comment.user == current_user
    end

end
